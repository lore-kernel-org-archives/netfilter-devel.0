From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [02/19] strtonum
Date: Wed, 16 Jan 2008 14:48:43 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801161448090.4953@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48677 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbYAPNso (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:48:44 -0500
In-Reply-To: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Introduce strtonum(), which works like string_to_number(), but passes
back the 'end' pointer. It is useful where you want to do boundary
checking yet work with strings that are not entirely slurped by
strtoul(), e.g.:

	s = "1/2"; /* one half */
	if (!strtonum(s, &end, &value, 0, 5))
		error("Zero-length string, or value out of bounds");
	if (*end != '/')
		error("Malformed string");
	info->param1 = value;
	if (!strtonum(end + 1, &end, &value, 2, 4))
		error("..");
	if (*end != '\0')
		error("Malformed string");
	info->param2 = value;

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/xtables.h |    5 +++++
 xtables.c         |   44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

Index: iptables-modules/include/xtables.h
===================================================================
--- iptables-modules.orig/include/xtables.h
+++ iptables-modules/include/xtables.h
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 #include <linux/netfilter/x_tables.h>
 #include <libiptc/libxtc.h>
+#include <stdbool.h>
 
 #ifndef XT_LIB_DIR
 #define XT_LIB_DIR "/usr/local/lib/iptables"
@@ -206,6 +207,10 @@ extern int string_to_number(const char *
 			    unsigned int min,
 			    unsigned int max,
 			    unsigned int *ret);
+extern bool strtonuml(const char *, char **, unsigned long *,
+	unsigned long, unsigned long);
+extern bool strtonum(const char *, char **, unsigned int *,
+	unsigned int, unsigned int);
 extern int service_to_port(const char *name, const char *proto);
 extern u_int16_t parse_port(const char *port, const char *proto);
 extern void
Index: iptables-modules/xtables.c
===================================================================
--- iptables-modules.orig/xtables.c
+++ iptables-modules/xtables.c
@@ -19,6 +19,7 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <netdb.h>
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -199,6 +200,49 @@ int string_to_number(const char *s, unsi
 	return result;
 }
 
+/*
+ * strtonum{,l} - string to number conversion
+ *
+ * If @end is NULL, we assume the caller does not want
+ * a case like "15a", so reject it.
+ */
+bool strtonuml(const char *s, char **end, unsigned long *value,
+               unsigned long min, unsigned long max)
+{
+	unsigned long v;
+	char *my_end;
+
+	errno = 0;
+	v = strtoul(s, &my_end, 0);
+
+	if (my_end == s)
+		return false;
+	if (end != NULL)
+		*end = my_end;
+
+	if (errno != ERANGE && min <= v && (max == 0 || v <= max)) {
+		if (value != NULL)
+			*value = v;
+		if (end == NULL)
+			return *my_end == '\0';
+		return true;
+	}
+
+	return false;
+}
+
+bool strtonum(const char *s, char **end, unsigned int *value,
+                  unsigned int min, unsigned int max)
+{
+	unsigned long v;
+	bool ret;
+
+	ret = strtonuml(s, end, &v, min, max);
+	if (value != NULL)
+		*value = v;
+	return ret;
+}
+
 int service_to_port(const char *name, const char *proto)
 {
 	struct servent *service;
