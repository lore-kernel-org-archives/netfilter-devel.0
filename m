From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nft_hash: do not dump the auto generated seed
Date: Mon,  3 Apr 2017 16:34:38 +0800
Message-ID: <1491208478-6119-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, laura.garcia@zevenet.com,
        Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:52197 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751622AbdDCIfS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Apr 2017 04:35:18 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

This can prevent the nft utility from printing out the auto generated
seed to the user, which is unnecessary and confusing.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nft_hash.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index eb2721a..c4dad12 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -21,6 +21,7 @@ struct nft_hash {
 	enum nft_registers      sreg:8;
 	enum nft_registers      dreg:8;
 	u8			len;
+	bool			autogen_seed:1;
 	u32			modulus;
 	u32			seed;
 	u32			offset;
@@ -82,10 +83,12 @@ static int nft_hash_init(const struct nft_ctx *ctx,
 	if (priv->offset + priv->modulus - 1 < priv->offset)
 		return -EOVERFLOW;
 
-	if (tb[NFTA_HASH_SEED])
+	if (tb[NFTA_HASH_SEED]) {
 		priv->seed = ntohl(nla_get_be32(tb[NFTA_HASH_SEED]));
-	else
+	} else {
+		priv->autogen_seed = true;
 		get_random_bytes(&priv->seed, sizeof(priv->seed));
+	}
 
 	return nft_validate_register_load(priv->sreg, len) &&
 	       nft_validate_register_store(ctx, priv->dreg, NULL,
@@ -105,7 +108,8 @@ static int nft_hash_dump(struct sk_buff *skb,
 		goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_HASH_MODULUS, htonl(priv->modulus)))
 		goto nla_put_failure;
-	if (nla_put_be32(skb, NFTA_HASH_SEED, htonl(priv->seed)))
+	if (!priv->autogen_seed &&
+	    nla_put_be32(skb, NFTA_HASH_SEED, htonl(priv->seed)))
 		goto nla_put_failure;
 	if (priv->offset != 0)
 		if (nla_put_be32(skb, NFTA_HASH_OFFSET, htonl(priv->offset)))
-- 
2.5.5


