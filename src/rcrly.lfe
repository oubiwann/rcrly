(defmodule rcrly
  (export all))

(include-lib "lutil/include/compose.lfe")
(include-lib "rcrly/include/options.lfe")

(defun start ()
  (prog1
    `(#(gproc ,(application:start 'gproc))
      #(econfig ,(application:start 'econfig))
      #(inets ,(inets:start))
      #(ssl ,(ssl:start))
      #(lhttpc ,(lhttpc:start)))
    (rcrly-cfg:open-cfg-file)))

(defun new ()
  (new (get-default-options)))

(defun new (connection-options)
  connection-options)

;;; Convenience client functions

(defun get (endpoint)
  (get endpoint '()))

(defun get (endpoint client-options)
  (rcrly-httpc:request
    endpoint
    "GET"
    ""
    client-options))

(defun post (endpoint data)
  (post endpoint data '()))

(defun post (endpoint data client-options)
  (rcrly-httpc:request
    endpoint
    "POST"
    data
    client-options))

;;; API functions

(defun get-accounts ()
  (get-accounts '()))

(defun get-accounts (client-options)
  (get "/accounts" client-options))

(defun get-account (id)
  (get-account id '()))

(defun get-account (id client-options)
  (get (++ "/accounts/"
           (rcrly-util:arg->str id))
       client-options))

(defun get-adjustments (account-id)
  (get-adjustments account-id '()))

(defun get-adjustments (account-id client-options)
  (get (++ "/accounts/"
           (rcrly-util:arg->str account-id)
           "/adjustments")
       client-options))

(defun get-adjustment (uuid)
  (get-adjustment uuid '()))

(defun get-adjustment (uuid client-options)
  (get (++ "/adjustments/"
           (rcrly-util:arg->str uuid))
       client-options))

(defun get-billing-info (account-id)
  (get-billing-info account-id '()))

(defun get-billing-info (account-id client-options)
  (get (++ "/accounts/"
           (rcrly-util:arg->str account-id)
           "/billing_info")
       client-options))

(defun get-all-invoices ()
  (get-all-invoices '()))

(defun get-all-invoices (client-options)
  (get "/invoices" client-options))

(defun get-invoices (account-id)
  (get-invoices account-id '()))

(defun get-invoices (account-id client-options)
  (get (++ "/accounts/"
           (rcrly-util:arg->str account-id)
           "/invoices")
       client-options))

(defun get-all-transactions ()
  (get-all-transactions '()))

(defun get-all-transactions (client-options)
  (get "/transactions" client-options))

(defun get-transactions (account-id)
  (get-transactions account-id '()))

(defun get-transactions (account-id client-options)
  (get (++ "/accounts/"
           (rcrly-util:arg->str account-id)
           "/transactions")
       client-options))

;;; Utility functions for this module

(defun get-default-options ()
  (make-conn host (rcrly-cfg:get-host)
             key (rcrly-cfg:get-api-key)
             default-currency (rcrly-cfg:get-default-currency)))

(defun get-data (results)
  (->>
    results
    (proplists:get_value 'body)
    (proplists:get_value 'content)))

(defun get-in (keys results)
  (rcrly-xml:get-in keys (get-data results)))