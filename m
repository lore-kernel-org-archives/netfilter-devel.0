From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/31] netfilter: nf_tables: rt: allow checking if dst has xfrm attached
Date: Tue,  9 Oct 2018 01:00:55 +0200
Message-ID: <20181008230125.2330-2-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Useful e.g. to avoid NATting inner headers of to-be-encrypted packets.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_rt.c                   | 11 +++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index e23290ffdc77..6c44cbbb2cda 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -826,12 +826,14 @@ enum nft_meta_keys {
  * @NFT_RT_NEXTHOP4: routing nexthop for IPv4
  * @NFT_RT_NEXTHOP6: routing nexthop for IPv6
  * @NFT_RT_TCPMSS: fetch current path tcp mss
+ * @NFT_RT_XFRM: boolean, skb->dst->xfrm != NULL
  */
 enum nft_rt_keys {
 	NFT_RT_CLASSID,
 	NFT_RT_NEXTHOP4,
 	NFT_RT_NEXTHOP6,
 	NFT_RT_TCPMSS,
+	NFT_RT_XFRM,
 	__NFT_RT_MAX
 };
 #define NFT_RT_MAX		(__NFT_RT_MAX - 1)
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index 76dba9f6b6f6..f35fa33913ae 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -90,6 +90,11 @@ static void nft_rt_get_eval(const struct nft_expr *expr,
 	case NFT_RT_TCPMSS:
 		nft_reg_store16(dest, get_tcpmss(pkt, dst));
 		break;
+#ifdef CONFIG_XFRM
+	case NFT_RT_XFRM:
+		nft_reg_store8(dest, !!dst->xfrm);
+		break;
+#endif
 	default:
 		WARN_ON(1);
 		goto err;
@@ -130,6 +135,11 @@ static int nft_rt_get_init(const struct nft_ctx *ctx,
 	case NFT_RT_TCPMSS:
 		len = sizeof(u16);
 		break;
+#ifdef CONFIG_XFRM
+	case NFT_RT_XFRM:
+		len = sizeof(u8);
+		break;
+#endif
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -164,6 +174,7 @@ static int nft_rt_validate(const struct nft_ctx *ctx, const struct nft_expr *exp
 	case NFT_RT_NEXTHOP4:
 	case NFT_RT_NEXTHOP6:
 	case NFT_RT_CLASSID:
+	case NFT_RT_XFRM:
 		return 0;
 	case NFT_RT_TCPMSS:
 		hooks = (1 << NF_INET_FORWARD) |
-- 
2.11.0
