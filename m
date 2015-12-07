From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/3] netfilter: nftables: add connlabel set support
Date: Mon,  7 Dec 2015 13:05:08 +0100
Message-ID: <1449489908-10205-4-git-send-email-fw@strlen.de>
References: <1449489908-10205-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37334 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754786AbbLGMFW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Dec 2015 07:05:22 -0500
In-Reply-To: <1449489908-10205-1-git-send-email-fw@strlen.de>
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
 net/netfilter/nft_ct.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 8cbca34..5b7fbf9 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -174,6 +174,12 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
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
@@ -252,6 +258,9 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 		if (tb[NFTA_CT_DIRECTION] != NULL)
 			return -EINVAL;
 		len = NF_CT_LABELS_MAX_SIZE;
+		err = nf_connlabels_get(ctx->net, (len * BITS_PER_BYTE) - 1);
+		if (err)
+			return err;
 		break;
 #endif
 	case NFT_CT_HELPER:
@@ -331,9 +340,21 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
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
@@ -353,6 +374,16 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
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
+	}
+
 	nft_ct_l3proto_module_put(ctx->afi->family);
 }
 
-- 
2.4.10

