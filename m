From: Florian Westphal <fw@strlen.de>
Subject: [RFC nf-next 2/5] netfilter: nf_tables: add ebpf expression
Date: Fri,  1 Jun 2018 17:32:13 +0200
Message-ID: <20180601153216.10901-3-fw@strlen.de>
References: <20180601153216.10901-1-fw@strlen.de>
Cc: ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180601153216.10901-1-fw@strlen.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This expression serves two purposes:
1. a middleman to invoke BPF_PROG_RUN() from nf_tables main eval loop
2. to expose the bpf program id via netlink, so userspace
   can map nftables rules to their corresponding ebpf program.

2) is added in a followup patch.

Its currently not possible to attach arbitrary ebpf programs from
userspace, but this limitation is easy to remove if needed.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables_core.h   |  9 ++++++
 include/uapi/linux/netfilter/nf_tables.h | 18 ++++++++++++
 net/netfilter/Makefile                   |  3 +-
 net/netfilter/nf_tables_core.c           | 33 ++++++++++++++++++++++
 net/netfilter/nf_tables_jit.c            | 48 ++++++++++++++++++++++++++++++++
 5 files changed, 110 insertions(+), 1 deletion(-)
 create mode 100644 net/netfilter/nf_tables_jit.c

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index e0c0c2558ec4..90087a84f127 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -15,6 +15,7 @@ extern struct nft_expr_type nft_range_type;
 extern struct nft_expr_type nft_meta_type;
 extern struct nft_expr_type nft_rt_type;
 extern struct nft_expr_type nft_exthdr_type;
+extern struct nft_expr_type nft_ebpf_type;
 
 int nf_tables_core_module_init(void);
 void nf_tables_core_module_exit(void);
@@ -62,6 +63,14 @@ struct nft_payload_set {
 
 extern const struct nft_expr_ops nft_payload_fast_ops;
 
+struct nft_ebpf {
+	struct bpf_prog *prog;
+	u8 expressions;
+	const struct nft_rule *original;
+};
+
+extern const struct nft_expr_ops nft_ebpf_fast_ops;
+
 extern struct static_key_false nft_counters_enabled;
 extern struct static_key_false nft_trace_enabled;
 
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 9c71f024f9cc..e05799652a4c 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -718,6 +718,24 @@ enum nft_payload_attributes {
 };
 #define NFTA_PAYLOAD_MAX	(__NFTA_PAYLOAD_MAX - 1)
 
+/**
+ * enum nft_ebpf_attributes - nf_tables ebpf expression netlink attributes
+ *
+ * @NFTA_EBPF_FD: file descriptor holding ebpf program (NLA_S32)
+ * @NFTA_EBPF_ID: bpf program id (NLA_U32)
+ * @NFTA_EBPF_TAG: bpf tag (NLA_BINARY)
+ * @NFTA_EBPF_TAG: expressions covered by this jit (NLA_U32)
+ */
+enum nft_ebpf_attributes {
+	NFTA_EBPF_UNSPEC,
+	NFTA_EBPF_FD,
+	NFTA_EBPF_ID,
+	NFTA_EBPF_TAG,
+	NFTA_EBPF_EXPR_COUNT,
+	__NFTA_EBPF_MAX,
+};
+#define NFTA_EBPF_MAX	(__NFTA_EBPF_MAX - 1)
+
 enum nft_exthdr_flags {
 	NFT_EXTHDR_F_PRESENT = (1 << 0),
 };
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 9b3434360d49..49c6e0a535f9 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -76,7 +76,8 @@ obj-$(CONFIG_NF_DUP_NETDEV)	+= nf_dup_netdev.o
 nf_tables-objs := nf_tables_core.o nf_tables_api.o nft_chain_filter.o \
 		  nf_tables_trace.o nft_immediate.o nft_cmp.o nft_range.o \
 		  nft_bitwise.o nft_byteorder.o nft_payload.o nft_lookup.o \
-		  nft_dynset.o nft_meta.o nft_rt.o nft_exthdr.o
+		  nft_dynset.o nft_meta.o nft_rt.o nft_exthdr.o \
+		  nf_tables_jit.o
 
 obj-$(CONFIG_NF_TABLES)		+= nf_tables.o
 obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 47cf667b15ca..038a15243508 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/filter.h>
 #include <linux/list.h>
 #include <linux/rculist.h>
 #include <linux/skbuff.h>
@@ -92,6 +93,35 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 	return true;
 }
 
+static void nft_ebpf_fast_eval(const struct nft_expr *expr,
+			       struct nft_regs *regs,
+			       const struct nft_pktinfo *pkt)
+{
+	const struct nft_ebpf *priv = nft_expr_priv(expr);
+	struct bpf_skb_data_end cb_saved;
+	int ret;
+
+	memcpy(&cb_saved, pkt->skb->cb, sizeof(cb_saved));
+	bpf_compute_data_pointers(pkt->skb);
+
+	ret = BPF_PROG_RUN(priv->prog, pkt->skb);
+
+	memcpy(pkt->skb->cb, &cb_saved, sizeof(cb_saved));
+
+	switch (ret) {
+	case NF_DROP:
+	case NF_ACCEPT:
+	case NFT_BREAK:
+		regs->verdict.code = ret;
+		return;
+	case NFT_CONTINUE:
+		return;
+	default:
+		pr_debug("Unknown verdict %d\n", ret);
+		regs->verdict.code = NF_DROP;
+		break;
+	}
+}
 DEFINE_STATIC_KEY_FALSE(nft_counters_enabled);
 
 static noinline void nft_update_chain_stats(const struct nft_chain *chain,
@@ -151,6 +181,8 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		nft_rule_for_each_expr(expr, last, rule) {
 			if (expr->ops == &nft_cmp_fast_ops)
 				nft_cmp_fast_eval(expr, &regs);
+			else if (expr->ops == &nft_ebpf_fast_ops)
+				nft_ebpf_fast_eval(expr, &regs, pkt);
 			else if (expr->ops != &nft_payload_fast_ops ||
 				 !nft_payload_fast_eval(expr, &regs, pkt))
 				expr->ops->eval(expr, &regs, pkt);
@@ -232,6 +264,7 @@ static struct nft_expr_type *nft_basic_types[] = {
 	&nft_meta_type,
 	&nft_rt_type,
 	&nft_exthdr_type,
+	&nft_ebpf_type,
 };
 
 int __init nf_tables_core_module_init(void)
diff --git a/net/netfilter/nf_tables_jit.c b/net/netfilter/nf_tables_jit.c
new file mode 100644
index 000000000000..415c2acfa471
--- /dev/null
+++ b/net/netfilter/nf_tables_jit.c
@@ -0,0 +1,48 @@
+#include <linux/bpf.h>
+#include <linux/netfilter.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
+
+struct nft_ebpf_expression {
+	struct nft_expr e;
+	struct nft_ebpf priv;
+};
+
+static const struct nla_policy nft_ebpf_policy[NFTA_EBPF_MAX + 1] = {
+	[NFTA_EBPF_FD]			= { .type = NLA_S32 },
+	[NFTA_EBPF_ID]			= { .type = NLA_U32 },
+	[NFTA_EBPF_EXPR_COUNT]		= { .type = NLA_U32 },
+	[NFTA_EBPF_TAG]			= { .type = NLA_BINARY,
+					    .len = BPF_TAG_SIZE, },
+};
+
+static int nft_ebpf_init(const struct nft_ctx *ctx,
+			 const struct nft_expr *expr,
+			 const struct nlattr * const tb[])
+{
+	return -EOPNOTSUPP;
+}
+
+static void nft_ebpf_destroy(const struct nft_ctx *ctx,
+			     const struct nft_expr *expr)
+{
+	struct nft_ebpf *priv = nft_expr_priv(expr);
+
+	bpf_prog_put(priv->prog);
+	kfree(priv->original);
+}
+
+const struct nft_expr_ops nft_ebpf_fast_ops = {
+	.type		= &nft_ebpf_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ebpf)),
+	.init		= nft_ebpf_init,
+	.destroy	= nft_ebpf_destroy,
+};
+
+struct nft_expr_type nft_ebpf_type __read_mostly = {
+	.name		= "ebpf",
+	.ops		= &nft_ebpf_fast_ops,
+	.policy		= nft_ebpf_policy,
+	.maxattr	= NFTA_EBPF_MAX,
+	.owner		= THIS_MODULE,
+};
-- 
2.16.4
