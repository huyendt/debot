class Person  
  #attr_accessor name
  
  def name=(name)
    @name = name
  end
  
  def name
    @name
  end
end

person = Person.new
person.name = 'Huyen'

puts person.name
