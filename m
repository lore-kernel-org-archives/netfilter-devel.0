From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 27/31] netfilter: nf_tables: add requirements for connsecmark support
Date: Tue,  9 Oct 2018 01:01:21 +0200
Message-ID: <20181008230125.2330-28-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Christian Göttsche <cgzones@googlemail.com>

Add ability to set the connection tracking secmark value.

Add ability to set the meta secmark value.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c   | 17 ++++++++++++++++-
 net/netfilter/nft_meta.c |  8 ++++++++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index d74afa70774f..586627c361df 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -279,7 +279,7 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
 {
 	const struct nft_ct *priv = nft_expr_priv(expr);
 	struct sk_buff *skb = pkt->skb;
-#ifdef CONFIG_NF_CONNTRACK_MARK
+#if defined(CONFIG_NF_CONNTRACK_MARK) || defined(CONFIG_NF_CONNTRACK_SECMARK)
 	u32 value = regs->data[priv->sreg];
 #endif
 	enum ip_conntrack_info ctinfo;
@@ -298,6 +298,14 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
 		}
 		break;
 #endif
+#ifdef CONFIG_NF_CONNTRACK_SECMARK
+	case NFT_CT_SECMARK:
+		if (ct->secmark != value) {
+			ct->secmark = value;
+			nf_conntrack_event_cache(IPCT_SECMARK, ct);
+		}
+		break;
+#endif
 #ifdef CONFIG_NF_CONNTRACK_LABELS
 	case NFT_CT_LABELS:
 		nf_connlabels_replace(ct,
@@ -565,6 +573,13 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 		len = sizeof(u32);
 		break;
 #endif
+#ifdef CONFIG_NF_CONNTRACK_SECMARK
+	case NFT_CT_SECMARK:
+		if (tb[NFTA_CT_DIRECTION])
+			return -EINVAL;
+		len = sizeof(u32);
+		break;
+#endif
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 91fd6e677ad7..6180626c3f80 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -284,6 +284,11 @@ static void nft_meta_set_eval(const struct nft_expr *expr,
 
 		skb->nf_trace = !!value8;
 		break;
+#ifdef CONFIG_NETWORK_SECMARK
+	case NFT_META_SECMARK:
+		skb->secmark = value;
+		break;
+#endif
 	default:
 		WARN_ON(1);
 	}
@@ -436,6 +441,9 @@ static int nft_meta_set_init(const struct nft_ctx *ctx,
 	switch (priv->key) {
 	case NFT_META_MARK:
 	case NFT_META_PRIORITY:
+#ifdef CONFIG_NETWORK_SECMARK
+	case NFT_META_SECMARK:
+#endif
 		len = sizeof(u32);
 		break;
 	case NFT_META_NFTRACE:
-- 
2.11.0
