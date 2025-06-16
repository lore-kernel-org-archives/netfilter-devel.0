Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B151F2222B6
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Jun 2025 21:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750111059; cv=none; b=quaGNnHNltpy5cKiDdnYbE9m5H3PXRfiyU0gk8GxJ5l9/fyEsNMybj7IjmYb2tSSPSkfhBfGwAX3IvCOBgC0bknE0LAf+14s1PosOU+Jo97HsmeMX0rdB8EvxbklRtPzkgPxaRk81V4BtLqKAFyMglXX6zG/XMq7h1N1pJowDq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750111059; c=relaxed/simple;
	bh=we8UGiRT9XfMyfKaBO2YRQ+XXGbp5r7pYOF/IvEaSDs=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RdTs2SORDA+1QCaJTLu0PvUrgZrLaxLpamPZXTEXRyOR95XdixyXqqY+yWuH/3UtILdZvtG57TUGLH3UoKca9h5nCHfAMYH2gQRTr2xiXS3Ft6B1YR7pbLva4MJF77hrjAM24P7zyTgMqMRJPm8Z2/JArDopDPT1tAMGLAZHPos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ooRiHvsl; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ooRiHvsl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ooRiHvsl";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ooRiHvsl"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A6D17603BB; Mon, 16 Jun 2025 23:57:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750111049;
	bh=aGi8by4TFm9Rcp1MdUGiJSvBBDXuBlogC2K+qgtM3TI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ooRiHvslIrT2pq/Oqf0MfaWvSIZQu8nfNX3baWttEwbu+7ZU2QBwnQuXHiVD/5BQ9
	 2zvOxJVy0Ii9WuqeNi+HWIMeUVgziZ2CB2AQClFj0hZFE6cv2UIJvY0vQ8XY8KFjqP
	 bAazd7+3yTvQc6K3PBnQY0GJAxvFDOFlO4iQQjdu44IwslKqC1n+WOVMjRr/1dUyXw
	 wk1x5IjdBWMeMe7+bH57m2KuFeQEXan0ztliT54MUC0LKPNSrie0LOWqfILep6ebYy
	 9476tMcDLXmJRVFn+2gNjUIuy7ba94ylJ+N6vP5H0NOIFLDMFv/tpwsDO/eicVGVGo
	 YR0Ro/wl3xbDg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1E129603B7
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Jun 2025 23:57:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750111049;
	bh=aGi8by4TFm9Rcp1MdUGiJSvBBDXuBlogC2K+qgtM3TI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ooRiHvslIrT2pq/Oqf0MfaWvSIZQu8nfNX3baWttEwbu+7ZU2QBwnQuXHiVD/5BQ9
	 2zvOxJVy0Ii9WuqeNi+HWIMeUVgziZ2CB2AQClFj0hZFE6cv2UIJvY0vQ8XY8KFjqP
	 bAazd7+3yTvQc6K3PBnQY0GJAxvFDOFlO4iQQjdu44IwslKqC1n+WOVMjRr/1dUyXw
	 wk1x5IjdBWMeMe7+bH57m2KuFeQEXan0ztliT54MUC0LKPNSrie0LOWqfILep6ebYy
	 9476tMcDLXmJRVFn+2gNjUIuy7ba94ylJ+N6vP5H0NOIFLDMFv/tpwsDO/eicVGVGo
	 YR0Ro/wl3xbDg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/3] src: use EXPR_RANGE_VALUE in interval maps
Date: Mon, 16 Jun 2025 23:57:23 +0200
Message-Id: <20250616215723.608990-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250616215723.608990-1-pablo@netfilter.org>
References: <20250616215723.608990-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the restriction on maps to use EXPR_RANGE_VALUE to reduce
memory consumption.

With 100k map with concatenation:

  table inet x {
         map y {
                    typeof ip saddr . tcp dport :  ip saddr
                    flags interval
                    elements = {
                        1.0.2.0-1.0.2.240 . 0-2 : 1.0.2.10,
			...
	 }
  }

Before: 153.6 Mbytes
After: 108.9 Mbytes (-29.11%)

With 100k map without concatenation:

  table inet x {
         map y {
                    typeof ip saddr :  ip saddr
                    flags interval
                    elements = {
                        1.0.2.0-1.0.2.240 : 1.0.2.10,
			...
	 }
  }

Before: 74.36 Mbytes
After: 62.39 Mbytes (-16.10%)

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c |  5 +++--
 src/netlink.c  | 50 +++++++++++++++++++++++++++++++++++++++++++-------
 src/optimize.c |  3 +++
 3 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index b157a9c9d935..fac6c657dcbb 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2268,6 +2268,7 @@ static bool data_mapping_has_interval(struct expr *data)
 	struct expr *i;
 
 	if (data->etype == EXPR_RANGE ||
+	    data->etype == EXPR_RANGE_VALUE ||
 	    data->etype == EXPR_PREFIX)
 		return true;
 
@@ -2276,6 +2277,7 @@ static bool data_mapping_has_interval(struct expr *data)
 
 	list_for_each_entry(i, &data->expressions, list) {
 		if (i->etype == EXPR_RANGE ||
+		    i->etype == EXPR_RANGE_VALUE ||
 		    i->etype == EXPR_PREFIX)
 			return true;
 	}
@@ -2368,8 +2370,7 @@ static int expr_evaluate_symbol_range(struct eval_ctx *ctx, struct expr **exprp)
 	left = range->left;
 	right = range->right;
 
-	/* maps need more work to use constant_range_expr. */
-	if (ctx->set && !set_is_map(ctx->set->flags) &&
+	if (ctx->set &&
 	    left->etype == EXPR_VALUE &&
 	    right->etype == EXPR_VALUE) {
 		constant_range = constant_range_expr_alloc(&expr->location,
diff --git a/src/netlink.c b/src/netlink.c
index 94cf177213fd..c07cbe6a0476 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -217,6 +217,7 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 		case EXPR_VALUE:
 		case EXPR_RANGE:
 		case EXPR_PREFIX:
+		case EXPR_RANGE_VALUE:
 			nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_DATA,
 					   nld.value, nld.len);
 			break;
@@ -369,29 +370,46 @@ static void netlink_gen_concat_key(const struct expr *expr,
 static int __netlink_gen_concat_data(int end, const struct expr *i,
 				     unsigned char *data)
 {
+	mpz_t value;
+	int ret;
+
 	switch (i->etype) {
 	case EXPR_RANGE:
-		i = end ? i->right : i->left;
+		if (end)
+			i = i->right;
+		else
+			i = i->left;
+
+		mpz_init_set(value, i->value);
+		break;
+	case EXPR_RANGE_VALUE:
+		if (end)
+			mpz_init_set(value, i->range.high);
+		else
+			mpz_init_set(value, i->range.low);
 		break;
 	case EXPR_PREFIX:
 		if (end) {
 			int count;
-			mpz_t v;
 
-			mpz_init_bitmask(v, i->len - i->prefix_len);
-			mpz_add(v, i->prefix->value, v);
-			count = netlink_export_pad(data, v, i);
-			mpz_clear(v);
+			mpz_init_bitmask(value, i->len - i->prefix_len);
+			mpz_add(value, i->prefix->value, value);
+			count = netlink_export_pad(data, value, i);
+			mpz_clear(value);
 			return count;
 		}
 		return netlink_export_pad(data, i->prefix->value, i);
 	case EXPR_VALUE:
+		mpz_init_set(value, i->value);
 		break;
 	default:
 		BUG("invalid expression type '%s' in set", expr_ops(i)->name);
 	}
 
-	return netlink_export_pad(data, i->value, i);
+	ret = netlink_export_pad(data, value, i);
+	mpz_clear(value);
+
+	return ret;
 }
 
 static void __netlink_gen_concat_expand(const struct expr *expr,
@@ -507,6 +525,22 @@ static void netlink_gen_range(const struct expr *expr,
 	nft_data_memcpy(nld, data, len);
 }
 
+static void netlink_gen_range_value(const struct expr *expr,
+				    struct nft_data_linearize *nld)
+{
+	unsigned int len = (netlink_padded_len(expr->len) / BITS_PER_BYTE) * 2;
+	unsigned char data[NFT_MAX_EXPR_LEN_BYTES];
+	unsigned int offset;
+
+	if (len > sizeof(data))
+		BUG("Value export of %u bytes would overflow", len);
+
+	memset(data, 0, sizeof(data));
+	offset = netlink_export_pad(data, expr->range.low, expr);
+	netlink_export_pad(data + offset, expr->range.high, expr);
+	nft_data_memcpy(nld, data, len);
+}
+
 static void netlink_gen_prefix(const struct expr *expr,
 			       struct nft_data_linearize *nld)
 {
@@ -558,6 +592,8 @@ static void __netlink_gen_data(const struct expr *expr,
 		return netlink_gen_range(expr, data);
 	case EXPR_PREFIX:
 		return netlink_gen_prefix(expr, data);
+	case EXPR_RANGE_VALUE:
+		return netlink_gen_range_value(expr, data);
 	default:
 		BUG("invalid data expression type %s\n", expr_name(expr));
 	}
diff --git a/src/optimize.c b/src/optimize.c
index 5b7b0ab62fbc..89ba0d9dee6a 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -172,6 +172,7 @@ static bool stmt_expr_supported(const struct expr *expr)
 	case EXPR_SYMBOL:
 	case EXPR_RANGE_SYMBOL:
 	case EXPR_RANGE:
+	case EXPR_RANGE_VALUE:
 	case EXPR_PREFIX:
 	case EXPR_SET:
 	case EXPR_LIST:
@@ -667,6 +668,7 @@ static void __merge_concat(const struct optimize_ctx *ctx, uint32_t i,
 			case EXPR_PREFIX:
 			case EXPR_RANGE_SYMBOL:
 			case EXPR_RANGE:
+			case EXPR_RANGE_VALUE:
 				clone = expr_clone(stmt_a->expr->right);
 				compound_expr_add(concat, clone);
 				break;
@@ -778,6 +780,7 @@ static void build_verdict_map(struct expr *expr, struct stmt *verdict,
 	case EXPR_PREFIX:
 	case EXPR_RANGE_SYMBOL:
 	case EXPR_RANGE:
+	case EXPR_RANGE_VALUE:
 	case EXPR_VALUE:
 	case EXPR_SYMBOL:
 	case EXPR_CONCAT:
-- 
2.30.2

