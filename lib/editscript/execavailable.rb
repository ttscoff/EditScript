module ScriptingTools
  # ExecAvailable module for Array and String testing of
  # available system executables
  module ExecAvailable
    def self.included(base)
      allowed_classes = [Array, String]
      unless allowed_classes.include? base
        fail 'ExecAvailable included in an unsupported class'
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

    def bins_available(bins)
      bins = bins.split(/\s*[ ,]\s*/) if bins.class == String
      matched = []
      missed = []
      bins.each do |b|
        `type -t #{b}`
        $CHILD_STATUS == 0 ? matched.push(b) : missed.push(b)
      end
      # found == bins.length
      [matched.length == bins.length, missed]
    end
  end
end
