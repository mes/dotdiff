module DotDiff
  class ElementHandler
    attr_accessor :driver, :elements

    def initialize(driver, elements = DotDiff.js_elements_to_hide)
      @driver = driver
      @elements = elements
    end

    def hide
      elements.each do |elem|
        driver.execute_script("#{elem}.style.visibility = 'hidden'")
      end
    end

    def show
      elements.each do |elem|
        driver.execute_script("#{elem}.style.visibility = ''")
      end
    end
  end
end
