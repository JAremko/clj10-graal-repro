(ns clj10-graal-repro.core
  (:require [clojure.spec.alpha :as s]
            [clojure.spec.gen.alpha :as gen])
  (:gen-class))


(s/def ::foo (s/with-gen (s/coll-of string?)
               #(gen/vector (s/gen string?) 1 3)))


(defn -main
  [& args]
  (println (s/valid? ::foo ["bar"]))
  (println *clojure-version*))
