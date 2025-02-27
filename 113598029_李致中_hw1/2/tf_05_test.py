import unittest
import tf_05

class TestTF05(unittest.TestCase):
    def test_filter_chars_and_normalize(self):
        sentence = "This is a test. This test is only a test."
        excepted = "this is a test  this test is only a test "
        tf_05.data = list(sentence)
        tf_05.filter_chars_and_normalize()
        self.assertEqual(tf_05.data, list(excepted))

    def test_filter_chars_and_normalize_twice(self):
        sentence = "This is Not a hard test. This test is only a test."
        excepted = "this is not a hard test  this test is only a test "
        tf_05.data = list(sentence)
        tf_05.filter_chars_and_normalize()
        self.assertEqual(tf_05.data, list(excepted))

    def test_scan(self):
        excepted = ["this", "is", "not", "a", "hard", "test", "this", "test", "is", "only", "a", "test"]
        tf_05.scan()
        self.assertEqual(tf_05.words, excepted)

    """
        在這裡測試第二次scan的時候，words的值是利用words = words + data_str.split()的方式來更新的
        因為words是全域變數且裡面原本的值沒有被清除因此words中的值會被累加上去，進而導致測試錯誤
        以此證明沒有idempotent
    """
    def test_scan_twice(self):
        excepted = ["this", "is", "not", "a", "hard", "test", "this", "test", "is", "only", "a", "test"]
        global words
        tf_05.scan()
        self.assertEqual(tf_05.words, excepted)

if __name__ == '__main__':
    unittest.main()
