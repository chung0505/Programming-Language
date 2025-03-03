import unittest
import tf_05

class TestTF05(unittest.TestCase):
    def setUp(self):
        tf_05.data = []
        tf_05.words = []
        tf_05.word_freqs = []

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
        tf_05.filter_chars_and_normalize()
        self.assertEqual(tf_05.data, list(excepted))

    def test_scan(self):
        excepted = ["this", "is", "not", "a", "hard", "test", "this", "test", "is", "only", "a", "test"]
        tf_05.data = "this is not a hard test  this test is only a test "
        tf_05.scan()
        self.assertEqual(tf_05.words, excepted)

    """
        在這裡測試第二次scan的時候，words的值是利用words = words + data_str.split()的方式來更新的
        因為words是全域變數且裡面原本的值沒有被清除因此words中的值會被累加上去，進而導致測試錯誤
        以此證明沒有idempotent
    """
    # def test_scan_twice(self):
    #     excepted = ["this", "is", "not", "a", "hard", "test", "this", "test", "is", "only", "a", "test"]
    #     tf_05.data = "this is not a hard test  this test is only a test "
    #     tf_05.scan()
    #     tf_05.scan()
    #     self.assertEqual(tf_05.words, excepted)

    def test_remove_stop_words(self):
        excepted = ["hard", "test", "test", "test"]
        tf_05.words = ["this", "is", "not", "a", "hard", "test", "this", "test", "is", "only", "a", "test"]
        tf_05.remove_stop_words()
        self.assertEqual(tf_05.words, excepted)

    def test_remove_stop_words_twice(self):
        excepted = ["hard", "test", "test", "test"]
        tf_05.words = ["this", "is", "not", "a", "hard", "test", "this", "test", "is", "only", "a", "test"]
        tf_05.remove_stop_words()
        tf_05.remove_stop_words()
        self.assertEqual(tf_05.words, excepted)

    def test_frequencies(self):
        excepted = [["hard", 1], ["test", 3]]
        tf_05.words = ["hard", "test", "test", "test"]
        tf_05.frequencies()
        self.assertEqual(tf_05.word_freqs, excepted)

    """
        frequencies函數是將words中的值進行統計，並將結果存放在word_freqs中
        透過word_freqs[keys.index(w)][1] += 1的方式來更新word_freqs中的值
        因此在第二次呼叫frequencies的時候，word_freqs中的值會被累加，進而導致測試錯誤
    """
    # def test_frequencies_twice(self):
    #     excepted = [["hard", 1], ["test", 3]]
    #     tf_05.words = ["hard", "test", "test", "test"]
    #     tf_05.frequencies()
    #     tf_05.frequencies()
    #     self.assertEqual(tf_05.word_freqs, excepted)

    def test_sort(self):
        excepted = [["test", 3], ["hard", 1]]
        tf_05.word_freqs = [["hard", 1], ["test", 3]]
        tf_05.sort()
        self.assertEqual(tf_05.word_freqs, excepted)
    
    def test_sort＿twice(self):
        excepted = [["test", 3], ["hard", 1]]
        tf_05.word_freqs = [["hard", 1], ["test", 3]]
        tf_05.sort()
        tf_05.sort()
        self.assertEqual(tf_05.word_freqs, excepted)

if __name__ == '__main__':
    unittest.main()

"""
    是idempotent的函數： filter_chars_and_normalize, remove_stop_words, sort
    filter_chars_and_normalize, sort這些函數並未修改到全域變數的值應此符合idempotent的特性
    remove_stop_words這個函數雖然有修改到全域變數的值，但是在第二次呼叫的時候，words中的值已經被刪除過了
    不是idempotent的函數： scan, frequencies
"""