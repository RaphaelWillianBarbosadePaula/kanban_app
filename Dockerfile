FROM ruby:3.4

RUN apt-get update -qq && apt-get install -y \
  postgresql-client \
  build-essential \
  libvips

WORKDIR /rails

ENV RAILS_ENV=development
ENV BUNDLE_PATH=/usr/local/bundle

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["rails", "server", "-b", "0.0.0.0"]
