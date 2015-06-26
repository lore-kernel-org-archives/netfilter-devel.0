From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] datatype: avoid crash in debug mode when printing integers
Date: Fri, 26 Jun 2015 10:50:44 +0200
Message-ID: <1435308644-15892-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43374 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585AbbFZInw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2015 04:43:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft -i --debug=all
nft> add rule ip filter foo mark 42

dies with sigfpe; seems mpz doesn't like len 0:
#1  0x0805f2ee in mpz_export_data (data=0xbfeda588, op=0x9d9fb08, byteorder=BYTEORDER_HOST_ENDIAN, len=0) at gmputil.c:115

After patch this prints 0x0000002a.
---
 src/datatype.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/datatype.c b/src/datatype.c
index f42e3df..f79f5d2 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -156,13 +156,14 @@ out:
 void symbolic_constant_print(const struct symbol_table *tbl,
 			     const struct expr *expr)
 {
+	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
 	const struct symbolic_constant *s;
 	uint64_t val = 0;
 
 	/* Export the data in the correct byteorder for comparison */
 	assert(expr->len / BITS_PER_BYTE <= sizeof(val));
 	mpz_export_data(constant_data_ptr(val, expr->len), expr->value,
-			expr->byteorder, expr->len / BITS_PER_BYTE);
+			expr->byteorder, len);
 
 	for (s = tbl->symbols; s->identifier != NULL; s++) {
 		if (val == s->value)
-- 
2.1.0

