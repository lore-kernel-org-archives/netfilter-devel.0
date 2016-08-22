From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] ct: allow numeric conntrack labels
Date: Mon, 22 Aug 2016 12:17:26 +0200
Message-ID: <1471861047-7254-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34890 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752152AbcHVKRY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 06:17:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When dumping labels in rule list we try to print a symbolic name.
If we don't find one, we print the bit number instead.

This changes nft to also allow use of the number instead of a name
when adding ct label rules so that such dumps can also be restored
again.

This is similar to other cases, e.g. skuid root vs skuid 0 which
are both valid.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/ct.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/src/ct.c b/src/ct.c
index 3575596..018ca0b 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -13,13 +13,14 @@
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
-#include <stdint.h>
+#include <inttypes.h>
 #include <string.h>
 
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
 
+#include <errno.h>
 #include <erec.h>
 #include <expression.h>
 #include <datatype.h>
@@ -121,6 +122,7 @@ static struct error_record *ct_label_type_parse(const struct expr *sym,
 	const struct symbolic_constant *s;
 	const struct datatype *dtype;
 	uint8_t data[CT_LABEL_BIT_SIZE];
+	uint64_t bit;
 	mpz_t value;
 
 	for (s = ct_label_tbl->symbols; s->identifier != NULL; s++) {
@@ -129,16 +131,28 @@ static struct error_record *ct_label_type_parse(const struct expr *sym,
 	}
 
 	dtype = sym->dtype;
-	if (s->identifier == NULL)
-		return error(&sym->location, "%s: could not parse %s \"%s\"",
-			     CONNLABEL_CONF, dtype->desc, sym->identifier);
+	if (s->identifier == NULL) {
+		char *ptr;
+
+		errno = 0;
+		bit = strtoull(sym->identifier, &ptr, 0);
+		if (*ptr)
+			return error(&sym->location, "%s: could not parse %s \"%s\"",
+				     CONNLABEL_CONF, dtype->desc, sym->identifier);
+		if (errno)
+			return error(&sym->location, "%s: could not parse %s \"%s\": %s",
+				     CONNLABEL_CONF, dtype->desc, sym->identifier, strerror(errno));
+
+	} else {
+		bit = s->value;
+	}
 
-	if (s->value >= CT_LABEL_BIT_SIZE)
-		return error(&sym->location, "%s: out of range (%u max)",
-			     s->identifier, s->value, CT_LABEL_BIT_SIZE);
+	if (bit >= CT_LABEL_BIT_SIZE)
+		return error(&sym->location, "%s: bit %" PRIu64 " out of range (%u max)",
+			     sym->identifier, bit, CT_LABEL_BIT_SIZE);
 
 	mpz_init2(value, dtype->size);
-	mpz_setbit(value, s->value);
+	mpz_setbit(value, bit);
 	mpz_export_data(data, value, BYTEORDER_HOST_ENDIAN, sizeof(data));
 
 	*res = constant_expr_alloc(&sym->location, dtype,
-- 
2.7.3

