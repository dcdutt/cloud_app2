require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Admin User",
                 :email => "admin@zighra.org",
                 :phone => "16132241400",
                 :password => "foobar",
                 :password_confirmation => "foobar",
                 :mobile_pin => "1234")
    admin.toggle!(:admin)
    99.times do |n|
      name  = Faker::Name.name
      email = "example#{n+1}@zighra.org"
      if n < 9
         phone = "1613224140#{n+1}"
      else
         phone = "161322414#{n+1}"
      end
      password  = "password"
      mobile_pin = "1234"
      User.create!(:name => name,
                   :email => email,
                   :phone => phone,
                   :password => password,
                   :password_confirmation => password,
                   :mobile_pin => mobile_pin)
    end
  end
end
