word_freqs = []
stop_words = []

open('../stop_words.txt') do |f|
   stop_words = f.read.split(',').map(&:downcase)
end

for line in open(ARGV[0]).readlines
    start_char_idx = nil

    i = 0
    for c in line.chars
        if start_char_idx.nil?
            if c.match?(/^[a-zA-Z0-9]$/)
                start_char_idx = i
            end
        else
            if !c.match?(/^[a-zA-Z0-9]$/)
                word = line[start_char_idx..i].strip.downcase

                if !stop_words.include?(word)
                    found = false

                    pair_index = 0
                    for pair in word_freqs
                        if word == pair[0]
                            pair[1] += 1
                            found = true
                            break
                        end
                        pair_index += 1
                    end

                    if !found
                        word_freqs << [word, 1]
                    elsif word_freqs.size > 1
                        pointer = pair_index

                        for n in (0..pair_index).to_a.reverse
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
        i += 1
    end
end

for pair in word_freqs do
    print "#{pair[0]} - #{pair[1]}\n"
end
