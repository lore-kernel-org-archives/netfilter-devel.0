From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 03/10] datatype: seperate time parsing/printing from time_type
Date: Sun, 12 Apr 2015 13:16:11 +0100
Message-ID: <1428840978-27226-4-git-send-email-kaber@trash.net>
References: <1428840978-27226-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58909 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbbDLMQY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Apr 2015 08:16:24 -0400
In-Reply-To: <1428840978-27226-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Seperate relative time parsing and printing from the time_type to make
it usable for set and set element time related parameters.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/datatype.h |  4 ++++
 src/datatype.c     | 66 +++++++++++++++++++++++++++++++++---------------------
 2 files changed, 45 insertions(+), 25 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 3c3f42f..2a6a4fc 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -231,4 +231,8 @@ concat_subtype_lookup(uint32_t type, unsigned int n)
 	return datatype_lookup(concat_subtype_id(type, n));
 }
 
+extern void time_print(uint64_t seconds);
+extern struct error_record *time_parse(const struct location *loc,
+				       const char *c, uint64_t *res);
+
 #endif /* NFTABLES_DATATYPE_H */
diff --git a/src/datatype.c b/src/datatype.c
index 1c83715..f93337b 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -760,11 +760,9 @@ const struct datatype icmpx_code_type = {
 	.sym_tbl	= &icmpx_code_tbl,
 };
 
-static void time_type_print(const struct expr *expr)
+void time_print(uint64_t seconds)
 {
-	uint64_t days, hours, minutes, seconds;
-
-	seconds = mpz_get_uint64(expr->value);
+	uint64_t days, hours, minutes;
 
 	days = seconds / 86400;
 	seconds %= 86400;
@@ -801,8 +799,8 @@ static uint32_t str2int(char *tmp, const char *c, int k)
 	return atoi(tmp);
 }
 
-static struct error_record *time_type_parse(const struct expr *sym,
-					    struct expr **res)
+struct error_record *time_parse(const struct location *loc, const char *str,
+				uint64_t *res)
 {
 	int i, len;
 	unsigned int k = 0;
@@ -811,64 +809,82 @@ static struct error_record *time_type_parse(const struct expr *sym,
 	uint64_t d = 0, h = 0, m = 0, s = 0;
 	uint32_t mask = 0;
 
-	c = sym->identifier;
+	c = str;
 	len = strlen(c);
 	for (i = 0; i < len; i++, c++) {
 		switch (*c) {
 		case 'd':
-			if (mask & DAY) {
-				return error(&sym->location,
+			if (mask & DAY)
+				return error(loc,
 					     "Day has been specified twice");
-			}
+
 			d = str2int(tmp, c, k);
 			k = 0;
 			mask |= DAY;
 			break;
 		case 'h':
-			if (mask & HOUR) {
-				return error(&sym->location,
+			if (mask & HOUR)
+				return error(loc,
 					     "Hour has been specified twice");
-			}
+
 			h = str2int(tmp, c, k);
 			k = 0;
 			mask |= HOUR;
 			break;
 		case 'm':
-			if (mask & MIN) {
-				return error(&sym->location,
+			if (mask & MIN)
+				return error(loc,
 					     "Minute has been specified twice");
-			}
+
 			m = str2int(tmp, c, k);
 			k = 0;
 			mask |= MIN;
 			break;
 		case 's':
-			if (mask & SECS) {
-				return error(&sym->location,
+			if (mask & SECS)
+				return error(loc,
 					     "Second has been specified twice");
-			}
+
 			s = str2int(tmp, c, k);
 			k = 0;
 			mask |= SECS;
 			break;
 		default:
 			if (!isdigit(*c))
-				return error(&sym->location, "wrong format");
+				return error(loc, "wrong time format");
 
-			if (k++ >= array_size(tmp)) {
-				return error(&sym->location,
-					     "value too large");
-			}
+			if (k++ >= array_size(tmp))
+				return error(loc, "value too large");
 			break;
 		}
 	}
 
 	/* default to seconds if no unit was specified */
 	if (!mask)
-		s = atoi(sym->identifier);
+		s = atoi(str);
 	else
 		s = 24*60*60*d+60*60*h+60*m+s;
 
+	*res = s;
+	return NULL;
+}
+
+
+static void time_type_print(const struct expr *expr)
+{
+	time_print(mpz_get_uint64(expr->value));
+}
+
+static struct error_record *time_type_parse(const struct expr *sym,
+					    struct expr **res)
+{
+	struct error_record *erec;
+	uint64_t s;
+
+	erec = time_parse(&sym->location, sym->identifier, &s);
+	if (erec != NULL)
+		return erec;
+
 	if (s > UINT32_MAX)
 		return error(&sym->location, "value too large");
 
-- 
2.1.0

