From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] datatype: default to display bitmask in hexadecimal
Date: Fri,  5 Jun 2015 17:31:56 +0200
Message-ID: <1433518317-9901-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58201 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628AbbFEP1G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 11:27:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of a plain integer.

This updates integer_type_print() to look up some basefmt in the change of
datatype, the first we find will be used to format the output.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/datatype.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index f93337b..82a7753 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -260,15 +260,22 @@ const struct datatype bitmask_type = {
 	.type		= TYPE_BITMASK,
 	.name		= "bitmask",
 	.desc		= "bitmask",
+	.basefmt	= "0x%Zx",
 	.basetype	= &integer_type,
 };
 
 static void integer_type_print(const struct expr *expr)
 {
+	const struct datatype *dtype = expr->dtype;
 	const char *fmt = "%Zu";
 
-	if (expr->dtype->basefmt != NULL)
-		fmt = expr->dtype->basefmt;
+	do {
+		if (dtype->basefmt != NULL) {
+			fmt = dtype->basefmt;
+			break;
+		}
+	} while ((dtype = dtype->basetype));
+
 	gmp_printf(fmt, expr->value);
 }
 
-- 
1.7.10.4

