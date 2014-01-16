From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft RFC] datatype: add time type parser and adapt output
Date: Thu, 16 Jan 2014 22:01:02 +0100
Message-ID: <1389906062-27409-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57052 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaAPVBS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 16:01:18 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows to specify a string to indicate the time, eg.

nft add rule filter output ct expiration \"1d2h3m4s\" counter

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
An alternative to this patch is to use seconds as input/output, that only
needs a smaller patch to fix time_type_print().

 include/utils.h |    4 ++
 src/datatype.c  |  133 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 121 insertions(+), 16 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 854986f..f23f8e6 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -62,6 +62,10 @@
 	(void) (&_max1 == &_max2);		\
 	_max1 > _max2 ? _max1 : _max2; })
 
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(a) (int)(sizeof(a)/sizeof((a)[0]))
+#endif
+
 extern void memory_allocation_error(void) __noreturn;
 
 extern void xfree(const void *ptr);
diff --git a/src/datatype.c b/src/datatype.c
index 4594490..0541fc0 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -11,6 +11,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <inttypes.h>
+#include <ctype.h> /* isdigit */
 #include <errno.h>
 #include <netdb.h>
 #include <arpa/inet.h>
@@ -670,7 +671,6 @@ const struct datatype mark_type = {
 static void time_type_print(const struct expr *expr)
 {
 	uint64_t days, hours, minutes, seconds;
-	const char *delim = "";
 
 	seconds = mpz_get_uint64(expr->value);
 
@@ -683,22 +683,122 @@ static void time_type_print(const struct expr *expr)
 	minutes = seconds / 60;
 	seconds %= 60;
 
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
+	printf("\"");
+
+	if (days > 0)
+		printf("%"PRIu64"d", days);
+	if (hours > 0)
+		printf("%"PRIu64"h", hours);
+	if (minutes > 0)
+		printf("%"PRIu64"m", minutes);
+	if (seconds > 0)
+		printf("%"PRIu64"s", seconds);
+
+	printf("\"");
+}
+
+enum {
+	DAY	= (1 << 0),
+	HOUR	= (1 << 1),
+	MIN 	= (1 << 2),
+	SECS	= (1 << 3),
+};
+
+static uint32_t str2int(char *tmp, const char *c, int k)
+{
+	if (k == 0)
+		return 0;
+
+	strncpy(tmp, c-k, k+1);
+	return atoi(tmp);
+}
+
+static struct error_record *time_type_parse(const struct expr *sym,
+					    struct expr **res)
+{
+	int i, k = 0, len;
+	char tmp[8];
+	const char *c;
+	uint64_t d = 0, h = 0, m = 0, s = 0;
+	uint32_t mask = 0;
+
+	c = sym->identifier;
+	len = strlen(c);
+	for (i = 0; i < len; i++, c++) {
+		switch (*c) {
+		case 'd':
+			if (mask & DAY) {
+				return error(&sym->location,
+					     "Day has been specified twice");
+			}
+			d = str2int(tmp, c, k);
+			k = 0;
+			mask |= DAY;
+			break;
+		case 'h':
+			if (mask & HOUR) {
+				return error(&sym->location,
+					     "Hour has been specified twice");
+			}
+			h = str2int(tmp, c, k);
+			k = 0;
+			if (h > 23) {
+				return error(&sym->location,
+					     "Hour needs to be 0-23");
+			}
+			mask |= HOUR;
+			break;
+		case 'm':
+			if (mask & MIN) {
+				return error(&sym->location,
+					     "Minute has been specified twice");
+			}
+			m = str2int(tmp, c, k);
+			k = 0;
+			if (m > 59) {
+				return error(&sym->location,
+					     "Minute needs to be 0-59");
+			}
+			mask |= MIN;
+			break;
+		case 's':
+			if (mask & SECS) {
+				return error(&sym->location,
+					     "Second has been specified twice");
+			}
+			s = str2int(tmp, c, k);
+			k = 0;
+			if (s > 59) {
+				return error(&sym->location,
+					     "second needs to be 0-59");
+			}
+			mask |= SECS;
+			break;
+		default:
+			if (!isdigit(*c))
+				return error(&sym->location, "wrong format");
+
+			if (k++ >= ARRAY_SIZE(tmp)) {
+				return error(&sym->location,
+					     "value too large");
+			}
+			break;
+		}
 	}
+
+	/* default to seconds if no unit was specified */
+	if (!mask)
+		s = atoi(sym->identifier);
+	else
+		s = 24*60*60*d+60*60*h+60*m+s;
+
+	if (s > UINT32_MAX)
+		return error(&sym->location, "value too large");
+
+	*res = constant_expr_alloc(&sym->location, &time_type,
+				   BYTEORDER_HOST_ENDIAN,
+				   sizeof(uint32_t) * BITS_PER_BYTE, &s);
+	return NULL;
 }
 
 const struct datatype time_type = {
@@ -709,6 +809,7 @@ const struct datatype time_type = {
 	.size		= 8 * BITS_PER_BYTE,
 	.basetype	= &integer_type,
 	.print		= time_type_print,
+	.parse		= time_type_parse,
 };
 
 static struct error_record *concat_type_parse(const struct expr *sym,
-- 
1.7.10.4

