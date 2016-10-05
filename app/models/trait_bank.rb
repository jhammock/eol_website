# Abstraction between our traits and the implementation of thir storage. ATM, we
# use neo4j.
#
# NOTE: in its current state, this is NOT done! Neography uses a plain hash to
# store objects, and ultimately we're going to want our own models to represent
# things. But in these early testing stages, this is adequate. Since this is not
# its final form, there are no specs yet. ...We need to feel out how we want
# this to work, first.
class TraitBank

  # The Labels, and their expected relationships { and (*required)properties }:
  # * Resource: { *resource_id }
  # * Page: ancestor(Page), parent(Page), trait(Trait) { *page_id }
  # * Trait: *predicate(Term), *supplier(Resource), metadata(MetaData),
  #          object_term(Term), units_term(Term)
  #     { *resource_pk, *scientific_name, statistical_method, sex, lifestage,
  #       source, measurement, object_page_id, literal }
  # * MetaData: *predicate(Term), object_term(Term), units_term(Term)
  #     { measurement, literal }
  # * Term: { *uri, *name, *section_ids(csv), definition, comment, attribution,
  #       is_hidden_from_overview, is_hidden_from_glossary }

  class << self
    @connected = false

    # REST-style:
    def connection
      @connection ||= Neography::Rest.new(ENV["EOL_TRAITBANK_URL"])
      @connected = true
      @connection
    end

    def ping
      begin
        connection.list_indexes
      rescue Excon::Error::Socket => e
        return false
      end
      true
    end

    # Neography-style:
    def connect
      parts = ENV["EOL_TRAITBANK_URL"].split(%r{[/:@]})
      Neography.configure do |cfg|
        cfg.username = parts[3]
        cfg.password = parts[4]
      end
    end

    def quote(string)
      return string if string.is_a?(Numeric) || string =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/
      %Q{"#{string.gsub(/"/, "\\\"")}"}
    end

    def setup
      create_indexes
      create_constraints
    end

    # You only have to run this once, and it's best to do it before loading TB:
    def create_indexes
      indexes = %w{ Page(page_id) Trait(resource_pk) Trait(predicate)
        Term(predicate) MetaData(predicate) }
      indexes.each do |index|
        connection.execute_query("CREATE INDEX ON :#{index};")
      end
    end

    # TODO: Can we create a constraint where a Trait only has one of
    # [measurement, object_page_id, literal, term]? I don't think so... NOTE:
    # You only have to run this once, and it's best to do it before loading TB:
    def create_constraints
      contraints = {
        "Page" => [:id],
        "Term" => [:uri],
        "Trait" => [:resource_id, :resource_pk]
      }
      contraints.each do |label, fields|
        fields.each do |field|
          begin
            connection.execute_query(
              "CREATE CONSTRAINT ON (o:#{label}) ASSERT o.#{field} IS UNIQUE;"
            )
          rescue Neography::NeographyError => e
            rails e unless e.message =~ /already exists/
          end
        end
      end
    end

    # Your gun, your foot: USE CAUTION. This erases EVERYTHING irrevocably.
    def nuclear_option!
      connection.execute_query("MATCH (n) DETACH DELETE n")
    end

    def trait_exists?(resource_id, pk)
      res = connection.execute_query("MATCH (trait:Trait { resource_pk: #{quote(pk)} })"\
        "-[:supplier]->(res:Resource { resource_id: #{resource_id} }) "\
        "RETURN trait")
      res["data"] ? res["data"].first : false
    end

    def by_predicate(predicate)
      res = connection.execute_query(
        "MATCH (page:Page)-[:trait]->(trait:Trait)"\
          "-[:supplier]->(resource:Resource) "\
        "MATCH (trait)-[:predicate]->(predicate:Term { uri: \"#{predicate}\" }) "\
        "OPTIONAL MATCH (trait)-[:object_term]->(object_term:Term) "\
        "OPTIONAL MATCH (trait)-[:units_term]->(units:Term) "\
        "OPTIONAL MATCH (trait)-[:metadata]->(meta:MetaData) "\
        "RETURN resource, trait, page, predicate, object_term, units, meta"
      )
      build_trait_array(res, [:resource, :trait, :page, :predicate, :object_term,
        :units, :meta])
    end

    def page_exists?(page_id)
      res = connection.execute_query("MATCH (page:Page { page_id: #{page_id} })"\
        "RETURN page")
      res["data"] ? res["data"].first : false
    end
    
    def node_exists?(node_id)
      result_node = get_node(node_id)
      result_node ? result_node.first : false
    end
    
    def get_node(node_id)
      res = connection.execute_query("MATCH (node:Node { node_id: #{node_id} })"\
        "RETURN node")
      res["data"]
    end

    def by_page(page_id)
      res = connection.execute_query(
        "MATCH (page:Page { page_id: #{page_id} })-[:trait]->(trait:Trait)"\
          "-[:supplier]->(resource:Resource) "\
        "MATCH (trait)-[:predicate]->(predicate:Term) "\
        "OPTIONAL MATCH (trait)-[:object_term]->(object_term:Term) "\
        "OPTIONAL MATCH (trait)-[:units_term]->(units:Term) "\
        "OPTIONAL MATCH (trait)-[:metadata]->(meta:MetaData) "\
        "RETURN resource, trait, predicate, object_term, units, meta"
      )
      # Neography recognizes the objects we get back, but the format is weird
      # for building pages, so I transform it here (temporarily, for
      # simplicity). NOTE: given one of the "res" sets here, you can find a
      # particular trait with this: trait_res = results["data"].find { |tr|
      # tr[2] && tr[2]["data"]["uri"] ==
      # "http://purl.obolibrary.org/obo/VT_0001259" }
      build_trait_array(res, [:resource, :trait, :predicate, :object_term,
        :units, :meta])
    end

    # The problem is that the results are in a kind of "table" format, where
    # columns on the left are duplicated to allow for multiple values on the
    # right. This detects those duplicates to add them (as an array) to the
    # trait, and adds all of the other data together into one object meant to
    # represent a single trait, and then returns an array of those traits. It's
    # really not as complicated as it seems! This is mostly bookkeeping.
    def build_trait_array(results, col_array)
      traits = []
      previous_id = nil
      col = {}
      col_array.each_with_index { |c, i| col[c] = i }
      results["data"].each do |trait_res|
        resource = get_column_data(:resource, trait_res, col)
        resource_id = resource ? resource["resource_id"] : "MISSING"
        trait = get_column_data(:trait, trait_res, col)
        page = get_column_data(:page, trait_res, col)
        predicate = get_column_data(:predicate, trait_res, col)
        object_term = get_column_data(:object_term, trait_res, col)
        units = get_column_data(:units, trait_res, col)
        meta_data = get_column_data(:meta, trait_res, col)
        this_id = "#{resource_id}:#{trait["resource_pk"]}"
        this_id += ":#{page["page_id"]}" if page
        if this_id == previous_id
          # the conditional at the end of this phrase actually detects duplicate
          # nodes, which we shouldn't have but I was getting in early tests:
          traits.last[:metadata] << meta_data.symbolize_keys if meta_data
        else
          trait[:metadata] = meta_data ? [ meta_data.symbolize_keys ] : nil
          trait[:page_id] = page["page_id"] if page
          trait[:resource_id] = resource_id if resource_id
          trait[:predicate] = predicate.symbolize_keys if predicate
          trait[:object_term] = object_term.symbolize_keys if object_term
          trait[:units] = units.symbolize_keys if units
          trait[:id] = this_id
          traits << trait.symbolize_keys
        end
        previous_id = this_id
      end
      traits
    end

    def get_column_data(name, results, col)
      return nil unless col.has_key?(name)
      return nil unless results[col[name]].is_a?(Hash)
      results[col[name]]["data"]
    end

    def glossary(traits)
      uris = {}
      traits.each do |trait|
        [:predicate, :units, :object_term].each do |type|
          next unless trait[type] && trait[type].is_a?(Hash)
          uris[trait[type][:uri]] ||= trait[type]
        end
      end
      uris
    end

    def resources(traits)
      resources = Resource.where(id: traits.map { |t| t[:resource_id] }.compact.uniq)
      # A little magic to index an array as a hash:
      Hash[ *resources.map { |r| [ r.id, r ] }.flatten ]
    end

    def create_page(id)
      if page = page_exists?(id)
        return page
      end
      page = connection.create_node(page_id: id)
      connection.add_label(page, "Page")
      page
    end

    def create_resource(id)
      resource = connection.create_node(resource_id: id)
      connection.add_label(resource, "Resource")
      resource
    end

    # NOTE: this doesn't handle associations, yet. That s/b coming soon.
    # TODO: we should probably do some checking here. For example, we should
    # only have ONE of [value/object_term/association/literal].
    def create_trait(options)
      page = options.delete(:page)
      supplier = options.delete(:supplier)
      meta = options.delete(:meta_data)
      predicate = parse_term(options.delete(:predicate))
      units = parse_term(options.delete(:units))
      object_term = parse_term(options.delete(:object_term))
      trait = connection.create_node(options)
      connection.add_label(trait, "Trait")
      connection.create_relationship("trait", page, trait)
      connection.create_relationship("supplier", trait, supplier)
      connection.create_relationship("predicate", trait, predicate)
      connection.create_relationship("units", trait, units) if units
      connection.create_relationship("object_term", trait, object_term) if
        object_term
      meta.each { |md| add_metadata_to_trait(trait, md) } if meta
      trait
    end
    
    # Note: I've named this create_node_in_hierarchy as there is another 
    # methods called create_node in neography
    def create_node_in_hierarchy(node_id, page_id)
      if node = node_exists?(node_id)
        return node
      end
      node = connection.create_node(node_id: node_id, page_id: page_id)
      connection.add_label(node, "Node")
    end
    
    def adjust_node_parent_relationship(node_id, parent_id)
      node = get_node(node_id)
      parent_node = get_node(parent_id)
      connection.create_relationship("parent", node, parent_node) unless relationship_exists?(node_id, parent_id)
    end
    
    def relationship_exists?(node_a, node_b)
      res = connection.execute_query("MATCH (node_a:Node { node_id: #{node_a} }) - [r:parent] - (node_b:Node { node_id: #{node_b} })"\
        "RETURN SIGN(COUNT(r))")
      res["data"] ? res["data"].first.first > 0 : false
    end

    def parse_term(term_options)
      return nil if term_options.nil?
      return term_options if term_options.is_a?(Hash)
      return create_term(term_options)
    end

    def create_term(options)
      if existing_term = term(options[:uri]) # NO DUPLICATES!
        return existing_term
      end
      options[:section_ids] = options[:section_ids] ?
        Array(options[:section_ids]).join(",") : ""
      term_node = connection.create_node(options)
      connection.add_label(term_node, "Term")
      term_node
    end

    def term(uri)
      res = connection.execute_query("MATCH (term:Term { uri: '#{uri}' }) "\
        "RETURN term")
      return nil unless res["data"] && res["data"].first
      res["data"].first.first
    end

    def term_as_hash(uri)
      hash = term(uri)
      raise ActiveRecord::RecordNotFound if hash.nil?
      # NOTE: this step is slightly annoying:
      hash["data"].symbolize_keys
    end

    def add_metadata_to_trait(trait, options)
      meta = connection.create_node(options)
      connection.add_label(meta, "MetaData")
      connection.create_relationship("metadata", trait, meta)
      meta
    end

    def sort(traits, glossary)
      traits.sort do |a,b|
        name_a = a && glossary[a[:predicate]].try(:name)
        name_b = b && glossary[b[:predicate]].try(:name)
        if name_a && name_b
          if name_a == name_b
            # TODO: associations
            if a[:literal] && b[:literal]
              a[:literal].downcase.gsub(/<\/?[^>]+>/, "") <=>
                b[:literal].downcase.gsub(/<\/?[^>]+>/, "")
            elsif a[:measurement] && b[:measurement]
              a[:measurement] <=> b[:measurement]
            else
              trait_a = glossary[a[:trait]].try(:name)
              trait_b = glossary[b[:trait]].try(:name)
              if trait_a && trait_b
                trait_a.downcase <=> trait_b.downcase
              elsif trait_a
                -1
              elsif trait_b
                1
              else
                0
              end
            end
          else
            name_a.downcase <=> name_b.downcase
          end
        elsif name_a
          -1
        elsif name_b
          1
        else
          0
        end
      end
    end
  end
end
