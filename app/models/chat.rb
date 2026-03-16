class Chat < ApplicationRecord
  belongs_to :challenge
  belongs_to :user
  has_many :chat_messages, dependent: :destroy
end
