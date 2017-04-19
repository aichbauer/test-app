FROM ruby:2.4.1
RUN apt-get update -qq
RUN apt-get install -y build-essential libpq-dev nodejs
RUN echo "deb http://ftp.us.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list \
         &&      apt-get update              \
         &&      apt-get install -y git      \
         &&      apt-get clean all

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile* /usr/src/app/

RUN bundle install

COPY . /usr/src/app

CMD ["bundle", "exec", "ruby", "app.rb", "-o", "0.0.0.0"]