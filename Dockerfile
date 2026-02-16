FROM ruby:3.4

RUN apt-get update -qq && apt-get install -y \
  postgresql-client \
  build-essential \
  libvips

WORKDIR /rails

ENV RAILS_ENV=development
ENV BUNDLE_PATH=/rails/vendor/bundle
ENV BUNDLE_BIN=/rails/vendor/bundle/bin
ENV GEM_HOME=/rails/vendor/bundle
ENV PATH="/rails/vendor/bundle/bin:${PATH}"


COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["rails", "server", "-b", "0.0.0.0"]