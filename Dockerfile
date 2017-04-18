FROM ruby:2.4.0-alpine

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile* /usr/src/app/

RUN bundle install

COPY . /usr/src/app

CMD ["bundle", "exec", "ruby", "myapp.rb", "-o", "0.0.0.0"]