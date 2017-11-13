class ImportEvent < ActiveRecord::Base
  belongs_to :import_log, inverse_of: :import_events

  enum cat: %i[infos warns errors starts ends urls]
end
