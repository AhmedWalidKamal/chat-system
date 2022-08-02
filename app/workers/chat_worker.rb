class ChatWorker
    include Sidekiq::Worker
    # sidekiq_options queue: :chat

    def perform()
        puts "========================== in perform ====================="
    end
end