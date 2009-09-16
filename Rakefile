task :default do
  sh 'cat README'
end

task :chapter2 do
  Dir.chdir("chapter2")
  ['http://semprog.com/psw/chapter2/business_triples.csv',
   'http://semprog.com/psw/chapter2/celeb_triples.csv',
   'http://semprog.com/psw/chapter2/celeb_triples.txt',
   'http://semprog.com/psw/chapter2/movies.csv',
   'http://semprog.com/psw/chapter2/place_triples.txt'].each do |file|
    sh "curl -O #{file}"
  end
  Dir.chdir("..")
end
