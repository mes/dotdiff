require 'dotdiff/version'
require 'shellwords'

require 'dotdiff/command_wrapper'

module DotDiff
 class << self
   attr_accessor :perceptual_diff_bin, :raise_error_on_diff, :resave_base_image,
                 :failure_image_path, :image_store_path

   def configure
     yield self
   end

   def raise_error_on_diff
     @raise_error_on_diff.nil? ? true : @raise_error_on_diff
   end

   def resave_base_image
     @resave_base_image ||= false
   end
 end
end
