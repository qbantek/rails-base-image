# Define Ruby, Rails, and Node.js versions as build arguments with default values
ARG RUBY_VERSION=3.4.1
ARG RAILS_VERSION=8.0.1
ARG NODE_VERSION=22.13.0

# Base image: Official Ruby image with the specified version
FROM ruby:${RUBY_VERSION}-slim

# Set working directory
WORKDIR /app

# Install system dependencies for Rails, native extensions, and Node.js
ARG NODE_VERSION
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y \
  build-essential \
  libpq-dev \
  curl \
  git && \
  curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION%.*}.x | bash - && \
  apt-get install --no-install-recommends -y \
  nodejs \
  yarn && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Set environment variables for Bundler
ENV BUNDLE_DEPLOYMENT="1" \
  BUNDLE_PATH="/usr/local/bundle" \
  BUNDLE_WITHOUT="development test" \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3 \
  BUNDLE_FROZEN="1"

# Install Rails and clean up Bundler cache
ARG RAILS_VERSION
RUN gem install rails -v ${RAILS_VERSION} && \
  rm -rf /usr/local/bundle/cache /usr/src

# Default command
CMD ["irb"]
