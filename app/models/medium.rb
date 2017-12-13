class Medium < ActiveRecord::Base
  include Content
  include Content::Attributed

  # Yes, we store this in two places. First, we log who set the icon when:
  has_many :page_icons, inverse_of: :medium
  # And then we denormlize the latest so we can query it efficiently:
  has_many :pages, inverse_of: :medium
  has_many :collected_pages_media, inverse_of: :medium
  has_many :collected_pages, through: :collected_pages_media
  has_many :collections, through: :collected_pages

  has_one :image_info, inverse_of: :image

  enum subclass: [ :image, :video, :sound, :map, :js_map ]
  enum format: [ :jpg, :youtube, :flash, :vimeo, :mp3, :ogg, :wav ]

  scope :images, -> { where(subclass: :image) }
  scope :videos, -> { where(subclass: :video) }
  scope :sounds, -> { where(subclass: :sound) }

  # NOTE: No, there is NOT a counter_culture here for pages, as this object does NOT reference pages itself.

  # searchable do
  #   text :name, :boost => 6.0
  #   text :description, :boost => 2.0
  #   text :resource_pk
  #   text :owner
  #   integer :ancestor_ids, multiple: true do
  #
  #   end
  # end

  # TODO: we will have our own media server with more intelligent names:
  def original_size_url
    orig = Rails.configuration.x.image_path['original']
    ext = Rails.configuration.x.image_path['ext']
    base_url + "#{orig}#{ext}"
  end

  def large_size_url
    base_url + format_image_size(580, 360)
  end

  def medium_icon_url
    base_url + format_image_size(130, 130)
  end
  alias_method :icon, :medium_icon_url

  def medium_size_url
    base_url + format_image_size(260, 190)
  end

  # Drat. :S
  def name(language = nil)
    self[:name]
  end

  def small_size_url
    base_url + format_image_size(98, 68)
  end

  def small_icon_url
    base_url + format_image_size(88, 88)
  end

  def format_image_size(w, h)
    join = Rails.configuration.x.image_path['join']
    by = Rails.configuration.x.image_path['by']
    ext = Rails.configuration.x.image_path['ext']
    "#{join}#{w}#{by}#{h}#{ext}"
  end

  def vitals
    [name, "#{license.name} #{owner.html_safe}"]
  end

  # TODO: spec these methods:
  def is_image?
    subclass == :image
  end

  def is_video?
    subclass == :video
  end

  def is_sound?
    subclass == :sound
  end

  def is_map?
    subclass == :map
  end

  def is_js_map?
    subclass == :js_map
  end
end
