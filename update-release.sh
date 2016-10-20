#/bin/sh -x

# Update release

git pull
mix do deps.get
node node_modules/brunch/bin/brunch build --production
MIX_ENV=prod mix compile
MIX_ENV=prod mix phoenix.digest
MIX_ENV=prod mix release
rel/lonestarelixir/bin/lonestarelixir restart

