class CustomAttributesProvider < ApplicationRecord
  validates :model, presence: true
  validates :key, presence: true
  validates :key, uniqueness: { scope: :model }
end
