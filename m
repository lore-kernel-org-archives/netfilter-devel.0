From: don-nfil1@isis.cs3-inc.com (Don Cohen)
Subject: script for stopping sshd attacks
Date: Thu, 16 Jun 2005 05:22:06 -0700
Message-ID: <17073.28398.666579.141388@isis.cs3-inc.com>
References: <200506152338.j5FNcHZ04996@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200506152338.j5FNcHZ04996@isis.cs3-inc.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


[I tried to post this to netfilter list but I'm not subscribed there.
 Oh well, at least the devel subscribers might be interested.
 Maybe if one of you think this is worth passing along will repost
 it there?]

I've been pretty happy with the script below and thought I'd share it.
I currently run this from rc.local.

It's written in lisp, which is my scripting language of choice, but
if you want to use some other language I hope it'll be easy enough
to translate.  Clisp should be easy enough to download and install
if you don't already have it.
I suppose something similar could be done for http and perhaps
other services, but I currently use other approaches for those.

I actually run two versions, one for an older machine.  The
differences are that it reads /var/log/messages instead of secure
and that it uses "ipchains -A input -s ~a -j DENY" instead of 
"iptables -A INPUT -s ~a -j MIRROR".

The choice of mirror vs deny/drop is an interesting one.
I think mirror is justified by the fact that the attacking
IP address is evidently not spoofed (it has already managed to
send the right tcp sequence numbers several times).  
I've noticed that the ssh attacks in particular tend to stop 
after about 30 packets if you drop, whereas they sometimes go
on for thousands if you mirror.  While this may be viewed as
bad for the machine running the script (wasting its bandwidth)
I regard it as a public service to waste the time of attackers
who might otherwise be successfully attacking others.
Also, of course, there's some chance that the attacking machine
will break into itself, and might even do some damage, which I
would also view as a public service.

====
#! /usr/local/bin/clisp
;; Stop listening to machines that attack sshd.

(defvar *logfile* "/var/log/secure")
(defvar *last-log-write* 0)
(defvar *last-log-length* 0)
(defvar *tables* nil)
(defvar *ntables* 6)
(defvar *sleep* 10)
(defvar *nfailures* 5)

;; nfailures failures from the same IP address
;; within (ntables x sleep) seconds is considered an attack
;; (actually, it's typically a lot longer, since the log file
;; is not written continually - it's ntables reads of the log
;; file, which happen at least sleep sec. apart.)

;; for some reason running this from rc.local with >> file
;; sends only the dates to that file ...

(defvar *log-out* "/var/log/sshd-attacks")

(defun add-log (format-string &rest args)
  (with-open-file
   (f *log-out* :direction :output :if-exists :append
      :if-does-not-exist :create)
   (format f "~%~a: " (show-ut))
   (apply 'format f format-string args)))

(defun show-ut (&optional (ut (get-universal-time))) 
  (multiple-value-bind 
   (s m h d mo y) (decode-universal-time ut) 
   (format nil "~d/~d/~d ~2,'0d:~2,'0d:~2,'0d" y mo d h m s)))

;; avoid duplicate rules
(defvar *denied* (make-hash-table :test 'equal))

(defun incremental (&optional kill
			      &aux pos line
			      (ip-count (make-hash-table :test 'equal)))
  (when (> (file-write-date *logfile*) *last-log-write*)
    (setf *last-log-write* (file-write-date *logfile*))
    (with-open-file
     (f *logfile*)
     (when (< (file-length f) *last-log-length*)
       ;; assume we've started a new version of the log file
       (setf *last-log-length* 0))
     (file-position f *last-log-length*)
     (loop while (setf line (read-line f nil)) do
       ;; Here's a sample of what I'm looking for in the log
       ;; May 13 22:38:08 isis sshd[27594]: Failed password for root from 81.180.201.38 port 43642 ssh2
       (when (and (setf pos (search "sshd" line))
		  (setf pos (search ": Failed password for " line :start2 pos))
		  (setf pos (search "from " line :start2 pos)))
	 (incf pos #.(length "from "))
	 (incf (gethash (subseq line pos (search " " line :start2 pos))
			ip-count 0))))
     (setf *last-log-length* (file-position f))
     (push ip-count *tables*)
     (when (nthcdr *ntables* *tables*)
       (setf (cdr (nthcdr *ntables* *tables*)) nil))
     (loop for ip being the hash-keys of (car *tables*)
       as total = (loop for tab in *tables* sum (gethash ip tab 0))
       unless (gethash ip *denied*)
       when (>= total *nfailures*)
       do
       (when kill
	 (setf (gethash ip *denied*) t)
	 (add-log " ~a failures: ~a~%" total ip)
	 (run-shell-command
	  (format nil "iptables -A INPUT -s ~a -j MIRROR" ip))))
     (unless kill (pop *tables*)))))

(add-log "start")
(incremental) ;; first time we just list previous attacks
(loop while t do
  (incremental t) 
  (sleep *sleep*))
