From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 3/3] netfilter: nftables: add connlabel set support
Date: Mon, 14 Mar 2016 15:09:14 +0100
Message-ID: <1457964554-13907-1-git-send-email-fw@strlen.de>
References: <1457963194-19132-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52721 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755203AbcCNOI7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 10:08:59 -0400
In-Reply-To: <1457963194-19132-1-git-send-email-fw@strlen.de>
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

Caveats: to set a label one has to use:

ct label set ct label | bar

as 'ct label set bar' will clear all other labels.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Supersede of v3, kbuild robot reported error wrt. unhandled
 case in nft_ct_destroy, add default: label.

 net/netfilter/nft_ct.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index d4a4619..b0e8102 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -198,6 +198,12 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
 		}
 		break;
 #endif
+#ifdef CONFIG_NF_CONNTRACK_LABELS
+	case NFT_CT_LABELS:
+		nf_connlabels_replace(ct, &regs->data[priv->sreg], NULL,
+				      NF_CT_LABELS_MAX_SIZE / sizeof(u32));
+		break;
+#endif
 	default:
 		break;
 	}
@@ -276,6 +282,9 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 		if (tb[NFTA_CT_DIRECTION] != NULL)
 			return -EINVAL;
 		len = NF_CT_LABELS_MAX_SIZE;
+		err = nf_connlabels_get(ctx->net, (len * BITS_PER_BYTE) - 1);
+		if (err)
+			return err;
 		break;
 #endif
 	case NFT_CT_HELPER:
@@ -362,9 +371,21 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 	switch (priv->key) {
 #ifdef CONFIG_NF_CONNTRACK_MARK
 	case NFT_CT_MARK:
+		if (tb[NFTA_CT_DIRECTION])
+			return -EINVAL;
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
@@ -384,6 +405,18 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
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
2.4.10

