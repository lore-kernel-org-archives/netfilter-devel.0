Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516EF30F927
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 12:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761221375; cv=none; b=uAcQ/7z8AfK70sCFO8X4ivN5ay8HZHLGSkvNcLtIYNI5QeWtveTZxwst1kmz6y98Do0tzy5L0qKPPgBSD3OUfNl9+JNlcWn3ShSzz2rLhAyvd2nUfI2ZJ+v7ER5ixh5ZhH+OBgE3TKb5hGuXf2ssZ3WaOGLqtxY0Sg1BEzVUhEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761221375; c=relaxed/simple;
	bh=uqIpRImtukeQYvMPHbCP8DM2wd24krjBXEBJB4W8I3M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sfMvnKEELNVckXY5I4ZomdlyFYbqKaVnXtcJkT/Ult1umqxw4t5mUnhSmRXMt23oBNKl+h60xVdFw+OY1wvAjXeZeQr8nXdjGR4/pPoylL3wz5LyQeoL/kiKNq4GLYawkwIAX8oJubJOjHhyJA6i/UXhHOXXewvBB89D+6RWKbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7A4A760627; Thu, 23 Oct 2025 14:09:31 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Antonio Ojea <aojea@google.com>
Subject: [PATCH nf] netfilter: nft_ct: enable labels for get case too
Date: Thu, 23 Oct 2025 14:09:18 +0200
Message-ID: <20251023120922.2847-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

conntrack labels can only be set when the conntrack has been created
with the "ctlabel" extension.

For older iptables (connlabel match), adding an "-m connlabel" rule
turns on the ctlabel extension allocation for all future conntrack
entries.

For nftables, its only enabled for 'ct label set foo', but not for
'ct label foo' (i.e. check).
But users could have a ruleset that only checks for presence, and rely
on userspace to set a label bit via ctnetlink infrastructure.

This doesn't work without adding a dummy 'ct label set' rule.
We could also enable extension infra for the first (failing) ctnetlink
request, but unlike ruleset we would not be able to disable the
extension again.

Therefore turn on ctlabel extension allocation if an nftables ruleset
checks for a connlabel too.

Fixes: 1ad8f48df6f6 ("netfilter: nftables: add connlabel set support")
Reported-by: Antonio Ojea <aojea@google.com>
Closes: https://lore.kernel.org/netfilter-devel/aPi_VdZpVjWujZ29@strlen.de/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_ct.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index d526e69a2a2b..a418eb3d612b 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -379,6 +379,14 @@ static bool nft_ct_tmpl_alloc_pcpu(void)
 }
 #endif
 
+static void __nft_ct_get_destroy(const struct nft_ctx *ctx, struct nft_ct *priv)
+{
+#ifdef CONFIG_NF_CONNTRACK_LABELS
+	if (priv->key == NFT_CT_LABELS)
+		nf_connlabels_put(ctx->net);
+#endif
+}
+
 static int nft_ct_get_init(const struct nft_ctx *ctx,
 			   const struct nft_expr *expr,
 			   const struct nlattr * const tb[])
@@ -413,6 +421,10 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 		if (tb[NFTA_CT_DIRECTION] != NULL)
 			return -EINVAL;
 		len = NF_CT_LABELS_MAX_SIZE;
+
+		err = nf_connlabels_get(ctx->net, (len * BITS_PER_BYTE) - 1);
+		if (err)
+			return err;
 		break;
 #endif
 	case NFT_CT_HELPER:
@@ -494,7 +506,8 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 		case IP_CT_DIR_REPLY:
 			break;
 		default:
-			return -EINVAL;
+			err = -EINVAL;
+			goto err;
 		}
 	}
 
@@ -502,11 +515,11 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 	err = nft_parse_register_store(ctx, tb[NFTA_CT_DREG], &priv->dreg, NULL,
 				       NFT_DATA_VALUE, len);
 	if (err < 0)
-		return err;
+		goto err;
 
 	err = nf_ct_netns_get(ctx->net, ctx->family);
 	if (err < 0)
-		return err;
+		goto err;
 
 	if (priv->key == NFT_CT_BYTES ||
 	    priv->key == NFT_CT_PKTS  ||
@@ -514,6 +527,9 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 		nf_ct_set_acct(ctx->net, true);
 
 	return 0;
+err:
+	__nft_ct_get_destroy(ctx, priv);
+	return err;
 }
 
 static void __nft_ct_set_destroy(const struct nft_ctx *ctx, struct nft_ct *priv)
@@ -626,6 +642,9 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 static void nft_ct_get_destroy(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr)
 {
+	struct nft_ct *priv = nft_expr_priv(expr);
+
+	__nft_ct_get_destroy(ctx, priv);
 	nf_ct_netns_put(ctx->net, ctx->family);
 }
 
-- 
2.51.0

