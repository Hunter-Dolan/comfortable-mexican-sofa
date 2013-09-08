class Cms::Snippet
  include Mongoid::Document

  include ComfortableMexicanSofa::ActsAsTree
  include ComfortableMexicanSofa::HasRevisions
  include ComfortableMexicanSofa::IsCategorized
  include ComfortableMexicanSofa::IsMirrored
  
  field :label
  field :identifier
  field :content
  field :position, type: Integer
  field :is_shared, type: Boolean
  
  cms_is_categorized
  cms_is_mirrored
  cms_has_revisions_for :content
  
  # -- Relationships --------------------------------------------------------
  belongs_to :site, class_name: "Cms::Site"
  
  # -- Callbacks ------------------------------------------------------------
  before_validation :assign_label
  before_create :assign_position
  after_save    :clear_cached_page_content
  after_destroy :clear_cached_page_content
  
  # -- Validations ----------------------------------------------------------
  validates :site_id,
    :presence   => true
  validates :label,
    :presence   => true
  validates :identifier,
    :presence   => true,
    :uniqueness => { :scope => :site_id },
    :format     => { :with => /\A\w[a-z0-9_-]*\z/i }
    
  # -- Scopes ---------------------------------------------------------------
  #default_scope -> { order('cms_snippets.position') }
  
protected
  
  def assign_label
    self.label = self.label.blank?? self.identifier.try(:titleize) : self.label
  end
  
  # Note: This might be slow. We have no idea where the snippet is used, so
  # gotta reload every single page. Kinda sucks, but might be ok unless there
  # are hundreds of pages.
  def clear_cached_page_content
    site.pages.each do |p|
      Cms::Page.where(:id => p.id).update_all(:content => p.content(true))
    end
  end
  
  def assign_position
    max = self.site.snippets.max(:position)
    self.position = max ? max + 1 : 0
  end
  
end
