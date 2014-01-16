From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] datatype: fix output of time type
Date: Thu, 16 Jan 2014 22:14:47 +0100
Message-ID: <1389906887-27919-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58189 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaAPVPA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 16:15:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Display output in seconds, which is what we get as input.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/datatype.c |   31 +------------------------------
 1 file changed, 1 insertion(+), 30 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 4594490..b8f6ca9 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -669,36 +669,7 @@ const struct datatype mark_type = {
 
 static void time_type_print(const struct expr *expr)
 {
-	uint64_t days, hours, minutes, seconds;
-	const char *delim = "";
-
-	seconds = mpz_get_uint64(expr->value);
-
-	days = seconds / 86400;
-	seconds %= 86400;
-
-	hours = seconds / 3600;
-	seconds %= 3600;
-
-	minutes = seconds / 60;
-	seconds %= 60;
-
-	if (days > 0) {
-		printf("%s%" PRIu64 " d", delim, days);
-		delim = " ";
-	}
-	if (hours > 0) {
-		printf("%s%" PRIu64 " h", delim, hours);
-		delim = " ";
-	}
-	if (minutes > 0) {
-		printf("%s%" PRIu64 " min", delim, minutes);
-		delim = " ";
-	}
-	if (seconds > 0) {
-		printf("%s%" PRIu64 " s", delim, seconds);
-		delim = " ";
-	}
+	printf("%"PRIu64"", mpz_get_uint64(expr->value));
 }
 
 const struct datatype time_type = {
-- 
1.7.10.4

