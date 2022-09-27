20.times do |i|
  email = "jdoe#{i}@example.com"
  password = "hello12"
  @user = User.create!(email: email, password: password, password_confirmation: password)

  @restaurant = @user.categories.create!(name: "Restaurants")
  @miscellaneous = @user.categories.create!(name: "Miscellaneous")
  @other = @user.categories.create!(name: "Other")
end