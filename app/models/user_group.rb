class UserGroup < ApplicationRecord
  belongs_to :group

  validates :device_id, presence: true
  validates :group_id, presence: true
  validates :device_id, uniqueness: { scope: :group_id, message: "already joined this group" }
end
