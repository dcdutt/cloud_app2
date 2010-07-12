# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
   user.name "Deepti Menon"
   user.email "dmdutt@zighra.com"
   user.phone "16137991499"
   user.password "deepti"
   user.password_confirmation "deepti"
end