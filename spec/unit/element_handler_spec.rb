require 'spec_helper'

class MockDriver
  def execute_script(str)
  end
end

RSpec.describe 'DotDiff::ElementHandler' do
  subject { DotDiff::ElementHandler.new(MockDriver.new) }

  before do
    DotDiff.js_elements_to_hide = [
      "document.getElementByClassName('master-opt')[0]",
      "document.getElementById('user-links')"
    ]
  end

  describe '#hide' do
    it 'calls execute_script adding css class' do
      expect_any_instance_of(MockDriver).to receive(:execute_script)
        .with("document.getElementByClassName('master-opt')[0].classList.add('hidden')").once

      expect_any_instance_of(MockDriver).to receive(:execute_script)
        .with("document.getElementById('user-links').classList.add('hidden')").once

      subject.hide
    end
  end

  describe '#show' do
    it 'calls execute_script removing css class' do
      expect_any_instance_of(MockDriver).to receive(:execute_script)
        .with("document.getElementByClassName('master-opt')[0].classList.remove('hidden')").once

      expect_any_instance_of(MockDriver).to receive(:execute_script)
        .with("document.getElementById('user-links').classList.remove('hidden')").once

      subject.show
    end
  end
end
