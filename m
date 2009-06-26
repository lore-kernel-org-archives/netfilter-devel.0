From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 05/10] iptables: allow for help-less extensions
Date: Fri, 26 Jun 2009 21:19:47 +0200
Message-ID: <1246043992-379-6-git-send-email-jengelh@medozas.de>
References: <1246043992-379-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39671 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761256AbZFZTUL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:20:11 -0400
In-Reply-To: <1246043992-379-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is for extensions that do not take any options, and which
subsequently do not offer any help text either.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am |   16 ++++++++--------
 ip6tables.c |   18 ++----------------
 iptables.c  |   18 ++----------------
 xshared.c   |   31 +++++++++++++++++++++++++++++++
 xshared.h   |   10 ++++++++++
 5 files changed, 53 insertions(+), 40 deletions(-)
 create mode 100644 xshared.c
 create mode 100644 xshared.h

diff --git a/Makefile.am b/Makefile.am
index 445717e..a9e3ad3 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -29,23 +29,23 @@ libxtables_la_LDFLAGS = -version-info ${libxtables_vcurrent}:0:${libxtables_vage
 libxtables_la_LIBADD  = -ldl
 
 # iptables, dynamic
-iptables_SOURCES          = iptables-standalone.c iptables.c
+iptables_SOURCES          = iptables-standalone.c iptables.c xshared.c
 iptables_LDFLAGS          = -rdynamic
 iptables_LDADD            = libiptc/libip4tc.la extensions/libext4.a libxtables.la -lm
 
 iptables_xml_LDADD        = libxtables.la
 iptables_multi_SOURCES    = iptables-multi.c iptables-save.c \
                             iptables-restore.c iptables-xml.c \
-                            iptables-standalone.c iptables.c
+                            iptables-standalone.c iptables.c xshared.c
 iptables_multi_CFLAGS     = ${AM_CFLAGS} -DIPTABLES_MULTI
 iptables_multi_LDFLAGS    = ${iptables_LDFLAGS}
 iptables_multi_LDADD      = ${iptables_LDADD}
 
-iptables_restore_SOURCES  = iptables-restore.c iptables.c
+iptables_restore_SOURCES  = iptables-restore.c iptables.c xshared.c
 iptables_restore_LDFLAGS  = ${iptables_LDFLAGS}
 iptables_restore_LDADD    = ${iptables_LDADD}
 
-iptables_save_SOURCES     = iptables-save.c iptables.c
+iptables_save_SOURCES     = iptables-save.c iptables.c xshared.c
 iptables_save_LDFLAGS     = ${iptables_LDFLAGS}
 iptables_save_LDADD       = ${iptables_LDADD}
 
@@ -57,22 +57,22 @@ iptables_static_LDADD     = libiptc/libip4tc.la extensions/libext4.a -lm
 iptables_xml_SOURCES      = iptables-xml.c
 
 # ip6tables, dynamic
-ip6tables_SOURCES         = ip6tables-standalone.c ip6tables.c
+ip6tables_SOURCES         = ip6tables-standalone.c ip6tables.c xshared.c
 ip6tables_LDFLAGS         = -rdynamic
 ip6tables_LDADD           = libiptc/libip6tc.la extensions/libext6.a libxtables.la -lm
 
 ip6tables_multi_SOURCES   = ip6tables-multi.c ip6tables-save.c \
                             ip6tables-restore.c ip6tables-standalone.c \
-                            ip6tables.c
+                            ip6tables.c xshared.c
 ip6tables_multi_CFLAGS    = ${AM_CFLAGS} -DIPTABLES_MULTI
 ip6tables_multi_LDFLAGS   = ${ip6tables_LDFLAGS}
 ip6tables_multi_LDADD     = ${ip6tables_LDADD}
 
-ip6tables_restore_SOURCES = ip6tables-restore.c ip6tables.c
+ip6tables_restore_SOURCES = ip6tables-restore.c ip6tables.c xshared.c
 ip6tables_restore_LDFLAGS = ${ip6tables_LDFLAGS}
 ip6tables_restore_LDADD   = ${ip6tables_LDADD}
 
-ip6tables_save_SOURCES    = ip6tables-save.c ip6tables.c
+ip6tables_save_SOURCES    = ip6tables-save.c ip6tables.c xshared.c
 ip6tables_save_LDFLAGS    = ${ip6tables_LDFLAGS}
 ip6tables_save_LDADD      = ${ip6tables_LDADD}
 
diff --git a/ip6tables.c b/ip6tables.c
index 71ff46f..f974fb1 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -43,6 +43,7 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include "ip6tables-multi.h"
+#include "xshared.h"
 
 #ifndef TRUE
 #define TRUE 1
@@ -235,9 +236,6 @@ exit_tryhelp(int status)
 static void
 exit_printhelp(struct xtables_rule_match *matches)
 {
-	struct xtables_rule_match *matchp = NULL;
-	struct xtables_target *t = NULL;
-
 	printf("%s v%s\n\n"
 "Usage: %s -[AD] chain rule-specification [options]\n"
 "       %s -I chain [rulenum] rule-specification [options]\n"
@@ -307,19 +305,7 @@ exit_printhelp(struct xtables_rule_match *matches)
 "  --set-counters PKTS BYTES	set the counter during insert/append\n"
 "[!] --version	-V		print package version.\n");
 
-	/* Print out any special helps. A user might like to be able to add a --help
-	   to the commandline, and see expected results. So we call help for all
-	   specified matches & targets */
-	for (t = xtables_targets; t; t = t->next) {
-		if (t->used) {
-			printf("\n");
-			t->help();
-		}
-	}
-	for (matchp = matches; matchp; matchp = matchp->next) {
-		printf("\n");
-		matchp->match->help();
-	}
+	print_extension_helps(xtables_targets, matches);
 	exit(0);
 }
 
diff --git a/iptables.c b/iptables.c
index cc17576..a229c35 100644
--- a/iptables.c
+++ b/iptables.c
@@ -40,6 +40,7 @@
 #include <xtables.h>
 #include <fcntl.h>
 #include <sys/utsname.h>
+#include "xshared.h"
 
 #ifndef TRUE
 #define TRUE 1
@@ -248,9 +249,6 @@ exit_tryhelp(int status)
 static void
 exit_printhelp(struct xtables_rule_match *matches)
 {
-	struct xtables_rule_match *matchp = NULL;
-	struct xtables_target *t = NULL;
-
 	printf("%s v%s\n\n"
 "Usage: %s -[AD] chain rule-specification [options]\n"
 "       %s -I chain [rulenum] rule-specification [options]\n"
@@ -320,19 +318,7 @@ exit_printhelp(struct xtables_rule_match *matches)
 "  --set-counters PKTS BYTES	set the counter during insert/append\n"
 "[!] --version	-V		print package version.\n");
 
-	/* Print out any special helps. A user might like to be able
-	   to add a --help to the commandline, and see expected
-	   results. So we call help for all specified matches & targets */
-	for (t = xtables_targets; t ;t = t->next) {
-		if (t->used) {
-			printf("\n");
-			t->help();
-		}
-	}
-	for (matchp = matches; matchp; matchp = matchp->next) {
-		printf("\n");
-		matchp->match->help();
-	}
+	print_extension_helps(xtables_targets, matches);
 	exit(0);
 }
 
diff --git a/xshared.c b/xshared.c
new file mode 100644
index 0000000..21b5b2c
--- /dev/null
+++ b/xshared.c
@@ -0,0 +1,31 @@
+#include <stdio.h>
+#include <xtables.h>
+#include "xshared.h"
+
+/*
+ * Print out any special helps. A user might like to be able to add a --help
+ * to the commandline, and see expected results. So we call help for all
+ * specified matches and targets.
+ */
+void print_extension_helps(const struct xtables_target *t,
+    const struct xtables_rule_match *m)
+{
+	for (; t != NULL; t = t->next) {
+		if (t->used) {
+			printf("\n");
+			if (t->help == NULL)
+				printf("%s does not take any options\n",
+				       t->name);
+			else
+				t->help();
+		}
+	}
+	for (; m != NULL; m = m->next) {
+		printf("\n");
+		if (m->match->help == NULL)
+			printf("%s does not take any options\n",
+			       m->match->name);
+		else
+			m->match->help();
+	}
+}
diff --git a/xshared.h b/xshared.h
new file mode 100644
index 0000000..c53b618
--- /dev/null
+++ b/xshared.h
@@ -0,0 +1,10 @@
+#ifndef IPTABLES_XSHARED_H
+#define IPTABLES_XSHARED_H 1
+
+struct xtables_rule_match;
+struct xtables_target;
+
+extern void print_extension_helps(const struct xtables_target *,
+	const struct xtables_rule_match *);
+
+#endif /* IPTABLES_XSHARED_H */
-- 
1.6.3.2

