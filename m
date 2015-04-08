From: David Miller <davem@davemloft.net>
Subject: [PATCH] netfilter: Fix switch statement warnings with recent gcc.
Date: Tue, 07 Apr 2015 23:05:42 -0400 (EDT)
Message-ID: <20150407.230542.359453916233129441.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:33543 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbbDHDFp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Apr 2015 23:05:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


More recent GCC warns about two kinds of switch statement uses:

1) Switching on an enumeration, but not having an explicit case
   statement for all members of the enumeration.  To show the
   compiler this is intentional, we simply add a default case
   with nothing more than a break statement.

2) Switching on a boolean value.  I think this warning is dumb
   but nevertheless you get it wholesale with -Wswitch.

This patch cures all such warnings in netfilter.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index 54a2fdf..ae8141f 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -371,6 +371,8 @@ static int nft_reject_bridge_dump(struct sk_buff *skb,
 		if (nla_put_u8(skb, NFTA_REJECT_ICMP_CODE, priv->icmp_code))
 			goto nla_put_failure;
 		break;
+	default:
+		break;
 	}
 
 	return 0;
diff --git a/net/ipv4/netfilter/nft_reject_ipv4.c b/net/ipv4/netfilter/nft_reject_ipv4.c
index 16a5d4d..a7621fa 100644
--- a/net/ipv4/netfilter/nft_reject_ipv4.c
+++ b/net/ipv4/netfilter/nft_reject_ipv4.c
@@ -33,6 +33,8 @@ static void nft_reject_ipv4_eval(const struct nft_expr *expr,
 	case NFT_REJECT_TCP_RST:
 		nf_send_reset(pkt->skb, pkt->ops->hooknum);
 		break;
+	default:
+		break;
 	}
 
 	data[NFT_REG_VERDICT].verdict = NF_DROP;
diff --git a/net/ipv6/netfilter/nft_reject_ipv6.c b/net/ipv6/netfilter/nft_reject_ipv6.c
index f732859..71c7be5 100644
--- a/net/ipv6/netfilter/nft_reject_ipv6.c
+++ b/net/ipv6/netfilter/nft_reject_ipv6.c
@@ -34,6 +34,8 @@ static void nft_reject_ipv6_eval(const struct nft_expr *expr,
 	case NFT_REJECT_TCP_RST:
 		nf_send_reset6(net, pkt->skb, pkt->ops->hooknum);
 		break;
+	default:
+		break;
 	}
 
 	data[NFT_REG_VERDICT].verdict = NF_DROP;
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 589b848..bdefefe 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -321,11 +321,11 @@ static void nft_match_eval(const struct nft_expr *expr,
 		return;
 	}
 
-	switch(ret) {
-	case true:
+	switch (ret ? 1 : 0) {
+	case 1:
 		data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;
 		break;
-	case false:
+	case 0:
 		data[NFT_REG_VERDICT].verdict = NFT_BREAK;
 		break;
 	}
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index cc56030..18d520e 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -56,6 +56,8 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 			state = NF_CT_STATE_BIT(ctinfo);
 		dest->data[0] = state;
 		return;
+	default:
+		break;
 	}
 
 	if (ct == NULL)
@@ -117,6 +119,8 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 		return;
 	}
 #endif
+	default:
+		break;
 	}
 
 	tuple = &ct->tuplehash[priv->dir].tuple;
@@ -141,6 +145,8 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 	case NFT_CT_PROTO_DST:
 		dest->data[0] = (__force __u16)tuple->dst.u.all;
 		return;
+	default:
+		break;
 	}
 	return;
 err:
@@ -172,6 +178,8 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
 		}
 		break;
 #endif
+	default:
+		break;
 	}
 }
 
