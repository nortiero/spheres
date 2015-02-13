(define libraries
  '((spheres/algorithm compare)
    (spheres/algorithm comprehension)
    (spheres/algorithm list-extra)
    (spheres/algorithm list)
    (spheres/algorithm random)
    (spheres/algorithm/random extract)
    (spheres/algorithm/random flip-coin)
    (spheres/algorithm/random pick-unique)
    (spheres/algorithm/random pick)
    (spheres/algorithm/random sample-ordered)
    (spheres/algorithm/random sample-tree)
    (spheres/algorithm/random sample)
    (spheres/algorithm shuffle)
    (spheres/algorithm/shuffle binary)
    (spheres/algorithm/shuffle fisher-yates)
    (spheres/algorithm/shuffle insertion)
    (spheres/algorithm/shuffle merge)
    (spheres/algorithm/shuffle selection)
    (spheres/algorithm sort-merge)
    (spheres/algorithm u8vector)
    (spheres/algorithm vector)
    (spheres/concurrency termite)
    (spheres/core assert)
    (spheres/core base)
    (spheres/core condition)
    (spheres/core functional)
    (spheres/core let-multiple)
    (spheres/core match)
    (spheres/core meta)
    (spheres/core minimal)
    (spheres/core rest-values)
    (spheres/core shift-reset)
    (spheres/crypto aes)
    (spheres/crypto digest)
    (spheres/crypto hmac)
    (spheres/crypto rsa)
    (spheres/dataenc base32)
    (spheres/dataenc base64)
    (spheres/dataenc bignum)
    (spheres/dataenc ieee-754)
    (spheres/dataenc integer)
    (spheres/gambit/ffi array)
    (spheres/gambit/ffi macros)
    (spheres/gambit/ffi memory)
    (spheres/gambit/ffi serialization)
    (spheres/gambit/ffi types)
    (spheres/math arithmetic)
    (spheres/math arithmetic-inexact)
    (spheres/math arithmetic-modular)
    (spheres/math bit-logic)
    (spheres/math combinatorics)
    (spheres/math euclidean)
    (spheres/math factor)
    (spheres/math interval)
    (spheres/math matrix)
    (spheres/math prime)
    (spheres/math vect2)
    (spheres/object prototype)
    (spheres/os arguments)
    (spheres/os date-time)
    (spheres/os functional-arguments)
    (spheres/os ios/ios)
    (spheres/os linux/error-codes)
    (spheres/os localization)
    (spheres/streams derived)
    (spheres/streams primitive)
    (spheres/streams extra)
    (spheres/string char)
    (spheres/string format)
    (spheres/string/format format-srfi-28)
    (spheres/string/format format-srfi-48)
    (spheres/string/format format-srfi-54)
    (spheres/string string)
    (spheres/string u8)
    (spheres/structure hash-table)
    (spheres/structure multi-dimensional-array)
    (spheres/structure/multi-dimensional-array ctor)
    (spheres/structure/multi-dimensional-array mbda)
    (spheres/structure/multi-dimensional-array tter)
    (spheres/util check)
    (spheres/util test)))

(define features
  '(((spheres/core let-multiple) only-macros)
    ((spheres/core match) only-macros)
    ((spheres/core meta) only-macros)
    ((spheres/core shift-reset) only-macros)
    ((spheres/os ios/ios) gambit)
    ((spheres/gambit/ffi array) gambit)
    ((spheres/gambit/ffi macros) gambit only-macros)
    ((spheres/gambit/ffi memory) gambit)
    ((spheres/gambit/ffi serialization) gambit)
    ((spheres/gambit/ffi types) gambit only-macros)))

(define-task (compile library) ()
  (define (compile-library lib)
    (let ((ftrs (or (assoc lib features) '())))
      (if (not (memq 'only-macros ftrs))
          (ssrun#compile-library
           lib
           cond-expand-features: '(debug)
           expander: (if (memq 'gambit ftrs)
                         'gambit
                         'syntax-case)))))
  (if library
      (compile-library library)
      (for-each compile-library libraries)))

(define-task (test file) ()
  (if file
      (ssrun#run-file (string-append "test/" file))
      (ssrun#run-all-files "test/")))

(define-task clean ()
  (ssrun#clean-libraries libraries))
