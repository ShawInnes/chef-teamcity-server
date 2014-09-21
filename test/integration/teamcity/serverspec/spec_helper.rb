
def database_exists?(database)
  expect(command %(sudo -u postgres psql -l | grep #{database})).to be_truthy
end