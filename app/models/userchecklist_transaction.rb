class UserchecklistTransaction < ApplicationRecord
  belongs_to :user
  belongs_to :userchecklist
end
