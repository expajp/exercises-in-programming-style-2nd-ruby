raise 'Please assign an input file as ARGV[0]' if ARGV[0].nil?
raise 'Please assign an stop_words file as ARGV[1]' if ARGV[1].nil?

class EventManager
    attr_accessor :_subscriptions

    def initialize
        self._subscriptions = Hash.new { [] }
    end

    def subscribe(event_type, handler)
        self._subscriptions[event_type] += [handler]
    end

    def publish(event)
        event_type = event[0]
        if self._subscriptions.keys.include?(event_type)
            self._subscriptions[event_type].each { |h| h.call(event) } 
        end
    end
end

class DataStorage
    attr_accessor :_event_manager, :_data

    def initialize(event_manager)
        self._event_manager = event_manager
        self._event_manager.subscribe('load', method(:load).to_proc)
        self._event_manager.subscribe('start', method(:produce_words).to_proc)
    end

    def load(event)
        path_to_file = event[1]
        self._data = File.open(path_to_file).read.gsub(/[\W_]+/, ' ').downcase
    end

    def produce_words(event)
        self._data.split(' ').each do |w|
            self._event_manager.publish(['word', w])
        end
        self._event_manager.publish(['eof', nil])
    end
end

class StopWordFilter
    attr_accessor :_stop_words, :_event_manager

    def initialize(event_manager)
        self._stop_words = []
        self._event_manager = event_manager
        self._event_manager.subscribe('load', method(:load).to_proc)
        self._event_manager.subscribe('word', method(:stop_word?).to_proc)
    end

    def load(event)
        self._stop_words = File.open(ARGV[1]).read.split(',') + ('a'..'z').to_a
    end

    def stop_word?(event)
        word = event[1]
        if !self._stop_words.include?(word)
            self._event_manager.publish(['valid_word', word])
        end
    end
end

class WordFrequencyCounter
    attr_accessor :_word_freqs, :_event_manager

    def initialize(event_manager)
        self._word_freqs = Hash.new(0)
        self._event_manager = event_manager
        self._event_manager.subscribe('valid_word', method(:increment_count).to_proc)
        self._event_manager.subscribe('print', method(:print_freqs).to_proc)
    end

    def increment_count(event)
        word = event[1]
        self._word_freqs[word] += 1
    end

    def print_freqs(event)
        word_freqs = self._word_freqs.to_a.sort_by.with_index { |v, i| [-v[1], i += 1] }
        word_freqs[0..24].each do |w, c|
            print("#{w} - #{c}\n")
        end
    end
end

class WordFrequencyApplication
    attr_accessor :_event_manager

    def initialize(event_manager)
        self._event_manager = event_manager
        self._event_manager.subscribe('run', method(:run).to_proc)
        self._event_manager.subscribe('eof', method(:stop).to_proc)
    end

    def run(event)
        path_to_file = event[1]
        self._event_manager.publish(['load', path_to_file])
        self._event_manager.publish(['start', nil])
    end

    def stop(event)
        self._event_manager.publish(['print', nil])
    end
end

em = EventManager.new
DataStorage.new(em)
StopWordFilter.new(em)
WordFrequencyCounter.new(em)
WordFrequencyApplication.new(em)
em.publish(['run', ARGV[0]])
