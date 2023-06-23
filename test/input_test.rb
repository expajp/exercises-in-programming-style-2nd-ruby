require 'minitest/autorun'

$test_target_filepath = ARGV[0]

class InputTest < Minitest::Test
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
        ARGV[0] = '../input.txt'
        load $test_target_filepath
        assert_equal expected, $stdout.string
    end
end