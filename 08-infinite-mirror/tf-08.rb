raise 'Please assign an input file as ARGV[0]' if ARGV[0].nil?
raise 'Please assign an stop_words file as ARGV[1]' if ARGV[1].nil?

def count(word_list, stop_words, word_freqs)
    # 空のリストであった場合
    return if word_list.empty?

    word = word_list[0]
    if !stop_words.include?(word)
        if word_freqs.include?(word)
            word_freqs[word] += 1
        else
            word_freqs[word] = 1
        end
    end
    count(word_list[1..], stop_words, word_freqs)
end

def wf_print(word_freqs)
    return if word_freqs.empty?

    w, c = word_freqs.first
    print("#{w} - #{c}\n")

    wf_print(word_freqs[1..])
end

recursion_limit = 5000

stop_words = []
open(ARGV[1]) { |f| stop_words = f.read.split(',') }
('a'..'z').to_a.each { |c| stop_words << c }

words = ''
open(ARGV[0]) { |f| words = f.read }
words = words.gsub(/[\W_]+/, ' ').downcase.split(' ')

word_freqs = {}

0.step(words.count, recursion_limit) do |i|
    count(words[i..i+recursion_limit-1], stop_words, word_freqs)
end
wf_print(word_freqs.to_a.sort_by.with_index { |v, i| [-v[1], i += 1] }[0..24])