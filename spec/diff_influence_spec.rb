require 'spec_helper'

describe DiffInfluence do
  it 'has a version number' do
    expect(DiffInfluence::VERSION).not_to be nil
  end

  it 'can load pamanent config' do
    expect(DiffInfluence::Config.load).to eq nil
    expect(DiffInfluence::Config.search_extensions).to include("ruby")
  end

  it 'can parse args' do
    expect(DiffInfluence::Config.parse_args ["-g"]).to eq true
    expect(DiffInfluence::Config.os_grep).to eq true
  end
end
