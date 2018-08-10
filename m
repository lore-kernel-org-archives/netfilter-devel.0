From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/8] netfilter: nft_ct: enable conntrack for helpers
Date: Fri, 10 Aug 2018 13:16:20 +0200
Message-ID: <20180810111622.3981-7-pablo@netfilter.org>
References: <20180810111622.3981-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180810111622.3981-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Enable conntrack if the user defines a helper to be used from the
ruleset policy.

Fixes: 1a64edf54f55 ("netfilter: nft_ct: add helper set support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 4788458a0931..4855d4ce1c8f 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -963,6 +963,7 @@ static int nft_ct_helper_obj_init(const struct nft_ctx *ctx,
 	struct nf_conntrack_helper *help4, *help6;
 	char name[NF_CT_HELPER_NAME_LEN];
 	int family = ctx->family;
+	int err;
 
 	if (!tb[NFTA_CT_HELPER_NAME] || !tb[NFTA_CT_HELPER_L4PROTO])
 		return -EINVAL;
@@ -1013,7 +1014,18 @@ static int nft_ct_helper_obj_init(const struct nft_ctx *ctx,
 	priv->helper4 = help4;
 	priv->helper6 = help6;
 
+	err = nf_ct_netns_get(ctx->net, ctx->family);
+	if (err < 0)
+		goto err_put_helper;
+
 	return 0;
+
+err_put_helper:
+	if (priv->helper4)
+		nf_conntrack_helper_put(priv->helper4);
+	if (priv->helper6)
+		nf_conntrack_helper_put(priv->helper6);
+	return err;
 }
 
 static void nft_ct_helper_obj_destroy(const struct nft_ctx *ctx,
@@ -1025,6 +1037,8 @@ static void nft_ct_helper_obj_destroy(const struct nft_ctx *ctx,
 		nf_conntrack_helper_put(priv->helper4);
 	if (priv->helper6)
 		nf_conntrack_helper_put(priv->helper6);
+
+	nf_ct_netns_put(ctx->net, ctx->family);
 }
 
 static void nft_ct_helper_obj_eval(struct nft_object *obj,
-- 
2.11.0
