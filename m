From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 3/3] netfilter: nf_tables: wrap tracing with a static key
Date: Thu, 26 Nov 2015 18:59:39 +0100
Message-ID: <1448560779-28989-4-git-send-email-fw@strlen.de>
References: <1448560779-28989-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37513 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826AbbKZR7u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 12:59:50 -0500
In-Reply-To: <1448560779-28989-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Only needed when meta nftrace rule(s) were added.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Changes since v1:
  - do not wrap rulenum++ into static key, because
  it might get incremented too late when trace
  rules are added/removed at high rate, giving wrong results.
  - add EXPORT_SYMBOL for nft_meta_set_destroy.

 There was another followup patch to disable old tracing
 infrastructure, but I dropped this for now.

 So, for the time being, you get both tracing formats.

 Should be easy to add sysctl later on to disable the old
 format.

 include/net/netfilter/nf_tables_core.h |  1 +
 include/net/netfilter/nft_meta.h       |  3 +++
 net/bridge/netfilter/nft_meta_bridge.c |  1 +
 net/netfilter/nf_tables_core.c         |  6 +++++-
 net/netfilter/nf_tables_trace.c        |  4 ++++
 net/netfilter/nft_meta.c               | 16 ++++++++++++++++
 6 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 4ff5424..a9060dd 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -57,6 +57,7 @@ struct nft_payload_set {
 };
 
 extern const struct nft_expr_ops nft_payload_fast_ops;
+extern struct static_key_false nft_trace_enabled;
 
 int nft_payload_module_init(void);
 void nft_payload_module_exit(void);
diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
index 711887a..d27588c 100644
--- a/include/net/netfilter/nft_meta.h
+++ b/include/net/netfilter/nft_meta.h
@@ -33,4 +33,7 @@ void nft_meta_set_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt);
 
+void nft_meta_set_destroy(const struct nft_ctx *ctx,
+			  const struct nft_expr *expr);
+
 #endif
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index a21269b..4b901d9 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -84,6 +84,7 @@ static const struct nft_expr_ops nft_meta_bridge_set_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
 	.eval		= nft_meta_set_eval,
 	.init		= nft_meta_set_init,
+	.destroy	= nft_meta_set_destroy,
 	.dump		= nft_meta_set_dump,
 };
 
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index e8ba9da..5d3d37b 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -16,6 +16,7 @@
 #include <linux/skbuff.h>
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
+#include <linux/static_key.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
@@ -62,7 +63,10 @@ static inline void nft_trace_packet(struct nft_traceinfo *info,
 				    int rulenum,
 				    enum nft_trace_types type)
 {
-	if (unlikely(pkt->skb->nf_trace)) {
+	if (static_branch_unlikely(&nft_trace_enabled)) {
+		if (!pkt->skb->nf_trace)
+			return;
+
 		info->chain = chain;
 		info->rule = rule;
 		info->verdict = verdict;
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index 2f557b7..7446891 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/static_key.h>
 #include <linux/hash.h>
 #include <linux/if_vlan.h>
 #include <linux/init.h>
@@ -25,6 +26,9 @@
 
 #define NFT_ID_SKB_HASHBITS	12
 
+DEFINE_STATIC_KEY_FALSE(nft_trace_enabled);
+EXPORT_SYMBOL_GPL(nft_trace_enabled);
+
 /* only used if tracing is on */
 static DEFINE_PER_CPU_READ_MOSTLY(u32, trace_seq);
 static atomic_t trace_cnt;
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index eaf41e4..1cf6814 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -18,10 +18,12 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/smp.h>
+#include <linux/static_key.h>
 #include <net/dst.h>
 #include <net/sock.h>
 #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
 #include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nft_meta.h>
 
 void nft_meta_get_eval(const struct nft_expr *expr,
@@ -299,6 +301,9 @@ int nft_meta_set_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
+	if (priv->key == NFT_META_NFTRACE)
+		static_branch_inc(&nft_trace_enabled);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nft_meta_set_init);
@@ -336,6 +341,16 @@ nla_put_failure:
 }
 EXPORT_SYMBOL_GPL(nft_meta_set_dump);
 
+void nft_meta_set_destroy(const struct nft_ctx *ctx,
+			  const struct nft_expr *expr)
+{
+	const struct nft_meta *priv = nft_expr_priv(expr);
+
+	if (priv->key == NFT_META_NFTRACE)
+		static_branch_dec(&nft_trace_enabled);
+}
+EXPORT_SYMBOL_GPL(nft_meta_set_destroy);
+
 static struct nft_expr_type nft_meta_type;
 static const struct nft_expr_ops nft_meta_get_ops = {
 	.type		= &nft_meta_type,
@@ -350,6 +365,7 @@ static const struct nft_expr_ops nft_meta_set_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
 	.eval		= nft_meta_set_eval,
 	.init		= nft_meta_set_init,
+	.destroy	= nft_meta_set_destroy,
 	.dump		= nft_meta_set_dump,
 };
 
-- 
2.4.10

