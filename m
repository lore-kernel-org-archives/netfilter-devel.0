From: Florian Westphal <fw@strlen.de>
Subject: [RFC nf-next 4/5] netfilter: nf_tables_jit: add dumping of original rule
Date: Fri,  1 Jun 2018 17:32:15 +0200
Message-ID: <20180601153216.10901-5-fw@strlen.de>
References: <20180601153216.10901-1-fw@strlen.de>
Cc: ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180601153216.10901-1-fw@strlen.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

After previous patch userspace can't discover the original rules
anymore when listing the rule.

This change adds a dump callback to the ebpf expression and
a special handling in the main dumper loop.

When we see an ebpf expression in a rule, we skip normal dump handling
and leave it the the nft ebpf expression -- it has a copy of the
original expressions and can then simply add them back.

In order to allow userspace to discover presence of auto-jit,
and to map the rule to the ebpf program, we still include the ebpf
expression itself as the first expression in the dump.

For now, we expose the ebpf tag and the ebpf id plus the
number of expressions that are supposedly covered by the program.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 11 +++++++++
 net/netfilter/nf_tables_jit.c | 55 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 40c2de230400..4c5acd5d1cab 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2054,6 +2054,17 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 	if (list == NULL)
 		goto nla_put_failure;
 	nft_rule_for_each_expr(expr, next, rule) {
+		/*
+		 * special case: ebpf_fast_ops will add original expressions
+		 * to the netlink message, it will call
+		 * nf_tables_fill_expr_info() itself.
+		 */
+		if (expr->ops == &nft_ebpf_fast_ops) {
+			if (expr->ops->dump(skb, expr) < 0)
+				goto nla_put_failure;
+			break;
+		}
+
 		if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr) < 0)
 			goto nla_put_failure;
 	}
diff --git a/net/netfilter/nf_tables_jit.c b/net/netfilter/nf_tables_jit.c
index a8f4696249bf..864331aaee6b 100644
--- a/net/netfilter/nf_tables_jit.c
+++ b/net/netfilter/nf_tables_jit.c
@@ -171,11 +171,66 @@ static void nft_ebpf_destroy(const struct nft_ctx *ctx,
 	kfree(priv->original);
 }
 
+static int nft_ebpf_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_ebpf *priv = nft_expr_priv(expr);
+	const struct bpf_prog *prog = priv->prog;
+	const struct nft_expr *next;
+	struct nlattr *nest, *data;
+	int ret;
+
+	/*
+	 * From netlink perspective dump of normal vs. ebpf-jitted rule are
+	 * the same, except epbf-jitted rule has the ebpf expression prepended
+	 * to it.  The ebpf expression allows us to propagate the epbf tag and
+	 * some other meta data back to userspace.
+	 *
+	 * After the epbf expression we serialize the expressions of the
+	 * original rule (rather than the ebpf-rule blob used in packet path).
+	 */
+	nest = nla_nest_start(skb, NFTA_LIST_ELEM);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (nla_put_string(skb, NFTA_EXPR_NAME, expr->ops->type->name))
+		return -EMSGSIZE;
+
+	/* first, add ebpf expr meta data */
+	data = nla_nest_start(skb, NFTA_EXPR_DATA);
+	if (data == NULL)
+		return -EMSGSIZE;
+
+	ret = nla_put_be32(skb, NFTA_EBPF_ID, htonl(prog->aux->id));
+	if (ret)
+		return ret;
+
+	ret = nla_put(skb, NFTA_EBPF_TAG, sizeof(prog->tag), prog->tag);
+	if (ret)
+		return ret;
+
+	ret = nla_put_be32(skb, NFTA_EBPF_EXPR_COUNT, htonl(priv->expressions));
+	if (ret)
+		return ret;
+	nla_nest_end(skb, data);
+	nla_nest_end(skb, nest);
+
+	/* ... followed by the expressions that made up the original rule. */
+	nft_rule_for_each_expr(expr, next, priv->original) {
+		if (WARN_ON(expr->ops->dump == nft_ebpf_dump))
+			break;
+		if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr) < 0)
+			return -EMSGSIZE;
+	}
+
+	return 0;
+}
+
 const struct nft_expr_ops nft_ebpf_fast_ops = {
 	.type		= &nft_ebpf_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ebpf)),
 	.init		= nft_ebpf_init,
 	.destroy	= nft_ebpf_destroy,
+	.dump		= nft_ebpf_dump,
 };
 
 struct nft_expr_type nft_ebpf_type __read_mostly = {
-- 
2.16.4
