class Publishing::PubVernaculars
  include Publishing::GetsLanguages

  def self.import(resource, log, repo)
    log ||= Publishing::PubLog.new(resource)
    a_long_long_time_ago = 1202911078 # 10 years ago when this was written; no sense coding it.
    repo ||= Publishing::Repository.new(resource: resource, log: log, since: a_long_long_time_ago)
    Publishing::PubVernaculars.new(resource, log, repo).import
  end

  def initialize(resource, log, repo)
    @resource = resource
    @log = log
    @repo = repo
    @languages = {}
  end

  def import
    @log.log('import_vernaculars')
    count = @repo.get_new(Vernacular) do |name|
      name[:node_id] = 0 # This will be replaced, but it cannot be nil. :(
      name[:string] = name.delete(:verbatim)
      name.delete(:language_code_verbatim) # We don't use this.
      lang = name.delete(:language)
      # TODO: default language per resource?
      name[:language_id] = lang ? get_language(lang) : get_language(code: "eng", group_code: "en")
      name[:is_preferred_by_resource] = name.delete(:is_preferred)
    end
    return if count.zero?
    Vernacular.propagate_id(fk: 'node_resource_pk',  other: 'nodes.resource_pk',
                            set: 'node_id', with: 'id', resource_id: @resource.id)
    @log.log('fixing counter_culture counts for ScientificName...')
    # TMP: [faster for now] Vernacular.counter_culture_fix_counts
    Vernacular.joins(:page).where(['pages.vernaculars_count = 1 AND vernaculars.is_preferred_by_resource = ? '\
      'AND vernaculars.resource_id = ?', true, @resource.id]).update_all(is_preferred: true)
  end
end
