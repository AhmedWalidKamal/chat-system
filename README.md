# chat-system

An API for a chatting system which allows the creation of applications, each application can have numerous chats, which in turn have messages.
The API is built using Ruby on Rails.

## How to run
The application is containerized using Docker, to build and run the whole stack in a docker container, navigate to the root directory, then run:
```bash
docker-compose build
docker-compose up
```
Then wait a couple of minutes until all the services in the container start up and are ready to receive requests.

## Built With

* Ruby on Rails
* MySQL
* Elasticsearch
* Redis
* Sidekiq

## Summary
The system offers a RESTful API with endpoints for all CRUD operations on:
 * Applications
 * Chats
 * Messages

The application creation endpoint creates a system-generated token, this token is returned to the client, by which the client can use it to access the application's chats. Each chat has a unique number which identifies it (starting from 1), the messages for each chat are accessed by using the combination of the application token and the chat number.

Another endpoint is offered for partial searching of messages for a specific chat. The client can send a query with the partial string and all messages for the specified chat are searched for a match. Elasticsearch is used to implement this.

Since it's assumed that there might be multiple servers running in parallel receiving a huge number of requests, Sidekiq workers are implemented to queue jobs for chats and messages creation. 

Redis store is used with the specified keys to keep track of the next number (ID) required for the next chat or message needed to be created.


## API
The application's endpoints can be show by running the following the root directory:
```bash
rails routes
```
By running this, the following endpoints show:
```
                                  Prefix Verb   URI Pattern                                                                                       Controller#Action
        search_application_chat_messages GET    /applications/:application_token/chats/:chat_number/messages/search(.:format)                     messages#search
               application_chat_messages GET    /applications/:application_token/chats/:chat_number/messages(.:format)                            messages#index
                                         POST   /applications/:application_token/chats/:chat_number/messages(.:format)                            messages#create
                application_chat_message GET    /applications/:application_token/chats/:chat_number/messages/:number(.:format)                    messages#show
                                         PATCH  /applications/:application_token/chats/:chat_number/messages/:number(.:format)                    messages#update
                                         PUT    /applications/:application_token/chats/:chat_number/messages/:number(.:format)                    messages#update
                                         DELETE /applications/:application_token/chats/:chat_number/messages/:number(.:format)                    messages#destroy
                       application_chats GET    /applications/:application_token/chats(.:format)                                                  chats#index
                                         POST   /applications/:application_token/chats(.:format)                                                  chats#create
                        application_chat GET    /applications/:application_token/chats/:number(.:format)                                          chats#show
                                         PATCH  /applications/:application_token/chats/:number(.:format)                                          chats#update
                                         PUT    /applications/:application_token/chats/:number(.:format)                                          chats#update
                                         DELETE /applications/:application_token/chats/:number(.:format)                                          chats#destroy
                            applications GET    /applications(.:format)                                                                           applications#index
                                         POST   /applications(.:format)                                                                           applications#create
                             application GET    /applications/:token(.:format)                                                                    applications#show
                                         PATCH  /applications/:token(.:format)                                                                    applications#update
                                         PUT    /applications/:token(.:format)                                                                    applications#update
                                         DELETE /applications/:token(.:format)                                                                    applications#destroy

```
