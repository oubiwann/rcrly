(defmodule unit-rcrly-xml-tests
  (behaviour ltest-unit)
  (export all)
  (import
    (from ltest
      (check-failed-assert 2)
      (check-wrong-assert-exception 2))))

(include-lib "ltest/include/ltest-macros.lfe")

;;; data for tests

(defun test-data-0 ()
  `(#(key1 val1)
    #(key2 val2)
    #(body (#(key3 val3)
            #(key4 val4)
            #(content "some content")))
    #(key5 val5)))

(defun test-data-1 ()
  '(#(address () ("108 Main"
                  "Apt #3"))
    #(city () ("Fairville"))
    #(state () ("Wisconsin"))
    #(zip () ("12345"))))

(defun test-data-2 ()
  '(#(level1-1 () ("thing"))
    #(level1-2 () ("ring"))
    #(level1-3
      ()
      (#(level2-1 () ("other"))
       #(level2-2
         ()
         (#(level3-1
            ()
            (#(level4-1 () ("cat"))
             #(level4-2 () ("bat"))
             #(level4-3 () ("hat"))))
          #(level3-2 () ("bit"))
          #(level3-3 () ("nit"))))
       #(level2-3 () ("brother"))))))

(defun test-data-3 ()
  `(#(key1 val1)
    #(key2 val2)
    #(key3 ,(test-data-2))))

(defun test-data-4 ()
  `#(key1 ,(test-data-2)))

;;; actual tests

(deftest get-data
  (is-equal "some content" (rcrly-xml:get-data (test-data-0))))

(deftest find-content
  (is-equal "Fairville" (rcrly-xml:find-content 'city (test-data-1)))
  (is-equal '("108 Main"
              "Apt #3") (rcrly-xml:find-content 'address (test-data-1))))

(deftest get-content-in-3tuple
  (is-equal "thing"
            (rcrly-xml:get-content-in-3tuple '(level1-1) (test-data-2)))
  (is-equal "brother"
            (rcrly-xml:get-content-in-3tuple '(level1-3 level2-3)
                                             (test-data-2)))
  (is-equal "bit"
            (rcrly-xml:get-content-in-3tuple '(level1-3 level2-2 level3-2)
                                             (test-data-2)))
  (is-equal "hat"
            (rcrly-xml:get-content-in-3tuple
              '(level1-3 level2-2 level3-1 level4-3)
              (test-data-2))))

(deftest get-in
  ;; test just the standard 3-tuple data structure
  (is-equal "thing"
            (rcrly-xml:get-in '(level1-1) (test-data-2)))
  (is-equal "brother"
            (rcrly-xml:get-in '(level1-3 level2-3)
                              (test-data-2)))
  (is-equal "bit"
            (rcrly-xml:get-in '(level1-3 level2-2 level3-2)
                              (test-data-2)))
  (is-equal "hat"
            (rcrly-xml:get-in '(level1-3 level2-2 level3-1 level4-3)
                              (test-data-2)))
  ;; test the 3-tuple data structure nested inside a proplist
  (is-equal "thing"
            (rcrly-xml:get-in '(key3 level1-1) (test-data-3)))
  (is-equal "brother"
            (rcrly-xml:get-in '(key3 level1-3 level2-3)
                              (test-data-3)))
  (is-equal "bit"
            (rcrly-xml:get-in '(key3 level1-3 level2-2 level3-2)
                              (test-data-3)))
  (is-equal "hat"
            (rcrly-xml:get-in '(key3 level1-3 level2-2 level3-1 level4-3)
                              (test-data-3)))
  ;; test a list of 3-tuples in a tuple (common in parsed results)
  (is-equal "thing"
            (rcrly-xml:get-in '(key1 level1-1) (test-data-4)))
  (is-equal "brother"
            (rcrly-xml:get-in '(key1 level1-3 level2-3)
                              (test-data-4)))
  (is-equal "bit"
            (rcrly-xml:get-in '(key1 level1-3 level2-2 level3-2)
                              (test-data-4)))
  (is-equal "hat"
            (rcrly-xml:get-in '(key1 level1-3 level2-2 level3-1 level4-3)
                              (test-data-4))))