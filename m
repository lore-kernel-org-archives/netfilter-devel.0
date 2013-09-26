From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [PATCH RFC 3/3] acct: add input and output interface index
Date: Thu, 26 Sep 2013 17:31:53 +0200
Message-ID: <20130926154005.592908761@eitzenberger.org>
References: <20130926153150.280914229@eitzenberger.org>
Cc: Krzysztof Piotr Oledzki <ole@ans.pl>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:62994 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab3IZPkJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:40:09 -0400
Content-Disposition: inline; filename=conntrack-acct-add-in-out-ifindex.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The interface indices are exported as uint32_t, although being
signed integer inside the kernel, which goes in line with
what nfnetlink_queue does.

Both interface indices are wrapped inside CTA_ACCT.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: net-next-ipfix/include/net/netfilter/nf_conntrack_acct.h
===================================================================
--- net-next-ipfix.orig/include/net/netfilter/nf_conntrack_acct.h
+++ net-next-ipfix/include/net/netfilter/nf_conntrack_acct.h
@@ -21,6 +21,8 @@ struct nf_conn_counter {
 
 struct nf_conn_acct {
 	struct nf_conn_counter counter[IP_CT_DIR_MAX];
+	int indev;
+	int outdev;
 };
 
 static inline
Index: net-next-ipfix/net/netfilter/nf_conntrack_core.c
===================================================================
--- net-next-ipfix.orig/net/netfilter/nf_conntrack_core.c
+++ net-next-ipfix/net/netfilter/nf_conntrack_core.c
@@ -33,6 +33,7 @@
 #include <linux/mm.h>
 #include <linux/nsproxy.h>
 #include <linux/rculist_nulls.h>
+#include <net/dst.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
@@ -1110,6 +1111,7 @@ void __nf_ct_refresh_acct(struct nf_conn
 acct:
 	if (do_acct) {
 		struct nf_conn_acct *acct;
+		struct dst_entry *dst;
 
 		acct = nf_conn_acct_find(ct);
 		if (acct) {
@@ -1117,6 +1119,13 @@ acct:
 
 			atomic64_inc(&counter[CTINFO2DIR(ctinfo)].packets);
 			atomic64_add(skb->len, &counter[CTINFO2DIR(ctinfo)].bytes);
+
+			if (acct->indev == 0 && skb->dev)
+				acct->indev = skb->dev->ifindex;
+
+			dst = skb_dst(skb);
+			if (acct->outdev == 0 && dst && dst->dev)
+				acct->outdev = dst->dev->ifindex;
 		}
 	}
 }
Index: net-next-ipfix/include/uapi/linux/netfilter/nfnetlink_conntrack.h
===================================================================
--- net-next-ipfix.orig/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ net-next-ipfix/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -53,6 +53,7 @@ enum ctattr_type {
 	CTA_MARK_MASK,
 	CTA_LABELS,
 	CTA_LABELS_MASK,
+	CTA_ACCT,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
@@ -138,6 +139,14 @@ enum ctattr_counters {
 };
 #define CTA_COUNTERS_MAX (__CTA_COUNTERS_MAX - 1)
 
+enum ctattr_acct {
+	CTA_ACCT_UNSPEC,
+	CTA_ACCT_INDEV,
+	CTA_ACCT_OUTDEV,
+	__CTA_ACCT_MAX
+};
+#define CTA_ACCT_MAX (__CTA_ACCT_MAX - 1)
+
 enum ctattr_tstamp {
 	CTA_TIMESTAMP_UNSPEC,
 	CTA_TIMESTAMP_START,
Index: net-next-ipfix/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-next-ipfix.orig/net/netfilter/nf_conntrack_netlink.c
+++ net-next-ipfix/net/netfilter/nf_conntrack_netlink.c
@@ -248,15 +248,27 @@ static int
 ctnetlink_dump_acct(struct sk_buff *skb, const struct nf_conn *ct, int type)
 {
 	struct nf_conn_acct *acct = nf_conn_acct_find(ct);
+	struct nlattr *nla_acct;
 
 	if (acct == NULL)
 		return 0;
 
+	/* counters are not nested in CTA_ACCT for backward compatibility */
 	if (dump_counters(skb, acct, IP_CT_DIR_ORIGINAL, type) < 0)
 		return -1;
 	if (dump_counters(skb, acct, IP_CT_DIR_REPLY, type) < 0)
 		return -1;
 
+	nla_acct = nla_nest_start(skb, CTA_ACCT | NLA_F_NESTED);
+	if (!nla_acct)
+		return -1;
+
+	if (nla_put_be32(skb, CTA_ACCT_INDEV, htonl(acct->indev)) ||
+		nla_put_be32(skb, CTA_ACCT_OUTDEV, htonl(acct->outdev)))
+		return -1;
+
+	nla_nest_end(skb, nla_acct);
+
 	return 0;
 }
 
@@ -542,6 +554,8 @@ ctnetlink_acct_size(const struct nf_conn
 	return 2 * nla_total_size(0) /* CTA_COUNTERS_ORIG|REPL */
 	       + 2 * nla_total_size(sizeof(uint64_t)) /* CTA_COUNTERS_PACKETS */
 	       + 2 * nla_total_size(sizeof(uint64_t)) /* CTA_COUNTERS_BYTES */
+		   + nla_total_size(0)					  /* CTA_ACCT */
+	       + 2 * nla_total_size(sizeof(uint32_t)) /* CTA_(IN|OUT)DEV */
 	       ;
 }
 

