FROM ruby:2.6.3

ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

# ruby:2.6.3 uses Debian Buster; update apt sources to archived mirrors.
RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list && \
  sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list && \
  printf 'Acquire::Check-Valid-Until "false";\nAcquire::AllowInsecureRepositories "true";\n' > /etc/apt/apt.conf.d/99archive

RUN apt-get update -qq && \
  apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    libsqlite3-dev \
    default-libmysqlclient-dev \
    default-mysql-client \
    shared-mime-info \
    nodejs \
    npm && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Gemfile.lock expects Bundler 2.1.4
RUN gem install bundler -v 2.1.4

COPY Gemfile Gemfile.lock ./

# mimemagic 0.3.3 was yanked; update the locked version to a still-available one.
# --conservative limits unrelated upgrades (helps avoid ffi/Ruby compatibility surprises).
RUN bundle update mimemagic marcel --conservative && bundle install

COPY . .

RUN bundle update mimemagic marcel --conservative && bundle install

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["docker-entrypoint.sh"]

