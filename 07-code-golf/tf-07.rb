raise 'Please assign an input file as ARGV[0]' if ARGV[0].nil?
raise 'Please assign an stop_words file as ARGV[1]' if ARGV[1].nil?

stops = open(ARGV[1]).read.split(',')
open(ARGV[0])
    .read
    .downcase
    .scan(/[a-z]{2,}/)
    .each_with_object(Hash.new 0) { |w, h| h[w] += 1 unless stops.include? w }
    .to_a
    .sort_by.with_index { |a, i| [-a[1], i] }[0..24]
    .each { |k, v| print "#{k} - #{v}\n" }