module API
class Parameters
  attr_accessor :name
  attr_accessor :type
  attr_accessor :required
  attr_accessor :values
  attr_accessor :test_value
  attr_accessor :default
  
  def initialize(options={})
   @name = options[:name]
   @type = options[:type] || String
   @required = options[:required] || false
   @values = options[:values]
   @test_value = options[:test_value]
   @default = false if boolean? && @default == nil
  end

  def integer?
   @type == Integer
  end
      
  def string?
   @type == String
  end
    
  def boolean?
   @type == 'Boolean'
  end

  def array?
   @values.class == Array
  end

  def range?
   @values.class == Range
  end

  def required?
   @required == true
  end
 end 
end