# NOTE that you use the show_* methods with a - not a = because it's writing
# to the stream directly, NOT building an output for you to show...
module DataHelper
  def metadata_container(data)
    return unless data[:meta] ||
      data[:source] ||
      data[:object_term] ||
      data[:units]
    haml_tag(:div, class: "meta_data", style: "display: none;")
  end

  def show_metadata(data)
    return if data.nil?
    return unless data[:meta] ||
      data[:source] ||
      data[:object_term] ||
      data[:units]
    haml_tag(:table) do
      if data[:metadata]
        data[:metadata].each do |meta_data|
          show_meta_data(meta_data)
        end
      end
      show_definition(data[:units])
      show_definition(data[:object_term]) if data[:object_term]
      show_source(data[:source]) if data[:source]
    end
  end

  def show_meta_data(meta_data)
    haml_tag :tr do
      haml_tag :th, meta_data[:predicate][:name]
      haml_tag :td do
        show_data_value(meta_data)
      end
    end
  end

  def build_associations(page)
    @associations =
      begin
        ids = page.data.map { |t| t[:object_page_id] }.compact.sort.uniq
        Page.where(id: ids).
          includes(:medium, :preferred_vernaculars, native_node: [:rank])
      end
  end

  def show_data_value(data)
    value = t(:data_missing, keys: data.keys.join(", "))
    if data[:object_page_id] && defined?(@associations)
      target = @associations.find { |a| a.id == data[:object_page_id] }
      if target.nil?
        haml_concat "[page #{data[:object_page_id]} not imported]"
      else
        summarize(target, options = {})
      end
    elsif data[:measurement]
      value = data[:measurement].to_s + " "
      value += data[:units][:name] if data[:units] && data[:units][:name]
      haml_concat(first_cap(value).html_safe)
    elsif data[:object_term] && data[:object_term][:name]
      value = data[:object_term][:name]
      haml_concat(link_to(first_cap(value), term_path(uri: data[:object_term][:uri], object: true)))
    elsif data[:literal]
      haml_concat first_cap(unlink(data[:literal])).html_safe
    else
      haml_concat "OOPS: "
      haml_concat value
    end
  end

  def show_definition(uri)
    return unless uri && uri[:definition]
    haml_tag(:tr) do
      haml_tag(:th, I18n.t(:data_definition, data: uri[:name]))
      haml_tag(:td) do
        haml_tag(:span, uri[:uri], class: "uri_defn")
        haml_tag(:br)
        if uri[:definition].empty?
          haml_concat(I18n.t(:data_unit_definition_blank))
        else
          haml_concat(uri[:definition].html_safe)
        end
      end
    end
  end

  def show_source(src)
    haml_tag(:tr) do
      haml_tag(:th, I18n.t(:data_source))
      haml_tag(:td, unlink(src))
    end
  end

  def show_source_col(data)
    # TODO: make this a proper link
    haml_tag(:td, class: "table-source") do
      if @resources && resource = @resources[data[:resource_id]]
        haml_tag("div.uk-overflow-auto") do
          haml_concat(link_to(resource.name, "#", title: resource.name,
            data: { toggle: "tooltip", placement: "left" } ))
        end
      else
        haml_concat(I18n.t(:resource_missing))
      end
    end
  end

  def show_data_page_icon(page)
    if image = page.medium
      haml_concat(link_to(image_tag(image.small_icon_url,
        alt: page.scientific_name.html_safe, size: "44x44"), page))
    end
  end

  def show_data_page_name(page)
    haml_tag(:div, class: "names d-inline") do
      if page.name && page.name != page.scientific_name
        haml_concat(link_to(page.name.titlecase, page, class: "primary-name"))
        haml_tag(:br)
        haml_concat(link_to(page.scientific_name.html_safe, page, class: "secondary-name"))
      else
        haml_concat(link_to(page.scientific_name.html_safe, page, class: "primary-name"))
      end
    end
  end

  def show_data_modifiers(data)
    haml_tag(:br)
    [data[:statistical_method], data[:sex], data[:lifestage]].compact.each do |type|
      haml_tag(:div, "#{type}", class: "data_type uk-text-muted uk-text-small")
    end
  end
end