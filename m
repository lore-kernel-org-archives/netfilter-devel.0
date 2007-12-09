From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/5] Add support for secmark
Date: Sun, 09 Dec 2007 19:13:24 +0100
Message-ID: <475C3044.5020300@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070809020807020202020404"
Cc: Patrick McHardy <kaber@trash.net>,
	James Morris <jmorris@redhat.com>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36767 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751178AbXLISNy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Dec 2007 13:13:54 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070809020807020202020404
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch adds support for James Morris' connsecmark.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------070809020807020202020404
Content-Type: text/x-patch;
 name="05.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05.patch"

[PATCH][CTNETLINK] Add support for secmark

This patch adds support for James Morris' connsecmark.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/include/linux/netfilter/nf_conntrack_common.h
===================================================================
--- net-2.6.git.orig/include/linux/netfilter/nf_conntrack_common.h	2007-12-08 19:56:12.000000000 +0100
+++ net-2.6.git/include/linux/netfilter/nf_conntrack_common.h	2007-12-08 20:04:37.000000000 +0100
@@ -133,6 +133,10 @@ enum ip_conntrack_events
 	/* NAT sequence adjustment */
 	IPCT_NATSEQADJ_BIT = 13,
 	IPCT_NATSEQADJ = (1 << IPCT_NATSEQADJ_BIT),
+
+	/* Secmark is set */
+	IPCT_SECMARK_BIT = 12,
+	IPCT_SECMARK = (1 << IPCT_SECMARK_BIT),
 };
 
 enum ip_conntrack_expect_events {
Index: net-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2007-12-08 20:04:36.000000000 +0100
+++ net-2.6.git/net/netfilter/nf_conntrack_netlink.c	2007-12-08 20:04:37.000000000 +0100
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
@@ -392,6 +408,7 @@ ctnetlink_fill_info(struct sk_buff *skb,
 	    ctnetlink_dump_protoinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
 	    ctnetlink_dump_mark(skb, ct) < 0 ||
+	    ctnetlink_dump_secmark(skb, ct) < 0 ||
 	    ctnetlink_dump_id(skb, ct) < 0 ||
 	    ctnetlink_dump_use(skb, ct) < 0 ||
 	    ctnetlink_dump_master(skb, ct) < 0 ||
@@ -493,6 +510,11 @@ static int ctnetlink_conntrack_event(str
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
Index: net-2.6.git/net/netfilter/xt_CONNSECMARK.c
===================================================================
--- net-2.6.git.orig/net/netfilter/xt_CONNSECMARK.c	2007-12-08 19:56:12.000000000 +0100
+++ net-2.6.git/net/netfilter/xt_CONNSECMARK.c	2007-12-08 20:04:37.000000000 +0100
@@ -20,6 +20,7 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_CONNSECMARK.h>
 #include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 
 #define PFX "CONNSECMARK: "
 
@@ -40,8 +41,10 @@ static void secmark_save(const struct sk
 		enum ip_conntrack_info ctinfo;
 
 		ct = nf_ct_get(skb, &ctinfo);
-		if (ct && !ct->secmark)
+		if (ct && !ct->secmark) {
 			ct->secmark = skb->secmark;
+			nf_conntrack_event_cache(IPCT_SECMARK, skb);
+		}
 	}
 }
 
Index: net-2.6.git/include/linux/netfilter/nfnetlink_conntrack.h
===================================================================
--- net-2.6.git.orig/include/linux/netfilter/nfnetlink_conntrack.h	2007-12-08 20:06:21.000000000 +0100
+++ net-2.6.git/include/linux/netfilter/nfnetlink_conntrack.h	2007-12-08 20:06:33.000000000 +0100
@@ -39,6 +39,7 @@ enum ctattr_type {
 	CTA_TUPLE_MASTER,
 	CTA_NAT_SEQ_ADJ_ORIG,
 	CTA_NAT_SEQ_ADJ_REPLY,
+	CTA_SECMARK,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)

--------------070809020807020202020404--
