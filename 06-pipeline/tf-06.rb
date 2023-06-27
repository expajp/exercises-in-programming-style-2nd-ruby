raise 'Please assign an input file as ARGV[0]' if ARGV[0].nil?
raise 'Please assign an stop_words file as ARGV[1]' if ARGV[1].nil?

def read_file(path_to_file)
    data = ''
    open(path_to_file) do |f|
        data = f.read
    end

    data
end

def filter_chars_and_normalize(str_data)
    str_data.gsub(/[\W]+/, ' ').downcase
end

def scan(str_data)
    str_data.split(' ')
end

def remove_stop_words(word_list)
    stop_words = []
    open(ARGV[1]) do |f|
        stop_words = f.read.split(',')
    end
    ('a'..'z').to_a.each { |c| stop_words << c }

    word_list.select { |word| !stop_words.include?(word) }
end

def frequencies(word_list)
    word_freqs = {}
    word_list.each do |word|
        if word_freqs.has_key?(word)
            word_freqs[word] += 1
        else
            word_freqs[word] = 1
        end
    end

    word_freqs
end

def sort(word_freq)
    word_freq.to_a.sort_by.with_index { |v, i| [-v[1], i += 1] }
end

def print_all(word_freqs)
    if !word_freqs.empty?
        print "#{word_freqs[0][0]} - #{word_freqs[0][1]}\n"
        print_all(word_freqs[1..])
    end
end

print_all(
    sort(
        frequencies(
            remove_stop_words(
                scan(
                    filter_chars_and_normalize(
                        read_file(
                            ARGV[0]
                        )
                    )
                )
            )
        )
    )[0..24]
)