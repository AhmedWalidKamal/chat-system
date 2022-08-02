class MessageWorker
    include Sidekiq::Worker
    sidekiq_options queue: :message_creation

    def perform(application_token, chat_number, message_number, message_body)
        application = Application.find_by!(token: application_token)
        chat = application.chats.find_by!(number: chat_number)
        new_message = chat.messages.build(number: message_number, body: message_body)
        new_message.save
    end
end