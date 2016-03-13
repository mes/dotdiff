require 'spec_helper'

class MockDriver
  def execute_script(str)
  end

  def evaluate_script(str)
  end
end

RSpec.describe 'DotDiff::ElementHandler' do
  subject { DotDiff::ElementHandler.new(MockDriver.new) }

  before do
    allow(DotDiff).to receive(:js_elements_to_hide).and_return([
      "document.getElementByClassName('master-opt')[0]",
      "document.getElementById('user-links')"
    ])
  end

  describe '#hide' do
    it 'calls execute_script setting the visibility to hidden' do
      allow(subject).to receive(:element_exists?).and_return(true)

      expect_any_instance_of(MockDriver).to receive(:execute_script)
        .with("document.getElementByClassName('master-opt')[0].style.visibility = 'hidden'").once

      expect_any_instance_of(MockDriver).to receive(:execute_script)
        .with("document.getElementById('user-links').style.visibility = 'hidden'").once

      subject.hide
    end

    it 'doesnt call the set visibility when element doesnt exist' do
      allow(subject).to receive(:element_exists?).and_return(false)

      expect_any_instance_of(MockDriver).not_to receive(:execute_script)
      expect_any_instance_of(MockDriver).not_to receive(:execute_script)

      subject.hide
    end
  end

  describe '#show' do
    it 'calls execute_script when setting the visibility to show' do
      allow(subject).to receive(:element_exists?).and_return(true)

      expect_any_instance_of(MockDriver).to receive(:execute_script)
        .with("document.getElementByClassName('master-opt')[0].style.visibility = ''").once

      expect_any_instance_of(MockDriver).to receive(:execute_script)
        .with("document.getElementById('user-links').style.visibility = ''").once

      subject.show
    end
  end

  describe '#elements' do
    it 'returns an empty array when not set' do
      allow(DotDiff).to receive(:js_elements_to_hide).and_return(nil)
      expect(subject.elements).to eq []
    end

    it 'returns the user set value js_elements_to_hide' do
      allow(DotDiff).to receive(:js_elements_to_hide).and_return(['blah', 'blue'])
      expect(subject.elements).to eq ['blah', 'blue']
    end
  end

  describe '#element_hidden?' do
    it 'call evalute script' do
      expect_any_instance_of(MockDriver).to receive(:evaluate_script).with('blah != undefined').once
      subject.element_exists?('blah')
    end
  end
end
