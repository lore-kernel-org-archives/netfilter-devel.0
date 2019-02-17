From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/11] netfilter: nft_tunnel: Add NFTA_TUNNEL_MODE options
Date: Mon, 18 Feb 2019 00:23:48 +0100
Message-ID: <20190217232357.29858-3-pablo@netfilter.org>
References: <20190217232357.29858-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190217232357.29858-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

nft "tunnel" expr match both the tun_info of RX and TX. This patch
provide the NFTA_TUNNEL_MODE to individually match the tun_info of
RX or TX.

Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  9 +++++++++
 net/netfilter/nft_tunnel.c               | 34 ++++++++++++++++++++++++++++++--
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 030302893d96..a66c8de006cc 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1727,10 +1727,19 @@ enum nft_tunnel_keys {
 };
 #define NFT_TUNNEL_MAX	(__NFT_TUNNEL_MAX - 1)
 
+enum nft_tunnel_mode {
+	NFT_TUNNEL_MODE_NONE,
+	NFT_TUNNEL_MODE_RX,
+	NFT_TUNNEL_MODE_TX,
+	__NFT_TUNNEL_MODE_MAX
+};
+#define NFT_TUNNEL_MODE_MAX	(__NFT_TUNNEL_MODE_MAX - 1)
+
 enum nft_tunnel_attributes {
 	NFTA_TUNNEL_UNSPEC,
 	NFTA_TUNNEL_KEY,
 	NFTA_TUNNEL_DREG,
+	NFTA_TUNNEL_MODE,
 	__NFTA_TUNNEL_MAX
 };
 #define NFTA_TUNNEL_MAX	(__NFTA_TUNNEL_MAX - 1)
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 3a15f219e4e7..ea28588c5eed 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -15,6 +15,7 @@
 struct nft_tunnel {
 	enum nft_tunnel_keys	key:8;
 	enum nft_registers	dreg:8;
+	enum nft_tunnel_mode	mode:8;
 };
 
 static void nft_tunnel_get_eval(const struct nft_expr *expr,
@@ -29,14 +30,32 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
 
 	switch (priv->key) {
 	case NFT_TUNNEL_PATH:
-		nft_reg_store8(dest, !!tun_info);
+		if (!tun_info) {
+			nft_reg_store8(dest, false);
+			return;
+		}
+		if (priv->mode == NFT_TUNNEL_MODE_NONE ||
+		    (priv->mode == NFT_TUNNEL_MODE_RX &&
+		     !(tun_info->mode & IP_TUNNEL_INFO_TX)) ||
+		    (priv->mode == NFT_TUNNEL_MODE_TX &&
+		     (tun_info->mode & IP_TUNNEL_INFO_TX)))
+			nft_reg_store8(dest, true);
+		else
+			nft_reg_store8(dest, false);
 		break;
 	case NFT_TUNNEL_ID:
 		if (!tun_info) {
 			regs->verdict.code = NFT_BREAK;
 			return;
 		}
-		*dest = ntohl(tunnel_id_to_key32(tun_info->key.tun_id));
+		if (priv->mode == NFT_TUNNEL_MODE_NONE ||
+		    (priv->mode == NFT_TUNNEL_MODE_RX &&
+		     !(tun_info->mode & IP_TUNNEL_INFO_TX)) ||
+		    (priv->mode == NFT_TUNNEL_MODE_TX &&
+		     (tun_info->mode & IP_TUNNEL_INFO_TX)))
+			*dest = ntohl(tunnel_id_to_key32(tun_info->key.tun_id));
+		else
+			regs->verdict.code = NFT_BREAK;
 		break;
 	default:
 		WARN_ON(1);
@@ -47,6 +66,7 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
 static const struct nla_policy nft_tunnel_policy[NFTA_TUNNEL_MAX + 1] = {
 	[NFTA_TUNNEL_KEY]	= { .type = NLA_U32 },
 	[NFTA_TUNNEL_DREG]	= { .type = NLA_U32 },
+	[NFTA_TUNNEL_MODE]	= { .type = NLA_U32 },
 };
 
 static int nft_tunnel_get_init(const struct nft_ctx *ctx,
@@ -74,6 +94,14 @@ static int nft_tunnel_get_init(const struct nft_ctx *ctx,
 
 	priv->dreg = nft_parse_register(tb[NFTA_TUNNEL_DREG]);
 
+	if (tb[NFTA_TUNNEL_MODE]) {
+		priv->mode = ntohl(nla_get_be32(tb[NFTA_TUNNEL_MODE]));
+		if (priv->mode > NFT_TUNNEL_MODE_MAX)
+			return -EOPNOTSUPP;
+	} else {
+		priv->mode = NFT_TUNNEL_MODE_NONE;
+	}
+
 	return nft_validate_register_store(ctx, priv->dreg, NULL,
 					   NFT_DATA_VALUE, len);
 }
@@ -87,6 +115,8 @@ static int nft_tunnel_get_dump(struct sk_buff *skb,
 		goto nla_put_failure;
 	if (nft_dump_register(skb, NFTA_TUNNEL_DREG, priv->dreg))
 		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_TUNNEL_MODE, htonl(priv->mode)))
+		goto nla_put_failure;
 	return 0;
 
 nla_put_failure:
-- 
2.11.0
