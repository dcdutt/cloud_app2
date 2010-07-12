require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Example User",
                 :email => "example@zighra.org",
                 :phone => "16132241400",
                 :password => "foobar",
                 :password_confirmation => "foobar")
    admin.toggle(:admin)
    99.times do |n|
      name  = Faker::Name.name
      email = "example#{n+1}@zighra.org"
      if n < 9
         phone = "1613224140#{n+1}"
      else
         phone = "161322414#{n+1}"
      end
      password  = "password"
      User.create!(:name => name,
                   :email => email,
                   :phone => phone,
                   :password => password,
                   :password_confirmation => password)
    end
  end
end
