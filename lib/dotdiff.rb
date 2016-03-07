require 'dotdiff/version'

require 'shellwords'
require 'tmpdir'

require 'dotdiff/command_wrapper'
require 'dotdiff/image'

module DotDiff
 class << self
   attr_accessor :perceptual_diff_bin, :resave_base_image, :failure_image_path,
                 :image_store_path, :overwrite_on_resave

   def configure
     yield self
   end

   def resave_base_image
     @resave_base_image ||= false
   end
 end
end
