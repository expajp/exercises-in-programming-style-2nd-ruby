word_freqs = []
stop_words = []

open('../stop_words.txt') do |f|
   stop_words = f.read.split(',').map(&:downcase)
end

open(ARGV[0]) do |f|
    f.readlines.each do |line|
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
                        found = false
                        word_freqs.each do |pair|
                            if word == pair[0]
                                pair[1] += 1
                                found = true
                                break
                            end
                        end
    
                        if !found
                            word_freqs << [word, 1]
                        elsif word_freqs.size > 1
                            word_freqs_size = word_freqs.size
                            pointer = word_freqs_size - 1
    
                            for n in (0..word_freqs_size-1).to_a.reverse
                                if word_freqs[pointer][1] > word_freqs[n][1]
                                    word_freqs[n], word_freqs[pointer] = 
                                        word_freqs[pointer], word_freqs[n]
                                end
                                pointer = n
                            end
                        end
                    end

                    start_char_idx = nil
                end
            end
        end
    end
end

word_freqs.each { |pair| print "#{pair[0]} - #{pair[1]}\n" }
