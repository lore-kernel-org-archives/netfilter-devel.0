From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: conntrack performance/DoS formula
Date: Fri, 28 Jun 2002 14:10:50 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15644.53466.193145.914415@isis.cs3-inc.com>
References: <15643.31140.525551.843205@isis.cs3-inc.com>
	<20020628082339.I2890@oknodo.bof.de>
	<15644.41633.528107.723418@isis.cs3-inc.com>
	<20020628203624.A4136@oknodo.bof.de>
	<15644.45834.373409.220647@isis.cs3-inc.com>
	<20020628213520.C4136@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20020628213520.C4136@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick Schaaf writes:
 > I have put a current sample, with ~33000 entries from one of those
 > proxy boxen, at http://bei.bof.de/ip_conntrack.1.gz

I started to test and found that I got longer buckets than I expected.
The problem seems to be that you have a lot of duplicate entries!
This should not happen in a connection table, right?

(setf ht (make-hash-table :test 'equal))
(loop for d in data do (incf (gethash d ht 0)))
(maphash (lambda (x y) (when (> y 1) (print (list x y)))) ht)
 ... 620 lines !!!
((6 161731392 2776778530 3228 1770) 2) = 9.163.211.64 165.130.71.34
((6 2776779313 974068 1241 80) 2) 
((6 2776779190 2386095140 2596 80) 2)
these are protocol, src/dst ip, src/dst port

I predict that when I remove the duplicates I'll get the expected
distribution.
