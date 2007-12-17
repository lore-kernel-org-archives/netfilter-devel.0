From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 34/64]: ctnetlink: add support for NAT sequence adjustments
Date: Tue, 18 Dec 2007 00:46:59 +0100 (MET)
Message-ID: <20071217234659.23601.4340.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38982 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868AbXLQXrB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:01 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ctnetlink: add support for NAT sequence adjustments

The combination of NAT and helpers may produce TCP sequence adjustments.
In failover setups, this information needs to be replicated in order to
achieve a successful recovery of mangled, related connections. This patch is
particularly useful for conntrackd, see:

http://people.netfilter.org/pablo/conntrack-tools/

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f76c1f6a5f4bdbcb8ac6bf4d5e3c0c3df06c935d
tree 91b7c08d1ff208087d9aa9893aaefddde3f019a6
parent 9e9b510cb6ca4fd63e7dea2ded5ff87f84897498
author Pablo Neira Ayuso <pablo@netfilter.org> Mon, 17 Dec 2007 14:58:19 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:56 +0100

 include/linux/netfilter/nf_conntrack_common.h |    4 +
 include/linux/netfilter/nfnetlink_conntrack.h |   10 ++
 net/ipv4/netfilter/nf_nat_helper.c            |    3 +
 net/netfilter/nf_conntrack_netlink.c          |  124 +++++++++++++++++++++++++
 4 files changed, 140 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 9e0dae0..19747e8 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -129,6 +129,10 @@ enum ip_conntrack_events
 	/* Mark is set */
 	IPCT_MARK_BIT = 12,
 	IPCT_MARK = (1 << IPCT_MARK_BIT),
+
+	/* NAT sequence adjustment */
+	IPCT_NATSEQADJ_BIT = 13,
+	IPCT_NATSEQADJ = (1 << IPCT_NATSEQADJ_BIT),
 };
 
 enum ip_conntrack_expect_events {
diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/netfilter/nfnetlink_conntrack.h
index 4affa3f..c19d976 100644
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -37,6 +37,8 @@ enum ctattr_type {
 	CTA_ID,
 	CTA_NAT_DST,
 	CTA_TUPLE_MASTER,
+	CTA_NAT_SEQ_ADJ_ORIG,
+	CTA_NAT_SEQ_ADJ_REPLY,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
@@ -119,6 +121,14 @@ enum ctattr_protonat {
 };
 #define CTA_PROTONAT_MAX (__CTA_PROTONAT_MAX - 1)
 
+enum ctattr_natseq {
+	CTA_NAT_SEQ_CORRECTION_POS,
+	CTA_NAT_SEQ_OFFSET_BEFORE,
+	CTA_NAT_SEQ_OFFSET_AFTER,
+	__CTA_NAT_SEQ_MAX
+};
+#define CTA_NAT_SEQ_MAX (__CTA_NAT_SEQ_MAX - 1)
+
 enum ctattr_expect {
 	CTA_EXPECT_UNSPEC,
 	CTA_EXPECT_MASTER,
diff --git a/net/ipv4/netfilter/nf_nat_helper.c b/net/ipv4/netfilter/nf_nat_helper.c
index 53f79a3..d24f3d9 100644
--- a/net/ipv4/netfilter/nf_nat_helper.c
+++ b/net/ipv4/netfilter/nf_nat_helper.c
@@ -20,6 +20,7 @@
 #include <linux/netfilter_ipv4.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_protocol.h>
@@ -191,6 +192,8 @@ nf_nat_mangle_tcp_packet(struct sk_buff *skb,
 		/* Tell TCP window tracking about seq change */
 		nf_conntrack_tcp_update(skb, ip_hdrlen(skb),
 					ct, CTINFO2DIR(ctinfo));
+
+		nf_conntrack_event_cache(IPCT_NATSEQADJ, skb);
 	}
 	return 1;
 }
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index a15971e..d7da167 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -254,6 +254,55 @@ nla_put_failure:
 #define ctnetlink_dump_mark(a, b) (0)
 #endif
 
+#ifdef CONFIG_NF_NAT_NEEDED
+static inline int
+dump_nat_seq_adj(struct sk_buff *skb, const struct nf_nat_seq *natseq, int type)
+{
+	__be32 tmp;
+	struct nlattr *nest_parms;
+
+	nest_parms = nla_nest_start(skb, type | NLA_F_NESTED);
+	if (!nest_parms)
+		goto nla_put_failure;
+
+	tmp = htonl(natseq->correction_pos);
+	NLA_PUT(skb, CTA_NAT_SEQ_CORRECTION_POS, sizeof(tmp), &tmp);
+	tmp = htonl(natseq->offset_before);
+	NLA_PUT(skb, CTA_NAT_SEQ_OFFSET_BEFORE, sizeof(tmp), &tmp);
+	tmp = htonl(natseq->offset_after);
+	NLA_PUT(skb, CTA_NAT_SEQ_OFFSET_AFTER, sizeof(tmp), &tmp);
+
+	nla_nest_end(skb, nest_parms);
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static inline int
+ctnetlink_dump_nat_seq_adj(struct sk_buff *skb, const struct nf_conn *ct)
+{
+	struct nf_nat_seq *natseq;
+	struct nf_conn_nat *nat = nfct_nat(ct);
+
+	if (!(ct->status & IPS_SEQ_ADJUST) || !nat)
+		return 0;
+
+	natseq = &nat->seq[IP_CT_DIR_ORIGINAL];
+	if (dump_nat_seq_adj(skb, natseq, CTA_NAT_SEQ_ADJ_ORIG) == -1)
+		return -1;
+
+	natseq = &nat->seq[IP_CT_DIR_REPLY];
+	if (dump_nat_seq_adj(skb, natseq, CTA_NAT_SEQ_ADJ_REPLY) == -1)
+		return -1;
+
+	return 0;
+}
+#else
+#define ctnetlink_dump_nat_seq_adj(a, b) (0)
+#endif
+
 static inline int
 ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
 {
@@ -321,7 +370,8 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
 	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_mark(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
-	    ctnetlink_dump_use(skb, ct) < 0)
+	    ctnetlink_dump_use(skb, ct) < 0 ||
+	    ctnetlink_dump_nat_seq_adj(skb, ct) < 0)
 		goto nla_put_failure;
 
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
@@ -424,6 +474,10 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 		    (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
 		     ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0))
 			goto nla_put_failure;
+
+		if (events & IPCT_NATSEQADJ &&
+		    ctnetlink_dump_nat_seq_adj(skb, ct) < 0)
+			goto nla_put_failure;
 	}
 
 	nlh->nlmsg_len = skb->tail - b;
@@ -935,6 +989,66 @@ ctnetlink_change_protoinfo(struct nf_conn *ct, struct nlattr *cda[])
 	return err;
 }
 
+#ifdef CONFIG_NF_NAT_NEEDED
+static inline int
+change_nat_seq_adj(struct nf_nat_seq *natseq, struct nlattr *attr)
+{
+	struct nlattr *cda[CTA_NAT_SEQ_MAX+1];
+
+	nla_parse_nested(cda, CTA_NAT_SEQ_MAX, attr, NULL);
+
+	if (!cda[CTA_NAT_SEQ_CORRECTION_POS])
+		return -EINVAL;
+
+	natseq->correction_pos =
+		ntohl(*(__be32 *)nla_data(cda[CTA_NAT_SEQ_CORRECTION_POS]));
+
+	if (!cda[CTA_NAT_SEQ_OFFSET_BEFORE])
+		return -EINVAL;
+
+	natseq->offset_before =
+		ntohl(*(__be32 *)nla_data(cda[CTA_NAT_SEQ_OFFSET_BEFORE]));
+
+	if (!cda[CTA_NAT_SEQ_OFFSET_AFTER])
+		return -EINVAL;
+
+	natseq->offset_after =
+		ntohl(*(__be32 *)nla_data(cda[CTA_NAT_SEQ_OFFSET_AFTER]));
+
+	return 0;
+}
+
+static int
+ctnetlink_change_nat_seq_adj(struct nf_conn *ct, struct nlattr *cda[])
+{
+	int ret = 0;
+	struct nf_conn_nat *nat = nfct_nat(ct);
+
+	if (!nat)
+		return 0;
+
+	if (cda[CTA_NAT_SEQ_ADJ_ORIG]) {
+		ret = change_nat_seq_adj(&nat->seq[IP_CT_DIR_ORIGINAL],
+					 cda[CTA_NAT_SEQ_ADJ_ORIG]);
+		if (ret < 0)
+			return ret;
+
+		ct->status |= IPS_SEQ_ADJUST;
+	}
+
+	if (cda[CTA_NAT_SEQ_ADJ_REPLY]) {
+		ret = change_nat_seq_adj(&nat->seq[IP_CT_DIR_REPLY],
+					 cda[CTA_NAT_SEQ_ADJ_REPLY]);
+		if (ret < 0)
+			return ret;
+
+		ct->status |= IPS_SEQ_ADJUST;
+	}
+
+	return 0;
+}
+#endif
+
 static int
 ctnetlink_change_conntrack(struct nf_conn *ct, struct nlattr *cda[])
 {
@@ -969,6 +1083,14 @@ ctnetlink_change_conntrack(struct nf_conn *ct, struct nlattr *cda[])
 		ct->mark = ntohl(*(__be32 *)nla_data(cda[CTA_MARK]));
 #endif
 
+#ifdef CONFIG_NF_NAT_NEEDED
+	if (cda[CTA_NAT_SEQ_ADJ_ORIG] || cda[CTA_NAT_SEQ_ADJ_REPLY]) {
+		err = ctnetlink_change_nat_seq_adj(ct, cda);
+		if (err < 0)
+			return err;
+	}
+#endif
+
 	return 0;
 }
 
