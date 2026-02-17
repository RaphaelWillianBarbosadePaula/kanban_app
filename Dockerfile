FROM ruby:3.4

# Dependências do sistema
RUN apt-get update -qq && apt-get install -y \
  postgresql-client \
  build-essential \
  libvips \
  && rm -rf /var/lib/apt/lists/*

# Cria usuário igual ao host
RUN useradd -m -u 1000 app

WORKDIR /rails

# Variáveis do Bundler
ENV BUNDLE_PATH=/bundle
ENV BUNDLE_BIN=/bundle/bin
ENV GEM_HOME=/bundle
ENV PATH="/bundle/bin:${PATH}"

# Copia Gemfile antes (cache)
COPY Gemfile Gemfile.lock ./

# Instala gems como root
RUN bundle install

# Copia o código
COPY . .

# Dá permissão pro usuário
RUN chown -R app:app /rails /bundle

# Troca pro usuário não-root
USER app

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
