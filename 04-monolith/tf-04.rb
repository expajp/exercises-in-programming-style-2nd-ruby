word_freqs = []
stop_words = []

raise 'Please assign an input file as ARGV[0]' if ARGV[0].nil?
raise 'Please assign an stop_words file as ARGV[1]' if ARGV[1].nil?

open(ARGV[1]) do |f|
    stop_words = f.read.split(',')
    for c in ('a'..'z').to_a
        stop_words << c
    end
end

for line in open(ARGV[0]).readlines
    start_char_idx = nil

    i = 0
    for c in line.chars
        if start_char_idx.nil?
            if c.match?(/^[[:alnum:]]$/)
                start_char_idx = i
            end
        else
            if !c.match?(/^[[:alnum:]]$/)
                word = line[start_char_idx..(i-1)].downcase # Pythonだと line[start_char_idx:i]

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

for pair in word_freqs[0..24] do
    print "#{pair[0]} - #{pair[1]}\n"
end
