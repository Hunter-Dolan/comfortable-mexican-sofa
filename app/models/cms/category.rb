class Cms::Category
  
  include Mongoid::Document

  include ComfortableMexicanSofa::ActsAsTree
  include ComfortableMexicanSofa::HasRevisions
  include ComfortableMexicanSofa::IsCategorized
  include ComfortableMexicanSofa::IsMirrored

  field :label, type: String
  field :categorized_type, type: String
    
  # -- Relationships --------------------------------------------------------
  belongs_to :site, class_name: "Cms::Site"
  has_many :categorizations,
    :dependent => :destroy,
    class_name: "Cms::Categorization"
    
  # -- Validations ----------------------------------------------------------
  validates :site_id, 
    :presence   => true
  validates :label,
    :presence   => true,
    :uniqueness => { :scope => [:categorized_type, :site_id] }
  validates :categorized_type,
    :presence   => true
    
  scope :of_type, lambda { |type|
    where(:categorized_type => type)
  }
  
end
