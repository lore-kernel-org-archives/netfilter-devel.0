From: Phil Oester <kernel@linuxace.com>
Subject: [RESEND][PATCH] Recent match jiffies wrap mismatches
Date: Mon, 28 Nov 2005 21:08:13 -0800
Message-ID: <20051129050813.GA30630@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

As 2.6.15-rc3 just came out, and the below fixes 3 bugzilla entries (I missed
#370 in the original report), it would be good to get this into 2.6.15 if
possible.

Phil

----- Forwarded message from Phil Oester <kernel@linuxace.com> -----

Date: Wed, 23 Nov 2005 12:03:11 -0800
From: Phil Oester <kernel@linuxace.com>
To: netfilter-devel@lists.netfilter.org
Subject: [PATCH] Recent match jiffies wrap mismatches

Around jiffies wrap time (i.e. within first 5 mins after boot), recent match
rules which contain both --seconds and --hitcount arguments experience
false matches.

This is because the last_pkts array is filled with zeros on creation, and
when comparing 'now' to 0 (+ --seconds argument), time_before_eq thinks it
has found a hit.

Below patch adds a break if the packet value is zero.  This has the unfortunate
side effect of causing mismatches if a packet was received when jiffies really
was equal to zero.  The odds of that happening are slim compared to the
problems caused by not adding the break however.  Plus, the author used
this same method just below, so it is "good enough".

This fixes bugs #383 and #395.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>




diff -ru linux-orig/net/ipv4/netfilter/ipt_recent.c linux-new/net/ipv4/netfilter/ipt_recent.c
--- linux-orig/net/ipv4/netfilter/ipt_recent.c	2005-10-27 20:02:08.000000000 -0400
+++ linux-new/net/ipv4/netfilter/ipt_recent.c	2005-11-23 13:29:29.000000000 -0500
@@ -532,6 +532,7 @@
 			}
 			if(info->seconds && info->hit_count) {
 				for(pkt_count = 0, hits_found = 0; pkt_count < ip_pkt_list_tot; pkt_count++) {
+					if(r_list[location].last_pkts[pkt_count] == 0) break;
 					if(time_before_eq(now,r_list[location].last_pkts[pkt_count]+info->seconds*HZ)) hits_found++;
 				}
 				if(hits_found >= info->hit_count) ans = !info->invert; else ans = info->invert;


----- End forwarded message -----
