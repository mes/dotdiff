require 'fileutils'

module DotDiff
  class Image
    attr_accessor :driver, :resave_base_image, :subdir, :file_name

    def initialize(opts = {})
      Hash(opts).each do |key, value|
        if self.respond_to?("#{key}=")
          self.send("#{key}=", value)
        end
      end
    end

    def compare
      outcome = []

      if !File.exists?(base_image_file) || resave_base_image
        path = capture_and_resave_base_image
        outcome = [true, path]
      else
        element_handler = ElementHandler.new(driver)
        result = CommandWrapper.new

        element_handler.hide
        result.run(base_image_file, capture_from_browser)
        element_handler.show

        outcome = [result.passed?, result.message]
      end

      outcome
    end

    def resave_base_image
      @resave_base_image.nil? ? DotDiff.resave_base_image : @resave_base_image
    end

    def base_image_file
      File.join(DotDiff.image_store_path, subdir.to_s, file_name)
    end

    private

    def capture_from_browser
      name = file_name
      name = "#{file_name}.png" unless file_name.include?('.png')
      tmp_screenshot_file = File.join(Dir.tmpdir, name)
      driver.save_screenshot(tmp_screenshot_file)

      tmp_screenshot_file
    end

    def capture_and_resave_base_image
      tmp_image = capture_from_browser
      FileUtils.mkdir_p(File.join(DotDiff.image_store_path, subdir))

      if !File.exists?(base_image_file) || DotDiff.overwrite_on_resave
        FileUtils.mv(tmp_image, base_image_file, force: true)
      else
        FileUtils.mv(tmp_image, "#{base_image_file}.r2", force: true)
      end
    end
  end
end
