From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: conntrack performance/DoS formula
Date: Fri, 28 Jun 2002 14:49:16 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15644.55772.391751.70273@isis.cs3-inc.com>
References: <15643.31140.525551.843205@isis.cs3-inc.com>
	<20020628082339.I2890@oknodo.bof.de>
	<15644.41633.528107.723418@isis.cs3-inc.com>
	<20020628203624.A4136@oknodo.bof.de>
	<15644.45834.373409.220647@isis.cs3-inc.com>
	<20020628213520.C4136@oknodo.bof.de>
	<15644.53466.193145.914415@isis.cs3-inc.com>
	<20020628232819.H4136@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20020628232819.H4136@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Below is some code along with some results after I removed the
duplicates.
You'll see I just simulated tables of different sizes with the first 
N lines of your data, always using buckets with expected occupancy=1.

The buckets are still a little longer than expected.
Perhaps this is related to
  ... 'cat /proc/net/ip_conntrack' being terminally broken.
Or perhaps something else strange in your data.  Or maybe something 
inherent in "real" data that has not yet occurred to me.


================
(in-package :user)

(defun c(n m &aux (ans 1))
  "number of ways of choosing m out of n"
  (loop for i from 1 to m do (setf ans (/ (* ans (- (+ 1 n) i)) i))) ans)

#+clisp
(setf (ext:long-float-digits) 64)

(defun f (n m p)
  "prob. that exactly m out of n entries end up in a bucket which gets
   an entry with prob. p"
  (* (c n m) (expt p m)(expt (- 1l0 p) (- n m))))

(defun parse-data-line (string)
  "input is a line from /proc/net/ip_conntrack,
   output is (proto src dst sport dport)"
  (let (proto src dst sport dport)
    (with-input-from-string (s string)
      (read s) (setf proto (read s)))
    (unless (integerp proto) (error "strange proto?"))
    (setf src (find-ip string "src=")
	  dst (find-ip string "dst=")
	  sport (find-port string "sport=")
	  dport (find-port string "dport="))
    (list proto src dst sport dport)))

(defun find-port (string label)
  (let (pos)
    (unless (setf pos (search label string)) (error "can't find ~A" label))
    (parse-integer string :start (+ pos (length label)) :junk-allowed t)))

(defun find-ip (string label)
  (let (pos int (ans 0))
    (unless (setf pos (search label string)) (error "can't find ~A" label))
    (incf pos (length label))
    (loop for i below 4 do
	  (multiple-value-setq (int pos)
	    (parse-integer string :start pos :junk-allowed t))
	  (setf ans (+ (* ans 256) int) pos (1+ pos)))
    ans))

(defun hash1 (tablesize proto src dst sport dport)
  (mod (+ proto src dst sport dport) tablesize))

(defun hash2 (tablesize proto src dst sport dport)
  (mod (+ proto src dst sport dport sport) tablesize))
;; is this the code now in conntrack?

(defun test-hash (hashfn data tablesize entries)
  (let ((table (make-array tablesize :initial-element 0)) max table2)
    (loop for i below entries as d in data do
	  (incf (aref table (apply hashfn tablesize d))))
    (setf max (loop for i below tablesize maximize (aref table i)))
    (setf table2 (make-array (1+ max) :initial-element 0))
    (loop for i below tablesize do (incf (aref table2 (aref table i))))
    (loop for i from 0 to max collect (list i (aref table2 i)))))

(length (setf data (with-open-file (f "/tmp/ip_conntrack.1")
		     (loop while (setf l (read-line f nil nil))
			 collect (parse-data-line l)))))
;; => 33465
;; now remove the duplicates !!!
(setf ht (make-hash-table :test 'equal))
(loop for d in data do (incf (gethash d ht 0)))
;; (maphash (lambda (x y) (when (> y 1) (print (list x y)))) ht)
;;  ... 620 lines !!!
(setf realdata nil)
(maphash (lambda (x y) (push x) realdata) ht)

#| results
(test-hash 'hash1 realdata 1024 1024)
((0 458) (1 291) (2 150) (3 86) (4 25) (5 10) (6 3) (7 1))
;; meaning 458 buckets with no entries, 291 buckets with 1 entry ...
(f 1023 7 (/ 1l0 1024))
7.154...L-5 - so we should get 7 in a bucket less than once in 10K
meaning this hash is not doing a good job with this data

(test-hash 'hash1 realdata 1023 1023)
((0 372) (1 381) (2 188) (3 64) (4 16) (5 2))
(f 1023 5 (/ 1l0 1023))
0.00304 [ i.e., 3 buckets out of 1000 should have 5 entries
so this is more reasonable ]

(test-hash 'hash1 realdata 16384 16384)
((0 6755) (1 5533) (2 2509) (3 955) (4 354) (5 169) (6 68) (7 34) (8 4) (9 1) (10 2))
10 in a bucket should happen only once in 1E7

(test-hash 'hash1 realdata 16383 16383)
((0 6692) (1 5496) (2 2647) (3 956) (4 367) (5 142) (6 50) (7 22) (8 8) (9 2) (10 0) (11 1))
and 11 only once in 1E8

Now adding sport twice
(test-hash 'hash2 realdata 1024 1024)
((0 391) (1 361) (2 184) (3 63) (4 19) (5 6))
(f 1023 5 (/ 1l0 1024))
0.003 (as above)

(test-hash 'hash2 realdata 1023 1023)
((0 365) (1 392) (2 190) (3 57) (4 17) (5 1) (6 0) (7 1))
above we saw 7E-5

(test-hash 'hash2 realdata 16384 16384)
((0 6518) (1 5667) (2 2678) (3 1005) (4 338) (5 104) (6 52) (7 15) (8 6) (9 1))
(test-hash 'hash2 realdata 16383 16383)
((0 6608) (1 5583) (2 2655) (3 984) (4 347) (5 128) (6 53) (7 11) (8 12) (9 1) (10 1))

|#
