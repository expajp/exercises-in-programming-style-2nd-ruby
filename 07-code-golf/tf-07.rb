raise 'Please assign an input file as ARGV[0]' if ARGV[0].nil?
raise 'Please assign an stop_words file as ARGV[1]' if ARGV[1].nil?

stops = open(ARGV[1]).read.split(',')
open(ARGV[0])
    .read
    .downcase
    .scan(/[a-z]{2,}/)
    .each_with_object(Hash.new 0) { _2[_1] += 1 if !stops.include? _1 }
    .to_a
    .sort_by.with_index { [-_1[1], _2] }[0..24]
    .each { print "#{_1} - #{_2}\n" }