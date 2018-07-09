From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/6] netfilter: nft_compat: explicitly reject ERROR and standard target
Date: Mon,  9 Jul 2018 19:19:02 +0200
Message-ID: <20180709171904.2460-5-pablo@netfilter.org>
References: <20180709171904.2460-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180709171904.2460-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

iptables-nft never requests these, but make this explicitly illegal.
If it were quested, kernel could oops as ->eval is NULL, furthermore,
the builtin targets have no owning module so its possible to rmmod
eb/ip/ip6_tables module even if they would be loaded.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 8d1ff654e5af..32535eea51b2 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -832,10 +832,18 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	rev = ntohl(nla_get_be32(tb[NFTA_TARGET_REV]));
 	family = ctx->family;
 
+	if (strcmp(tg_name, XT_ERROR_TARGET) == 0 ||
+	    strcmp(tg_name, XT_STANDARD_TARGET) == 0 ||
+	    strcmp(tg_name, "standard") == 0)
+		return ERR_PTR(-EINVAL);
+
 	/* Re-use the existing target if it's already loaded. */
 	list_for_each_entry(nft_target, &nft_target_list, head) {
 		struct xt_target *target = nft_target->ops.data;
 
+		if (!target->target)
+			continue;
+
 		if (nft_target_cmp(target, tg_name, rev, family))
 			return &nft_target->ops;
 	}
@@ -844,6 +852,11 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	if (IS_ERR(target))
 		return ERR_PTR(-ENOENT);
 
+	if (!target->target) {
+		err = -EINVAL;
+		goto err;
+	}
+
 	if (target->targetsize > nla_len(tb[NFTA_TARGET_INFO])) {
 		err = -EINVAL;
 		goto err;
-- 
2.11.0
