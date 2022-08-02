class ChatWorker
    include Sidekiq::Worker
    sidekiq_options queue: :chat_creation

    def perform(application_token, chat_number)
        application = Application.find_by!(token: application_token)
        new_chat = application.chats.build(number: chat_number, messages_count: 0)
        new_chat.save
    end
end