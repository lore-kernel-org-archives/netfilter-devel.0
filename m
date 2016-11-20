From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nft_dynset: fix incorrect element expiration calculation
Date: Sun, 20 Nov 2016 14:18:07 +0800
Message-ID: <1479622687-17266-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, akp@cohaesio.com,
        Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:40926 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752092AbcKTGTE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 20 Nov 2016 01:19:04 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

After commit a8b1e36d0d1d ("netfilter: nft_dynset: fix element timeout
for HZ != 1000"), priv->timeout was stored in jiffies, while
set->timeout was stored in milliseconds. This is inconsistent and
incorrect.

Firstly, we already call msecs_to_jiffies in nft_set_elem_init, so
priv->timeout will be converted to jiffies twice.

Secondly, if the user did not specify the NFTA_DYNSET_TIMEOUT attr,
set->timeout will be used, but we forget to call msecs_to_jiffies
when do update elements.

So it's better to call msecs_to_jiffies when updating elements.

Fixes: a8b1e36d0d1d ("netfilter: nft_dynset: fix element timeout for HZ != 1000")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nft_dynset.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 31ca947..28dd592 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -81,7 +81,8 @@ static void nft_dynset_eval(const struct nft_expr *expr,
 		if (priv->op == NFT_DYNSET_OP_UPDATE &&
 		    nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
 			timeout = priv->timeout ? : set->timeout;
-			*nft_set_ext_expiration(ext) = jiffies + timeout;
+			*nft_set_ext_expiration(ext) =
+				jiffies + msecs_to_jiffies(timeout);
 		} else if (sexpr == NULL)
 			goto out;
 
@@ -165,8 +166,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	if (tb[NFTA_DYNSET_TIMEOUT] != NULL) {
 		if (!(set->flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
-		timeout = msecs_to_jiffies(be64_to_cpu(nla_get_be64(
-						tb[NFTA_DYNSET_TIMEOUT])));
+		timeout = be64_to_cpu(nla_get_be64(tb[NFTA_DYNSET_TIMEOUT]));
 	}
 
 	priv->sreg_key = nft_parse_register(tb[NFTA_DYNSET_SREG_KEY]);
@@ -254,8 +254,7 @@ static int nft_dynset_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		goto nla_put_failure;
 	if (nla_put_string(skb, NFTA_DYNSET_SET_NAME, priv->set->name))
 		goto nla_put_failure;
-	if (nla_put_be64(skb, NFTA_DYNSET_TIMEOUT,
-			 cpu_to_be64(jiffies_to_msecs(priv->timeout)),
+	if (nla_put_be64(skb, NFTA_DYNSET_TIMEOUT, cpu_to_be64(priv->timeout),
 			 NFTA_DYNSET_PAD))
 		goto nla_put_failure;
 	if (priv->expr && nft_expr_dump(skb, NFTA_DYNSET_EXPR, priv->expr))
-- 
2.5.5


