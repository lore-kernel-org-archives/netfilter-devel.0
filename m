From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 4/4] fixes conntrack event cache deadlock/oops
Date: Sat, 24 Sep 2005 19:03:21 +0900 (JST)
Message-ID: <200509241003.j8OA3MnR003356@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sat_Sep_24_19_03_21_2005_640)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
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

----Next_Part(Sat_Sep_24_19_03_21_2005_640)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This follows ip_conntrack fixes for following bugs
	- call nf_conntrack_event_cache() while holding lock, which causes
	  to deadlock.
	- update counters for unconfirmed connections without lock, which
	  causes to race.
	- call nf_conntrack_event_cache() with NULL pointer as skb, which
	  causes to NULL pointer access.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Sat_Sep_24_19_03_21_2005_640)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="04-event-cache.patch"

[NETFILTER] fixes conntrack event cache deadlock/oops in nf_conntrack

This follows ip_conntrack fixes for following bugs
	- call nf_conntrack_event_cache() while holding lock, which causes
	  to deadlock.
	- update counters for unconfirmed connections without lock, which
	  causes to race.
	- call nf_conntrack_event_cache() with NULL pointer as skb, which
	  causes to NULL pointer access.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 286d48b5fe11375b44d201a44c5e829eaef21de8
tree 7f60ef515b38d9fe964bf32eb50f6c03dba1f1c0
parent 471edbcb122763a16759403331bd1a01372d52c7
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 23 Sep 2005 22:24:59 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 23 Sep 2005 22:24:59 +0900

 include/linux/netfilter/nf_conntrack.h  |   25 +++++++++++++--
 net/netfilter/nf_conntrack_core.c       |   51 ++++++++++++++++---------------
 net/netfilter/nf_conntrack_standalone.c |    2 +
 3 files changed, 49 insertions(+), 29 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack.h b/include/linux/netfilter/nf_conntrack.h
--- a/include/linux/netfilter/nf_conntrack.h
+++ b/include/linux/netfilter/nf_conntrack.h
@@ -191,11 +191,28 @@ extern void need_nf_conntrack(void);
 extern int nf_ct_invert_tuplepr(struct nf_conntrack_tuple *inverse,
 				const struct nf_conntrack_tuple *orig);
 
+extern void __nf_ct_refresh_acct(struct nf_conn *ct,
+				 enum ip_conntrack_info ctinfo,
+				 const struct sk_buff *skb,
+				 unsigned long extra_jiffies,
+				 int do_acct);
+
+/* Refresh conntrack for this many jiffies and do accounting */
+static inline void nf_ct_refresh_acct(struct nf_conn *ct,
+				      enum ip_conntrack_info ctinfo,
+				      const struct sk_buff *skb,
+				      unsigned long extra_jiffies)
+{
+	__nf_ct_refresh_acct(ct, ctinfo, skb, extra_jiffies, 1);
+}
+
 /* Refresh conntrack for this many jiffies */
-extern void nf_ct_refresh_acct(struct nf_conn *ct,
-			       enum ip_conntrack_info ctinfo,
-			       const struct sk_buff *skb,
-			       unsigned long extra_jiffies);
+extern inline void nf_ct_refresh(struct nf_conn *ct,
+				 const struct sk_buff *skb,
+				 unsigned long extra_jiffies)
+{
+	__nf_ct_refresh_acct(ct, 0, skb, extra_jiffies, 0);
+}
 
 /* These are for NAT.  Icky. */
 /* Update TCP window tracking data when NAT mangles the packet */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1240,44 +1240,47 @@ void nf_conntrack_helper_unregister(stru
 	synchronize_net();
 }
 
-static inline void ct_add_counters(struct nf_conn *ct,
-				   enum ip_conntrack_info ctinfo,
-				   const struct sk_buff *skb)
+/* Refresh conntrack for this many jiffies and do accounting if do_acct is 1 */
+void __nf_ct_refresh_acct(struct nf_conn *ct,
+			  enum ip_conntrack_info ctinfo,
+			  const struct sk_buff *skb,
+			  unsigned long extra_jiffies,
+			  int do_acct)
 {
-#ifdef CONFIG_NF_CT_ACCT
-	if (skb) {
-		ct->counters[CTINFO2DIR(ctinfo)].packets++;
-		/* XXX totlen should be used ? - YK */
-		ct->counters[CTINFO2DIR(ctinfo)].bytes +=
-			ntohs(skb->len - (unsigned int)(skb->nh.raw
-							- skb->data));
-	}
-#endif
-}
+	int do_event = 0;
 
-/* Refresh conntrack for this many jiffies and do accounting (if skb != NULL) */
-void nf_ct_refresh_acct(struct nf_conn *ct,
-			enum ip_conntrack_info ctinfo,
-			const struct sk_buff *skb,
-			unsigned long extra_jiffies)
-{
 	NF_CT_ASSERT(ct->timeout.data == (unsigned long)ct);
+	NF_CT_ASSERT(skb);
+
+	write_lock_bh(&nf_conntrack_lock);
 
 	/* If not in hash table, timer will not be active yet */
 	if (!nf_ct_is_confirmed(ct)) {
 		ct->timeout.expires = extra_jiffies;
-		ct_add_counters(ct, ctinfo, skb);
+		do_event = 1;
 	} else {
-		write_lock_bh(&nf_conntrack_lock);
 		/* Need del_timer for race avoidance (may already be dying). */
 		if (del_timer(&ct->timeout)) {
 			ct->timeout.expires = jiffies + extra_jiffies;
 			add_timer(&ct->timeout);
-			nf_conntrack_event_cache(IPCT_REFRESH, skb);
+			do_event = 1;
 		}
-		ct_add_counters(ct, ctinfo, skb);
-		write_unlock_bh(&nf_conntrack_lock);
 	}
+
+#ifdef CONFIG_NF_CT_ACCT
+	if (do_acct) {
+		ct->counters[CTINFO2DIR(ctinfo)].packets++;
+		ct->counters[CTINFO2DIR(ctinfo)].bytes +=
+				ntohs(skb->len - (unsigned int)(skb->nh.raw
+								- skb->data));
+	}
+#endif
+
+	write_unlock_bh(&nf_conntrack_lock);
+
+	/* must be unlocked when calling event cache */
+	if (do_event)
+		nf_conntrack_event_cache(IPCT_REFRESH, skb);
 }
 
 /* Used by ipt_REJECT and ip6t_REJECT. */
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -845,7 +845,7 @@ EXPORT_SYMBOL(need_nf_conntrack);
 EXPORT_SYMBOL(nf_conntrack_helper_register);
 EXPORT_SYMBOL(nf_conntrack_helper_unregister);
 EXPORT_SYMBOL(nf_ct_iterate_cleanup);
-EXPORT_SYMBOL(nf_ct_refresh_acct);
+EXPORT_SYMBOL(__nf_ct_refresh_acct);
 EXPORT_SYMBOL(nf_ct_protos);
 EXPORT_SYMBOL(nf_ct_find_proto);
 EXPORT_SYMBOL(nf_ct_l3protos);

----Next_Part(Sat_Sep_24_19_03_21_2005_640)----
