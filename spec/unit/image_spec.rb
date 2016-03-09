require 'spec_helper'

class MockDriver
  def save_screenshot(file)
  end
end

RSpec.describe DotDiff::Image do
  subject { DotDiff::Image.new(opts) }
  let(:mockdriver) { MockDriver.new }
  let(:base_file) { '/tmp/T/test.png' }
  let(:opts) {{ driver: mockdriver, resave_base_image: true, subdir: 'T', file_name: 'test.png' }}

  before do
    DotDiff.image_store_path = '/tmp'
    DotDiff.resave_base_image = true
    allow(File).to receive(:exists?).with(base_file).and_return(true)
  end

  describe '#initialize' do
    it "doesnt error when option method doesn't exist" do
      expect { DotDiff::Image.new(blah: 'whatever', file_dir: '/ds/ds/') }.not_to raise_error
    end

    it 'assigns the options to the instance vars' do
      expect(subject.driver).to eq mockdriver
      expect(subject.resave_base_image).to eq true
      expect(subject.subdir).to eq 'T'
      expect(subject.file_name).to eq 'test.png'
    end
  end

  describe '#base_image_file' do
    it 'returns the full path to the base_image' do
      expect(subject.base_image_file).to eq '/tmp/T/test.png'
    end
  end

  describe '#resave_base_image' do
    it 'returns the overriden user set value' do
      expect(DotDiff::Image.new(resave_base_image: false).resave_base_image).to be_falsey
    end

    it 'returns the global dotdiff set value' do
      expect(DotDiff::Image.new.resave_base_image).to be_truthy
    end
  end

  describe '#capture_from_browser' do
    it 'calls save_screenshot with temporary location' do
      expect(subject.driver).to receive(:save_screenshot).with(Dir.tmpdir + '/test.png').once
      expect(subject.send(:capture_from_browser)).to eq File.join(Dir.tmpdir, 'test.png')
    end

    it 'correctly appends the png file extension' do
      subj = DotDiff::Image.new(driver: mockdriver, file_name: 'tmpshot')
      expect(subj.driver).to receive(:save_screenshot).with(Dir.tmpdir + '/tmpshot.png').once
      expect(subj.send(:capture_from_browser)).to eq File.join(Dir.tmpdir, 'tmpshot.png')
    end
  end

  describe '#capture_and_resave_base_image' do
    before { allow(File).to receive(:exists?).and_return(true) }

    it 'calls mkdir_p to ensure subdir exist' do
      expect(FileUtils).to receive(:mkdir_p).with(DotDiff.image_store_path + '/T')
      subject.send(:capture_and_resave_base_image)
    end

    context 'when overwrite on resave' do
      before { DotDiff.overwrite_on_resave = true }

      it 'calls FileUtils with force option' do
        allow(subject).to receive(:capture_from_browser).and_return('/tmp/S/shot.png')
        expect(FileUtils).to receive(:mv).with('/tmp/S/shot.png', base_file, force: true)

        subject.send(:capture_and_resave_base_image)
      end
    end

    context 'when overwrite on resave false' do
      before { DotDiff.overwrite_on_resave = false }
      let(:newfile) { '/tmp/A/shot1.png' }
      let(:altered_file) { "#{base_file}.r2" }

      it 'calls FileUtils with an altered file name destination' do
        allow(subject).to receive(:capture_from_browser).and_return('/tmp/A/shot1.png')
        expect(FileUtils).to receive(:mv).with('/tmp/A/shot1.png', altered_file, force: true)
        subject.send(:capture_and_resave_base_image)
      end

      it 'creates base_image_file without r2 when original file doesnt exist' do
        allow(File).to receive(:exists?).and_return(false)
        allow(subject).to receive(:capture_from_browser).and_return('/tmp/A/shot1.png')
        expect(FileUtils).to receive(:mv).with(newfile, base_file, force: true)
        subject.send(:capture_and_resave_base_image)
      end
    end
  end

  describe '#compare' do
    context 'when resave_base_image is true' do
      it 'calls capture_and_resave_base_image' do
        allow(subject).to receive(:resave_base_image).and_return(true)
        expect(subject).to receive(:capture_and_resave_base_image).once

        subject.compare
      end
    end

    context 'when the base_image_file doesnt exist and resave false' do
      it 'calls capture_and_resave_base_image' do
        allow(subject).to receive(:resave_base_image).and_return(false)
        expect(File).to receive(:exists?).with(base_file).and_return(false)
        expect(subject).to receive(:capture_and_resave_base_image).once

        subject.compare
      end
    end

    context 'when resave_base_image is false' do
      let(:command_wrapper) { DotDiff::CommandWrapper.new }
      let(:elem_handler) { DotDiff::ElementHandler.new(subject.driver) }

      before do
        allow(subject).to receive(:resave_base_image).and_return(false)
        allow(subject).to receive(:capture_from_browser).and_return('/tmp/S/blah.png')
        allow(DotDiff::CommandWrapper).to receive(:new).and_return(command_wrapper)

        command_wrapper.instance_variable_set('@ran_checks', true)
        command_wrapper.instance_variable_set('@failed', false)

      end

      it 'calls element handler' do
        expect(DotDiff::ElementHandler).to receive(:new)
          .with(subject.driver).once.and_return(elem_handler)

        expect_any_instance_of(DotDiff::ElementHandler).to receive(:hide).once
        expect_any_instance_of(DotDiff::ElementHandler).to receive(:show).once
        expect_any_instance_of(DotDiff::CommandWrapper).to receive(:run)
          .with('/tmp/T/test.png', '/tmp/S/blah.png').once

        subject.compare
      end

      context 'when images match' do
        it 'calls command wrapper' do
          expect_any_instance_of(DotDiff::CommandWrapper).to receive(:run)
           .with('/tmp/T/test.png', '/tmp/S/blah.png').once

          expect(subject.compare).to eq [true, nil]
        end
      end

      context 'when the images dont match' do
        before do
          command_wrapper.instance_variable_set('@ran_checks', true)
          command_wrapper.instance_variable_set('@failed', true)
          command_wrapper.instance_variable_set('@message', 'FAILED: 120px pixel different')
        end

        it 'returns false' do
          expect_any_instance_of(DotDiff::CommandWrapper).to receive(:run)
           .with('/tmp/T/test.png', '/tmp/S/blah.png').once

          expect(subject.compare).to eq [false, 'FAILED: 120px pixel different']
        end
      end
    end
  end
end
