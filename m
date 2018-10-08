From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/31] netfilter: nf_tables: warn when expr implements only one of activate/deactivate
Date: Tue,  9 Oct 2018 01:00:57 +0200
Message-ID: <20181008230125.2330-4-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

->destroy is only allowed to free data, or do other cleanups that do not
have side effects on other state, such as visibility to other netlink
requests.

Such things need to be done in ->deactivate.
As a transaction can fail, we need to make sure we can undo such
operations, therefore ->activate() has to be provided too.

So print a warning and refuse registration if expr->ops provides
only one of the two operations.

v2: fix nft_expr_check_ops to not repeat same check twice (Jones Desougi)

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 220e6aab3fac..d4c531e0a26f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -207,6 +207,18 @@ static int nft_delchain(struct nft_ctx *ctx)
 	return err;
 }
 
+/* either expr ops provide both activate/deactivate, or neither */
+static bool nft_expr_check_ops(const struct nft_expr_ops *ops)
+{
+	if (!ops)
+		return true;
+
+	if (WARN_ON_ONCE((!ops->activate ^ !ops->deactivate)))
+		return false;
+
+	return true;
+}
+
 static void nft_rule_expr_activate(const struct nft_ctx *ctx,
 				   struct nft_rule *rule)
 {
@@ -1907,6 +1919,9 @@ static int nf_tables_delchain(struct net *net, struct sock *nlsk,
  */
 int nft_register_expr(struct nft_expr_type *type)
 {
+	if (!nft_expr_check_ops(type->ops))
+		return -EINVAL;
+
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	if (type->family == NFPROTO_UNSPEC)
 		list_add_tail_rcu(&type->list, &nf_tables_expressions);
@@ -2054,6 +2069,10 @@ static int nf_tables_expr_parse(const struct nft_ctx *ctx,
 			err = PTR_ERR(ops);
 			goto err1;
 		}
+		if (!nft_expr_check_ops(ops)) {
+			err = -EINVAL;
+			goto err1;
+		}
 	} else
 		ops = type->ops;
 
-- 
2.11.0
