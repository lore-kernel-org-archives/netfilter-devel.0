From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: nft_hash: Add hash offset value
Date: Mon, 12 Sep 2016 18:34:59 +0200
Message-ID: <20160912163459.GA11062@salvia>
References: <20160906064416.GA32396@sonyv>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="T4sUOijqQbZv57TR"
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57680 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752778AbcILQfE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 12:35:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 856AF2273FC
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 18:35:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 737C0FB45F
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 18:35:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 289A81150C6
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 18:35:00 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160906064416.GA32396@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Laura,

On Tue, Sep 06, 2016 at 08:44:19AM +0200, Laura Garcia Liebana wrote:
> Add support to pass through an offset to the hash value. With this
> feature, the sysadmin is able to generate a hash with a given
> offset value.

We've been using 'offset' to refer to this for a while, to I'm
renaming this to NFTA_HASH_OFFSET.

> diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
> index b7e3b40..2102c94 100644
> --- a/net/netfilter/nft_hash.c
> +++ b/net/netfilter/nft_hash.c
> @@ -60,6 +62,11 @@ static int nft_hash_init(const struct nft_ctx *ctx,
>  	    !tb[NFTA_HASH_MODULUS])
>  		return -EINVAL;
>  
> +	if (tb[NFTA_HASH_SUM])
> +		priv->sum = ntohl(nla_get_be32(tb[NFTA_HASH_SUM]));
> +	else
> +		priv->sum = 0;

priv is allocated via kzalloc, so this priv->sum = 0 is not required.

No need to resend, I have revamped your patch, keeping your authorship
in place.

--T4sUOijqQbZv57TR
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nft_hash-Add-hash-offset-value.patch"

>From cf4cdeb8d5a2ea4cd27c1d9cf95aba4ce1e194b5 Mon Sep 17 00:00:00 2001
From: Laura Garcia Liebana <nevola@gmail.com>
Date: Tue, 6 Sep 2016 08:44:19 +0200
Subject: [PATCH] netfilter: nft_hash: Add hash offset value

Add support to pass through an offset to the hash value. With this
feature, the sysadmin is able to generate a hash with a given
offset value.

Example:

	meta mark set jhash ip saddr mod 2 seed 0xabcd plus 100

This option generates marks according to the source address from 100 to
101.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_hash.c                 | 17 +++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 24161e2..8c653bb 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -731,6 +731,7 @@ enum nft_meta_keys {
  * @NFTA_HASH_LEN: source data length (NLA_U32)
  * @NFTA_HASH_MODULUS: modulus value (NLA_U32)
  * @NFTA_HASH_SEED: seed value (NLA_U32)
+ * @NFTA_HASH_OFFSET: add this offset value to hash result (NLA_U32)
  */
 enum nft_hash_attributes {
 	NFTA_HASH_UNSPEC,
@@ -739,6 +740,7 @@ enum nft_hash_attributes {
 	NFTA_HASH_LEN,
 	NFTA_HASH_MODULUS,
 	NFTA_HASH_SEED,
+	NFTA_HASH_OFFSET,
 	__NFTA_HASH_MAX,
 };
 #define NFTA_HASH_MAX	(__NFTA_HASH_MAX - 1)
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 764251d..bd12f7a 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -23,6 +23,7 @@ struct nft_hash {
 	u8			len;
 	u32			modulus;
 	u32			seed;
+	u32			offset;
 };
 
 static void nft_hash_eval(const struct nft_expr *expr,
@@ -31,10 +32,10 @@ static void nft_hash_eval(const struct nft_expr *expr,
 {
 	struct nft_hash *priv = nft_expr_priv(expr);
 	const void *data = &regs->data[priv->sreg];
+	u32 h;
 
-	regs->data[priv->dreg] =
-		reciprocal_scale(jhash(data, priv->len, priv->seed),
-				 priv->modulus);
+	h = reciprocal_scale(jhash(data, priv->len, priv->seed), priv->modulus);
+	regs->data[priv->dreg] = h + priv->offset;
 }
 
 static const struct nla_policy nft_hash_policy[NFTA_HASH_MAX + 1] = {
@@ -59,6 +60,9 @@ static int nft_hash_init(const struct nft_ctx *ctx,
 	    !tb[NFTA_HASH_MODULUS])
 		return -EINVAL;
 
+	if (tb[NFTA_HASH_OFFSET])
+		priv->offset = ntohl(nla_get_be32(tb[NFTA_HASH_OFFSET]));
+
 	priv->sreg = nft_parse_register(tb[NFTA_HASH_SREG]);
 	priv->dreg = nft_parse_register(tb[NFTA_HASH_DREG]);
 
@@ -72,6 +76,9 @@ static int nft_hash_init(const struct nft_ctx *ctx,
 	if (priv->modulus <= 1)
 		return -ERANGE;
 
+	if (priv->offset + priv->modulus - 1 < U32_MAX)
+		return -EOVERFLOW;
+
 	priv->seed = ntohl(nla_get_be32(tb[NFTA_HASH_SEED]));
 
 	return nft_validate_register_load(priv->sreg, len) &&
@@ -94,7 +101,9 @@ static int nft_hash_dump(struct sk_buff *skb,
 		goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_HASH_SEED, htonl(priv->seed)))
 		goto nla_put_failure;
-
+	if (priv->offset != 0)
+		if (nla_put_be32(skb, NFTA_HASH_OFFSET, htonl(priv->offset)))
+			goto nla_put_failure;
 	return 0;
 
 nla_put_failure:
-- 
2.1.4


--T4sUOijqQbZv57TR--
