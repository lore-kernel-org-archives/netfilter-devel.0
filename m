From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 7/6] netfilter: nft_ct: load both IPv4 and IPv6 conntrack
 modules for NFPROTO_INET
Date: Mon, 6 Jan 2014 18:09:49 +0000
Message-ID: <20140106180948.GB27979@macbook.localnet>
References: <1388751378-23272-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55897 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbaAFSJw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:09:52 -0500
Content-Disposition: inline
In-Reply-To: <1388751378-23272-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 71bcc5bde767f1a6da04391b0d9595f30e3f720b
Author: Patrick McHardy <kaber@trash.net>
Date:   Mon Jan 6 17:58:02 2014 +0000

    netfilter: nft_ct: load both IPv4 and IPv6 conntrack modules for NFPROTO_INET
    
    The ct expression can currently not be used in the inet family since
    we don't have a conntrack module for NFPROTO_INET, so
    nf_ct_l3proto_try_module_get() fails. Add some manual handling to
    load the modules for both NFPROTO_IPV4 and NFPROTO_IPV6 if the
    ct expression is used in the inet family.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 955f4e6..78bf57c 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -129,6 +129,39 @@ static const struct nla_policy nft_ct_policy[NFTA_CT_MAX + 1] = {
 	[NFTA_CT_DIRECTION]	= { .type = NLA_U8 },
 };
 
+static int nft_ct_l3proto_try_module_get(uint8_t family)
+{
+	int err;
+
+	if (family == NFPROTO_INET) {
+		err = nf_ct_l3proto_try_module_get(NFPROTO_IPV4);
+		if (err < 0)
+			goto err1;
+		err = nf_ct_l3proto_try_module_get(NFPROTO_IPV6);
+		if (err < 0)
+			goto err2;
+	} else {
+		err = nf_ct_l3proto_try_module_get(family);
+		if (err < 0)
+			goto err1;
+	}
+	return 0;
+
+err2:
+	nf_ct_l3proto_module_put(NFPROTO_IPV4);
+err1:
+	return err;
+}
+
+static void nft_ct_l3proto_module_put(uint8_t family)
+{
+	if (family == NFPROTO_INET) {
+		nf_ct_l3proto_module_put(NFPROTO_IPV4);
+		nf_ct_l3proto_module_put(NFPROTO_IPV6);
+	} else
+		nf_ct_l3proto_module_put(family);
+}
+
 static int nft_ct_init(const struct nft_ctx *ctx,
 		       const struct nft_expr *expr,
 		       const struct nlattr * const tb[])
@@ -179,7 +212,7 @@ static int nft_ct_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
-	err = nf_ct_l3proto_try_module_get(ctx->afi->family);
+	err = nft_ct_l3proto_try_module_get(ctx->afi->family);
 	if (err < 0)
 		return err;
 	priv->family = ctx->afi->family;
@@ -195,7 +228,7 @@ static int nft_ct_init(const struct nft_ctx *ctx,
 	return 0;
 
 err1:
-	nf_ct_l3proto_module_put(ctx->afi->family);
+	nft_ct_l3proto_module_put(ctx->afi->family);
 	return err;
 }
 
@@ -203,7 +236,7 @@ static void nft_ct_destroy(const struct nft_expr *expr)
 {
 	struct nft_ct *priv = nft_expr_priv(expr);
 
-	nf_ct_l3proto_module_put(priv->family);
+	nft_ct_l3proto_module_put(priv->family);
 }
 
 static int nft_ct_dump(struct sk_buff *skb, const struct nft_expr *expr)
