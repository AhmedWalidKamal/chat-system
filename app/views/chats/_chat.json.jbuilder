json.extract! chat, :id, :number, :messages_count, :application_id, :created_at, :updated_at
json.url chat_url(chat, format: :json)
