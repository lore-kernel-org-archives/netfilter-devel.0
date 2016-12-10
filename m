From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft] datatype: Display pre-defined inet_service values in
 decimal base
Date: Sat, 10 Dec 2016 21:59:36 -0200
Message-ID: <20161210235936.GA4967@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:33238 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752184AbcLJX7o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 10 Dec 2016 18:59:44 -0500
Received: by mail-vk0-f67.google.com with SMTP id l126so2663702vkh.0
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Dec 2016 15:59:43 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

because the convention is to represent ports in base 10.

gcc-workaround is no longer needed and was removed.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 include/datatype.h | 18 +++++++++++++++++-
 src/datatype.c     |  7 +++++--
 src/services.c     |  3 ++-
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index a7db1df..cf76fcf 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -176,12 +176,28 @@ struct symbolic_constant {
 #define SYMBOL_LIST_END	(struct symbolic_constant) { }
 
 /**
+ * enum base
+ *
+ * @BASE_HEXADECIMAL:	hexadecimal
+ * @BASE_DECIMAL:	decimal
+ * @BASE_OCTAL:		octal
+ * @BASE_BINARY:	binary
+ */
+enum base {
+	BASE_HEXADECIMAL,
+	BASE_DECIMAL,
+	BASE_OCTAL,
+	BASE_BINARY,
+};
+
+/**
  * struct symbol_table - type construction from symbolic values
  *
+ * @base:	base of symbols representation
  * @symbols:	the symbols
  */
 struct symbol_table {
-	int				gcc_workaround;
+	enum base 			base;
 	struct symbolic_constant	symbols[];
 };
 
diff --git a/src/datatype.c b/src/datatype.c
index 5600efc..ec0b120 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -204,8 +204,11 @@ void symbol_table_print(const struct symbol_table *tbl,
 		if (byteorder == BYTEORDER_BIG_ENDIAN)
 			switch_byteorder(&value, len);
 
-		printf("\t%-30s\t0x%.*" PRIx64 "\n",
-		       s->identifier, 2 * len, value);
+		if (tbl->base == BASE_DECIMAL)
+			printf("\t%-30s\t%20lu\n", s->identifier, value);
+		else
+			printf("\t%-30s\t0x%.*" PRIx64 "\n",
+			       s->identifier, 2 * len, value);
 	}
 }
 
diff --git a/src/services.c b/src/services.c
index 0ba195e..83c2672 100644
--- a/src/services.c
+++ b/src/services.c
@@ -2,7 +2,8 @@
 #include <datatype.h>
 
 const struct symbol_table inet_service_tbl = {
-	.symbols =	{
+	.base		= BASE_DECIMAL,
+	.symbols	= {
 		SYMBOL("tcpmux",		__constant_htons(1)),
 		SYMBOL("echo",			__constant_htons(7)),
 		SYMBOL("discard",		__constant_htons(9)),
-- 
2.7.4

