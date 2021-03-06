require 'spec_helper'

RSpec.describe 'Dotdiff configuration' do
  subject { DotDiff }
  let(:user_methods) do
    (DotDiff.public_methods - Object.public_methods).reject do |mth|
      mth.to_s.include?('=') || mth == :configure
    end
  end

  before(:each) do
    user_methods.each {|mth| DotDiff.instance_variable_set("@#{mth}", nil)}
  end

  describe '#resave_base_image' do
    it 'returns false when not set' do
      expect(subject.resave_base_image).to eq false
    end

    it 'returns user defined value' do
      subject.resave_base_image = true
      expect(subject.resave_base_image).to be_truthy
    end
  end

  describe '#image_magick_diff_bin' do
    it 'trims any newlines' do
      DotDiff.image_magick_diff_bin = "/usr/bin/compare\n"
      expect(DotDiff.image_magick_diff_bin).to eq '/usr/bin/compare'
    end
  end

  describe '#image_magick_options' do
    let(:opts) { '-fuzz 10% -metric phash' }

    it 'returns the default options' do
      expect(subject.image_magick_options).to eq '-fuzz 5% -metric AE'
    end

    it 'returns the user set options' do
      DotDiff.image_magick_options = opts
      expect(subject.image_magick_options).to eq opts
    end
  end

  describe 'pixel_threshold' do
    it 'returns the default 100 pixels' do
      expect(subject.pixel_threshold).to eq 100
    end

    it 'returns the user defined value' do
      DotDiff.pixel_threshold = 120
      expect(subject.pixel_threshold).to eq 120
    end
  end

  describe '#image_store_path' do
    let(:path) { '/tmp/image_store_path' }

    it 'returns the user set value' do
      DotDiff.image_store_path = path
      expect(subject.image_store_path).to eq path
    end
  end

  describe '#failure_image_path' do
    let(:path) { '/tmp/failed_image_store' }

    it 'returns the user set value' do
      DotDiff.failure_image_path   = path
      expect(subject.failure_image_path).to eq path
    end
  end

  describe '#xpath_elements_to_hide' do
    let(:elems) { ["document.findElementByid('f')", ""] }
    it 'defaults to an empty array' do
      expect(subject.xpath_elements_to_hide).to eq []
    end

    it 'returns the user elements' do
      DotDiff.xpath_elements_to_hide = elems
      expect(subject.xpath_elements_to_hide).to eq elems
    end
  end

  describe '#default_max_wait_time' do
    context 'when dotdiff max wait time is set' do
      before { subject.instance_variable_set('@max_wait_time', 18) }

      it 'returns the Dotdiff set time' do
        expect(subject.max_wait_time).to eq 18
      end
    end

    context 'when dotdiff wait time not set' do
      before { subject.instance_variable_set('@max_wait_time', nil) }

      it 'returns the capybara default max wait time' do
        expect(Capybara).to receive(:default_max_wait_time).and_return(8).once
        expect(subject.max_wait_time).to eq 8
      end
    end
  end
end
