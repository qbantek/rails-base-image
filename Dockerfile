# Define Ruby, Rails, and Node.js versions as build arguments with default values
ARG RUBY_VERSION=3.4.1
ARG NODE_VERSION=22.13.0

# Base image: Official Ruby image with the specified version
FROM ruby:${RUBY_VERSION}-slim

# Set working directory
WORKDIR /app

# Install base runtime dependencies
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y \
  build-essential \
  curl \
  git \
  libjemalloc2 \
  node-gyp \
  pkg-config \
  python-is-python3 && \
  rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install Node.js and Yarn
ARG NODE_VERSION
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
  apt-get install --no-install-recommends -y \
  nodejs && \
  npm install -g yarn && \
  rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set environment variables for Bundler
ENV BUNDLE_DEPLOYMENT="1" \
  BUNDLE_PATH="/usr/local/bundle" \
  BUNDLE_WITHOUT="development test" \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3 \
  BUNDLE_FROZEN="1"

# Install Rails and clean up Bundler cache
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
  rm -rf ~/.bundle/ "${BUNDLE_PATH}/ruby/*/cache" "${BUNDLE_PATH}/ruby/*/bundler/gems/*/.git"

# Default command
CMD ["irb"]
