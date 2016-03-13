module DotDiff
  class ElementHandler
    attr_accessor :driver

    def initialize(driver, elements = DotDiff.js_elements_to_hide)
      @driver = driver
      @elements = elements
    end

    def hide
      elements.each do |elem|
        if element_exists?(elem)
          driver.execute_script("#{elem}.style.visibility = 'hidden'")
        end
      end
    end

    def show
      elements.each do |elem|
        if element_exists?(elem)
          driver.execute_script("#{elem}.style.visibility = ''")
        end
      end
    end

    def element_exists?(element)
      driver.evaluate_script("#{element} != undefined")
    end

    def elements
      @elements ||= []
    end
  end
end
