#/bin/sh -x

# Update release

git pull
mix do deps.get
node assets/node_modules/brunch/bin/brunch build --production
MIX_ENV=prod mix compile
MIX_ENV=prod mix phx.digest
MIX_ENV=prod mix release
rel/lonestarelixir/bin/lonestarelixir stop
rel/lonestarelixir/bin/lonestarelixir start
