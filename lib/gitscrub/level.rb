module Gitscrub
  class Level
    include UI

    LEVELS = [nil, "init", "add", "commit", "config", "blame",  "contribute"]

    attr_accessor :level_no, :level_path
    
    class << self
      
      def load(level_no)
        level = new
        level_path = "#{File.dirname(__FILE__)}/../../levels/#{LEVELS[level_no]}"
        location = "#{level_path}.rb"
        return false unless File.exists?(location)
        level.instance_eval(File.read(location))
        level.level_no = level_no
        level.level_path = level_path
        level
      end

    end

    def init_from_level
      FileUtils.cp_r("#{level_path}/.", ".")
      FileUtils.mv(".gitscrub", ".git")
    end

    def difficulty(num)
      @difficulty = num
    end

    def description(description)
      @description = description
    end

    def solution(&block)
      @solution = block
    end

    def setup(&block)
      @setup = block 
    end

    def hint(&hint)
      @hint = hint
    end

    def full_description
      UI.puts
      UI.puts "Level: #{level_no}"
      UI.puts "Difficulty: #{"*"*@difficulty}"
      UI.puts
      UI.puts @description
      UI.puts
    end

    def setup_level
      repo.reset
      @setup.call if @setup
    end

    def repo
      @repo ||= Repository.new
    end

    def solve
      @solution.call
    rescue
      false
    end


    def show_hint
      UI.word_box("Gitscrub")
      if @hint
        @hint.call
      else
        UI.puts("No hints available for this level")
      end
    end
  end
end
