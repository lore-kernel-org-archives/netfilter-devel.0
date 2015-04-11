From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/2] datatype: fix parsing of time type
Date: Sat, 11 Apr 2015 15:00:29 +0100
Message-ID: <1428760830-6135-2-git-send-email-kaber@trash.net>
References: <1428760830-6135-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50805 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbbDKOAf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Apr 2015 10:00:35 -0400
In-Reply-To: <1428760830-6135-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Properly detect time strings in the lexer without quotation marks.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/datatype.c | 4 ----
 src/scanner.l  | 7 +++++++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index c93f76a..0772b50 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -775,8 +775,6 @@ static void time_type_print(const struct expr *expr)
 	minutes = seconds / 60;
 	seconds %= 60;
 
-	printf("\"");
-
 	if (days > 0)
 		printf("%"PRIu64"d", days);
 	if (hours > 0)
@@ -785,8 +783,6 @@ static void time_type_print(const struct expr *expr)
 		printf("%"PRIu64"m", minutes);
 	if (seconds > 0)
 		printf("%"PRIu64"s", seconds);
-
-	printf("\"");
 }
 
 enum {
diff --git a/src/scanner.l b/src/scanner.l
index 73c4f8b..27d95bf 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -117,6 +117,8 @@ quotedstring	\"[^"]*\"
 comment		#.*$
 slash		\/
 
+timestring	([0-9]+d)?([0-9]+h)?([0-9]+m)?([0-9]+s)?
+
 hex4		([[:xdigit:]]{1,4})
 v680		(({hex4}:){7}{hex4})
 v670		((:)((:{hex4}){7}))
@@ -457,6 +459,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return STRING;
 			}
 
+{timestring}		{
+				yylval->string = xstrdup(yytext);
+				return STRING;
+			}
+
 {decstring}		{
 				errno = 0;
 				yylval->val = strtoull(yytext, NULL, 0);
-- 
2.1.0

