From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH 2/5] netfilter: nf_tables: Make meta expression core functions public
Date: Thu, 27 Mar 2014 14:47:04 +0200
Message-ID: <1395924427-27947-3-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1395924427-27947-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64293 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755098AbaC0Mrd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Mar 2014 08:47:33 -0400
In-Reply-To: <1395924427-27947-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This will be useful to create network family dedicated META expression
as for NFPROTO_BRIDGE for instance.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/net/netfilter/nft_meta.h | 32 ++++++++++++++++++++++++++++++
 net/netfilter/nft_meta.c         | 42 ++++++++++++++++++++--------------------
 2 files changed, 53 insertions(+), 21 deletions(-)
 create mode 100644 include/net/netfilter/nft_meta.h

diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
new file mode 100644
index 0000000..2fcb32f
--- /dev/null
+++ b/include/net/netfilter/nft_meta.h
@@ -0,0 +1,32 @@
+#ifndef _NFT_META_H_
+#define _NFT_META_H_
+
+struct nft_meta {
+	enum nft_meta_keys	key:8;
+	union {
+		enum nft_registers	dreg:8;
+		enum nft_registers	sreg:8;
+	};
+};
+
+extern const struct nla_policy nft_meta_policy[];
+
+int nft_meta_init_validate_get(uint32_t key);
+
+int nft_meta_init_validate_set(uint32_t key);
+
+int nft_meta_get_dump(struct sk_buff *skb,
+		      const struct nft_expr *expr);
+
+int nft_meta_set_dump(struct sk_buff *skb,
+		      const struct nft_expr *expr);
+
+void nft_meta_get_eval(const struct nft_expr *expr,
+		       struct nft_data data[NFT_REG_MAX + 1],
+		       const struct nft_pktinfo *pkt);
+
+void nft_meta_set_eval(const struct nft_expr *expr,
+		       struct nft_data data[NFT_REG_MAX + 1],
+		       const struct nft_pktinfo *pkt);
+
+#endif
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index e8254ad..1b1422c 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -18,18 +18,11 @@
 #include <net/sock.h>
 #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nft_meta.h>
 
-struct nft_meta {
-	enum nft_meta_keys	key:8;
-	union {
-		enum nft_registers	dreg:8;
-		enum nft_registers	sreg:8;
-	};
-};
-
-static void nft_meta_get_eval(const struct nft_expr *expr,
-			      struct nft_data data[NFT_REG_MAX + 1],
-			      const struct nft_pktinfo *pkt)
+void nft_meta_get_eval(const struct nft_expr *expr,
+		       struct nft_data data[NFT_REG_MAX + 1],
+		       const struct nft_pktinfo *pkt)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
@@ -140,10 +133,11 @@ static void nft_meta_get_eval(const struct nft_expr *expr,
 err:
 	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
 }
+EXPORT_SYMBOL_GPL(nft_meta_get_eval);
 
-static void nft_meta_set_eval(const struct nft_expr *expr,
-			      struct nft_data data[NFT_REG_MAX + 1],
-			      const struct nft_pktinfo *pkt)
+void nft_meta_set_eval(const struct nft_expr *expr,
+		       struct nft_data data[NFT_REG_MAX + 1],
+		       const struct nft_pktinfo *pkt)
 {
 	const struct nft_meta *meta = nft_expr_priv(expr);
 	struct sk_buff *skb = pkt->skb;
@@ -163,14 +157,16 @@ static void nft_meta_set_eval(const struct nft_expr *expr,
 		WARN_ON(1);
 	}
 }
+EXPORT_SYMBOL_GPL(nft_meta_set_eval);
 
-static const struct nla_policy nft_meta_policy[NFTA_META_MAX + 1] = {
+const struct nla_policy nft_meta_policy[NFTA_META_MAX + 1] = {
 	[NFTA_META_DREG]	= { .type = NLA_U32 },
 	[NFTA_META_KEY]		= { .type = NLA_U32 },
 	[NFTA_META_SREG]	= { .type = NLA_U32 },
 };
+EXPORT_SYMBOL_GPL(nft_meta_policy);
 
-static int nft_meta_init_validate_set(uint32_t key)
+int nft_meta_init_validate_set(uint32_t key)
 {
 	switch (key) {
 	case NFT_META_MARK:
@@ -181,8 +177,9 @@ static int nft_meta_init_validate_set(uint32_t key)
 		return -EOPNOTSUPP;
 	}
 }
+EXPORT_SYMBOL_GPL(nft_meta_init_validate_set);
 
-static int nft_meta_init_validate_get(uint32_t key)
+int nft_meta_init_validate_get(uint32_t key)
 {
 	switch (key) {
 	case NFT_META_LEN:
@@ -211,6 +208,7 @@ static int nft_meta_init_validate_get(uint32_t key)
 	}
 
 }
+EXPORT_SYMBOL_GPL(nft_meta_init_validate_get);
 
 static int nft_meta_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 			 const struct nlattr * const tb[])
@@ -246,8 +244,8 @@ static int nft_meta_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	return 0;
 }
 
-static int nft_meta_get_dump(struct sk_buff *skb,
-			     const struct nft_expr *expr)
+int nft_meta_get_dump(struct sk_buff *skb,
+		      const struct nft_expr *expr)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 
@@ -260,9 +258,10 @@ static int nft_meta_get_dump(struct sk_buff *skb,
 nla_put_failure:
 	return -1;
 }
+EXPORT_SYMBOL_GPL(nft_meta_get_dump);
 
-static int nft_meta_set_dump(struct sk_buff *skb,
-			     const struct nft_expr *expr)
+int nft_meta_set_dump(struct sk_buff *skb,
+		      const struct nft_expr *expr)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 
@@ -276,6 +275,7 @@ static int nft_meta_set_dump(struct sk_buff *skb,
 nla_put_failure:
 	return -1;
 }
+EXPORT_SYMBOL_GPL(nft_meta_set_dump);
 
 static struct nft_expr_type nft_meta_type;
 static const struct nft_expr_ops nft_meta_get_ops = {
-- 
1.8.3.2

