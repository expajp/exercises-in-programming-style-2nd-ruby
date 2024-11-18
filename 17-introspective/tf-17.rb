raise 'Please assign an input file as ARGV[0]' if ARGV[0].nil?
raise 'Please assign an stop_words file as ARGV[1]' if ARGV[1].nil?

def caller_method
    caller[1].match(/.+:[0-9]+:in [`'](.+)'/).captures[0]
end

def read_stop_words(path_to_stop_words_file)
    return if caller_method != 'extract_words'

    File.open(binding.local_variable_get('path_to_stop_words_file')).read.split(',') + ('a'..'z').to_a
end

def extract_words(path_to_file, path_to_stop_words_file)
    word_list = File.open(binding.local_variable_get('path_to_file')).read.gsub(/[\W_]+/, ' ').downcase.split(' ')
    stop_words = read_stop_words(path_to_stop_words_file)

    word_list - stop_words
end

def frequencies(word_list)
    word_freqs = Hash.new(0)
    binding.local_variable_get('word_list').each do |w|
        word_freqs[w] += 1
    end

    word_freqs
end

def sort(word_freqs)
    word_freqs.to_a.sort_by.with_index { |v, i| [-v[1], i += 1] }
end

def main
    word_freqs = sort(frequencies(extract_words(ARGV[0], ARGV[1])))

    binding.local_variable_get('word_freqs')[0..24].each do |w, c|
        print("#{w} - #{c}\n")
    end
end

if __method__.nil?
    main
end
 