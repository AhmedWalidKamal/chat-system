module Filter
    def filter(record)
        return :json => record, :except => [:created_at, :updated_at, :id, :application_id, :chat_id]
    end
end