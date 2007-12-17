From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 36/64]: ctnetlink: add support for secmark
Date: Tue, 18 Dec 2007 00:47:02 +0100 (MET)
Message-ID: <20071217234701.23601.93215.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38982 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759855AbXLQXrD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:03 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ctnetlink: add support for secmark

This patch adds support for James Morris' connsecmark.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 458ec48bd83fa935e90880fe2e45b190c9e3d075
tree d5afc919de8252d88f38cfe3cdceb43966f6c035
parent 511b7ee38fc06fe1a18ae3f4872f318ecb9301c6
author Pablo Neira Ayuso <pablo@netfilter.org> Mon, 17 Dec 2007 14:58:22 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:56 +0100

 include/linux/netfilter/nf_conntrack_common.h |    4 ++++
 include/linux/netfilter/nfnetlink_conntrack.h |    1 +
 net/netfilter/nf_conntrack_netlink.c          |   22 ++++++++++++++++++++++
 net/netfilter/xt_CONNSECMARK.c                |    5 ++++-
 4 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 19747e8..bad1eb7 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -133,6 +133,10 @@ enum ip_conntrack_events
 	/* NAT sequence adjustment */
 	IPCT_NATSEQADJ_BIT = 13,
 	IPCT_NATSEQADJ = (1 << IPCT_NATSEQADJ_BIT),
+
+	/* Secmark is set */
+	IPCT_SECMARK_BIT = 14,
+	IPCT_SECMARK = (1 << IPCT_SECMARK_BIT),
 };
 
 enum ip_conntrack_expect_events {
diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index c19d976..e3e1533 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -39,6 +39,7 @@ enum ctattr_type {
 	CTA_TUPLE_MASTER,
 	CTA_NAT_SEQ_ADJ_ORIG,
 	CTA_NAT_SEQ_ADJ_REPLY,
+	CTA_SECMARK,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 94027c8..d4eedc6 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -254,6 +254,22 @@ nla_put_failure:
 #define ctnetlink_dump_mark(a, b) (0)
 #endif
 
+#ifdef CONFIG_NF_CONNTRACK_SECMARK
+static inline int
+ctnetlink_dump_secmark(struct sk_buff *skb, const struct nf_conn *ct)
+{
+	__be32 mark = htonl(ct->secmark);
+
+	NLA_PUT(skb, CTA_SECMARK, sizeof(u_int32_t), &mark);
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+#else
+#define ctnetlink_dump_secmark(a, b) (0)
+#endif
+
 #define master_tuple(ct) &(ct->master->tuplehash[IP_CT_DIR_ORIGINAL].tuple)
 
 static inline int
@@ -392,6 +408,7 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 	    ctnetlink_dump_protoinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_mark(skb, ct) < 0 ||
+	    ctnetlink_dump_secmark(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
 	    ctnetlink_dump_master(skb, ct) < 0 ||
@@ -493,6 +510,11 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 		    && ctnetlink_dump_mark(skb, ct) < 0)
 			goto nla_put_failure;
 #endif
+#ifdef CONFIG_NF_CONNTRACK_SECMARK
+		if ((events & IPCT_SECMARK || ct->secmark)
+		    && ctnetlink_dump_secmark(skb, ct) < 0)
+			goto nla_put_failure;
+#endif
 
 		if (events & IPCT_COUNTER_FILLING &&
 		    (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 2c265e8..2333f7e 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -20,6 +20,7 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_CONNSECMARK.h>
 #include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 
 #define PFX "CONNSECMARK: "
 
@@ -40,8 +41,10 @@ static void secmark_save(const struct sk_buff *skb)
 		enum ip_conntrack_info ctinfo;
 
 		ct = nf_ct_get(skb, &ctinfo);
-		if (ct && !ct->secmark)
+		if (ct && !ct->secmark) {
 			ct->secmark = skb->secmark;
+			nf_conntrack_event_cache(IPCT_SECMARK, skb);
+		}
 	}
 }
 
