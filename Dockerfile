FROM ruby:2.5.3

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /brickyard_api
WORKDIR /brickyard_api

COPY Gemfile /brickyard_api/Gemfile
COPY Gemfile.lock /brickyard_api/Gemfile.lock

RUN bundle install

COPY . /brickyard_api

EXPOSE 3000