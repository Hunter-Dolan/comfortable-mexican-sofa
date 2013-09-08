class Cms::Categorization
  
  include Mongoid::Document
  
  include ComfortableMexicanSofa::ActsAsTree
  include ComfortableMexicanSofa::HasRevisions
  include ComfortableMexicanSofa::IsCategorized
  include ComfortableMexicanSofa::IsMirrored
  
  
  field :categorized_type, type: String
  
  # -- Relationships --------------------------------------------------------
  belongs_to :category, class_name: "Cms::Category"
  belongs_to :categorized,
    :polymorphic => true,
    :class_name => "Cms::Category"
    
  # -- Validations ----------------------------------------------------------
  validates :categorized_type, :categorized_id,
    :presence   => true
  validates :category_id,
    :presence   => true,
    :uniqueness => { :scope => [:categorized_type, :categorized_id] }
  
end
