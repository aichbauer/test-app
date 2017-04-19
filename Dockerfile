FROM ruby:2.3.0
RUN apt-get update
RUN apt-get install libgmp-dev

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile* /usr/src/app/

RUN gem install bundler
RUN bundle install

COPY . /usr/src/app

CMD ["bundle", "exec", "ruby", "app.rb", "-o", "0.0.0.0"]