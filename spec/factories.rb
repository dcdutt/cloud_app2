# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
   user.name "Deepti Dutt"
   user.email "ddutt@zighra.com"
   user.phone "16137991479"
   user.password "deepti"
   user.password_confirmation "deepti"
end