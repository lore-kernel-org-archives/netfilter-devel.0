From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 13/22]: ip_conntrack: fix invalid conntrack statistics
	RCU assumption
Date: Mon, 12 Feb 2007 11:36:39 +0100 (MET)
Message-ID: <20070212103639.661.21437.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ip_conntrack: fix invalid conntrack statistics RCU assumption

CONNTRACK_STAT_INC assumes rcu_read_lock in nf_hook_slow disables
preemption as well, making it legal to use __get_cpu_var without
disabling preemption manually. The assumption is not correct anymore
with preemptable RCU, additionally we need to protect against softirqs
when not holding ip_conntrack_lock.

Add CONNTRACK_STAT_INC_ATOMIC macro, which disables local softirqs,
and use where necessary.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ff0856c0c2e24e278b0611df2d66f66d5c0d1fd6
tree d5899481f22f436368fa121ac617a08fc53941f4
parent 2f34e7966f36432f6915ab7eee85116439a3944e
author Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 11:03:24 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 11:03:24 +0100

 include/linux/netfilter_ipv4/ip_conntrack.h |    6 ++++++
 net/ipv4/netfilter/ip_conntrack_core.c      |   14 +++++++-------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
index 33581c1..da9274e 100644
--- a/include/linux/netfilter_ipv4/ip_conntrack.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h
@@ -301,6 +301,12 @@ extern unsigned int ip_conntrack_htable_
 extern int ip_conntrack_checksum;
  
 #define CONNTRACK_STAT_INC(count) (__get_cpu_var(ip_conntrack_stat).count++)
+#define CONNTRACK_STAT_INC_ATOMIC(count)		\
+do {							\
+	local_bh_disable();				\
+	__get_cpu_var(ip_conntrack_stat).count++;	\
+	local_bh_enable();				\
+} while (0)
 
 #ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
 #include <linux/notifier.h>
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index ed87812..d1368db 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -538,7 +538,7 @@ static int early_drop(struct list_head *
 	if (del_timer(&ct->timeout)) {
 		death_by_timeout((unsigned long)ct);
 		dropped = 1;
-		CONNTRACK_STAT_INC(early_drop);
+		CONNTRACK_STAT_INC_ATOMIC(early_drop);
 	}
 	ip_conntrack_put(ct);
 	return dropped;
@@ -805,7 +805,7 @@ unsigned int ip_conntrack_in(unsigned in
 
 	/* Previously seen (loopback or untracked)?  Ignore. */
 	if ((*pskb)->nfct) {
-		CONNTRACK_STAT_INC(ignore);
+		CONNTRACK_STAT_INC_ATOMIC(ignore);
 		return NF_ACCEPT;
 	}
 
@@ -841,20 +841,20 @@ #endif
 	 * core what to do with the packet. */
 	if (proto->error != NULL
 	    && (ret = proto->error(*pskb, &ctinfo, hooknum)) <= 0) {
-		CONNTRACK_STAT_INC(error);
-		CONNTRACK_STAT_INC(invalid);
+		CONNTRACK_STAT_INC_ATOMIC(error);
+		CONNTRACK_STAT_INC_ATOMIC(invalid);
 		return -ret;
 	}
 
 	if (!(ct = resolve_normal_ct(*pskb, proto,&set_reply,hooknum,&ctinfo))) {
 		/* Not valid part of a connection */
-		CONNTRACK_STAT_INC(invalid);
+		CONNTRACK_STAT_INC_ATOMIC(invalid);
 		return NF_ACCEPT;
 	}
 
 	if (IS_ERR(ct)) {
 		/* Too stressed to deal. */
-		CONNTRACK_STAT_INC(drop);
+		CONNTRACK_STAT_INC_ATOMIC(drop);
 		return NF_DROP;
 	}
 
@@ -866,7 +866,7 @@ #endif
 		 * the netfilter core what to do*/
 		nf_conntrack_put((*pskb)->nfct);
 		(*pskb)->nfct = NULL;
-		CONNTRACK_STAT_INC(invalid);
+		CONNTRACK_STAT_INC_ATOMIC(invalid);
 		return -ret;
 	}
 
