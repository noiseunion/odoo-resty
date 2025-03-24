# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
directories(%w[lib test])
  .select { |d| Dir.exist?(d) ? d : UI.warning("Directory #{d} does not exist") }

# guard :minitest, all_on_start: false do
guard "minitest", cmd: "rake test", all_on_start: false do
  watch(%r{^lib/(.+)\.rb$})         { |m| "test/lib/#{m[1]}_test.rb" }
  watch(%r{^test/.+_test\.rb$})
  watch(%r{^test/test_helper\.rb$}) { "noop" }
end
