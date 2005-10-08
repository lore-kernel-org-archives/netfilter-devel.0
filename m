From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 3/4] notify the indication of counter overflow
Date: Sat, 08 Oct 2005 20:14:03 +0900 (JST)
Message-ID: <200510081114.j98BE4xd016370@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sat_Oct__8_20_14_03_2005_793)--"
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

----Next_Part(Sat_Oct__8_20_14_03_2005_793)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This synchronizes nf_conntrack with ip_conntrack and notify that
conntrack-based counters are overflow soon.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

Regards,
-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Sat_Oct__8_20_14_03_2005_793)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="03-counter.patch"

[NETFILTER] notify the indication of conntrack-based counters overflow

This synchronizes nf_conntrack with ip_conntrack and notify that
conntrack-based counters are overflow soon.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit a2e91360ab67898da19d503a21ce2b425951bc7a
tree 20eb882d3aecbffe321c042602cf770247d81c76
parent eb6b86e4268d54fc5a5ef430e5391f1413b84784
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 08 Oct 2005 19:29:06 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 08 Oct 2005 19:29:06 +0900

 net/netfilter/nf_conntrack_core.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1252,7 +1252,7 @@ void __nf_ct_refresh_acct(struct nf_conn
 			  unsigned long extra_jiffies,
 			  int do_acct)
 {
-	int do_event = 0;
+	int event = 0;
 
 	NF_CT_ASSERT(ct->timeout.data == (unsigned long)ct);
 	NF_CT_ASSERT(skb);
@@ -1262,13 +1262,13 @@ void __nf_ct_refresh_acct(struct nf_conn
 	/* If not in hash table, timer will not be active yet */
 	if (!nf_ct_is_confirmed(ct)) {
 		ct->timeout.expires = extra_jiffies;
-		do_event = 1;
+		event = IPCT_REFRESH;
 	} else {
 		/* Need del_timer for race avoidance (may already be dying). */
 		if (del_timer(&ct->timeout)) {
 			ct->timeout.expires = jiffies + extra_jiffies;
 			add_timer(&ct->timeout);
-			do_event = 1;
+			event = IPCT_REFRESH;
 		}
 	}
 
@@ -1278,14 +1278,17 @@ void __nf_ct_refresh_acct(struct nf_conn
 		ct->counters[CTINFO2DIR(ctinfo)].bytes +=
 				ntohs(skb->len - (unsigned int)(skb->nh.raw
 								- skb->data));
+	if ((ct->counters[CTINFO2DIR(ctinfo)].packets & 0x80000000)
+	    || (ct->counters[CTINFO2DIR(ctinfo)].bytes & 0x80000000))
+		event |= IPCT_COUNTER_FILLING;
 	}
 #endif
 
 	write_unlock_bh(&nf_conntrack_lock);
 
 	/* must be unlocked when calling event cache */
-	if (do_event)
-		nf_conntrack_event_cache(IPCT_REFRESH, skb);
+	if (event)
+		nf_conntrack_event_cache(event, skb);
 }
 
 /* Used by ipt_REJECT and ip6t_REJECT. */

----Next_Part(Sat_Oct__8_20_14_03_2005_793)----
