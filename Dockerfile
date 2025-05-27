FROM ruby:2.7.6

ENV BUNDLER_VERSION=2.3.26

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    sqlite3 \
    libsqlite3-dev \
    libsqlite3-0 \
    build-essential libpq-dev curl nodejs yarn && \
    rm -rf /var/lib/apt/lists/*

RUN gem install bundler -v ${BUNDLER_VERSION}

COPY Gemfile* ./

RUN bundle lock --add-platform ruby && bundle install

RUN bundle install

COPY . .
