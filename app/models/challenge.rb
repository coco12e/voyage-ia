class Challenge < ApplicationRecord
  has_many :chats, dependent: :destroy
end
