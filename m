From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC,net-next 3/3] netfilter: nft_tunnel: support for tunnel type
Date: Thu,  4 Oct 2018 02:03:45 +0200
Message-ID: <20181004000345.2380-4-pablo@netfilter.org>
References: <20181004000345.2380-1-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, roopa@cumulusnetworks.com,
        amir@vadai.me, pshelar@ovn.org, u9012063@gmail.com
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181004000345.2380-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch allows you to set an explicit tunnel driver type in the
metadata template. In case of misconfiguration, ie. if the packets ends
up in the wrong tunnel device, the packet is dropped.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 10 ++++++++++
 net/netfilter/nft_tunnel.c               |  9 ++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 5444e76870bb..b36acb52eb50 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1692,6 +1692,15 @@ enum nft_tunnel_flags {
 				 NFT_TUNNEL_F_DONT_FRAGMENT | \
 				 NFT_TUNNEL_F_SEQ_NUMBER)
 
+/* 1:1 mapping with the internal enum ip_tunnel_type. */
+enum nft_tunnel_type {
+	NFT_TUNNEL_TYPE_UNSPEC   = 0,
+	NFT_TUNNEL_TYPE_GRE,
+	NFT_TUNNEL_TYPE_VXLAN,
+	NFT_TUNNEL_TYPE_GENEVE,
+	NFT_TUNNEL_TYPE_ERSPAN,
+};
+
 enum nft_tunnel_key_attributes {
 	NFTA_TUNNEL_KEY_UNSPEC,
 	NFTA_TUNNEL_KEY_ID,
@@ -1703,6 +1712,7 @@ enum nft_tunnel_key_attributes {
 	NFTA_TUNNEL_KEY_SPORT,
 	NFTA_TUNNEL_KEY_DPORT,
 	NFTA_TUNNEL_KEY_OPTS,
+	NFTA_TUNNEL_KEY_TYPE,
 	__NFTA_TUNNEL_KEY_MAX
 };
 #define NFTA_TUNNEL_KEY_MAX	(__NFTA_TUNNEL_KEY_MAX - 1)
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 3a15f219e4e7..3cc54bc4ce31 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -305,6 +305,7 @@ static const struct nla_policy nft_tunnel_key_policy[NFTA_TUNNEL_KEY_MAX + 1] =
 	[NFTA_TUNNEL_KEY_TOS]	= { .type = NLA_U8, },
 	[NFTA_TUNNEL_KEY_TTL]	= { .type = NLA_U8, },
 	[NFTA_TUNNEL_KEY_OPTS]	= { .type = NLA_NESTED, },
+	[NFTA_TUNNEL_KEY_TYPE]	= { .type = NLA_U32, },
 };
 
 static int nft_tunnel_obj_init(const struct nft_ctx *ctx,
@@ -312,6 +313,7 @@ static int nft_tunnel_obj_init(const struct nft_ctx *ctx,
 			       struct nft_object *obj)
 {
 	struct nft_tunnel_obj *priv = nft_obj_data(obj);
+	u32 type = NFT_TUNNEL_TYPE_UNSPEC;
 	struct ip_tunnel_info info;
 	struct metadata_dst *md;
 	int err;
@@ -319,7 +321,11 @@ static int nft_tunnel_obj_init(const struct nft_ctx *ctx,
 	if (!tb[NFTA_TUNNEL_KEY_ID])
 		return -EINVAL;
 
+	if (tb[NFTA_TUNNEL_KEY_TYPE])
+		type = ntohl(nla_get_be32(tb[NFTA_TUNNEL_KEY_TYPE]));
+
 	memset(&info, 0, sizeof(info));
+	info.type		= type;
 	info.mode		= IP_TUNNEL_INFO_TX;
 	info.key.tun_id		= key32_to_tunnel_id(nla_get_be32(tb[NFTA_TUNNEL_KEY_ID]));
 	info.key.tun_flags	= TUNNEL_KEY | TUNNEL_CSUM | TUNNEL_NOCACHE;
@@ -494,7 +500,8 @@ static int nft_tunnel_obj_dump(struct sk_buff *skb,
 	struct nft_tunnel_obj *priv = nft_obj_data(obj);
 	struct ip_tunnel_info *info = &priv->md->u.tun_info;
 
-	if (nla_put_be32(skb, NFTA_TUNNEL_KEY_ID,
+	if (nla_put_be32(skb, NFTA_TUNNEL_KEY_TYPE, htonl(info->type)) ||
+	    nla_put_be32(skb, NFTA_TUNNEL_KEY_ID,
 			 tunnel_id_to_key32(info->key.tun_id)) ||
 	    nft_tunnel_ip_dump(skb, info) < 0 ||
 	    nft_tunnel_ports_dump(skb, info) < 0 ||
-- 
2.11.0
