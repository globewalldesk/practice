require 'minitest/autorun'
class TestSong < Minitest::Test

  def test_chicago
    me = {you: 100, foo: 5, bar: 2}
    assert_equal(me.values.max, me.delete(:you))
  end

end
