From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH] netfilter: nft_hash: Add hash offset value
Date: Mon, 5 Sep 2016 10:36:57 +0200
Message-ID: <20160905083655.GA15395@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34945 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752268AbcIEIhC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Sep 2016 04:37:02 -0400
Received: by mail-wm0-f65.google.com with SMTP id a6so866807wmc.2
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Sep 2016 01:37:01 -0700 (PDT)
Received: from sonyv ([91.126.73.162])
        by smtp.gmail.com with ESMTPSA id bc5sm19735351wjb.37.2016.09.05.01.36.59
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 05 Sep 2016 01:37:00 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support to pass through an offset to the hash value. With this
feature, the sysadmin is able to generate a hash with a given
offset value.

Example:

	meta mark set jhash ip saddr mod 2 seed 0xabcd sum 100

This option generates marks according to the source address from 100 to
101.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_hash.c                 | 13 +++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 4dbeeed..8026684 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -764,6 +764,7 @@ enum nft_meta_keys {
  * @NFTA_HASH_LEN: source data length (NLA_U32)
  * @NFTA_HASH_MODULUS: modulus value (NLA_U32)
  * @NFTA_HASH_SEED: seed value (NLA_U32)
+ * @NFTA_HASH_SUM: Hash offset value (NLA_U32)
  */
 enum nft_hash_attributes {
 	NFTA_HASH_UNSPEC,
@@ -772,6 +773,7 @@ enum nft_hash_attributes {
 	NFTA_HASH_LEN,
 	NFTA_HASH_MODULUS,
 	NFTA_HASH_SEED,
+	NFTA_HASH_SUM,
 	__NFTA_HASH_MAX,
 };
 #define NFTA_HASH_MAX	(__NFTA_HASH_MAX - 1)
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index b7e3b40..8ab04d9 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -23,6 +23,7 @@ struct nft_hash {
 	u8			len;
 	u32			modulus;
 	u32			seed;
+	u32			sum;
 };
 
 static void nft_hash_eval(const struct nft_expr *expr,
@@ -35,7 +36,7 @@ static void nft_hash_eval(const struct nft_expr *expr,
 
 	h = reciprocal_scale(jhash(data, priv->len, priv->seed), priv->modulus);
 
-	regs->data[priv->dreg] = h;
+	regs->data[priv->dreg] = priv->sum + h;
 }
 
 const struct nla_policy nft_hash_policy[NFTA_HASH_MAX + 1] = {
@@ -44,6 +45,7 @@ const struct nla_policy nft_hash_policy[NFTA_HASH_MAX + 1] = {
 	[NFTA_HASH_LEN]			= { .type = NLA_U32 },
 	[NFTA_HASH_MODULUS]		= { .type = NLA_U32 },
 	[NFTA_HASH_SEED]		= { .type = NLA_U32 },
+	[NFTA_HASH_SUM]			= { .type = NLA_U32 },
 };
 
 static int nft_hash_init(const struct nft_ctx *ctx,
@@ -60,6 +62,11 @@ static int nft_hash_init(const struct nft_ctx *ctx,
 	    !tb[NFTA_HASH_MODULUS])
 		return -EINVAL;
 
+	if (tb[NFTA_HASH_SUM])
+		priv->sum = ntohl(nla_get_be32(tb[NFTA_HASH_SUM]));
+	else
+		priv->sum = 0;
+
 	priv->sreg = nft_parse_register(tb[NFTA_HASH_SREG]);
 	if (priv->sreg < 0)
 		return -ERANGE;
@@ -99,7 +106,9 @@ static int nft_hash_dump(struct sk_buff *skb,
 		goto nla_put_failure;
 	if (nft_dump_register(skb, NFTA_HASH_SEED, priv->seed))
 		goto nla_put_failure;
-
+	if (priv->sum != 0)
+		if (nft_dump_register(skb, NFTA_HASH_SUM, priv->sum))
+			goto nla_put_failure;
 	return 0;
 
 nla_put_failure:
-- 
2.8.1

