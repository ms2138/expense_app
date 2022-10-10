20.times do |i|
  name = "John #{i} Doe"
  email = "jdoe#{i}@example.com"
  password = "hello12"
  @user = User.create!(name:name, email: email, password: password, password_confirmation: password)

  @restaurant = @user.categories.create!(name: "Restaurants")
  @miscellaneous = @user.categories.create!(name: "Miscellaneous")
  @other = @user.categories.create!(name: "Other")
end