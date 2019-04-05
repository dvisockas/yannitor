require 'spec_helper'

RSpec.describe Yannitor do
  it 'has a version number' do
    expect(Yannitor::VERSION).not_to be nil
  end

  it 'yolo' do
    expect('yolo').to eq('yolo')
  end
end
