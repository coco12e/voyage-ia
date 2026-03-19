class Chat < ApplicationRecord
  belongs_to :trip
  belongs_to :user
  has_many :messages, dependent: :destroy

  DEFAULT_TITLE = "Untitled"
  TITLE_PROMPT = <<~PROMPT
    Generate a short, descriptive, 3-to-6-word title that summarizes the user question for a chat conversation.
    Output ONLY the title, no quotes.
  PROMPT

  def generate_title_from_first_message
    return unless title == DEFAULT_TITLE

    first_user_message = messages.find_by(role: "user")
    return if first_user_message.nil?

    begin
      response = RubyLLM.chat.with_instructions(TITLE_PROMPT).ask(first_user_message.content)
      new_title = response.content.strip.gsub(/\A["']|["']\Z/, "")
      update(title: new_title)
    rescue StandardError => e
      Rails.logger.error "Chat Title Generation Error: #{e.message}"
    end
  end
end
