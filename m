From: Florian Westphal <fw@strlen.de>
Subject: [PATCH next] nft_meta: add skb hash get support
Date: Mon, 31 Oct 2016 13:44:29 +0100
Message-ID: <1477917869-26872-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44168 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S941857AbcJaMoO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Oct 2016 08:44:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
NB1: Alternative is to place this in nft_hash, but that uses
an sreg so i think meta is fine.

NB2: This causes a compile warning wrt. __skb_get_hash_symmetric;
net-next tree contains a change to make its argument const so this
warning won't show up anymore one this commit makes it to net-next.

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 14e5f619167e..a931bd0dca6d 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -729,6 +729,8 @@ enum nft_exthdr_attributes {
  * @NFT_META_OIFGROUP: packet output interface group
  * @NFT_META_CGROUP: socket control group (skb->sk->sk_classid)
  * @NFT_META_PRANDOM: a 32bit pseudo-random number
+ * @NFT_META_HASH: skb hash
+ * @NFT_META_SYMHASH: symmetric skb hash
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -756,6 +758,8 @@ enum nft_meta_keys {
 	NFT_META_OIFGROUP,
 	NFT_META_CGROUP,
 	NFT_META_PRANDOM,
+	NFT_META_HASH,
+	NFT_META_SYMHASH,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 64994023bf81..ea6018e7a6c4 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -190,6 +190,12 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		*dest = prandom_u32_state(state);
 		break;
 	}
+	case NFT_META_HASH:
+		*dest = skb_get_hash(pkt->skb);
+		break;
+	case NFT_META_SYMHASH:
+		*dest = __skb_get_hash_symmetric(skb);
+		break;
 	default:
 		WARN_ON(1);
 		goto err;
@@ -273,6 +279,8 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 #ifdef CONFIG_CGROUP_NET_CLASSID
 	case NFT_META_CGROUP:
 #endif
+	case NFT_META_HASH:
+	case NFT_META_SYMHASH:
 		len = sizeof(u32);
 		break;
 	case NFT_META_IIFNAME:
-- 
2.7.3

