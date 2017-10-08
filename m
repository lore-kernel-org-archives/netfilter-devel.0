From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] datatype: Change "%Zx" to "%zx" and "%Zu" to "%zu"
Date: Mon,  9 Oct 2017 02:00:36 +0530
Message-ID: <20171008203036.24619-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34308 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbdJHUc4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Oct 2017 16:32:56 -0400
Received: by mail-pf0-f194.google.com with SMTP id b85so2532377pfj.1
        for <netfilter-devel@vger.kernel.org>; Sun, 08 Oct 2017 13:32:56 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use "%zx" and "%zu" over "%Zx" and "%Zu" respectively as "%Zx" and "%Zu"
is non-standard C.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 src/datatype.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 94b1224..34dda84 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -239,7 +239,7 @@ void symbol_table_print(const struct symbol_table *tbl,
 
 static void invalid_type_print(const struct expr *expr, struct output_ctx *octx)
 {
-	nft_gmp_print(octx, "0x%Zx [invalid type]", expr->value);
+	nft_gmp_print(octx, "0x%zx [invalid type]", expr->value);
 }
 
 const struct datatype invalid_type = {
@@ -313,14 +313,14 @@ const struct datatype bitmask_type = {
 	.type		= TYPE_BITMASK,
 	.name		= "bitmask",
 	.desc		= "bitmask",
-	.basefmt	= "0x%Zx",
+	.basefmt	= "0x%zx",
 	.basetype	= &integer_type,
 };
 
 static void integer_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	const struct datatype *dtype = expr->dtype;
-	const char *fmt = "%Zu";
+	const char *fmt = "%zu";
 
 	do {
 		if (dtype->basefmt != NULL) {
@@ -749,7 +749,7 @@ const struct datatype mark_type = {
 	.size		= 4 * BITS_PER_BYTE,
 	.byteorder	= BYTEORDER_HOST_ENDIAN,
 	.basetype	= &integer_type,
-	.basefmt	= "0x%.8Zx",
+	.basefmt	= "0x%.8zx",
 	.print		= mark_type_print,
 	.parse		= mark_type_parse,
 	.flags		= DTYPE_F_PREFIX,
-- 
2.11.0

