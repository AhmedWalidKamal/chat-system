FROM ruby:3.1.2
RUN mkdir /chat-system
WORKDIR /chat-system
ADD Gemfile Gemfile.lock ./
RUN gem install bundler
RUN bundle install
ADD . ./chat-system

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
COPY wait-for-it.sh /usr/bin/
RUN chmod +x /usr/bin/wait-for-it.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]