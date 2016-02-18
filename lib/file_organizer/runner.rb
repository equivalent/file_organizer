class Runner
  attr_reader :sets
  attr_accessor :folder, :sets_size

  def initialize
    @sets = []
  end

  def run
    detect_existing_sets
    prepare_extra_sets
    starts_uploading
  end

  private
    def starts_uploading
      # todo
    end

    def prepare_set
      Set.new
        .tap { |s| s.folder = folder }
        .tap { |s| s.prepare }
    end

    def detect_existing_sets
      self.sets.concat(Set.detect_existing(folder))
    end

    def prepare_extra_sets
      (sets_size - sets.size).times do
        sets << prepare_set
      end
    end
end
