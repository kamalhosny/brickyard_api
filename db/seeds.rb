user1 = User.admin.create!(
  name: 'Kamal Hosny',
  email: 'kamal@brickyard.eu',
  password: '123456'
)

user2 = User.create!(
  name: 'Test User',
  email: 'test@test.com',
  password: '123456'
)

State.create!(
  [{ name: 'Assembled', order: '1' },
   { name: 'Painted', order: '2' },
   { name: 'Tested', order: '3' },
   { name: 'Designed', order: '4' }]
)

user1.vehicles.create!(description: 'BMW')
user1.vehicles.create!(description: 'Toyota')
user2.vehicles.create!(description: 'Mercedes')
