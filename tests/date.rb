#date comparison 
require 'date'
require 'pry'

birth = DateTime.now.new_offset(0)
puts "birth: #{birth}"


puts "please input date and time of desired death"
puts "format is YYYY-MM-DD HH:MM:SS"
input = gets.chomp

death = DateTime.parse(input)
puts "death: #{death}"


comparison = death-birth

if comparison > 0
puts "#{comparison.to_i} days until death"
else
puts "Already dead"
end



# binding.pry

