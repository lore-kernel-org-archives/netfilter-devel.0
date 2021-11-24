Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00997C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242507AbhKXR2S (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240975AbhKXR2R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:28:17 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E22C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:25:08 -0800 (PST)
Received: from localhost ([::1]:44954 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpw14-0001Di-8u; Wed, 24 Nov 2021 18:25:06 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 09/15] netlink_delinearize: Fix for escaped asterisk strings on Big Endian
Date:   Wed, 24 Nov 2021 18:22:45 +0100
Message-Id: <20211124172251.11539-10-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124172251.11539-1-phil@nwl.cc>
References: <20211124172251.11539-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The original nul-char detection was not functional on Big Endian.
Instead, go a simpler route by exporting the string and working on the
exported data to check for a nul-char and escape a trailing asterisk if
present. With the data export already happening in the caller, fold
escaped_string_wildcard_expr_alloc() into it as well.

Fixes: b851ba4731d9f ("src: add interface wildcard matching")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink_delinearize.c | 57 ++++++++++++---------------------------
 1 file changed, 17 insertions(+), 40 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 0c2b439eac6fb..db58e8c386c00 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2422,56 +2422,33 @@ static struct expr *string_wildcard_expr_alloc(struct location *loc,
 				   expr->len + BITS_PER_BYTE, data);
 }
 
-static void escaped_string_wildcard_expr_alloc(struct expr **exprp,
-					       unsigned int len)
-{
-	struct expr *expr = *exprp, *tmp;
-	char data[len + 3];
-	int pos;
-
-	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
-	pos = div_round_up(len, BITS_PER_BYTE);
-	data[pos - 1] = '\\';
-	data[pos] = '*';
-
-	tmp = constant_expr_alloc(&expr->location, expr->dtype,
-				  BYTEORDER_HOST_ENDIAN,
-				  expr->len + BITS_PER_BYTE, data);
-	expr_free(expr);
-	*exprp = tmp;
-}
-
 /* This calculates the string length and checks if it is nul-terminated, this
  * function is quite a hack :)
  */
 static bool __expr_postprocess_string(struct expr **exprp)
 {
 	struct expr *expr = *exprp;
-	unsigned int len = expr->len;
-	bool nulterminated = false;
-	mpz_t tmp;
-
-	mpz_init(tmp);
-	while (len >= BITS_PER_BYTE) {
-		mpz_bitmask(tmp, BITS_PER_BYTE);
-		mpz_lshift_ui(tmp, len - BITS_PER_BYTE);
-		mpz_and(tmp, tmp, expr->value);
-		if (mpz_cmp_ui(tmp, 0))
-			break;
-		else
-			nulterminated = true;
-		len -= BITS_PER_BYTE;
-	}
+	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
+	char data[len + 1];
 
-	mpz_rshift_ui(tmp, len - BITS_PER_BYTE);
+	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
 
-	if (nulterminated &&
-	    mpz_cmp_ui(tmp, '*') == 0)
-		escaped_string_wildcard_expr_alloc(exprp, len);
+	if (data[len - 1] != '\0')
+		return false;
 
-	mpz_clear(tmp);
+	len = strlen(data);
+	if (len && data[len - 1] == '*') {
+		data[len - 1]	= '\\';
+		data[len]	= '*';
+		data[len + 1]	= '\0';
+		expr = constant_expr_alloc(&expr->location, expr->dtype,
+					   BYTEORDER_HOST_ENDIAN,
+					   (len + 2) * BITS_PER_BYTE, data);
+		expr_free(*exprp);
+		*exprp = expr;
+	}
 
-	return nulterminated;
+	return true;
 }
 
 static struct expr *expr_postprocess_string(struct expr *expr)
-- 
2.33.0

