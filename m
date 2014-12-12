From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/6] datatype: generate name for concat types
Date: Fri, 12 Dec 2014 00:22:31 +0000
Message-ID: <1418343756-2886-2-git-send-email-kaber@trash.net>
References: <1418343756-2886-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57277 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933361AbaLLAWm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Dec 2014 19:22:42 -0500
In-Reply-To: <1418343756-2886-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The name of a concat type is the names of the individual types concatenated
using a '.'.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/datatype.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/src/datatype.c b/src/datatype.c
index 4519d87..29c967b 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -927,12 +927,16 @@ const struct datatype *concat_type_alloc(const struct expr *expr)
 	struct datatype *dtype;
 	struct expr *i;
 	char desc[256] = "concatenation of (";
+	char name[256] = "";
 	unsigned int type = 0, size = 0;
 
 	list_for_each_entry(i, &expr->expressions, list) {
-		if (size != 0)
+		if (size != 0) {
 			strncat(desc, ", ", sizeof(desc) - strlen(desc) - 1);
+			strncat(name, " . ", sizeof(name) - strlen(name) - 1);
+		}
 		strncat(desc, i->dtype->desc, sizeof(desc) - strlen(desc) - 1);
+		strncat(name, i->dtype->name, sizeof(name) - strlen(name) - 1);
 
 		type <<= 8;
 		type  |= i->dtype->type;
@@ -943,6 +947,7 @@ const struct datatype *concat_type_alloc(const struct expr *expr)
 	dtype		= dtype_alloc();
 	dtype->type	= type;
 	dtype->size	= size;
+	dtype->name	= xstrdup(name);
 	dtype->desc	= xstrdup(desc);
 	dtype->parse	= concat_type_parse;
 
@@ -952,6 +957,7 @@ const struct datatype *concat_type_alloc(const struct expr *expr)
 void concat_type_destroy(const struct datatype *dtype)
 {
 	if (dtype->flags & DTYPE_F_ALLOC) {
+		xfree(dtype->name);
 		xfree(dtype->desc);
 		xfree(dtype);
 	}
-- 
2.1.0

