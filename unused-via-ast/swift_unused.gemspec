Gem::Specification.new do |s|
  s.name        = 'swift-unused'
  s.version     = '0.0.1'
  s.date        = '2017-10-31'
  s.summary     = 'Gem for searching for unused code in Swift via ast file'
  s.description = <<-THEEND
Tool that allows to search for unused code in swift 
THEEND
  s.authors     = ['Paul Taykalo']
  s.email       = 'tt.kilew@gmail.com'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    =
      'https://github.com/PaulTaykalo/swift-scripts'
  s.license       = 'MIT'
  s.executables << 'swift-unused'
  s.add_runtime_dependency 'objc-dependency-tree-generator', '~> 0.1.0'
end