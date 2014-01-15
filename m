From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2 nft RFC] expression: default to print binary operations using nominal representation
Date: Wed, 15 Jan 2014 12:09:26 +0100
Message-ID: <1389784167-10198-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40593 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbaAOLKE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:10:04 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since b59e65c ("scanner: add aliases to symbols for easier
interaction with most shells") we have nominal aliases, default to
these for the output representation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expression.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index 71154cc..6da5c10 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -351,17 +351,17 @@ const char *expr_op_symbols[] = {
 	[OP_INVALID]	= "invalid",
 	[OP_HTON]	= "hton",
 	[OP_NTOH]	= "ntoh",
-	[OP_AND]	= "&",
-	[OP_OR]		= "|",
-	[OP_XOR]	= "^",
-	[OP_LSHIFT]	= "<<",
-	[OP_RSHIFT]	= ">>",
+	[OP_AND]	= "and",
+	[OP_OR]		= "or",
+	[OP_XOR]	= "xor",
+	[OP_LSHIFT]	= "lshift",
+	[OP_RSHIFT]	= "rshift",
 	[OP_EQ]		= NULL,
-	[OP_NEQ]	= "!=",
-	[OP_LT]		= "<",
-	[OP_GT]		= ">",
-	[OP_LTE]	= "<=",
-	[OP_GTE]	= ">=",
+	[OP_NEQ]	= "ne",
+	[OP_LT]		= "lt",
+	[OP_GT]		= "gt",
+	[OP_LTE]	= "le",
+	[OP_GTE]	= "ge",
 	[OP_RANGE]	= "within range",
 	[OP_LOOKUP]	= NULL,
 };
-- 
1.7.10.4

