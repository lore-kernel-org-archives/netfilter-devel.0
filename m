From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft v2 2/2] datatype: Implement binary search in
 symbolic_constant_print()
Date: Sun, 27 Nov 2016 23:28:14 -0200
Message-ID: <20161128012814.GA22480@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:33103 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753405AbcK1B2V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Nov 2016 20:28:21 -0500
Received: by mail-ua0-f196.google.com with SMTP id 20so8643503uak.0
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Nov 2016 17:28:20 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Because a linear search is used, which is slower.

This approach demands that the symbol_table have a variable with its
size, also, it must be sorted by value.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---

 v2: This patch has no v1.

 include/datatype.h |  2 ++
 src/datatype.c     | 37 +++++++++++++++++++++++++++++--------
 src/proto.c        |  3 ++-
 src/services.c     |  3 ++-
 4 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index e53797d..0e7db40 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -178,10 +178,12 @@ struct symbolic_constant {
 /**
  * struct symbol_table - type construction from symbolic values
  *
+ * @size: 	number of symbols, without SYMBOL_LIST_END
  * @symbols:	the symbols
  */
 struct symbol_table {
 	int				gcc_workaround;
+	unsigned int 			size;
 	struct symbolic_constant	symbols[];
 };
 
diff --git a/src/datatype.c b/src/datatype.c
index 1ae7db4..25d9000 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -116,6 +116,18 @@ struct error_record *symbol_parse(const struct expr *sym,
 		     sym->dtype->desc);
 }
 
+static int symbolic_constant_cmp(const void *p1, const void *p2)
+{
+        const struct symbolic_constant f = *(struct symbolic_constant *)p1;
+        const struct symbolic_constant s = *(struct symbolic_constant *)p2;
+
+        if (f.value > s.value)
+                return  1;
+        if (f.value < s.value)
+                return -1;
+        return 0;
+}
+
 struct error_record *symbolic_constant_parse(const struct expr *sym,
 					     const struct symbol_table *tbl,
 					     struct expr **res)
@@ -157,8 +169,10 @@ out:
 void symbolic_constant_print(const struct symbol_table *tbl,
 			     const struct expr *expr, bool quotes)
 {
+        unsigned int l = 0;
+        unsigned int m;
+        unsigned int r = tbl->size - 1;
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
-	const struct symbolic_constant *s;
 	uint64_t val = 0;
 
 	/* Export the data in the correct byteorder for comparison */
@@ -166,18 +180,22 @@ void symbolic_constant_print(const struct symbol_table *tbl,
 	mpz_export_data(constant_data_ptr(val, expr->len), expr->value,
 			expr->byteorder, len);
 
-	for (s = tbl->symbols; s->identifier != NULL; s++) {
-		if (val == s->value)
-			break;
-	}
+        while (l < r) {
+                m = l + (r - l)/2;
+
+                if (tbl->symbols[m].value < val)
+                        l = m + 1;
+                else
+                        r = m;
+        }
 
-	if (s->identifier == NULL)
+	if (tbl->symbols[l].value != val)
 		return expr_basetype(expr)->print(expr);
 
 	if (quotes)
-		printf("\"%s\"", s->identifier);
+		printf("\"%s\"", tbl->symbols[l].identifier);
 	else
-		printf("%s", s->identifier);
+		printf("%s", tbl->symbols[l].identifier);
 }
 
 void symbol_table_print(const struct symbol_table *tbl,
@@ -652,6 +670,9 @@ struct symbol_table *rt_symbol_table_init(const char *filename)
 
 	fclose(f);
 out:
+        tbl->size = nelems;
+        qsort(tbl->symbols, nelems, sizeof(tbl->symbols[0]),
+              symbolic_constant_cmp);
 	tbl->symbols[nelems] = SYMBOL_LIST_END;
 	return tbl;
 }
diff --git a/src/proto.c b/src/proto.c
index df5439c..27f9f8a 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -860,11 +860,12 @@ const struct datatype etheraddr_type = {
 };
 
 static const struct symbol_table ethertype_tbl = {
+        .size 		= 4,
 	.symbols	= {
 		SYMBOL("ip",		__constant_htons(ETH_P_IP)),
+                SYMBOL("vlan",		__constant_htons(ETH_P_8021Q)),
 		SYMBOL("arp",		__constant_htons(ETH_P_ARP)),
 		SYMBOL("ip6",		__constant_htons(ETH_P_IPV6)),
-		SYMBOL("vlan",		__constant_htons(ETH_P_8021Q)),
 		SYMBOL_LIST_END
 	},
 };
diff --git a/src/services.c b/src/services.c
index 8cb1cdf..6c964ba 100644
--- a/src/services.c
+++ b/src/services.c
@@ -2,7 +2,8 @@
 #include <datatype.h>
 
 const struct symbol_table serv_tbl = {
-	.symbols =	{
+        .size 		= 335,
+        .symbols 	= {
 		SYMBOL("exec",	2),
 		SYMBOL("tcpmux",	256),
 		SYMBOL("login",	258),
-- 
2.7.4

