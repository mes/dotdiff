require 'spec_helper'

RSpec.describe DotDiff::CommandWrapper do
  subject { DotDiff::CommandWrapper.new }
  before  { DotDiff.perceptual_diff_bin = '/bin/echo' }

  let(:base_img) { '/home/test/image 12343.png' }
  let(:new_img)  { '/home/test/compare_1234 3.png' }

  describe '#command' do
    let(:escaped_cmd) { "/bin/echo /home/test/image\\ 12343.png /home/test/compare_1234\\ 3.png -verbose" }

    it 'escapes both base and new file names' do
      expect(subject.send(:command, base_img, new_img)).to eq escaped_cmd
    end
  end

  describe '#run' do
      it 'assigns false to failed variable' do
        subject.run('PASS: They are the same', '')
        expect(subject.failed?).to eq false
      end

    context 'when it fails' do
      before { subject.run('FAIL:', "haha\ngood") }

      it 'assigns true to failed when stdout has FAIL' do
        expect(subject.failed?).to be_truthy
        expect(subject.message).to eq "FAIL: haha good -verbose"
      end
    end

    context 'when the program doesnt exist' do
      before  { DotDiff.perceptual_diff_bin = '/bin/echoo' }
      let(:error) { "No such file or directory - /bin/echoo" }

      it 'raises an exception when program not found' do
        expect { subject.run('haha','haha') }.to raise_error(Errno::ENOENT, error)
      end
    end
  end
end
