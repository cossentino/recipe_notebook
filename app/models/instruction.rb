

class Instruction < ActiveRecord::Base
    has_many :comments
    belongs_to :recipe
end