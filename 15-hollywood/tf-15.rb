raise 'Please assign an input file as ARGV[0]' if ARGV[0].nil?
raise 'Please assign an stop_words file as ARGV[1]' if ARGV[1].nil?

class WordFrequencyFramework
    attr_accessor :_load_event_handlers, :_dowork_event_handlers, :_end_event_handlers

    def initialize
        self._load_event_handlers = []
        self._dowork_event_handlers = []
        self._end_event_handlers = []
    end

    def register_for_load_event(handler)
        self._load_event_handlers.append(handler)
    end
    
    def register_for_dowork_event(handler)
        self._dowork_event_handlers.append(handler)
    end
    
    def register_for_end_event(handler)
        self._end_event_handlers.append(handler)
    end

    def run(path_to_file)
        self._load_event_handlers.each { |h| h.call(path_to_file) }
        self._dowork_event_handlers.each { |h| h.call }
        self._end_event_handlers.each { |h| h.call }
    end
end

class DataStorage
    attr_accessor :_data, :_stop_word_filter, :_word_event_handlers

    def initialize(wfapp, stop_word_filter)
        self._data = ''
        self._stop_word_filter = stop_word_filter
        self._word_event_handlers = []
        
        wfapp.register_for_load_event(method(:__load).to_proc)
        wfapp.register_for_dowork_event(method(:__produce_words).to_proc)
    end

    def __load(path_to_file)
        self._data = File.open(path_to_file).read.gsub(/[\W_]+/, ' ').downcase
    end

    def __produce_words
        self._data.split(' ').each do |w|
            if !self._stop_word_filter.stop_word?(w)
                self._word_event_handlers.each { |h| h.call(w) }
            end
        end
    end

    def register_for_word_event(handler)
        self._word_event_handlers.append(handler)
    end
end

class StopWordFilter
    attr_accessor :_stop_words

    def initialize(wfapp)
        self._stop_words = []
        wfapp.register_for_load_event(method(:__load).to_proc)
    end

    def __load(ignore)
        self._stop_words = File.open(ARGV[1]).read.split(',') + ('a'..'z').to_a
    end

    def stop_word?(word)
        self._stop_words.include?(word)
    end
end

class WordFrequencyCounter
    attr_accessor :_word_freqs

    def initialize(wfapp, data_storage)
        self._word_freqs = {}

        data_storage.register_for_word_event(method(:__increment_count).to_proc)
        wfapp.register_for_end_event(method(:__print_freqs).to_proc)
    end

    def __increment_count(word)
        if self._word_freqs.keys.include?(word)
            self._word_freqs[word] += 1
        else
            self._word_freqs[word] = 1
        end
    end

    def __print_freqs
        word_freqs = self._word_freqs.to_a.sort_by.with_index { |v, i| [-v[1], i += 1] }
        word_freqs[0..24].each do |w, c|
            print("#{w} - #{c}\n")
        end
    end
end

wfapp = WordFrequencyFramework.new
stop_word_filter = StopWordFilter.new(wfapp)
data_storage = DataStorage.new(wfapp, stop_word_filter)
word_freq_counter = WordFrequencyCounter.new(wfapp, data_storage)

wfapp.run(ARGV[0])
