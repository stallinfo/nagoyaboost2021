class Userchecklist < ApplicationRecord
    has_many :userchecklist_transactions, dependent: :destroy
end
