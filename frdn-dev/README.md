# frdn-dev

development environment for frdn

## with macOS

### setup dev env

```sh
# on project root dir (NOT on frdn-docs)
rbenv install
nvm install && nvm use
brew install protobuf libidn postgresql
bundle install
yarn install --pure-lockfile
gem install foreman --no-document

cat << EOF > .env
DB_HOST=localhost
DB_USER=postgres
DEFAULT_HASHTAG=frfr
DEFAULT_HASHTAG_ID=1
EOF

rails db:setup
```

### run dev env

```sh
# run db and redis
docker-compose -f frdn-dev/docker-compose-dev.yml up -d db redis
```

```sh
# in other terminal
bundle install
rails db:migrate
nvm use && yarn install --pure-lockfile
nvm use && foreman start
```

### troubleshooting

error: `Library not loaded: /usr/local/opt/icu4c/lib/libicudata.64.dylib"`

```sh
# reverting homebrew formula
cd /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/Formula
# restore v64.2
git restore --source a806a621ed3722fb580a58000fb274a2f2d86a6d icu4c.rb
# reinstall
brew reinstall icu4c
```

```sh
# fix error `LoadError: Could not open library '~/.rbenv/versions/2.6.6/lib/ruby/gems/2.6.0/gems/cld3-3.3.0/lib/../ext/cld3/libcld3.bundle': dlopen(~/.rbenv/versions/2.6.6/lib/ruby/gems/2.6.0/gems/cld3-3.3.0/lib/../ext/cld3/libcld3.bundle, 5): Library not loaded: /usr/local/opt/protobuf/lib/libprotobuf.22.dylib`
```

## with Docker

:warning: Docker dev env is WIP

:information_source: letter_opener_web not working

```sh
COMPOSE_FILE=frdn-dev/docker-compose-dev.yml

docker-compose build

# first run
docker-compose up -d db
docker-compose run app bundle exec rails db:setup

docker-compose run app bundle exec rails db:migrate
docker-compose up -d
docker-compose logs -f
docker-compose down
```
