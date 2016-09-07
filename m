From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH v2] netfilter: nft_numgen: add increment counter offset value
Date: Wed, 7 Sep 2016 19:56:49 +0200
Message-ID: <20160907175646.GA7317@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36487 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932255AbcIGR4x (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Sep 2016 13:56:53 -0400
Received: by mail-wm0-f67.google.com with SMTP id l65so4106961wmf.3
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Sep 2016 10:56:53 -0700 (PDT)
Received: from sonyv (cli-5b7e49a2.wholesale.adamo.es. [91.126.73.162])
        by smtp.gmail.com with ESMTPSA id bw9sm40066027wjc.33.2016.09.07.10.56.51
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 07 Sep 2016 10:56:51 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for an initialization counter value. With this option the
sysadmin is able to start the counter when used with the increment type.

Example:

	meta mark set numgen inc mod 2 sum 100

This will generate marks with the serie 100, 101, 100, 101, ...

Only supported for increment number generation.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
Changes in v2:
	- Separate _SUM_ changes with _until_ attribute renaming.

 include/uapi/linux/netfilter/nf_tables.h | 2 ++
 net/netfilter/nft_numgen.c               | 9 +++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 24161e2..00a689d 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1128,12 +1128,14 @@ enum nft_trace_types {
  * @NFTA_NG_DREG: destination register (NLA_U32)
  * @NFTA_NG_MODULUS: maximum counter value (NLA_U32)
  * @NFTA_NG_TYPE: operation type (NLA_U32)
+ * @NFTA_NG_SUM: Offset to initiate the counter (NLA_U32)
  */
 enum nft_ng_attributes {
 	NFTA_NG_UNSPEC,
 	NFTA_NG_DREG,
 	NFTA_NG_MODULUS,
 	NFTA_NG_TYPE,
+	NFTA_NG_SUM,
 	__NFTA_NG_MAX
 };
 #define NFTA_NG_MAX	(__NFTA_NG_MAX - 1)
diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index f51a3ed..a5ea3f7 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -44,6 +44,7 @@ static const struct nla_policy nft_ng_policy[NFTA_NG_MAX + 1] = {
 	[NFTA_NG_DREG]		= { .type = NLA_U32 },
 	[NFTA_NG_MODULUS]	= { .type = NLA_U32 },
 	[NFTA_NG_TYPE]		= { .type = NLA_U32 },
+	[NFTA_NG_SUM]		= { .type = NLA_U32 },
 };
 
 static int nft_ng_inc_init(const struct nft_ctx *ctx,
@@ -51,13 +52,17 @@ static int nft_ng_inc_init(const struct nft_ctx *ctx,
 			   const struct nlattr * const tb[])
 {
 	struct nft_ng_inc *priv = nft_expr_priv(expr);
+	u32 sum = 0;
+
+	if (tb[NFTA_NG_SUM])
+		sum = ntohl(nla_get_be32(tb[NFTA_NG_SUM]));
 
 	priv->modulus = ntohl(nla_get_be32(tb[NFTA_NG_MODULUS]));
-	if (priv->modulus == 0)
+	if (priv->modulus == 0 || sum >= priv->modulus)
 		return -ERANGE;
 
 	priv->dreg = nft_parse_register(tb[NFTA_NG_DREG]);
-	atomic_set(&priv->counter, 0);
+	atomic_set(&priv->counter, sum);
 
 	return nft_validate_register_store(ctx, priv->dreg, NULL,
 					   NFT_DATA_VALUE, sizeof(u32));
-- 
2.8.1

