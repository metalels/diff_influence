require 'spec_helper'

describe DiffInfluence do
  it 'has a version number' do
    expect(DiffInfluence::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(DiffInfluence::Config.parse_options ["--debug"]).to eq true
  end
end
