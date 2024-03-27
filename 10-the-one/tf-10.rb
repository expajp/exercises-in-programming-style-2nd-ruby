raise 'Please assign an input file as ARGV[0]' if ARGV[0].nil?
raise 'Please assign an stop_words file as ARGV[1]' if ARGV[1].nil?

class TFTheOne
    attr_accessor :_value

    def initialize(v)
        self._value = v
    end

    def bind(func)
        self._value = func.call(self._value)
        
        self
    end

    def printme
        print(self._value)
    end
end

def read_file(path_to_file)
    File.open(path_to_file).read
end

def filter_chars(str_data)
    str_data.gsub(/[\W_]+/, ' ')
end

def normalize(str_data)
    str_data.downcase
end

def scan(str_data)
    str_data.split(' ')
end

def remove_stop_words(word_list)
    stop_words = File.open(ARGV[1]).read.split(',')
    stop_words += ('a'..'z').to_a

    word_list - stop_words
end

def frequencies(word_list)
    word_freqs = Hash.new(0)
    word_list.each do |w|
        word_freqs[w] += 1
    end

    word_freqs
end

def sort(word_freq)
    word_freq.to_a.sort_by.with_index { |v, i| [-v[1], i += 1] }
end

def top25_freqs(word_freqs)
    top25 = ""

    word_freqs[0..24].each do |tf|
        top25 += "#{tf[0]} - #{tf[1]}\n"
    end

    top25
end

TFTheOne.new(ARGV[0])
    .bind(method(:read_file))
    .bind(method(:filter_chars))
    .bind(method(:normalize))
    .bind(method(:scan))
    .bind(method(:remove_stop_words))
    .bind(method(:frequencies))
    .bind(method(:sort))
    .bind(method(:top25_freqs))
    .printme
