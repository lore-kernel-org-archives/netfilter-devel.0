From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: IPT [PATCH 1/3] Introduce bound_strtou()
Date: Tue, 27 Nov 2007 00:46:09 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711270044250.22369@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711270041320.22369@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49155 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277AbXKZXqM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:46:12 -0500
In-Reply-To: <Pine.LNX.4.64.0711270041320.22369@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


(This will be used by libxt_tos, libxt_TOS and more to come.)

===Patch begins here===

Introduce bound_strtou(), which works like string_to_number_ll(),
but updates ("passes back") the 'end' pointer. It is useful where
you want to do boundary checking yet work with strings that are
not entirely numbers recognized by strtoul(), e.g.:

	s = "1/2";
	if (!strtoul_bound(s, &end, &value, 0, 5))
		error("Zero-length string, or value out of bounds");
	if (*end != '/')
		error("Malformed string");
	info->param1 = value;
	if (!strtoul_bound(end + 1, &end, &value, 2, 4))
		error("..");
	if (*end != '\0')
		error("Malformed string");
	info->param2 = value;

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 include/xtables.h |    5 +++++
 xtables.c         |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

Index: iptables-modules/include/xtables.h
===================================================================
--- iptables-modules.orig/include/xtables.h
+++ iptables-modules/include/xtables.h
@@ -2,6 +2,7 @@
 #define _XTABLES_H
 
 #include <sys/types.h>
+#include <stdbool.h>
 #include <linux/netfilter/x_tables.h>
 #include <libiptc/libxtc.h>
 
@@ -205,6 +206,10 @@ extern int string_to_number(const char *
 			    unsigned int min,
 			    unsigned int max,
 			    unsigned int *ret);
+extern bool bound_strtoul(const char *, char **, unsigned long *,
+	unsigned long, unsigned long);
+extern bool bound_strtou(const char *, char **, unsigned int *,
+	unsigned int, unsigned int);
 extern int service_to_port(const char *name, const char *proto);
 extern u_int16_t parse_port(const char *port, const char *proto);
 extern void
Index: iptables-modules/xtables.c
===================================================================
--- iptables-modules.orig/xtables.c
+++ iptables-modules/xtables.c
@@ -20,6 +20,7 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <netdb.h>
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -196,6 +197,38 @@ int string_to_number(const char *s, unsi
 	return result;
 }
 
+bool bound_strtoul(const char *s, char **end, unsigned long *value,
+                   unsigned long min, unsigned long max)
+{
+	unsigned long v;
+
+	errno = 0;
+	v = strtoul(s, end, 0);
+
+	if (*end == s)
+		return false;
+
+	if (errno != ERANGE && min <= v && (max == 0 || v <= max)) {
+		if (value != NULL)
+			*value = v;
+		return true;
+	}
+
+	return false;
+}
+
+bool bound_strtou(const char *s, char **end, unsigned int *value,
+                  unsigned int min, unsigned int max)
+{
+	unsigned long v;
+	bool ret;
+
+	ret = bound_strtoul(s, end, &v, min, max);
+	if (ret && value != NULL)
+		*value = v;
+	return ret;
+}
+
 int service_to_port(const char *name, const char *proto)
 {
 	struct servent *service;
