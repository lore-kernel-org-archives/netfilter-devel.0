From: =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
Subject: [PATCH v3 2/2] netfilter: nf_tables: add requirements for connsecmark support
Date: Sun, 23 Sep 2018 20:26:16 +0200
Message-ID: <20180923182616.11398-2-cgzones@googlemail.com>
References: <20180923182616.11398-1-cgzones@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, paul@paul-moore.com,
        sds@tycho.nsa.gov, eparis@parisplace.org, jmorris@namei.org,
        serge@hallyn.com, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180923182616.11398-1-cgzones@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Add ability to set the connection tracking secmark value.

Add ability to set the meta secmark value.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
---

v3: fix compile error when CONFIG_NF_CONNTRACK_MARK not defined

Based on nf-next
Tested with v4.18.8

 net/netfilter/nft_ct.c   | 17 ++++++++++++++++-
 net/netfilter/nft_meta.c |  8 ++++++++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index d74afa707..586627c36 100644
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
@@ -564,6 +572,13 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 			return -EINVAL;
 		len = sizeof(u32);
 		break;
+#endif
+#ifdef CONFIG_NF_CONNTRACK_SECMARK
+	case NFT_CT_SECMARK:
+		if (tb[NFTA_CT_DIRECTION])
+			return -EINVAL;
+		len = sizeof(u32);
+		break;
 #endif
 	default:
 		return -EOPNOTSUPP;
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index c8ac0ef4b..a6715c816 100644
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
2.19.0
