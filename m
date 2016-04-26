From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -nf v7] netfilter: nftables: add connlabel set support
Date: Tue, 26 Apr 2016 11:59:53 +0200
Message-ID: <1461664793-22342-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34651 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751851AbcDZJ7s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Apr 2016 05:59:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Conntrack labels are currently sized depending on the iptables
ruleset, i.e. if we're asked to test or set bits 1, 2, and 65 then we
would allocate enough room to store at least bit 65.

However, with nft, the input is just a register with arbitrary runtime
content.

We therefore ask for the upper ceiling we currently have, which is
enough room to store 128 bits.

Alternatively, we could alter nf_connlabel_replace to increase
net->ct.label_words at run time, but since 128 bits is not that
big we'd only save sizeof(long) so it doesn't seem worth it for now.

This follows a similar approach that xtables 'connlabel'
match uses, so when user inputs

    ct label set bar

then we will set the bit used by the 'bar' label and leave the rest alone.

This is done by passing the sreg content to nf_connlabels_replace
as both value and mask argument.
Labels (bits) already set thus cannot be re-set to zero, but
this is not supported by xtables connlabel match either.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Changes since v6:
  - revert back to using an sreg, like in V1
 Changes vs. V1:
  - pass sreg also as a mask so existing labels are left alone

 net/netfilter/nft_ct.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 25998fa..4ef41a8 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -198,9 +198,22 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
 		}
 		break;
 #endif
+#ifdef CONFIG_NF_CONNTRACK_LABELS
+	case NFT_CT_LABELS:
+		if (nf_connlabels_replace(ct,
+					  &regs->data[priv->sreg],
+					  &regs->data[priv->sreg],
+					  NF_CT_LABELS_MAX_SIZE / sizeof(u32)))
+			goto err;
+		break;
+#endif
 	default:
 		break;
 	}
+
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
 }
 
 static const struct nla_policy nft_ct_policy[NFTA_CT_MAX + 1] = {
@@ -365,6 +378,16 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 		len = FIELD_SIZEOF(struct nf_conn, mark);
 		break;
 #endif
+#ifdef CONFIG_NF_CONNTRACK_LABELS
+	case NFT_CT_LABELS:
+		if (tb[NFTA_CT_DIRECTION])
+			return -EINVAL;
+		len = NF_CT_LABELS_MAX_SIZE;
+		err = nf_connlabels_get(ctx->net, (len * BITS_PER_BYTE) - 1);
+		if (err)
+			return err;
+		break;
+#endif
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -384,6 +407,18 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 static void nft_ct_destroy(const struct nft_ctx *ctx,
 			   const struct nft_expr *expr)
 {
+	struct nft_ct *priv = nft_expr_priv(expr);
+
+	switch (priv->key) {
+#ifdef CONFIG_NF_CONNTRACK_LABELS
+	case NFT_CT_LABELS:
+		nf_connlabels_put(ctx->net);
+		break;
+#endif
+	default:
+		break;
+	}
+
 	nft_ct_l3proto_module_put(ctx->afi->family);
 }
 
-- 
2.7.3

