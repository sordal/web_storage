require 'google/cloud/storage'
require 'open-uri'

class WebStorage
  def initialize(key_file, config_file)

    # TODO: Load teh YAML File
    config = YAML.load_file(config_file)
    open(config['source']) {|f|
      File.open(config['target'],'wb') do |file|
        file.puts f.read
      end
    }
    @storage = Google::Cloud::Storage.new(
        project: config['project'],
        keyfile: key_file
    )
    @bucket = @storage.bucket config['storage_bucket']
    @seconds = config['seconds']
  end

  def execute
    # writes image to google cloud
    @bucket.create_file './test.jpg', 'test.jpg', {acl:'public_read'}
  end
end

# default values
key_file = 'site-data.json'
config_file = 'config.yml'

# TODO: Command line support:
# --key=/path/to/config/xxx.json
# --config=/path/to/config/config.yml

storage = WebStorage.new(key_file, config_file)
storage.execute

