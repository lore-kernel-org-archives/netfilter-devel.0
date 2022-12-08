Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C64C4708D
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 01:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiLHBcW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 20:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiLHBcW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 20:32:22 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F57A8DFF6
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 17:32:21 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] netlink: unfold function to generate concatenations for keys and data
Date:   Thu,  8 Dec 2022 02:32:17 +0100
Message-Id: <20221208013217.483019-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221208013217.483019-1-pablo@netfilter.org>
References: <20221208013217.483019-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a specific function to generate concatenation with and without
intervals in maps. This restores the original function added by
8ac2f3b2fca3 ("src: Add support for concatenated set ranges") which is
used by 66746e7dedeb ("src: support for nat with interval
concatenation") to generate the data concatenations in maps.

Only the set element key requires the byteswap introduced by 1017d323cafa
("src: support for selectors with different byteorder with interval
concatenations"). Therefore, better not to reuse the same function for
key and data as the future might bring support for more kind of
concatenations in data maps.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c | 45 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 9 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 2ede25b9ce9d..026b599826ce 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -253,8 +253,8 @@ static int netlink_export_pad(unsigned char *data, const mpz_t v,
 	return netlink_padded_len(i->len) / BITS_PER_BYTE;
 }
 
-static int netlink_gen_concat_data_expr(uint32_t flags, const struct expr *i,
-					unsigned char *data)
+static int netlink_gen_concat_key(uint32_t flags, const struct expr *i,
+				  unsigned char *data)
 {
 	struct expr *expr;
 
@@ -316,12 +316,40 @@ static void __netlink_gen_concat(const struct expr *expr,
 	memset(data, 0, len);
 
 	list_for_each_entry(i, &expr->expressions, list)
-		offset += netlink_gen_concat_data_expr(expr->flags, i, data + offset);
+		offset += netlink_gen_concat_key(expr->flags, i, data + offset);
 
 	memcpy(nld->value, data, len);
 	nld->len = len;
 }
 
+static int netlink_gen_concat_data(int end, const struct expr *i,
+				   unsigned char *data)
+{
+	switch (i->etype) {
+	case EXPR_RANGE:
+		i = end ? i->right : i->left;
+		break;
+	case EXPR_PREFIX:
+		if (end) {
+			int count;
+			mpz_t v;
+
+			mpz_init_bitmask(v, i->len - i->prefix_len);
+			mpz_add(v, i->prefix->value, v);
+			count = netlink_export_pad(data, v, i);
+			mpz_clear(v);
+			return count;
+		}
+		return netlink_export_pad(data, i->prefix->value, i);
+	case EXPR_VALUE:
+		break;
+	default:
+		BUG("invalid expression type '%s' in set", expr_ops(i)->name);
+	}
+
+	return netlink_export_pad(data, i->value, i);
+}
+
 static void __netlink_gen_concat_expand(const struct expr *expr,
 				        struct nft_data_linearize *nld)
 {
@@ -332,18 +360,17 @@ static void __netlink_gen_concat_expand(const struct expr *expr,
 	memset(data, 0, len);
 
 	list_for_each_entry(i, &expr->expressions, list)
-		offset += netlink_gen_concat_data_expr(0, i, data + offset);
+		offset += netlink_gen_concat_data(false, i, data + offset);
 
 	list_for_each_entry(i, &expr->expressions, list)
-		offset += netlink_gen_concat_data_expr(EXPR_F_INTERVAL_END, i, data + offset);
+		offset += netlink_gen_concat_data(true, i, data + offset);
 
 	memcpy(nld->value, data, len);
 	nld->len = len;
 }
 
-static void netlink_gen_concat_data(const struct expr *expr,
-				    struct nft_data_linearize *nld,
-				    bool expand)
+static void netlink_gen_concat(const struct expr *expr,
+			       struct nft_data_linearize *nld, bool expand)
 {
 	if (expand)
 		__netlink_gen_concat_expand(expr, nld);
@@ -437,7 +464,7 @@ void __netlink_gen_data(const struct expr *expr,
 	case EXPR_VALUE:
 		return netlink_gen_constant_data(expr, data);
 	case EXPR_CONCAT:
-		return netlink_gen_concat_data(expr, data, expand);
+		return netlink_gen_concat(expr, data, expand);
 	case EXPR_VERDICT:
 		return netlink_gen_verdict(expr, data);
 	case EXPR_RANGE:
-- 
2.30.2

