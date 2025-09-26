# Rails Base Image

A lightweight Docker base image for Rails 8 applications with Ruby 3.4.1 and Rails 8.0.1.

## Features

- Ruby 3.4.1
- Rails 8.0.1
- Pre-installed dependencies for Rails applications
- Node.js 22.13.0 and Yarn for JavaScript asset management

---

## Usage

### Using This Image as a Base

To use this image as the base for your Rails applications, reference it in your
project's `Dockerfile`:

```dockerfile
# Use the Rails base image (recommended - always latest)
FROM ghcr.io/qbantek/rails-base-image:latest

# Or pin to a specific version (optional)
# FROM ghcr.io/qbantek/rails-base-image:3.4.1-22.13.0-8.0.3

# Set working directory
WORKDIR /app

# Copy application files
COPY . .

# Install application dependencies
RUN bundle install

# Expose the application port
EXPOSE 3000

# Default command
CMD ["rails", "server", "-b", "0.0.0.0"]
```

#### Available Tags

- `:latest` - Always points to the most recent build
- `:3.4.1-22.13.0-8.0.3` - Pinned to specific Ruby/Node/Rails versions

The versioned tag format is `ruby-node-rails` (e.g., `3.4.1-22.13.0-8.0.3`).

### Building the Base Image

If you need to build the base image itself (e.g., for customization), follow
these steps.

#### Build Arguments

- `RUBY_VERSION`: Ruby version to use (default: `3.4.1`).
- `RAILS_VERSION`: Rails version to install (default: `8.0.1`).
- `NODE_VERSION`: Node.js version to install (default: `22.13.0`).

#### Build Commands

1. Build with default versions:

```bash
docker build -t rails-base-image .
```

2. Build with custom versions:

```bash
docker build --build-arg RUBY_VERSION=3.3.0 \
             --build-arg RAILS_VERSION=7.1.0 \
             --build-arg NODE_VERSION=18.17.1 \
             -t rails-base-image .
```

#### Pushing to a Registry

To make this image reusable across projects, push it to a container registry
such as GitHub Container Registry:

```bash
docker tag rails-base-image ghcr.io/<your-username>/rails-base-image:latest
docker push ghcr.io/<your-username>/rails-base-image:latest
```

## Version Consistency

The GitHub Actions workflow includes automatic validation to ensure version consistency across all configuration files:

- **Ruby version**: Validates `mise.toml` matches workflow environment
- **Node version**: Validates `mise.toml` matches workflow environment
- **Rails version**: Validates `Gemfile` matches workflow environment

If versions don't match, the build will fail with clear error messages.

## Additional Notes

- This image is optimized for production environments.
- Built for `linux/amd64` platform only.
- For development environments, consider adding development tools or using a
  different image.
