From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH nf-next 1/2] netfilter: nft_hash: rename nft_hash to nft_jhash
Date: Thu, 23 Feb 2017 12:10:15 +0100
Message-ID: <20170223111015.573g4cxe7ehkev3y@nevthink>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33661 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750891AbdBWLRh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Feb 2017 06:17:37 -0500
Received: by mail-wr0-f196.google.com with SMTP id s27so3532818wrb.0
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Feb 2017 03:17:36 -0800 (PST)
Received: from nevthink ([91.126.73.162])
        by smtp.gmail.com with ESMTPSA id m80sm5887093wmi.34.2017.02.23.03.10.16
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 Feb 2017 03:10:17 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch renames the local nft_hash structure and functions
to nft_jhash in order to prepare the nft_hash module code to
add new hash functions.

Signed-off-by: Laura Garcia Liebana <laura.garcia@zevenet.com>
---
 net/netfilter/nft_hash.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index eb2721af898d..ccb834ef049b 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -17,7 +17,7 @@
 #include <net/netfilter/nf_tables_core.h>
 #include <linux/jhash.h>
 
-struct nft_hash {
+struct nft_jhash {
 	enum nft_registers      sreg:8;
 	enum nft_registers      dreg:8;
 	u8			len;
@@ -26,11 +26,11 @@ struct nft_hash {
 	u32			offset;
 };
 
-static void nft_hash_eval(const struct nft_expr *expr,
-			  struct nft_regs *regs,
-			  const struct nft_pktinfo *pkt)
+static void nft_jhash_eval(const struct nft_expr *expr,
+			   struct nft_regs *regs,
+			   const struct nft_pktinfo *pkt)
 {
-	struct nft_hash *priv = nft_expr_priv(expr);
+	struct nft_jhash *priv = nft_expr_priv(expr);
 	const void *data = &regs->data[priv->sreg];
 	u32 h;
 
@@ -47,11 +47,11 @@ static const struct nla_policy nft_hash_policy[NFTA_HASH_MAX + 1] = {
 	[NFTA_HASH_OFFSET]	= { .type = NLA_U32 },
 };
 
-static int nft_hash_init(const struct nft_ctx *ctx,
-			 const struct nft_expr *expr,
-			 const struct nlattr * const tb[])
+static int nft_jhash_init(const struct nft_ctx *ctx,
+			  const struct nft_expr *expr,
+			  const struct nlattr * const tb[])
 {
-	struct nft_hash *priv = nft_expr_priv(expr);
+	struct nft_jhash *priv = nft_expr_priv(expr);
 	u32 len;
 	int err;
 
@@ -92,10 +92,10 @@ static int nft_hash_init(const struct nft_ctx *ctx,
 					   NFT_DATA_VALUE, sizeof(u32));
 }
 
-static int nft_hash_dump(struct sk_buff *skb,
-			 const struct nft_expr *expr)
+static int nft_jhash_dump(struct sk_buff *skb,
+			  const struct nft_expr *expr)
 {
-	const struct nft_hash *priv = nft_expr_priv(expr);
+	const struct nft_jhash *priv = nft_expr_priv(expr);
 
 	if (nft_dump_register(skb, NFTA_HASH_SREG, priv->sreg))
 		goto nla_put_failure;
@@ -117,17 +117,17 @@ static int nft_hash_dump(struct sk_buff *skb,
 }
 
 static struct nft_expr_type nft_hash_type;
-static const struct nft_expr_ops nft_hash_ops = {
+static const struct nft_expr_ops nft_jhash_ops = {
 	.type		= &nft_hash_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_hash)),
-	.eval		= nft_hash_eval,
-	.init		= nft_hash_init,
-	.dump		= nft_hash_dump,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_jhash)),
+	.eval		= nft_jhash_eval,
+	.init		= nft_jhash_init,
+	.dump		= nft_jhash_dump,
 };
 
 static struct nft_expr_type nft_hash_type __read_mostly = {
 	.name		= "hash",
-	.ops		= &nft_hash_ops,
+	.ops		= &nft_jhash_ops,
 	.policy		= nft_hash_policy,
 	.maxattr	= NFTA_HASH_MAX,
 	.owner		= THIS_MODULE,
-- 
2.11.0

