# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Topic.create(name:"Barack Obama", hyperlink:"Barack_Obama", start_count:1, end_count:0)
Topic.create(name:"Peanut", hyperlink:"Peanut", start_count:0, end_count:1)