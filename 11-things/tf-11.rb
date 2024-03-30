raise 'Please assign an input file as ARGV[0]' if ARGV[0].nil?
raise 'Please assign an stop_words file as ARGV[1]' if ARGV[1].nil?

class TFExercise

    def info
        self.class.name
    end
end

class DataStorageManager < TFExercise

    def initialize(path_to_file)
        @data = File.open(path_to_file).read.gsub(/[\W_]+/, ' ').downcase
    end
    
    def words
        @data.split(' ')
    end
    
    def info
        "#{super.info}: My major data structure is a #{@data.class.name}"
    end
end

class StopWordManager < TFExercise
    
    def initialize(path_to_stop_words_file)
        @stop_words = File.open(path_to_stop_words_file).read.split(',')
        @stop_words += ('a'..'z').to_a
    end
    
    def stop_word?(word)
        @stop_words.include?(word)
    end
    
    def info
        "#{super.info}: My major data structure is a #{@stop_words.class.name}"
    end
end

class WordFrequencyManager < TFExercise
    
    def initialize
        @word_freqs = Hash.new(0)
    end
    
    def increment_count(word)
        @word_freqs[word] += 1
    end
    
    def sorted
        @word_freqs.to_a.sort_by.with_index { |v, i| [-v[1], i += 1] }
    end

    def info
        "#{super.info}: My major data structure is a #{@word_freqs.class.name}"
    end
end

class WordFrequencyController < TFExercise

    def initialize(path_to_file, path_to_stop_words_file)
        @storage_manager = DataStorageManager.new(path_to_file)
        @stop_word_manager = StopWordManager.new(path_to_stop_words_file)
        @word_freq_manager = WordFrequencyManager.new
    end

    def run
        @storage_manager.words.each do |word|
            if !@stop_word_manager.stop_word?(word)
                @word_freq_manager.increment_count(word)
            end
        end

        word_freqs = @word_freq_manager.sorted
        word_freqs[0..24].each { |k, v| print("#{k} - #{v}\n") }
    end
end

WordFrequencyController.new(ARGV[0], ARGV[1]).run