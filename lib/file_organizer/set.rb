class Set
  attr_accessor :folder, :guid

  def files
    @files ||= Dir
      .glob(guid_folder.join('*'))
      .map { |file| Pathname.new(file) }
      .select { |path| !(upload_blacklist).include?(path.basename.to_s) }
  end

  def prepare
    generate_guid
    create_guid_folder
    create_discription_file
  end

  def guid_folder
    folder.join(guid)
  end

  def upstream_json
    {
      title: title,
      description: description,
      guid: guid,
      type: type
    }
  end

  def type
    desc_content.fetch('type')
  end

  def title
    desc_content.fetch('title')
  end

  def description
    desc_content.fetch('description')
  end

  def upload_blacklist
    %w(description.yml .file_orginizer_delete_ready .file_orginizer_lock)
  end

  def delete_ready
    File.exist?(guid_folder.join('.delete_ready'))
  end

  def upload_ready
    desc_content.fetch('ready')
  end

  def locked
    File.exist?(guid_folder.join('.locked'))
  end

  private
    def create_guid_folder
      FileUtils.mkdir(guid_folder)
    end

    def create_discription_file
      FileUtils.cp(description_template, guid_folder.join('description.yml'))
    end

    def description_template
      FileOrganizer.config.template_folder.join('description.yml')
    end

    def description_file
      guid_folder.join('description.yml')
    end

    def generate_guid
      @guid = SecureRandom.hex
    end

    def desc_content
      @desc_content ||= YAML.load_file(description_file)
    end
end
