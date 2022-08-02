module Searchable
    extend ActiveSupport::Concern

    included do
      include Elasticsearch::Model
      include Elasticsearch::Model::Callbacks

      # initialize the message index if not initialized
      unless Message.__elasticsearch__.index_exists?
        Message.__elasticsearch__.create_index!
      end

      def as_indexed_json(_options = {})
        as_json(only: %i[ :chat_id :body ])
      end

      settings settings_attributes do
        mappings dynamic: false do
          indexes :body, type: :text, analyzer: :autocomplete
        end
      end

      def self.search(query, chat_id)
        params = {
            query: {
              bool: {
                must: [
                  {
                    wildcard: { body: "*#{query}*" }
                  },
                ],
                filter: [
                  {
                    term: { chat_id: chat_id }
                  }
                ]
              }
            }
        }

        return self.__elasticsearch__.search(params).map do |r|
            r._source
        end
      end
    end

    class_methods do
        def settings_attributes
          {
            index: {
              analysis: {
                analyzer: {
                  autocomplete: {
                    type: :custom,
                    tokenizer: :standard,
                    filter: %i[lowercase autocomplete]
                  }
                },
                filter: {
                  autocomplete: {
                    type: :edge_ngram,
                    min_gram: 2,
                    max_gram: 25
                  }
                }
              }
            }
          }
        end
    end
end
