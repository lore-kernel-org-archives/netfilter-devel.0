From: Mateusz Golicz <mtg@elsat.net.pl>
Subject: [BUG] nth match: using more than 1 counter
Date: Sat, 7 Dec 2002 04:58:17 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021207035817.GA15544@fouk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello,

  The userspace part of the nth match (BTW, quite an useful one)
seems to be a bit broken. (at least in the CVS version from the
WWW frontend (don't know if there are any other ones ;), i'm
new to netfilter developement): http://cvs.netfilter.org/cgi-bin/cvsweb/~checkout~/netfilter/userspace/extensions/libipt_nth.c)

around line 102, in parse(), there is a fragment doing some
checks concerning the --every option:

--- CUT ---
                nthinfo->packet = 0xFF;
                if(!(*flags & IPT_NTH_OPT_EVERY))
                {
                        nthinfo->counter = 0;
                }
--- CUT ---

... but actually, the IPT_NTH_OPT_EVERY flag is
set only in this function, but after this part. So, if
you specify --every after --counter, the previous nthinfo->counter
will be always lost, which will make the match behave quite improperly in
case you use more than a one counter... i guess this check should be
something like:

--- CUT ---
--- extensions/libipt_nth.c.old Sat Dec  7 05:47:47 2002
+++ extensions/libipt_nth.c     Sat Dec  7 05:29:28 2002
@@ -100,7 +101,7 @@
                nthinfo->every = num-1;
                nthinfo->startat = 0;
                 nthinfo->packet = 0xFF;
-                if(!(*flags & IPT_NTH_OPT_EVERY))
+                if(!(*flags & IPT_NTH_OPT_COUNTER))
                 {
                         nthinfo->counter = 0;
                 }
--- CUT ---

Matthew Golicz, IP Network Dept., Cable Television "Elsat" Ltd.
-- 
______________________________________________________________________
mteg <mtg@elsat.net.pl>       * MG452-RIPE *            Mateusz Golicz
* ,,I just had a thought I have seen everything in this lifetime, but*
* now I sit here and watch a cyborg diving ... in her spare time!''  *
