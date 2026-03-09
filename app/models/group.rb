class Group < ApplicationRecord
  VALID_TYPES = %w[familia instituto universidad ciudad provincia comunidad_autonoma pais].freeze

  has_many :user_groups, dependent: :destroy

  validates :name, presence: true
  validates :group_type, presence: true, inclusion: { in: VALID_TYPES }

  scope :by_type, ->(type) { where(group_type: type) }
end
