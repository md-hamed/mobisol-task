class CustomAttribute < ApplicationRecord
  belongs_to :customizable, polymorphic: true
end
