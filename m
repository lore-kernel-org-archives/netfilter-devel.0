From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 14/22]: nf_conntrack: fix invalid conntrack statistics
	RCU assumption
Date: Mon, 12 Feb 2007 11:36:41 +0100 (MET)
Message-ID: <20070212103640.661.29714.sendpatchset@localhost.localdomain>
References: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: fix invalid conntrack statistics RCU assumption

NF_CT_STAT_INC assumes rcu_read_lock in nf_hook_slow disables
preemption as well, making it legal to use __get_cpu_var without
disabling preemption manually. The assumption is not correct anymore
with preemptable RCU, additionally we need to protect against softirqs
when not holding nf_conntrack_lock.

Add NF_CT_STAT_INC_ATOMIC macro, which disables local softirqs,
and use where necessary.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit bab7afccc8d458cc09b3a5bb4224358cbd4f188a
tree 537777d83e0b45a4fa17aa148113c9b275823806
parent ff0856c0c2e24e278b0611df2d66f66d5c0d1fd6
author Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 11:04:50 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 11:04:50 +0100

 include/net/netfilter/nf_conntrack.h           |    6 ++++++
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    4 ++--
 net/netfilter/nf_conntrack_core.c              |   14 +++++++-------
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 68ec274..0e690e3 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -257,6 +257,12 @@ extern int nf_conntrack_max;
 
 DECLARE_PER_CPU(struct ip_conntrack_stat, nf_conntrack_stat);
 #define NF_CT_STAT_INC(count) (__get_cpu_var(nf_conntrack_stat).count++)
+#define NF_CT_STAT_INC_ATOMIC(count)			\
+do {							\
+	local_bh_disable();				\
+	__get_cpu_var(nf_conntrack_stat).count++;	\
+	local_bh_enable();				\
+} while (0)
 
 /* no helper, no nat */
 #define	NF_CT_F_BASIC	0
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index a2353ed..4b7be4b 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -154,8 +154,8 @@ ipv6_prepare(struct sk_buff **pskb, unsi
 	 */
 	if ((protoff < 0) || (protoff > (*pskb)->len)) {
 		DEBUGP("ip6_conntrack_core: can't find proto in pkt\n");
-		NF_CT_STAT_INC(error);
-		NF_CT_STAT_INC(invalid);
+		NF_CT_STAT_INC_ATOMIC(error);
+		NF_CT_STAT_INC_ATOMIC(invalid);
 		return -NF_ACCEPT;
 	}
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3deeb90..d59640e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -563,7 +563,7 @@ static int early_drop(struct list_head *
 	if (del_timer(&ct->timeout)) {
 		death_by_timeout((unsigned long)ct);
 		dropped = 1;
-		NF_CT_STAT_INC(early_drop);
+		NF_CT_STAT_INC_ATOMIC(early_drop);
 	}
 	nf_ct_put(ct);
 	return dropped;
@@ -821,7 +821,7 @@ nf_conntrack_in(int pf, unsigned int hoo
 
 	/* Previously seen (loopback or untracked)?  Ignore. */
 	if ((*pskb)->nfct) {
-		NF_CT_STAT_INC(ignore);
+		NF_CT_STAT_INC_ATOMIC(ignore);
 		return NF_ACCEPT;
 	}
 
@@ -840,8 +840,8 @@ nf_conntrack_in(int pf, unsigned int hoo
 	 * core what to do with the packet. */
 	if (l4proto->error != NULL &&
 	    (ret = l4proto->error(*pskb, dataoff, &ctinfo, pf, hooknum)) <= 0) {
-		NF_CT_STAT_INC(error);
-		NF_CT_STAT_INC(invalid);
+		NF_CT_STAT_INC_ATOMIC(error);
+		NF_CT_STAT_INC_ATOMIC(invalid);
 		return -ret;
 	}
 
@@ -849,13 +849,13 @@ nf_conntrack_in(int pf, unsigned int hoo
 			       &set_reply, &ctinfo);
 	if (!ct) {
 		/* Not valid part of a connection */
-		NF_CT_STAT_INC(invalid);
+		NF_CT_STAT_INC_ATOMIC(invalid);
 		return NF_ACCEPT;
 	}
 
 	if (IS_ERR(ct)) {
 		/* Too stressed to deal. */
-		NF_CT_STAT_INC(drop);
+		NF_CT_STAT_INC_ATOMIC(drop);
 		return NF_DROP;
 	}
 
@@ -868,7 +868,7 @@ nf_conntrack_in(int pf, unsigned int hoo
 		DEBUGP("nf_conntrack_in: Can't track with proto module\n");
 		nf_conntrack_put((*pskb)->nfct);
 		(*pskb)->nfct = NULL;
-		NF_CT_STAT_INC(invalid);
+		NF_CT_STAT_INC_ATOMIC(invalid);
 		return -ret;
 	}
 
