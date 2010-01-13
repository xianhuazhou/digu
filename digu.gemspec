Gem::Specification.new do |s|
  s.name = "digu"
  s.version = "0.1"
  s.date = "2010-01-12"
  s.summary = "Client library of digu.com"
  s.email = "xianhua.zhou@gmail.com"
  s.homepage = "http://my.cnzxh.net/"
  s.description = "This is a client library of digu.com  for post messages and ..."
  s.rubyforge_project = "digu"
  s.has_rdoc = true
  s.authors = ["Zhou Xianhua"]
  s.files = Dir["lib/**/*", "README.rdoc", "ChangeLog"]
  s.add_dependency('http_request.rb', '>= 1.1')
end
