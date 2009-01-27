From: Jan Engelhardt <jengelh@medozas.de>
Subject: libxtables: prefix names and order it #2
Date: Tue, 27 Jan 2009 15:11:28 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901271511190.13940@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901271500200.13940@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, jamal <hadi@cyberus.ca>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51071 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZA0OL3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Jan 2009 09:11:29 -0500
In-Reply-To: <alpine.LSU.2.00.0901271500200.13940@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent d6c2522895ff2906cd905bd2ef728bf388bdaa77 (v1.4.3-rc1-23-gd6c2522)
commit 8759aeb8e8531f26df72ee15fbcab921ca4f361f
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Jan 27 15:10:05 2009 +0100

libxtables: prefix names and order it #2

This change affects:
	load_xtables_ko -> xtables_load_ko
	modprobe_program -> xtables_modprobe_program
Now uses bool for the "quiet" flag.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in       |    5 +++++
 include/xtables/internal.h |    4 ----
 ip6tables-restore.c        |    5 +++--
 ip6tables.c                |    5 +++--
 iptables-restore.c         |    5 +++--
 iptables.c                 |    5 +++--
 xtables.c                  |   10 +++++-----
 7 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index e63d171..2512d79 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -140,9 +140,14 @@ struct xtables_target
 #endif
 };
 
+extern const char *xtables_modprobe_program;
+
 extern void *xtables_calloc(size_t, size_t);
 extern void *xtables_malloc(size_t);
 
+extern int xtables_insmod(const char *, const char *, bool);
+extern int xtables_load_ko(const char *, bool);
+
 /* Your shared library should call one of these. */
 extern void xtables_register_match(struct xtables_match *me);
 extern void xtables_register_target(struct xtables_target *me);
diff --git a/include/xtables/internal.h b/include/xtables/internal.h
index 6b78d3a..62fe2ed 100644
--- a/include/xtables/internal.h
+++ b/include/xtables/internal.h
@@ -43,10 +43,6 @@ struct xtables_rule_match {
 
 extern char *lib_dir;
 
-extern const char *modprobe_program;
-extern int xtables_insmod(const char *modname, const char *modprobe, int quiet);
-extern int load_xtables_ko(const char *modprobe, int quiet);
-
 /* This is decleared in ip[6]tables.c */
 extern struct afinfo afinfo;
 
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index a84c2e3..097711f 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -12,6 +12,7 @@
 
 #include <getopt.h>
 #include <sys/errno.h>
+#include <stdbool.h>
 #include <string.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -64,7 +65,7 @@ static struct ip6tc_handle *create_handle(const char *tablename)
 
 	if (!handle) {
 		/* try to insmod the module if iptc_init failed */
-		load_xtables_ko(modprobe_program, 0);
+		xtables_load_ko(xtables_modprobe_program, false);
 		handle = ip6tc_init(tablename);
 	}
 
@@ -165,7 +166,7 @@ int main(int argc, char *argv[])
 				noflush = 1;
 				break;
 			case 'M':
-				modprobe_program = optarg;
+				xtables_modprobe_program = optarg;
 				break;
 		}
 	}
diff --git a/ip6tables.c b/ip6tables.c
index 59c1011..580a644 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -33,6 +33,7 @@
 #include <stdlib.h>
 #include <ctype.h>
 #include <stdarg.h>
+#include <stdbool.h>
 #include <limits.h>
 #include <ip6tables.h>
 #include <xtables.h>
@@ -1769,7 +1770,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			break;
 
 		case 'M':
-			modprobe_program = optarg;
+			xtables_modprobe_program = optarg;
 			break;
 
 		case 'c':
@@ -1967,7 +1968,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 		*handle = ip6tc_init(*table);
 
 	/* try to insmod the module if iptc_init failed */
-	if (!*handle && load_xtables_ko(modprobe_program, 0) != -1)
+	if (!*handle && xtables_load_ko(xtables_modprobe_program, false) != -1)
 		*handle = ip6tc_init(*table);
 
 	if (!*handle)
diff --git a/iptables-restore.c b/iptables-restore.c
index 7cc6d6d..3fbc908 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -9,6 +9,7 @@
 
 #include <getopt.h>
 #include <sys/errno.h>
+#include <stdbool.h>
 #include <string.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -63,7 +64,7 @@ static struct iptc_handle *create_handle(const char *tablename)
 
 	if (!handle) {
 		/* try to insmod the module if iptc_init failed */
-		load_xtables_ko(modprobe_program, 0);
+		xtables_load_ko(xtables_modprobe_program, false);
 		handle = iptc_init(tablename);
 	}
 
@@ -167,7 +168,7 @@ main(int argc, char *argv[])
 				noflush = 1;
 				break;
 			case 'M':
-				modprobe_program = optarg;
+				xtables_modprobe_program = optarg;
 				break;
 			case 'T':
 				tablename = optarg;
diff --git a/iptables.c b/iptables.c
index 0b7edd8..61e7aab 100644
--- a/iptables.c
+++ b/iptables.c
@@ -29,6 +29,7 @@
 #include <string.h>
 #include <netdb.h>
 #include <errno.h>
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <ctype.h>
@@ -1786,7 +1787,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			break;
 
 		case 'M':
-			modprobe_program = optarg;
+			xtables_modprobe_program = optarg;
 			break;
 
 		case 'c':
@@ -1996,7 +1997,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 		*handle = iptc_init(*table);
 
 	/* try to insmod the module if iptc_init failed */
-	if (!*handle && load_xtables_ko(modprobe_program, 0) != -1)
+	if (!*handle && xtables_load_ko(xtables_modprobe_program, false) != -1)
 		*handle = iptc_init(*table);
 
 	if (!*handle)
diff --git a/xtables.c b/xtables.c
index 83c72ee..94ea764 100644
--- a/xtables.c
+++ b/xtables.c
@@ -47,7 +47,7 @@
 char *lib_dir;
 
 /* the path to command to load kernel module */
-const char *modprobe_program = NULL;
+const char *xtables_modprobe_program;
 
 /* Keeping track of external matches and targets: linked lists.  */
 struct xtables_match *xtables_matches;
@@ -108,7 +108,7 @@ static char *get_modprobe(void)
 	return NULL;
 }
 
-int xtables_insmod(const char *modname, const char *modprobe, int quiet)
+int xtables_insmod(const char *modname, const char *modprobe, bool quiet)
 {
 	char *buf = NULL;
 	char *argv[4];
@@ -150,9 +150,9 @@ int xtables_insmod(const char *modname, const char *modprobe, int quiet)
 	return -1;
 }
 
-int load_xtables_ko(const char *modprobe, int quiet)
+int xtables_load_ko(const char *modprobe, bool quiet)
 {
-	static int loaded = 0;
+	static bool loaded = false;
 	static int ret = -1;
 
 	if (!loaded) {
@@ -502,7 +502,7 @@ static int compatible_revision(const char *name, u_int8_t revision, int opt)
 		exit(1);
 	}
 
-	load_xtables_ko(modprobe_program, 1);
+	xtables_load_ko(xtables_modprobe_program, true);
 
 	strcpy(rev.name, name);
 	rev.revision = revision;
-- 
# Created with git-export-patch
