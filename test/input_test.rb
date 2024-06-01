require 'minitest/autorun'

$test_target_filepath = ARGV[0]
$toplevel_filepath = ARGV[1] || `pwd`.chomp || '/Users/shu/workspaces/git/exs_pg_style_rb'

class InputTest < Minitest::Test
    def test_stdout_by_test_txt
        expected = <<~EOS
        acquaintance - 1
        suppose - 1
        sure - 1
        know - 1
        EOS
        $stdin = StringIO.new
        $stdout = StringIO.new
        $stderr = StringIO.new
        ARGV[0] = "#{$toplevel_filepath}/test.txt"
        ARGV[1] = "#{$toplevel_filepath}/stop_words.txt"
        load "#{$toplevel_filepath}/#{$test_target_filepath}"
        assert_equal expected, $stdout.string
    end

    def test_stdout_by_input_txt
        expected = <<~EOS
        live - 2
        mostly - 2
        white - 1
        tigers - 1
        india - 1
        wild - 1
        lions - 1
        africa - 1
        EOS
        $stdin = StringIO.new
        $stdout = StringIO.new
        $stderr = StringIO.new
        ARGV[0] = "#{$toplevel_filepath}/input.txt"
        ARGV[1] = "#{$toplevel_filepath}/stop_words.txt"
        load "#{$toplevel_filepath}/#{$test_target_filepath}"
        assert_equal expected, $stdout.string
    end

    def test_stdout_by_pride_and_prejudice_txt
        expected = <<~EOS
        mr - 786
        elizabeth - 635
        very - 488
        darcy - 418
        such - 395
        mrs - 343
        much - 329
        more - 327
        bennet - 323
        bingley - 306
        jane - 295
        miss - 283
        one - 275
        know - 239
        before - 229
        herself - 227
        though - 226
        well - 224
        never - 220
        sister - 218
        soon - 216
        think - 211
        now - 209
        time - 203
        good - 201
        EOS
        $stdin = StringIO.new
        $stdout = StringIO.new
        $stderr = StringIO.new
        ARGV[0] = "#{$toplevel_filepath}/pride-and-prejudice.txt"
        ARGV[1] = "#{$toplevel_filepath}/stop_words.txt"
        load "#{$toplevel_filepath}/#{$test_target_filepath}"
        assert_equal expected, $stdout.string
    end
end
