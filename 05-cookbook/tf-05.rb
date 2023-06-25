raise 'Please assign an input file as ARGV[0]' if ARGV[0].nil?
raise 'Please assign an stop_words file as ARGV[1]' if ARGV[1].nil?

$data = []
$words = []
$word_freqs = []

def read_file(path_to_file)
    open(path_to_file) do |f|
        data += f.read
    end
end

def filter_chars_and_normalize
    $data.length.times do |i|
        if !$data[i].match?(/^[[:alnum:]]$/)
            $data[i] = ' '
        else
            $data[i] = $data[i].downcase
        end
    end
end

def scan
    data_str = data.to_s
    $words += data_str.split(' ')
end

def remove_stop_words
    open(ARGV[1]) do |f|
        stop_words = f.read.split(',')
    end
    stop_words += ('a'..'z').to_a

    words.each do |word|
        words.delete(word) if stop_words.include?(word)
    end
end

def frequencies
    $words.each do |word|
        keys = $word_freqs.map { _1[0] }
        if keys.include?(word)
            $word_freqs[keys.index(word)][1] += 1
        else
            $word_freqs << [word, 1]
        end
    end
end

def sort
    word_freqs.sort { |a, b| b[1] <=> a[1] }
end

read_file(ARGV[0])
filter_chars_and_normalize
scan
remove_stop_words
frequencies
sort

$word_freqs[0..24].each do |pair|
    print "#{pair[0]} - #{pair[1]}\n"
end