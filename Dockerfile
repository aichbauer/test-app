FROM ruby:2.3.0

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile* /usr/src/app/

RUN bundle install

COPY . /usr/src/app

CMD ["bundle", "exec", "ruby", "myapp.rb", "-o", "0.0.0.0"]