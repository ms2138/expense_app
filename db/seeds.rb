20.times do |i|
  email = "jdoe#{i}@example.com"
  password = "hello12"
  @user = User.create!(email: email, password: password, password_confirmation: password)
end

@restaurant = Category.create!(name: "Restaurants")
@miscellaneous = Category.create!(name: "Miscellaneous")
@other = Category.create!(name: "Other")