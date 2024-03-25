raise 'Please assign an input file as ARGV[0]' if ARGV[0].nil?
raise 'Please assign an stop_words file as ARGV[1]' if ARGV[1].nil?

def read_file(path_to_file, func)
    data = File.open(path_to_file).read

    # func: filter_chars
    func.call(data, method(:normalize).to_proc)
end

def filter_chars(str_data, func)
    pattern = /[\W_]+/
    
    # func: normalize
    func.call(str_data.gsub(pattern, ' '), method(:scan).to_proc)
end

def normalize(str_data, func)
    # func: scan
    func.call(str_data.downcase, method(:remove_stop_words).to_proc)
end

def scan(str_data, func)
    # func: remove_stop_words
    func.call(str_data.split(' '), method(:frequencies).to_proc)
end

def remove_stop_words(word_list, func)
    stop_words = File.open(ARGV[1]).read.split(',')
    stop_words += ('a'..'z').to_a

    # func: frequencies
    func.call(word_list - stop_words, method(:sort).to_proc)
end

def frequencies(word_list, func)
    wf = Hash.new(0)
    word_list.each { |w| wf[w] += 1 }
    
    # func: sort
    func.call(wf, method(:print_text).to_proc)
end

def sort(wf, func)
    sorted_wf = wf.to_a.sort_by.with_index { |v, i| [-v[1], i += 1] }

    func.call(sorted_wf, method(:no_op).to_proc)
end

def print_text(word_freqs, func)
    word_freqs[0..24].each do |w, c|
        print("#{w} - #{c}\n")
    end

    # func: no_op
    func.call(nil)
end

def no_op(func) = nil

read_file(ARGV[0], method(:filter_chars).to_proc)