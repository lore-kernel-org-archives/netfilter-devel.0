From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: conntrack performance/DoS formula
Date: Sat, 29 Jun 2002 09:48:23 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15645.58583.30187.70748@isis.cs3-inc.com>
References: <15643.31140.525551.843205@isis.cs3-inc.com>
	<20020628082339.I2890@oknodo.bof.de>
	<15644.41633.528107.723418@isis.cs3-inc.com>
	<20020628203624.A4136@oknodo.bof.de>
	<15644.45834.373409.220647@isis.cs3-inc.com>
	<20020628213520.C4136@oknodo.bof.de>
	<15644.53466.193145.914415@isis.cs3-inc.com>
	<20020628232819.H4136@oknodo.bof.de>
	<15644.58258.483223.56527@isis.cs3-inc.com>
	<20020629110332.I4136@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20020629110332.I4136@oknodo.bof.de>
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
 > > Is this "normal" ?  Do you have some idea about all these
 > > ports 3128 and 3228 ?  
 > 
 > The machine where that ip_conntrack came from, is running two squid
 > processes, one on each processor, and clients are distributed evenly
 > over the two processes. 3128 and 3228 are the two listening ports
 > of those squid processes.
 > 
 > Such a conntrack shape will be the normal case for iptables running
 > on a server, more extreme than when it's running on a routing firewall.

The fact that many connections have the same source IP and two common 
source ports does not seem at all abnormal.  The interesting correlation
in this case is that the client with IP address differing by n is
using a port that differs by -n.  This is just the sort of correlation
that would be bad for this hash function, and the sort that I would
not expect.

 (6 161731392 2776778790 3228 1045)
 (6 161731392 2776778584 3128 1351) ;;  (0 0 206 100 -306)
 (6 161731392 2776778230 3228 1605) ;;  (0 0 560 0 -560)
 (6 2776778862 161726449 1064 8080) ;; different machines
 (6 161731392 2776778518 3228 1317) ;;  (0 0 272 0 -272)
 (6 161731392 2776778560 3128 1375) ;;  (0 0 230 100 -330)
 (6 161731392 2776778406 3228 1429) ;;  (0 0 384 0 -384)
 (6 161731392 2776778148 3128 1787) ;;  (0 0 642 100 -742)
 (6 161731392 2776779212 3128 33489) ;; different sum
 (6 2776778556 161726449 1370 8080) ;; different machines
 (6 161731392 2776778534 3228 1301) ;;  (0 0 256 0 -256)

 > As you asked for ideas about "better" hashes, could you possibly try
 > using CRC32 over the concatenation of the key values?

Looks like you may have done this already, but if not then perhaps
you could supply the code or tell me how to compute it.  Instead,
I just look at your words above "concatenation of the key values".
Here's my first order approximation:
Instead of adding IPs to ports I concatenate IP and port into one
48 bit number.  Then add the two 48 bit numbers (and the protocol)
and take the result mod table size.
(defun hash3 (tablesize proto src dst sport dport)
  (mod (+ proto (ash (+ src dst) 16) sport dport) tablesize))

The result:
 (test-hash 'hash3 realdata 16383 16383)
 ((0 6284) (1 5796) (2 2867) (3 1015) (4 319) (5 84) (6 14) (7 4))
Much closer to theory

BTW it turns out this leads to a good demonstration of my point about
making the modulus relatively prime to the size of the data.
If I change 16383 to 16384 (a power of 2) then almost all of the IP
address data above is ignored and we get this monster:

 (test-hash 'hash3 realdata 16384 16384)
 ((0 8757) (1 4875) (2 1192) (3 490) (4 293) (5 179) (6 131) (7 95) (8
 92) (9 60) (10 49) (11 42) (12 37) (13 28) (14 20) (15 13) (16 11) (17
 6) (18 6) (19 2) (20 1) (21 1) (22 0) (23 1) (24 1) (25 0) (26 0) (27
 0) (28 1) (29 0) (30 0) (31 0) (32 0) (33 0) (34 0) (35 0) (36 0) (37
 0) (38 0) (39 0) (40 0) (41 0) (42 0) (43 0) (44 0) (45 0) (46 0) (47
 0) (48 0) (49 0) (50 0) (51 0) (52 0) (53 0) (54 0) (55 0) (56 0) (57
 0) (58 0) (59 0) (60 0) (61 0) (62 0) (63 0) (64 0) (65 0) (66 0) (67
 0) (68 0) (69 0) (70 0) (71 0) (72 0) (73 0) (74 0) (75 0) (76 0) (77
 0) (78 0) (79 0) (80 0) (81 0) (82 0) (83 0) (84 0) (85 0) (86 1))

[reactions to later messages]

  one more thing to observe for your tests: each line from ip_conntrack
  is hashed twice, with mirrored source / destination addresses. 
I was only reading the first src/dst/sport/dport from each line.
I didn't check for such mirrors in general, but they don't appear
in the sample bucket above containing 11 entries. 

  This version adds a '-b X' option. If you specify that, all TCP conntracks
  with timeouts less than X get ignored. For example, use "-b 431940" to only
  count the conntracks active within the last 60 seconds.

I guess I just don't understand conntrack well enough.
How does -b 431940 map to active in the last 60 sec?
Also, why does this matter?  If you use my suggestion to treat a "full
bucket" like a full table then the issue is whether buckets are full,
and I don't see how that's affected by how recently used the entries
are. 

  Incidentally, this makes the current ip_conntrack hash function look a lot
  less bad than before. I appears that the "long bucket" packets mostly belong
  to some kind of port scan. They will time out eventually, and they will NOT
  contribute significantly to CPU usage, because they will be rarely hit.

They do contribute to cpu cost because they lengthen the search for
other connections.

  Everybody should see the results for their own system. Really. I mean it.

My feeling is that we should be able to find a hash function that is
"good enough" in almost all cases, meaning something like this:
if we want probability of full bucket < 1E-10 and the formula tells
us that this indicates we need to make max bucket length >= 12 then
to be on the safe side we increase it, say 50% to 18, and then we
log full buckets.  When these appear in the log then there are two
possible explanations.  One is that we're under attack from someone
purposely trying to fill buckets.  The other is that our hash function
is bad for the real data.  In either case we should use your program
to look at the connections in the overflowing buckets, and this will
tell us what's going on (and how to fix it if it can be fixed).
