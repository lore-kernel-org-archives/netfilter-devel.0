From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: conntrack performance/DoS formula
Date: Fri, 28 Jun 2002 15:30:42 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15644.58258.483223.56527@isis.cs3-inc.com>
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


  The buckets are still a little longer than expected.
  Perhaps this is related to
    ... 'cat /proc/net/ip_conntrack' being terminally broken.
  Or perhaps something else strange in your data.  Or maybe something 
  inherent in "real" data that has not yet occurred to me.

Here's the most extreme case:
  (test-hash 'hash1 realdata 16383 16383)
  ((0 6692) (1 5496) (2 2647) (3 956) (4 367) (5 142) (6 50) (7 22) (8 8) (9 2) (10 0) (11 1))
  and 11 only once in 1E8

I changed the code to find the data that went into this bucket with
11 connections.  Here it is:
 (loop for x in
 '(
 (6 161731392 2776778790 3228 1045)
 (6 161731392 2776778584 3128 1351)
 (6 161731392 2776778230 3228 1605)
 (6 2776778862 161726449 1064 8080)
 (6 161731392 2776778518 3228 1317)
 (6 161731392 2776778560 3128 1375)
 (6 161731392 2776778406 3228 1429)
 (6 161731392 2776778148 3128 1787)
 (6 161731392 2776779212 3128 33489)
 (6 2776778556 161726449 1370 8080)
 (6 161731392 2776778534 3228 1301)) collect (reduce '+ x))
(2938514461
 2938514461
 2938514461
 2938514461
 2938514461
 2938514461
 2938514461
 2938514461
 2938547227
 2938514461
 2938514461)
And what we see is that the sum of the data (used in hash1) is
almost always the same, so the table size doesn't matter.
Now, let's see how the components of the first differ from those
of the others:
(loop for x in <data above> collect 
 (loop for y in ' (6 161731392 2776778790 3228 1045) as z in x 
 collect (- y z)))
((0 0 0 0 0)
 (0 0 206 100 -306)
 (0 0 560 0 -560)
 (0 -2615047470 2615052341 2164 -7035)
 (0 0 272 0 -272)
 (0 0 230 100 -330)
 (0 0 384 0 -384)
 (0 0 642 100 -742)
 (0 0 -422 100 -32444)
 (0 -2615047164 2615052341 1858 -7035)
 (0 0 256 0 -256))

So there are 4 cases where the source IP and port are the same
and the dest IP and dest port happen to cancel out, and
four more where the source port differs by 100 and the dest
IP and port differ by enough to cancel that 100.
That's 8 out of the 11.

Is this "normal" ?  Do you have some idea about all these
ports 3128 and 3228 ?  
