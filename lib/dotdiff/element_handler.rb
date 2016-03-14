module DotDiff
  class ElementHandler
    attr_accessor :driver

    def initialize(driver, elements = DotDiff.js_elements_to_hide)
      @driver = driver
      @elements = elements
    end

    def hide
      elements.each do |xpath|
        if element_exists?(xpath)
          driver.execute_script("#{js_element(xpath)}.style.visibility = 'hidden'")
        end
      end
    end

    def show
      elements.each do |xpath|
        if element_exists?(xpath)
          driver.execute_script("#{js_element(xpath)}.style.visibility = ''")
        end
      end
    end

    def js_element(xpath)
      "document.evaluate(\"#{xpath}\", "\
      "document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue"
    end

    def element_exists?(xpath)
      # TODO: Allow custom overriding beyond Capybara.default_max_wait_time
      driver.find(:xpath, xpath, wait: 5) rescue nil
    end

    def elements
      @elements ||= []
    end
  end
end
