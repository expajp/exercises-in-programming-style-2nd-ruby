word_freqs = {}
stop_words = []

open('../stop_words.txt') do |f|
   stop_words = f.read.split(',').map(&:downcase)
end

open(ARGV[0]) do |f|
    f.readlines.map(&:chomp).each do |line|
        start_char_idx = nil
        line.each_char.with_index do |c, i|
            if start_char_idx.nil?
                if c.match?(/^[a-zA-Z0-9]$/)
                    start_char_idx = i
                end
            else
                if !c.match?(/^[a-zA-Z0-9]$/)
                    word = line[start_char_idx..i].strip.downcase
                    if !stop_words.include?(word)
                        if word_freqs.has_key?(word)
                            word_freqs[word] += 1
                        else
                            word_freqs[word] = 1
                        end
                    end
                    start_char_idx = nil
                end
            end
        end
    end
end

word_freqs.sort { |a, b| b[1] <=> a[1] }.each { |pair| print "#{pair[0]} - #{pair[1]}\n" }