From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/32]: nf_conntrack: fix NF_CT_TUPLE_DUMP for IPv4
Date: Thu, 28 Feb 2008 12:59:59 +0100 (MET)
Message-ID: <20080228115951.29267.9784.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49967 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153AbYB1MAA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:00:00 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: fix NF_CT_TUPLE_DUMP for IPv4

NF_CT_TUPLE_DUMP prints IPv4 addresses as IPv6, fix this and use printk
(guarded by #ifdef DEBUG) directly instead of pr_debug since the tuple
is usually printed at the end of line and we don't want to include a
log-level.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1fd566261c97eda01f8106bcf10e09f1ecaf2d62
tree 046a6153da1deacbcdd5dd90a51b3a0bee4899fc
parent 64c4eb535c3d06edb1ceb47edc5bfce36348a7c4
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:05 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:05 +0100

 include/net/netfilter/nf_conntrack_tuple.h |   38 ++++++++++++++++++++++++----
 1 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index e69ab2e..d9b53dd 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -113,11 +113,39 @@ struct nf_conntrack_tuple_mask
 
 #ifdef __KERNEL__
 
-#define NF_CT_DUMP_TUPLE(tp)						     \
-pr_debug("tuple %p: %u %u " NIP6_FMT " %hu -> " NIP6_FMT " %hu\n",	     \
-	 (tp), (tp)->src.l3num, (tp)->dst.protonum,			     \
-	 NIP6(*(struct in6_addr *)(tp)->src.u3.all), ntohs((tp)->src.u.all), \
-	 NIP6(*(struct in6_addr *)(tp)->dst.u3.all), ntohs((tp)->dst.u.all))
+static inline void nf_ct_dump_tuple_ip(const struct nf_conntrack_tuple *t)
+{
+#ifdef DEBUG
+	printk("tuple %p: %u " NIPQUAD_FMT ":%hu -> " NIPQUAD_FMT ":%hu\n",
+	       t, t->dst.protonum,
+	       NIPQUAD(t->src.u3.ip), ntohs(t->src.u.all),
+	       NIPQUAD(t->dst.u3.ip), ntohs(t->dst.u.all));
+#endif
+}
+
+static inline void nf_ct_dump_tuple_ipv6(const struct nf_conntrack_tuple *t)
+{
+#ifdef DEBUG
+	printk("tuple %p: %u " NIP6_FMT " %hu -> " NIP6_FMT " %hu\n",
+	       t, t->dst.protonum,
+	       NIP6(*(struct in6_addr *)t->src.u3.all), ntohs(t->src.u.all),
+	       NIP6(*(struct in6_addr *)t->dst.u3.all), ntohs(t->dst.u.all));
+#endif
+}
+
+static inline void nf_ct_dump_tuple(const struct nf_conntrack_tuple *t)
+{
+	switch (t->src.l3num) {
+	case AF_INET:
+		nf_ct_dump_tuple_ip(t);
+		break;
+	case AF_INET6:
+		nf_ct_dump_tuple_ipv6(t);
+		break;
+	}
+}
+
+#define NF_CT_DUMP_TUPLE(tp)	nf_ct_dump_tuple(tp)
 
 /* If we're the first tuple, it's the original dir. */
 #define NF_CT_DIRECTION(h)						\
