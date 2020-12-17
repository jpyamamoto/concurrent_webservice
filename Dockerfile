# ./Dockerfile

# Extend from the official Elixir image
FROM elixir:1.10.4-alpine 

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install hex package manager
# By using --force, we don’t need to type “Y” to confirm the installation
RUN mix local.rebar --force
RUN mix local.hex --force
RUN mix clean

# Compile the project
RUN mix deps.get
RUN mix compile
RUN chmod +x entrypoint.sh

ENTRYPOINT ["sh", "/app/entrypoint.sh"]
