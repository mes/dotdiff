require 'dotdiff/version'

require 'shellwords'
require 'tmpdir'
require 'fileutils'

require 'dotdiff/command_wrapper'
require 'dotdiff/element_handler'

require 'dotdiff/element_meta'
require 'dotdiff/image/cropper'
require 'dotdiff/snapshot'
require 'dotdiff/comparer'

module DotDiff
  class << self
    attr_accessor :image_magick_diff_bin, :resave_base_image, :failure_image_path,
      :image_store_path, :overwrite_on_resave, :xpath_elements_to_hide,
      :max_wait_time

    attr_writer :image_magick_options, :pixel_threshold

    def configure
      yield self
    end

    def resave_base_image
      @resave_base_image ||= false
    end

    def xpath_elements_to_hide
      @xpath_elements_to_hide ||= []
    end

    def image_magick_options
      @image_magick_options ||= '-fuzz 5% -metric AE'
    end

    def pixel_threshold
      @pixel_threshold ||= 100
    end

    def max_wait_time
      @max_wait_time || Capybara.default_max_wait_time
    end
  end
end
