raise 'Please assign an input file as ARGV[0]' if ARGV[0].nil?
raise 'Please assign an stop_words file as ARGV[1]' if ARGV[1].nil?

def extract_words(obj, path_to_file)
    obj[:data] = File.open(path_to_file).read.gsub(/[\W_]+/, ' ').downcase.split(' ')
end

def load_stop_words(obj, path_to_stop_words_file)
    obj[:stop_words] = File.open(path_to_stop_words_file).read.split(',') + ('a'..'z').to_a
end

def increment_count(obj, w)
    if !obj[:freqs].keys.include?(w)
        obj[:freqs][w] = 1
    else
        obj[:freqs][w] += 1
    end
end

data_storage_obj = {
    data: [],
    init: ->(path_to_file) { extract_words(data_storage_obj, path_to_file) },
    words: -> { data_storage_obj[:data] }
}

stop_words_obj = {
    stop_words: [],
    init: ->(path_to_stop_words_file) { load_stop_words(stop_words_obj, path_to_stop_words_file) },
    is_stop_word: ->(word) { stop_words_obj[:stop_words].include?(word) }
}

word_freqs_obj = {
    freqs: {},
    increment_count: ->(w) { increment_count(word_freqs_obj, w) },
    sorted: -> { word_freqs_obj[:freqs].to_a.sort_by.with_index { |v, i| [-v[1], i += 1] } }
}

data_storage_obj[:init].call(ARGV[0])
stop_words_obj[:init].call(ARGV[1])

data_storage_obj[:words].call.each do |w|
    unless stop_words_obj[:is_stop_word].call(w)
        word_freqs_obj[:increment_count].call(w)
    end
end

word_freqs = word_freqs_obj[:sorted].call
word_freqs[0..24].each do |w, c|
    print("#{w} - #{c}\n")
end
