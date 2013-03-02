require 'rake/testtask'

task  :default => [:treetop, :test]

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*test.rb']
  t.verbose = true
end

task :treetop do 
  # Generate the parser from the treetop source
  print "Generating the parser..."
  system("tt #{File.expand_path('../src/pay_file.treetop', __FILE__)}" )
  system("mv #{File.expand_path('../src/pay_file.rb',__FILE__)} #{File.expand_path('../lib/pay_file_parser.rb',__FILE__)}" )
  puts "done."
end

task :clean do
  system( "rm -r #{File.expand_path("../doc/*", __FILE__)}")
  system( "rmdir #{File.expand_path("../doc", __FILE__)}")
  system( "rm #{File.expand_path("../lib/pay_file_parser.rb", __FILE__)}")
end

task :doc do
  system("rdoc --exclude #{File.expand_path("../lib/pay_file_parser.rb", __FILE__)}")
end