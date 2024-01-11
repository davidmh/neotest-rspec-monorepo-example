# Minimal config to debug neotest on monorepos

While setting up [neotest-rspec] in a monorepo, I noticed the tests would always run the rspec command from the root directory, which also includes a `Gemfile`.

To test the issue:

1. `cd service-a/ && bundle install && cd ..`
2. `nvim -u minimal-init.lua service-a/spec/minimal_spec.rb`
3. Run the tests using the summary

The test fails saying that the rspec gem couldn't be found in the Gemfile.

The problem goes away when the current working directory is `service-a/`

1. `cd service-a/`
2. `nvim -u ../minimal-init.la spec/minimal_spec.rb`
3. `:Neotest run<cr>`
4. Success!
