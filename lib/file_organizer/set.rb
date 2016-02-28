class FileOrganizer::Set
  attr_accessor :folder, :guid

  def self.detect_existing(root_folder)
    Dir
      .glob(root_folder.join('*'))
      .map { |f| Pathname.new(f) }
      .map do |path|
        self.new.tap do |set|
          set.folder = root_folder
          set.guid   = path.basename.to_s
        end
      end
      .select { |set| set.valid? }
  end

  def files
    @files ||= Dir
      .glob(guid_folder.join('*'))
      .map do |f|
        FileOrganizer::Document.new(raw_file:f, set: self)
      end
      .select  { |d| d.qualify_for_upload? }
      .sort_by { |d, x| [(d.is_description_file ? 0 : 1), x] }
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

  def date
    desc_content.fetch('date')
  end

  def valid?
    File.exist?(description_file)
  end

  def delete_ready
    File.exist?(guid_folder.join('.delete_ready'))
  end

  def upload_ready
    desc_content.fetch('ready') && !locked?
  end

  def lock
    FileUtils.touch lock_file
  end

  def locked?
    File.exist?(lock_file)
  end

  private
    def lock_file
      guid_folder.join('.file_organizer_lock')
    end

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
