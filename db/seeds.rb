# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#

User.create([{ name: 'FirstUser', email: 'first_user@gmail.com' }, { name: 'SecondUser', email: 'second_user@gmail.com' }])
Repository.create([{ name: 'FirstRepo' }, { name: 'SecondRepo' }])

