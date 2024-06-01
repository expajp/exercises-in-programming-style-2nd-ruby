raise 'Please assign an input file as ARGV[0]' if ARGV[0].nil?
raise 'Please assign an stop_words file as ARGV[1]' if ARGV[1].nil?

class IDataStorage
    def initialize
        raise
    end

    def words
        raise
    end
end

class IStopWordFilter
    def initialize
        raise
    end

    def stop_word?(word)
        raise
    end
end

class IWordFrequencyCounter
    def initialize
        raise
    end

    def increment_count(word)
        raise
    end

    def sorted
        raise
    end
end

data_storage_manager = Class.new(IDataStorage)
stop_word_manager = Class.new(IStopWordFilter)
word_frequency_manager = Class.new(IWordFrequencyCounter)

data_storage_manager.class_eval do
    def initialize(path_to_file)
        @data = File.open(path_to_file).read.gsub(/[\W_]+/, ' ').downcase.split(' ')
    end

    def words
        @data
    end
end
DataStorageManager = data_storage_manager

stop_word_manager.class_eval do
    def initialize(path_to_stop_words_file)
        @stop_words = File.open(path_to_stop_words_file).read.split(',') + ('a'..'z').to_a
    end

    def stop_word?(word)
        @stop_words.include?(word)
    end
end
StopWordManager = stop_word_manager

word_frequency_manager.class_eval do
    def initialize
        @word_freqs = {}
    end

    def increment_count(word)
        if @word_freqs.keys.include?(word)
            @word_freqs[word] += 1
        else
            @word_freqs[word] = 1
        end
    end

    def sorted
        @word_freqs.to_a.sort_by.with_index { |v, i| [-v[1], i += 1] }
    end
end
WordFrequencyManager = word_frequency_manager

class WordFrequencyController
    def initialize(path_to_file, path_to_stop_words_file)
        @storage = ::DataStorageManager.new(path_to_file)
        @stop_word_manager = ::StopWordManager.new(path_to_stop_words_file)
        @word_freq_counter = ::WordFrequencyManager.new
    end

    def run
        @storage.words.each do |w|
            unless @stop_word_manager.stop_word?(w)
                @word_freq_counter.increment_count(w)
            end
        end
        word_freqs = @word_freq_counter.sorted
        word_freqs[0..24].each do |w, c|
            print("#{w} - #{c}\n")
        end
    end
end

WordFrequencyController.new(ARGV[0], ARGV[1]).run