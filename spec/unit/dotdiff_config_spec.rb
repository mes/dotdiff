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

  describe '#hide_element_css_name' do
    it 'defaults to hidden' do
      expect(subject.hide_element_css_name).to eq 'hidden'
    end

    it 'returns the user set value' do
      DotDiff.hide_element_css_name = 'hide'
      expect(subject.hide_element_css_name).to eq 'hide'
    end
  end

  describe '#js_elements_to_hide' do
    let(:elems) { ["document.findElementByid('f')", ""] }
    it 'defaults to an empty array' do
      expect(subject.js_elements_to_hide).to eq []
    end

    it 'returns the user elements' do
      DotDiff.js_elements_to_hide = elems
      expect(subject.js_elements_to_hide).to eq elems
    end
  end
end
