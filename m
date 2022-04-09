Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB4D4C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 13:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242288AbiDIOBM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 10:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236016AbiDIOBM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 10:01:12 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335C0DF2B
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 06:59:05 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ndBcF-0008Ln-Kh; Sat, 09 Apr 2022 15:59:03 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 6/9] segtree: add string "range" reversal support
Date:   Sat,  9 Apr 2022 15:58:29 +0200
Message-Id: <20220409135832.17401-7-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220409135832.17401-1-fw@strlen.de>
References: <20220409135832.17401-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Previous commits allows to use set key as a range, i.e.

	key ifname
	flags interval
	elements = { eth* }

and then have it match on any interface starting with 'eth'.

Listing is broken however, we need to reverse-translate the (128bit)
number back to a string.

'eth*' is stored as interval
00687465 0000000 ..  00697465 0000000, i.e. "eth-eti",
this adds the needed endianess fixups.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/segtree.c | 47 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 6 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index b4e76bf530d6..bed8bbcf0c8e 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -1032,6 +1032,33 @@ static struct expr *interval_to_prefix(struct expr *low, struct expr *i, const m
 	return __expr_to_set_elem(low, prefix);
 }
 
+static struct expr *interval_to_string(struct expr *low, struct expr *i, const mpz_t range)
+{
+	unsigned int len = div_round_up(i->len, BITS_PER_BYTE);
+	unsigned int prefix_len, str_len;
+	char data[len + 2];
+	struct expr *expr;
+
+	prefix_len = expr_value(i)->len - mpz_scan0(range, 0);
+
+	if (prefix_len > i->len || prefix_len % BITS_PER_BYTE)
+		return interval_to_prefix(low, i, range);
+
+	mpz_export_data(data, expr_value(low)->value, BYTEORDER_BIG_ENDIAN, len);
+
+	str_len = strnlen(data, len);
+	if (str_len >= len || str_len == 0)
+		return interval_to_prefix(low, i, range);
+
+	data[str_len] = '*';
+
+	expr = constant_expr_alloc(&low->location, low->dtype,
+				   BYTEORDER_HOST_ENDIAN,
+				   (str_len + 1) * BITS_PER_BYTE, data);
+
+	return __expr_to_set_elem(low, expr);
+}
+
 static struct expr *interval_to_range(struct expr *low, struct expr *i, mpz_t range)
 {
 	struct expr *tmp;
@@ -1130,16 +1157,24 @@ void interval_map_decompose(struct expr *set)
 
 		mpz_and(p, expr_value(low)->value, range);
 
-		if (!mpz_cmp_ui(range, 0))
+		if (!mpz_cmp_ui(range, 0)) {
+			if (expr_basetype(low)->type == TYPE_STRING)
+				mpz_switch_byteorder(expr_value(low)->value, low->len / BITS_PER_BYTE);
+
 			compound_expr_add(set, expr_get(low));
-		else if ((!range_is_prefix(range) ||
-			  !(i->dtype->flags & DTYPE_F_PREFIX)) ||
-			 mpz_cmp_ui(p, 0)) {
-			struct expr *expr = interval_to_range(low, i, range);
+		} else if (range_is_prefix(range) && !mpz_cmp_ui(p, 0)) {
+			struct expr *expr;
+
+			if (i->dtype->flags & DTYPE_F_PREFIX)
+				expr = interval_to_prefix(low, i, range);
+			else if (expr_basetype(i)->type == TYPE_STRING)
+				expr = interval_to_string(low, i, range);
+			else
+				expr = interval_to_range(low, i, range);
 
 			compound_expr_add(set, expr);
 		} else {
-			struct expr *expr = interval_to_prefix(low, i, range);
+			struct expr *expr = interval_to_range(low, i, range);
 
 			compound_expr_add(set, expr);
 		}
-- 
2.35.1

