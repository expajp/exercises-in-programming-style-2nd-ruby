raise 'Please assign an input file as ARGV[0]' if ARGV[0].nil?
raise 'Please assign an stop_words file as ARGV[1]' if ARGV[1].nil?

def count(word_list, stop_words, word_freqs)
    # 空のリストであった場合
    return if word_list.empty?

    # 再帰的な場合、つまりリストに単語が入っている場合
    # リスト先頭の単語を処理する
    word = word_list[0]
    if !stop_words.include?(word)
        word_freqs[word] ||= 0
        word_freqs[word] += 1
    end

    # 残りを処理する
    count(word_list[1..], stop_words, word_freqs)
end

def wf_print(word_freqs_ary)
    return if word_freqs_ary.empty?

    w, c = word_freqs_ary.first
    print("#{w} - #{c}\n")

    wf_print(word_freqs_ary[1..])
end

recursion_limit = 5000

stop_words = File.open(ARGV[1]).read.split(',')
word_list = File.open(ARGV[0]).read.gsub(/[\W_]+/, ' ').downcase.split(' ').select{ _1.match?(/[a-z]{2,}/) }
word_freqs = {}

# スタックを使い果たすのを防ぐためrecusrsion_limit ごとに処理
# 本来はcountを呼び出すだけで良い
0.step(word_list.count, recursion_limit) { |i| count(word_list[i..i+recursion_limit-1], stop_words, word_freqs) }

word_freqs_ary = word_freqs.to_a.sort_by.with_index { |v, i| [-v[1], i += 1] }[0..24]
wf_print(word_freqs_ary)