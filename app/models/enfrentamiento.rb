class Enfrentamiento < ApplicationRecord
  belongs_to :bebe_1, class_name: 'Bebe'
  belongs_to :bebe_2, class_name: 'Bebe'
  belongs_to :user
end
