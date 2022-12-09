Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 246CFC04FDE
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Dec 2022 12:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiLIMQ4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Dec 2022 07:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiLIMQv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Dec 2022 07:16:51 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 188844A07C
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Dec 2022 04:16:50 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/3,v2] netlink: unfold function to generate concatenations for keys and data
Date:   Fri,  9 Dec 2022 13:16:45 +0100
Message-Id: <20221209121645.903831-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221209121645.903831-1-pablo@netfilter.org>
References: <20221209121645.903831-1-pablo@netfilter.org>
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
v2: Rebased on top on current series, split functions for the non-expand
    case for set element data bytecode generation.

 src/netlink.c | 63 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 53 insertions(+), 10 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 15eb890e422a..efbc65650c4b 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -254,8 +254,8 @@ static int netlink_export_pad(unsigned char *data, const mpz_t v,
 	return netlink_padded_len(i->len) / BITS_PER_BYTE;
 }
 
-static int netlink_gen_concat_data_expr(uint32_t flags, const struct expr *i,
-					unsigned char *data)
+static int __netlink_gen_concat_key(uint32_t flags, const struct expr *i,
+				    unsigned char *data)
 {
 	struct expr *expr;
 
@@ -307,8 +307,8 @@ static int netlink_gen_concat_data_expr(uint32_t flags, const struct expr *i,
 	return netlink_export_pad(data, i->value, i);
 }
 
-static void __netlink_gen_concat(const struct expr *expr,
-				 struct nft_data_linearize *nld)
+static void netlink_gen_concat_key(const struct expr *expr,
+				    struct nft_data_linearize *nld)
 {
 	unsigned int len = expr->len / BITS_PER_BYTE, offset = 0;
 	unsigned char data[len];
@@ -317,12 +317,40 @@ static void __netlink_gen_concat(const struct expr *expr,
 	memset(data, 0, len);
 
 	list_for_each_entry(i, &expr->expressions, list)
-		offset += netlink_gen_concat_data_expr(expr->flags, i, data + offset);
+		offset += __netlink_gen_concat_key(expr->flags, i, data + offset);
 
 	memcpy(nld->value, data, len);
 	nld->len = len;
 }
 
+static int __netlink_gen_concat_data(int end, const struct expr *i,
+				     unsigned char *data)
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
@@ -333,18 +361,33 @@ static void __netlink_gen_concat_expand(const struct expr *expr,
 	memset(data, 0, len);
 
 	list_for_each_entry(i, &expr->expressions, list)
-		offset += netlink_gen_concat_data_expr(0, i, data + offset);
+		offset += __netlink_gen_concat_data(false, i, data + offset);
+
+	list_for_each_entry(i, &expr->expressions, list)
+		offset += __netlink_gen_concat_data(true, i, data + offset);
+
+	memcpy(nld->value, data, len);
+	nld->len = len;
+}
+
+static void __netlink_gen_concat(const struct expr *expr,
+				 struct nft_data_linearize *nld)
+{
+	unsigned int len = expr->len / BITS_PER_BYTE, offset = 0;
+	unsigned char data[len];
+	const struct expr *i;
+
+	memset(data, 0, len);
 
 	list_for_each_entry(i, &expr->expressions, list)
-		offset += netlink_gen_concat_data_expr(EXPR_F_INTERVAL_END, i, data + offset);
+		offset += __netlink_gen_concat_data(expr->flags, i, data + offset);
 
 	memcpy(nld->value, data, len);
 	nld->len = len;
 }
 
 static void netlink_gen_concat_data(const struct expr *expr,
-				    struct nft_data_linearize *nld,
-				    bool expand)
+				    struct nft_data_linearize *nld, bool expand)
 {
 	if (expand)
 		__netlink_gen_concat_expand(expr, nld);
@@ -438,7 +481,7 @@ static void netlink_gen_key(const struct expr *expr,
 	case EXPR_VALUE:
 		return netlink_gen_constant_data(expr, data);
 	case EXPR_CONCAT:
-		return netlink_gen_concat_data(expr, data, false);
+		return netlink_gen_concat_key(expr, data);
 	case EXPR_RANGE:
 		return netlink_gen_range(expr, data);
 	case EXPR_PREFIX:
-- 
2.30.2

