# syntax = docker/dockerfile:1

# Use Ruby
FROM ruby:3.3.7-slim

# Rails app lives here
WORKDIR /rails

# Install required system packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    ca-certificates \
    default-mysql-client \
    default-libmysqlclient-dev \
    git \
    libyaml-dev \
    nodejs \
    npm && \
    rm -rf /var/lib/apt/lists/*

# Copy gem files
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy application code
COPY . .

# Expose Rails port
EXPOSE 3000

# Start Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]