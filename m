From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/5] Add support for NAT sequence adjustments
Date: Sun, 09 Dec 2007 19:13:00 +0100
Message-ID: <475C302C.1070402@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090004070801060200020501"
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52511 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750905AbXLISNv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Dec 2007 13:13:51 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090004070801060200020501
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The combination of NAT and helpers may produce TCP sequence adjustments.
In failover setups, this information needs to be replicated in order to
achieve a successful recovery of mangled, related connections. This
patch is particularly useful for conntrackd, see:

http://people.netfilter.org/pablo/conntrack-tools/

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------090004070801060200020501
Content-Type: text/x-patch;
 name="01.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.patch"

[PATCH][CTNETLINK] Add support for NAT sequence adjustments

The combination of NAT and helpers may produce TCP sequence adjustments.
In failover setups, this information needs to be replicated in order to
achieve a successful recovery of mangled, related connections. This patch is
particularly useful for conntrackd, see: 

http://people.netfilter.org/pablo/conntrack-tools/

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/include/linux/netfilter/nf_conntrack_common.h
===================================================================
--- net-2.6.git.orig/include/linux/netfilter/nf_conntrack_common.h	2007-11-25 19:08:13.000000000 +0100
+++ net-2.6.git/include/linux/netfilter/nf_conntrack_common.h	2007-12-08 21:38:18.000000000 +0100
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
Index: net-2.6.git/include/linux/netfilter/nfnetlink_conntrack.h
===================================================================
--- net-2.6.git.orig/include/linux/netfilter/nfnetlink_conntrack.h	2007-11-25 19:08:13.000000000 +0100
+++ net-2.6.git/include/linux/netfilter/nfnetlink_conntrack.h	2007-12-08 21:38:18.000000000 +0100
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
 
+enum ctattr_natseqadj {
+	CTA_NAT_SEQ_CUR,
+	CTA_NAT_OFFSET_BEFORE,
+	CTA_NAT_OFFSET_AFTER,
+	__CTA_NAT_SEQ_MAX
+};
+#define CTA_NAT_SEQ_MAX (__CTA_NAT_SEQ_MAX - 1)
+
 enum ctattr_expect {
 	CTA_EXPECT_UNSPEC,
 	CTA_EXPECT_MASTER,
Index: net-2.6.git/net/ipv4/netfilter/nf_nat_helper.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/nf_nat_helper.c	2007-11-25 19:08:17.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/nf_nat_helper.c	2007-12-08 21:01:28.000000000 +0100
@@ -20,6 +20,7 @@
 #include <linux/netfilter_ipv4.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_protocol.h>
@@ -191,6 +192,8 @@ nf_nat_mangle_tcp_packet(struct sk_buff 
 		/* Tell TCP window tracking about seq change */
 		nf_conntrack_tcp_update(skb, ip_hdrlen(skb),
 					ct, CTINFO2DIR(ctinfo));
+
+		nf_conntrack_event_cache(IPCT_NATSEQADJ, skb);
 	}
 	return 1;
 }
Index: net-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2007-11-25 19:08:18.000000000 +0100
+++ net-2.6.git/net/netfilter/nf_conntrack_netlink.c	2007-12-08 21:42:31.000000000 +0100
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
+	NLA_PUT(skb, CTA_NAT_SEQ_CUR, sizeof(tmp), &tmp);
+	tmp = htonl(natseq->offset_before);
+	NLA_PUT(skb, CTA_NAT_OFFSET_BEFORE, sizeof(tmp), &tmp);
+	tmp = htonl(natseq->offset_after);
+	NLA_PUT(skb, CTA_NAT_OFFSET_AFTER, sizeof(tmp), &tmp);
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
@@ -321,7 +370,8 @@ ctnetlink_fill_info(struct sk_buff *skb,
 	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_mark(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
-	    ctnetlink_dump_use(skb, ct) < 0)
+	    ctnetlink_dump_use(skb, ct) < 0 ||
+	    ctnetlink_dump_nat_seq_adj(skb, ct) < 0)
 		goto nla_put_failure;
 
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
@@ -424,6 +474,10 @@ static int ctnetlink_conntrack_event(str
 		    (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
 		     ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0))
 			goto nla_put_failure;
+
+		if (events & IPCT_NATSEQADJ &&
+		    ctnetlink_dump_nat_seq_adj(skb, ct) < 0)
+			goto nla_put_failure;
 	}
 
 	nlh->nlmsg_len = skb->tail - b;
@@ -935,6 +989,66 @@ ctnetlink_change_protoinfo(struct nf_con
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
+	if (!cda[CTA_NAT_SEQ_CUR])
+		return -EINVAL;
+
+	natseq->correction_pos = 
+		ntohl(*(__be32 *)nla_data(cda[CTA_NAT_SEQ_CUR]));
+
+	if (!cda[CTA_NAT_OFFSET_BEFORE])
+		return -EINVAL;
+
+	natseq->offset_before = 
+		ntohl(*(__be32 *)nla_data(cda[CTA_NAT_OFFSET_BEFORE]));
+
+	if (!cda[CTA_NAT_OFFSET_AFTER])
+		return -EINVAL;
+
+	natseq->offset_after = 
+		ntohl(*(__be32 *)nla_data(cda[CTA_NAT_OFFSET_AFTER]));
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
@@ -969,6 +1083,14 @@ ctnetlink_change_conntrack(struct nf_con
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
 

--------------090004070801060200020501--
