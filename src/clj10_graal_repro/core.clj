(ns clj10-graal-repro.core
  (:require [clojure.spec.alpha :as s])
  (:gen-class))

(s/def ::foo (s/coll-of string?))

(defn -main
  [& args]
  (println (s/valid? ::foo ["bar"]))
  (println *clojure-version*))
