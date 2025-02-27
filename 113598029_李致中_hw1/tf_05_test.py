import unittest
import tf_05

class TestTF05(unittest.TestCase):
    def test_filter_chars_and_normalize(self):
        sentence = "This is a test. This test is only a test."
        excepted = "this is a test  this test is only a test "
        global data
        tf_05.data = list(sentence)
        tf_05.filter_chars_and_normalize()
        self.assertEqual(tf_05.data, list(excepted))

    def test_scan(self):
        sentence = "this is not a hard test  this test is only a test "
        excepted = ["this", "is", "not", "a", "hard", "test", "this", "test", "is", "only", "a", "test"]
        global data
        global words
        tf_05.data = list(sentence)
        tf_05.scan()
        self.assertEqual(tf_05.words, excepted)


    def test_scan_twice(self):
        sentence = "this is not a hard test  this test is only a test "
        excepted = ["this", "is", "not", "a", "hard", "test", "this", "test", "is", "only", "a", "test"]
        global data
        global words
        tf_05.data = list(sentence)
        tf_05.scan()
        self.assertEqual(tf_05.words, excepted)

    # def test_filter_chars_and_normalize_twice(self):
    #     sentence = "This is Not a test. This test is only a test."
    #     excepted = "this is not a test  this test is only a test "
    #     global data
    #     tf_05.data = list(sentence)
    #     tf_05.filter_chars_and_normalize()
    #     self.assertEqual(tf_05.data, list(excepted))

if __name__ == '__main__':
    unittest.main()
