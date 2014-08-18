From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] verdict type: handle verdict flags and encoded additional information
Date: Tue, 19 Aug 2014 00:37:20 +0100
Message-ID: <1408405040-9505-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53330 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaHRXhY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2014 19:37:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The kernel can handle this, nftables should also.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/datatype.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 36d5985..fdfee54 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -176,15 +176,6 @@ const struct datatype invalid_type = {
 static void verdict_type_print(const struct expr *expr)
 {
 	switch (expr->verdict) {
-	case NF_ACCEPT:
-		printf("accept");
-		break;
-	case NF_DROP:
-		printf("drop");
-		break;
-	case NF_QUEUE:
-		printf("queue");
-		break;
 	case NFT_CONTINUE:
 		printf("continue");
 		break;
@@ -201,7 +192,19 @@ static void verdict_type_print(const struct expr *expr)
 		printf("return");
 		break;
 	default:
-		BUG("invalid verdict value %u\n", expr->verdict);
+		switch (expr->verdict & NF_VERDICT_MASK) {
+		case NF_ACCEPT:
+			printf("accept");
+			break;
+		case NF_DROP:
+			printf("drop");
+			break;
+		case NF_QUEUE:
+			printf("queue");
+			break;
+		default:
+			BUG("invalid verdict value %u\n", expr->verdict);
+		}
 	}
 }
 
-- 
1.9.3

