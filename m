From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/5] iptables: move kernel version find routing into libxtables
Date: Mon,  5 Sep 2011 20:22:52 +0200
Message-ID: <1315246974-11538-5-git-send-email-jengelh@medozas.de>
References: <1315246974-11538-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:33342 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab1IESXD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Sep 2011 14:23:03 -0400
In-Reply-To: <1315246974-11538-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

That way, the remaining unreferenced symbols that do appear in
libipt_DNAT and libipt_SNAT as part of the new check can be resolved,
and the ugly -rdynamic hack can finally be removed.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am          |    3 ++-
 include/iptables.h   |    8 --------
 include/xtables.h.in |    8 ++++++++
 iptables/Makefile.am |    1 -
 iptables/iptables.c  |   18 ------------------
 iptables/xtables.c   |   18 ++++++++++++++++++
 6 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 34b3501..9167e8e 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -3,7 +3,7 @@
 ACLOCAL_AMFLAGS  = -I m4
 AUTOMAKE_OPTIONS = foreign subdir-objects
 
-SUBDIRS          = extensions libiptc iptables
+SUBDIRS          = libiptc iptables
 if ENABLE_DEVEL
 SUBDIRS         += include
 endif
@@ -13,6 +13,7 @@ endif
 if HAVE_LIBNFNETLINK
 SUBDIRS         += utils
 endif
+SUBDIRS         += extensions
 
 .PHONY: tarball
 tarball:
diff --git a/include/iptables.h b/include/iptables.h
index 65b3290..89217e2 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -18,14 +18,6 @@ extern int for_each_chain4(int (*fn)(const ipt_chainlabel, int, struct iptc_hand
 extern void print_rule4(const struct ipt_entry *e,
 		struct iptc_handle *handle, const char *chain, int counters);
 
-/* kernel revision handling */
-extern int kernel_version;
-extern void get_kernel_version(void);
-#define LINUX_VERSION(x,y,z)	(0x10000*(x) + 0x100*(y) + z)
-#define LINUX_VERSION_MAJOR(x)	(((x)>>16) & 0xFF)
-#define LINUX_VERSION_MINOR(x)	(((x)>> 8) & 0xFF)
-#define LINUX_VERSION_PATCH(x)	( (x)      & 0xFF)
-
 extern struct xtables_globals iptables_globals;
 
 #endif /*_IPTABLES_USER_H*/
diff --git a/include/xtables.h.in b/include/xtables.h.in
index d50df79..28e2933 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -477,6 +477,14 @@ extern void xtables_save_string(const char *value);
 extern const struct xtables_pprot xtables_chain_protos[];
 extern u_int16_t xtables_parse_protocol(const char *s);
 
+/* kernel revision handling */
+extern int kernel_version;
+extern void get_kernel_version(void);
+#define LINUX_VERSION(x,y,z)	(0x10000*(x) + 0x100*(y) + z)
+#define LINUX_VERSION_MAJOR(x)	(((x)>>16) & 0xFF)
+#define LINUX_VERSION_MINOR(x)	(((x)>> 8) & 0xFF)
+#define LINUX_VERSION_PATCH(x)	( (x)      & 0xFF)
+
 /* xtoptions.c */
 extern void xtables_option_metavalidate(const char *,
 					const struct xt_option_entry *);
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index f6db32d..af620f7 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -21,7 +21,6 @@ endif
 
 xtables_multi_SOURCES  = xtables-multi.c iptables-xml.c
 xtables_multi_CFLAGS   = ${AM_CFLAGS}
-xtables_multi_LDFLAGS  = -rdynamic
 xtables_multi_LDADD    = ../extensions/libext.a
 if ENABLE_STATIC
 xtables_multi_CFLAGS  += -DALL_INCLUSIVE
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 50dc1e7..830ddbc 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -39,7 +39,6 @@
 #include <iptables.h>
 #include <xtables.h>
 #include <fcntl.h>
-#include <sys/utsname.h>
 #include "xshared.h"
 
 #ifndef TRUE
@@ -187,8 +186,6 @@ static const int inverse_for_options[NUMBER_OF_OPT] =
 #define prog_name iptables_globals.program_name
 #define prog_vers iptables_globals.program_version
 
-int kernel_version;
-
 /* Primitive headers... */
 /* defined in netinet/in.h */
 #if 0
@@ -1281,21 +1278,6 @@ static void clear_rule_matches(struct xtables_rule_match **matches)
 	*matches = NULL;
 }
 
-void
-get_kernel_version(void) {
-	static struct utsname uts;
-	int x = 0, y = 0, z = 0;
-
-	if (uname(&uts) == -1) {
-		fprintf(stderr, "Unable to retrieve kernel version.\n");
-		xtables_free_opts(1);
-		exit(1);
-	}
-
-	sscanf(uts.release, "%d.%d.%d", &x, &y, &z);
-	kernel_version = LINUX_VERSION(x, y, z);
-}
-
 static void command_jump(struct iptables_command_state *cs)
 {
 	size_t size;
diff --git a/iptables/xtables.c b/iptables/xtables.c
index e72aa28..014e115 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -31,6 +31,7 @@
 #include <sys/stat.h>
 #include <sys/statfs.h>
 #include <sys/types.h>
+#include <sys/utsname.h>
 #include <sys/wait.h>
 #include <arpa/inet.h>
 #if defined(HAVE_LINUX_MAGIC_H)
@@ -1812,3 +1813,20 @@ xtables_parse_protocol(const char *s)
 		"unknown protocol \"%s\" specified", s);
 	return -1;
 }
+
+int kernel_version;
+
+void get_kernel_version(void)
+{
+	static struct utsname uts;
+	int x = 0, y = 0, z = 0;
+
+	if (uname(&uts) == -1) {
+		fprintf(stderr, "Unable to retrieve kernel version.\n");
+		xtables_free_opts(1);
+		exit(1);
+	}
+
+	sscanf(uts.release, "%d.%d.%d", &x, &y, &z);
+	kernel_version = LINUX_VERSION(x, y, z);
+}
-- 
1.7.3.4

