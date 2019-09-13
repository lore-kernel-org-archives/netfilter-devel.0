Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F31C4CEC8
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:17:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7D2820717
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:17:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="OqEyX8Ky"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387473AbfIMIRy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 04:17:54 -0400
Received: from kadath.azazel.net ([81.187.231.250]:60852 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387427AbfIMIRy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 04:17:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CUFVCT6C1wZxX1OuuuU4US6nqhUEyoSdw7Sb/2ByTrQ=; b=OqEyX8KyirifnAiSpSUx+lPolS
        Z3baIAo6KGGgvXezNNmWq5zpSJQYxcwyl59JLo3FkU8uTX4z7Mb7+YK9d3X/+bsP9hcHFjla2WZMK
        dJmoBHA0rZcE4flmihikOVceqKqU/W9Piriz9T/FWz7KfgYRRAnBHvWh8sndyPlevqxlPXwPOuKGd
        PT92YrlXUKBCZMBjOJYTT8/QCnUpLESdUalonjMI1FdyW+n34UFbVWkkfjsYktvHaQ3oQcUVnioL4
        6zDVvmRh0F1f+6C5nhIGjm+z1w0HYr+nTrcEbfT5dmDgu7OwrCPMf2COQNT1oWv2QbW3Q9yOTDr8m
        FRcebS8w==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i8ghm-0005yL-4z; Fri, 13 Sep 2019 09:13:22 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v3 14/18] netfilter: move nf_conntrack code to linux/nf_conntrack_common.h.
Date:   Fri, 13 Sep 2019 09:13:14 +0100
Message-Id: <20190913081318.16071-15-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913081318.16071-1-jeremy@azazel.net>
References: <20190913081318.16071-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Move some `struct nf_conntrack` code from linux/skbuff.h to
linux/nf_conntrack_common.h.  Together with a couple of helpers for
getting and setting skb->_nfct, it allows us to remove
CONFIG_NF_CONNTRACK checks from net/netfilter/nf_conntrack.h.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter/nf_conntrack_common.h | 20 ++++++++++++
 include/linux/skbuff.h                        | 32 +++++++++----------
 include/net/netfilter/nf_conntrack.h          | 24 +++-----------
 net/netfilter/nf_conntrack_standalone.c       |  1 -
 4 files changed, 40 insertions(+), 37 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index e142b2b5f1ea..1db83c931d9c 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -2,6 +2,7 @@
 #ifndef _NF_CONNTRACK_COMMON_H
 #define _NF_CONNTRACK_COMMON_H
 
+#include <linux/atomic.h>
 #include <uapi/linux/netfilter/nf_conntrack_common.h>
 
 struct ip_conntrack_stat {
@@ -19,4 +20,23 @@ struct ip_conntrack_stat {
 	unsigned int search_restart;
 };
 
+#define NFCT_INFOMASK	7UL
+#define NFCT_PTRMASK	~(NFCT_INFOMASK)
+
+struct nf_conntrack {
+	atomic_t use;
+};
+
+void nf_conntrack_destroy(struct nf_conntrack *nfct);
+static inline void nf_conntrack_put(struct nf_conntrack *nfct)
+{
+	if (nfct && atomic_dec_and_test(&nfct->use))
+		nf_conntrack_destroy(nfct);
+}
+static inline void nf_conntrack_get(struct nf_conntrack *nfct)
+{
+	if (nfct)
+		atomic_inc(&nfct->use);
+}
+
 #endif /* _NF_CONNTRACK_COMMON_H */
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 028e684fa974..907209c0794e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -37,6 +37,9 @@
 #include <linux/in6.h>
 #include <linux/if_packet.h>
 #include <net/flow.h>
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+#include <linux/netfilter/nf_conntrack_common.h>
+#endif
 
 /* The interface for checksum offload between the stack and networking drivers
  * is as follows...
@@ -244,12 +247,6 @@ struct bpf_prog;
 union bpf_attr;
 struct skb_ext;
 
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
-struct nf_conntrack {
-	atomic_t use;
-};
-#endif
-
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 struct nf_bridge_info {
 	enum {
@@ -914,7 +911,6 @@ static inline bool skb_pfmemalloc(const struct sk_buff *skb)
 #define SKB_DST_NOREF	1UL
 #define SKB_DST_PTRMASK	~(SKB_DST_NOREF)
 
-#define SKB_NFCT_PTRMASK	~(7UL)
 /**
  * skb_dst - returns skb dst_entry
  * @skb: buffer
@@ -4040,25 +4036,27 @@ static inline void skb_remcsum_process(struct sk_buff *skb, void *ptr,
 static inline struct nf_conntrack *skb_nfct(const struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
-	return (void *)(skb->_nfct & SKB_NFCT_PTRMASK);
+	return (void *)(skb->_nfct & NFCT_PTRMASK);
 #else
 	return NULL;
 #endif
 }
 
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
-void nf_conntrack_destroy(struct nf_conntrack *nfct);
-static inline void nf_conntrack_put(struct nf_conntrack *nfct)
+static inline unsigned long skb_get_nfct(const struct sk_buff *skb)
 {
-	if (nfct && atomic_dec_and_test(&nfct->use))
-		nf_conntrack_destroy(nfct);
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	return skb->_nfct;
+#else
+	return 0UL;
+#endif
 }
-static inline void nf_conntrack_get(struct nf_conntrack *nfct)
+
+static inline void skb_set_nfct(struct sk_buff *skb, unsigned long nfct)
 {
-	if (nfct)
-		atomic_inc(&nfct->use);
-}
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	skb->_nfct = nfct;
 #endif
+}
 
 #ifdef CONFIG_SKB_EXTENSIONS
 enum skb_ext_id {
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 22275f42f0bb..9f551f3b69c6 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -13,12 +13,10 @@
 #ifndef _NF_CONNTRACK_H
 #define _NF_CONNTRACK_H
 
-#include <linux/netfilter/nf_conntrack_common.h>
-
 #include <linux/bitops.h>
 #include <linux/compiler.h>
-#include <linux/atomic.h>
 
+#include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_conntrack_tcp.h>
 #include <linux/netfilter/nf_conntrack_dccp.h>
 #include <linux/netfilter/nf_conntrack_sctp.h>
@@ -58,7 +56,6 @@ struct nf_conntrack_net {
 #include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
 
 struct nf_conn {
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	/* Usage count in here is 1 for hash table, 1 per skb,
 	 * plus 1 for any connection(s) we are `master' for
 	 *
@@ -68,7 +65,6 @@ struct nf_conn {
 	 * beware nf_ct_get() is different and don't inc refcnt.
 	 */
 	struct nf_conntrack ct_general;
-#endif
 
 	spinlock_t	lock;
 	/* jiffies32 when this ct is considered dead */
@@ -149,18 +145,14 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 int nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 			     const struct nf_conn *ignored_conntrack);
 
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
-
-#define NFCT_INFOMASK	7UL
-#define NFCT_PTRMASK	~(NFCT_INFOMASK)
-
 /* Return conntrack_info and tuple hash for given skb. */
 static inline struct nf_conn *
 nf_ct_get(const struct sk_buff *skb, enum ip_conntrack_info *ctinfo)
 {
-	*ctinfo = skb->_nfct & NFCT_INFOMASK;
+	unsigned long nfct = skb_get_nfct(skb);
 
-	return (struct nf_conn *)(skb->_nfct & NFCT_PTRMASK);
+	*ctinfo = nfct & NFCT_INFOMASK;
+	return (struct nf_conn *)(nfct & NFCT_PTRMASK);
 }
 
 /* decrement reference count on a conntrack */
@@ -170,8 +162,6 @@ static inline void nf_ct_put(struct nf_conn *ct)
 	nf_conntrack_put(&ct->ct_general);
 }
 
-#endif
-
 /* Protocol module loading */
 int nf_ct_l3proto_try_module_get(unsigned short l3proto);
 void nf_ct_l3proto_module_put(unsigned short l3proto);
@@ -323,16 +313,12 @@ void nf_ct_tmpl_free(struct nf_conn *tmpl);
 
 u32 nf_ct_get_id(const struct nf_conn *ct);
 
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
-
 static inline void
 nf_ct_set(struct sk_buff *skb, struct nf_conn *ct, enum ip_conntrack_info info)
 {
-	skb->_nfct = (unsigned long)ct | info;
+	skb_set_nfct(skb, (unsigned long)ct | info);
 }
 
-#endif
-
 #define NF_CT_STAT_INC(net, count)	  __this_cpu_inc((net)->ct.stat->count)
 #define NF_CT_STAT_INC_ATOMIC(net, count) this_cpu_inc((net)->ct.stat->count)
 #define NF_CT_STAT_ADD_ATOMIC(net, count, v) this_cpu_add((net)->ct.stat->count, (v))
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 88d4127df863..410809c669e1 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -1167,7 +1167,6 @@ static int __init nf_conntrack_standalone_init(void)
 	if (ret < 0)
 		goto out_start;
 
-	BUILD_BUG_ON(SKB_NFCT_PTRMASK != NFCT_PTRMASK);
 	BUILD_BUG_ON(NFCT_INFOMASK <= IP_CT_NUMBER);
 
 #ifdef CONFIG_SYSCTL
-- 
2.23.0

