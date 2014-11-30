
##### ExecAvailable module for Array and String testing of available system executables

module ExecAvaliable
  def self.included(base)
    @allowed_classes = [Array,String]
    unless allowed_classes.include? base
      raise "ExecAvailable included in an unsupported class"
    end
    super
  end

  def bins_available?
    bins_available(self)[0]
  end

  def missing_bins
    bins_available(self)[1]
  end

  private

  def bins_available bins
    if bins.class == String
      bins = bins.split(/\s*,\s*/)
    end
    matched = []
    missed = []
    bins.each {|b|
      %x{type -t #{b}}
       $?.exitstatus == 0 ? matched.push(b) : missed.push(b)
    }
    # found == bins.length
    [matched.length==bins.length,missed]
  end
end
