raise 'Please assign an input file as ARGV[0]' if ARGV[0].nil?
raise 'Please assign an stop_words file as ARGV[1]' if ARGV[1].nil?

class TFExercise

    def info
        self.class.name
    end
end

class DataStorageManager < TFExercise
    
    def initialize(path_to_file)
        self.data = File.open(path_to_file).read.gsub(/[\W_]+/, ' ').downcase
    end
    
    def words
        self.data.split(' ')
    end
    
    def info
        "#{super.info}: My major data structure is a #{self.data.class.name}"
    end

    private

    attr_accessor :data
end

class StopWordManager < TFExercise
    
    def initialize(path_to_stop_words_file)
        self.stop_words = File.open(path_to_stop_words_file).read.split(',')
        self.stop_words += ('a'..'z').to_a
    end
    
    def stop_word?(word)
        self.stop_words.include?(word)
    end
    
    def info
        "#{super.info}: My major data structure is a #{self.stop_words.class.name}"
    end

    private

    attr_accessor :stop_words
end

class WordFrequencyManager < TFExercise
    
    def initialize
        self.word_freqs = Hash.new(0)
    end
    
    def increment_count(word)
        self.word_freqs[word] += 1
    end
    
    def sorted
        self.word_freqs.to_a.sort_by.with_index { |v, i| [-v[1], i += 1] }
    end

    def info
        "#{super.info}: My major data structure is a #{self.word_freqs.class.name}"
    end

    private

    attr_accessor :word_freqs
end

class WordFrequencyController < TFExercise

    def initialize(path_to_file, path_to_stop_words_file)
        self.storage_manager = DataStorageManager.new(path_to_file)
        self.stop_word_manager = StopWordManager.new(path_to_stop_words_file)
        self.word_freq_manager = WordFrequencyManager.new
    end

    def run
        self.storage_manager.words.each do |word|
            if !self.stop_word_manager.stop_word?(word)
                self.word_freq_manager.increment_count(word)
            end
        end

        word_freqs = self.word_freq_manager.sorted
        word_freqs[0..24].each { |k, v| print("#{k} - #{v}\n") }
    end

    private

    attr_accessor :storage_manager, :stop_word_manager, :word_freq_manager
end

WordFrequencyController.new(ARGV[0], ARGV[1]).run