From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/3] datatype: take endianess into account in symbolic_constant_print()
Date: Tue, 19 Aug 2014 00:27:30 +0100
Message-ID: <1408404451-9075-3-git-send-email-kaber@trash.net>
References: <1408404451-9075-1-git-send-email-kaber@trash.net>
Cc: alvaroneay@gmail.com, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53274 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaHRX1j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2014 19:27:39 -0400
In-Reply-To: <1408404451-9075-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

symbolic_constant_print() uses mpz_cmp_ui() to find the matching symbol.
Since GMP internally treats all values as being in host byte, this
doesn't work when the constant value is non-host byteorder, such as
the ethernet protocol type.

Export the expression's value in its original byteorder for comparison
to fix this.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/datatype.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/src/datatype.c b/src/datatype.c
index 55af227..36d5985 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -132,9 +132,15 @@ void symbolic_constant_print(const struct symbol_table *tbl,
 			     const struct expr *expr)
 {
 	const struct symbolic_constant *s;
+	uint64_t val = 0;
+
+	/* Export the data in the correct byteorder for comparison */
+	assert(expr->len / BITS_PER_BYTE <= sizeof(val));
+	mpz_export_data(&val, expr->value, expr->byteorder,
+			expr->len / BITS_PER_BYTE);
 
 	for (s = tbl->symbols; s->identifier != NULL; s++) {
-		if (!mpz_cmp_ui(expr->value, s->value))
+		if (val == s->value)
 			break;
 	}
 
-- 
1.9.3

