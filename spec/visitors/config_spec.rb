require 'spec_helper'

describe Visitors::Config do
  describe '#all' do
    it 'uses the config.yml file to return a hash of configuration information' do
      File.stub!(:expand_path => '/path/to/config.yml')
      YAML.should_receive(:load_file).with('/path/to/config.yml').and_return('development' => {})
      Visitors::Config.load.all
    end

    it 'raises when an environment is not defined' do
      expect {
	YAML.stub!(:load_file => {})
	Visitors::Config.load.all
      }.to raise_error(Visitors::Config::MissingEnvironmentError)
    end
  end
end
