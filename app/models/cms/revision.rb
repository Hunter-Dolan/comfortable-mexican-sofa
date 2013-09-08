class Cms::Revision
  
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  include ComfortableMexicanSofa::ActsAsTree
  include ComfortableMexicanSofa::HasRevisions
  include ComfortableMexicanSofa::IsCategorized
  include ComfortableMexicanSofa::IsMirrored
  
  field :record_type
  field :text
    
  # -- Relationships --------------------------------------------------------
  belongs_to :record, :polymorphic => true
  
  # -- Scopes ---------------------------------------------------------------
  #default_scope -> { order('created_at DESC') }
  
end