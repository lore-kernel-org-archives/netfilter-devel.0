From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 08/16] libxtables: prefix/order - program_name
Date: Mon,  9 Feb 2009 18:34:52 +0100
Message-ID: <1234200900-5964-9-git-send-email-jengelh@medozas.de>
References: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51468 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbZBIRfF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:35:05 -0500
In-Reply-To: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Split XTABLES_VERSION into xtables and iptables, and encode the
xtables soversion into the extensions instead. This makes it possible
to upgrade iptables without having to recompile 3rd-party extensions
(if the libxtables version matches, of course).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .gitignore                    |    1 +
 Makefile.am                   |    2 +-
 configure.ac                  |   26 ++++++++++----------------
 include/xtables.h.in          |   13 ++++++++-----
 include/xtables/internal.h    |   34 ----------------------------------
 include/xtables/internal.h.in |   41 +++++++++++++++++++++++++++++++++++++++++
 ip6tables-restore.c           |    5 +++--
 ip6tables-save.c              |    5 +++--
 ip6tables-standalone.c        |    3 ++-
 iptables-restore.c            |    5 +++--
 iptables-save.c               |    5 +++--
 iptables-standalone.c         |    3 ++-
 iptables-xml.c                |    4 ++--
 xtables.c                     |   37 +++++++++++++++++++++++--------------
 14 files changed, 102 insertions(+), 82 deletions(-)
 delete mode 100644 include/xtables/internal.h
 create mode 100644 include/xtables/internal.h.in

diff --git a/.gitignore b/.gitignore
index 741f972..116de2c 100644
--- a/.gitignore
+++ b/.gitignore
@@ -18,6 +18,7 @@ Makefile.in
 /extensions/targets?.man
 
 /include/xtables.h
+/include/xtables/internal.h
 
 /aclocal.m4
 /autom4te*.cache
diff --git a/Makefile.am b/Makefile.am
index 83ab3bb..0ffb978 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -14,7 +14,7 @@ libiptc_libiptc_a_SOURCES = libiptc/libip4tc.c libiptc/libip6tc.c
 
 lib_LTLIBRARIES       = libxtables.la
 libxtables_la_SOURCES = xtables.c
-libxtables_la_LDFLAGS = -version-info 1:0:0
+libxtables_la_LDFLAGS = -version-info ${libxtables_vcurrent}:0:${libxtables_vage}
 
 # iptables, dynamic
 iptables_SOURCES          = iptables-standalone.c iptables.c
diff --git a/configure.ac b/configure.ac
index 8c9c30d..bb32130 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,11 +1,10 @@
-define([_XTABLES_VERSION_MAJOR], 1)
-define([_XTABLES_VERSION_MINOR], 4)
-define([_XTABLES_VERSION_PATCH], 3)
-define([_XTABLES_VERSION_EXTRA], -rc1)
 
-define([_XTABLES_VERSION],_XTABLES_VERSION_MAJOR._XTABLES_VERSION_MINOR._XTABLES_VERSION_PATCH[]_XTABLES_VERSION_EXTRA)
+AC_INIT([iptables], [1.4.3-rc1])
+
+# See libtool.info "Libtool's versioning system"
+libxtables_vcurrent=1
+libxtables_vage=0
 
-AC_INIT([iptables], _XTABLES_VERSION)
 AC_CONFIG_HEADERS([config.h])
 AC_CONFIG_MACRO_DIR([m4])
 AC_PROG_INSTALL
@@ -74,16 +73,11 @@ AC_SUBST([kbuilddir])
 AC_SUBST([ksourcedir])
 AC_SUBST([xtlibdir])
 AC_SUBST([pkgconfigdir])
-
-XTABLES_VERSION_MAJOR=_XTABLES_VERSION_MAJOR
-XTABLES_VERSION_MINOR=_XTABLES_VERSION_MINOR
-XTABLES_VERSION_PATCH=_XTABLES_VERSION_PATCH
-XTABLES_VERSION_EXTRA=_XTABLES_VERSION_EXTRA
-AC_SUBST([XTABLES_VERSION_MAJOR])
-AC_SUBST([XTABLES_VERSION_MINOR])
-AC_SUBST([XTABLES_VERSION_PATCH])
-AC_SUBST([XTABLES_VERSION_EXTRA])
+AC_SUBST([libxtables_vcurrent])
+AC_SUBST([libxtables_vage])
+libxtables_vmajor=$(($libxtables_vcurrent - $libxtables_vage));
+AC_SUBST([libxtables_vmajor])
 
 AC_CONFIG_FILES([Makefile extensions/GNUmakefile libipq/Makefile
-	include/xtables.h xtables.pc])
+	include/xtables.h include/xtables/internal.h xtables.pc])
 AC_OUTPUT
diff --git a/include/xtables.h.in b/include/xtables.h.in
index f372d33..e1f9c92 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -1,6 +1,11 @@
 #ifndef _XTABLES_H
 #define _XTABLES_H
 
+/*
+ * Changing any structs/functions may incur a needed change
+ * in libxtables_vcurrent/vage too.
+ */
+
 #include <sys/socket.h> /* PF_* */
 #include <sys/types.h>
 #include <stdbool.h>
@@ -20,10 +25,8 @@
 #define IPPROTO_UDPLITE	136
 #endif
 
-#define XTABLES_VERSION "@PACKAGE_VERSION@"
-#define XTABLES_VERSION_CODE (0x10000 * @XTABLES_VERSION_MAJOR@ + 0x100 * @XTABLES_VERSION_MINOR@ + @XTABLES_VERSION_PATCH@)
-
-#define XTABLES_API_VERSION(x,y,z)    (0x10000*(x) + 0x100*(y) + z)
+#define XTABLES_VERSION "libxtables.so.@libxtables_vmajor@"
+#define XTABLES_VERSION_CODE @libxtables_vmajor@
 
 struct in_addr;
 
@@ -155,6 +158,7 @@ enum xtables_tryload {
 	XTF_LOAD_MUST_SUCCEED,
 };
 
+extern const char *xtables_program_name;
 extern const char *xtables_modprobe_program;
 extern struct xtables_match *xtables_matches;
 extern struct xtables_target *xtables_targets;
@@ -202,7 +206,6 @@ int check_inverse(const char option[], int *invert, int *my_optind, int argc);
 void exit_error(enum exittype, const char *, ...)__attribute__((noreturn,
 							  format(printf,2,3)));
 extern void param_act(unsigned int, const char *, ...);
-extern const char *program_name, *program_version;
 
 extern const char *ipaddr_to_numeric(const struct in_addr *);
 extern const char *ipaddr_to_anyname(const struct in_addr *);
diff --git a/include/xtables/internal.h b/include/xtables/internal.h
deleted file mode 100644
index 21c4401..0000000
--- a/include/xtables/internal.h
+++ /dev/null
@@ -1,34 +0,0 @@
-#ifndef _XTABLES_INTERNAL_H
-#define _XTABLES_INTERNAL_H 1
-
-#ifndef XT_LIB_DIR
-#	define XT_LIB_DIR "/usr/local/lib/iptables"
-#endif
-
-/* protocol family dependent informations */
-struct afinfo {
-	/* protocol family */
-	int family;
-
-	/* prefix of library name (ex "libipt_" */
-	char *libprefix;
-
-	/* used by setsockopt (ex IPPROTO_IP */
-	int ipproto;
-
-	/* kernel module (ex "ip_tables" */
-	char *kmod;
-
-	/* optname to check revision support of match */
-	int so_rev_match;
-
-	/* optname to check revision support of match */
-	int so_rev_target;
-};
-
-/* This is decleared in ip[6]tables.c */
-extern struct afinfo afinfo;
-
-extern void _init(void);
-
-#endif /* _XTABLES_INTERNAL_H */
diff --git a/include/xtables/internal.h.in b/include/xtables/internal.h.in
new file mode 100644
index 0000000..2143829
--- /dev/null
+++ b/include/xtables/internal.h.in
@@ -0,0 +1,41 @@
+#ifndef _XTABLES_INTERNAL_H
+#define _XTABLES_INTERNAL_H 1
+
+#define IPTABLES_VERSION "@PACKAGE_VERSION@"
+
+#ifndef XT_LIB_DIR
+#	define XT_LIB_DIR "/usr/local/lib/iptables"
+#endif
+
+/* protocol family dependent informations */
+struct afinfo {
+	/* protocol family */
+	int family;
+
+	/* prefix of library name (ex "libipt_" */
+	char *libprefix;
+
+	/* used by setsockopt (ex IPPROTO_IP */
+	int ipproto;
+
+	/* kernel module (ex "ip_tables" */
+	char *kmod;
+
+	/* optname to check revision support of match */
+	int so_rev_match;
+
+	/* optname to check revision support of match */
+	int so_rev_target;
+};
+
+/* This is decleared in ip[6]tables.c */
+extern struct afinfo afinfo;
+
+/**
+ * Program's own name and version.
+ */
+extern const char *program_name, *program_version;
+
+extern void _init(void);
+
+#endif /* _XTABLES_INTERNAL_H */
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 6be1a36..beb640b 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -127,9 +127,10 @@ int main(int argc, char *argv[])
 	int in_table = 0, testing = 0;
 
 	program_name = "ip6tables-restore";
-	program_version = XTABLES_VERSION;
+	program_version = IPTABLES_VERSION;
 	line = 0;
 
+	xtables_program_name = program_name;
 	xtables_init();
 #ifdef NO_SHARED_LIBS
 	init_extensions();
@@ -151,7 +152,7 @@ int main(int argc, char *argv[])
 				break;
 			case 'h':
 				print_usage("ip6tables-restore",
-					    XTABLES_VERSION);
+					    IPTABLES_VERSION);
 				break;
 			case 'n':
 				noflush = 1;
diff --git a/ip6tables-save.c b/ip6tables-save.c
index 1b9d00a..86ec6b2 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -76,7 +76,7 @@ static int do_output(const char *tablename)
 		time_t now = time(NULL);
 
 		printf("# Generated by ip6tables-save v%s on %s",
-		       XTABLES_VERSION, ctime(&now));
+		       IPTABLES_VERSION, ctime(&now));
 		printf("*%s\n", tablename);
 
 		/* Dump out chain names first,
@@ -137,8 +137,9 @@ int main(int argc, char *argv[])
 	int c;
 
 	program_name = "ip6tables-save";
-	program_version = XTABLES_VERSION;
+	program_version = IPTABLES_VERSION;
 
+	xtables_program_name = program_name;
 	xtables_init();
 #ifdef NO_SHARED_LIBS
 	init_extensions();
diff --git a/ip6tables-standalone.c b/ip6tables-standalone.c
index 9543557..3ab114e 100644
--- a/ip6tables-standalone.c
+++ b/ip6tables-standalone.c
@@ -50,8 +50,9 @@ main(int argc, char *argv[])
 	struct ip6tc_handle *handle = NULL;
 
 	program_name = "ip6tables";
-	program_version = XTABLES_VERSION;
+	program_version = IPTABLES_VERSION;
 
+	xtables_program_name = program_name;
 	xtables_init();
 #ifdef NO_SHARED_LIBS
 	init_extensions();
diff --git a/iptables-restore.c b/iptables-restore.c
index d982fca..56812ee 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -129,9 +129,10 @@ main(int argc, char *argv[])
 	const char *tablename = NULL;
 
 	program_name = "iptables-restore";
-	program_version = XTABLES_VERSION;
+	program_version = IPTABLES_VERSION;
 	line = 0;
 
+	xtables_program_name = program_name;
 	xtables_init();
 #ifdef NO_SHARED_LIBS
 	init_extensions();
@@ -153,7 +154,7 @@ main(int argc, char *argv[])
 				break;
 			case 'h':
 				print_usage("iptables-restore",
-					    XTABLES_VERSION);
+					    IPTABLES_VERSION);
 				break;
 			case 'n':
 				noflush = 1;
diff --git a/iptables-save.c b/iptables-save.c
index e615de9..d08ec4b 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -74,7 +74,7 @@ static int do_output(const char *tablename)
 		time_t now = time(NULL);
 
 		printf("# Generated by iptables-save v%s on %s",
-		       XTABLES_VERSION, ctime(&now));
+		       IPTABLES_VERSION, ctime(&now));
 		printf("*%s\n", tablename);
 
 		/* Dump out chain names first,
@@ -137,8 +137,9 @@ main(int argc, char *argv[])
 	int c;
 
 	program_name = "iptables-save";
-	program_version = XTABLES_VERSION;
+	program_version = IPTABLES_VERSION;
 
+	xtables_program_name = program_name;
 	xtables_init();
 #ifdef NO_SHARED_LIBS
 	init_extensions();
diff --git a/iptables-standalone.c b/iptables-standalone.c
index c06b286..9190873 100644
--- a/iptables-standalone.c
+++ b/iptables-standalone.c
@@ -51,8 +51,9 @@ main(int argc, char *argv[])
 	struct iptc_handle *handle = NULL;
 
 	program_name = "iptables";
-	program_version = XTABLES_VERSION;
+	program_version = IPTABLES_VERSION;
 
+	xtables_program_name = program_name;
 	xtables_init();
 #ifdef NO_SHARED_LIBS
 	init_extensions();
diff --git a/iptables-xml.c b/iptables-xml.c
index 6481b8e..a3f6987 100644
--- a/iptables-xml.c
+++ b/iptables-xml.c
@@ -643,7 +643,7 @@ main(int argc, char *argv[])
 	FILE *in;
 
 	program_name = "iptables-xml";
-	program_version = XTABLES_VERSION;
+	program_version = IPTABLES_VERSION;
 	line = 0;
 
 	while ((c = getopt_long(argc, argv, "cvh", options, NULL)) != -1) {
@@ -656,7 +656,7 @@ main(int argc, char *argv[])
 			verbose = 1;
 			break;
 		case 'h':
-			print_usage("iptables-xml", XTABLES_VERSION);
+			print_usage("iptables-xml", IPTABLES_VERSION);
 			break;
 		}
 	}
diff --git a/xtables.c b/xtables.c
index 9e57679..642c04b 100644
--- a/xtables.c
+++ b/xtables.c
@@ -44,6 +44,11 @@
 #define PROC_SYS_MODPROBE "/proc/sys/kernel/modprobe"
 #endif
 
+/**
+ * Program will set this to its own name.
+ */
+const char *xtables_program_name;
+
 /* Search path for Xtables .so files */
 static const char *xtables_libdir;
 
@@ -529,23 +534,25 @@ void xtables_register_match(struct xtables_match *me)
 {
 	struct xtables_match **i, *old;
 
-	if (strcmp(me->version, program_version) != 0) {
-		fprintf(stderr, "%s: match `%s' v%s (I'm v%s).\n",
-			program_name, me->name, me->version, program_version);
+	if (strcmp(me->version, XTABLES_VERSION) != 0) {
+		fprintf(stderr, "%s: match \"%s\" has version \"%s\", "
+		        "but \"%s\" is required.\n",
+			xtables_program_name, me->name,
+			me->version, XTABLES_VERSION);
 		exit(1);
 	}
 
 	/* Revision field stole a char from name. */
 	if (strlen(me->name) >= XT_FUNCTION_MAXNAMELEN-1) {
 		fprintf(stderr, "%s: target `%s' has invalid name\n",
-			program_name, me->name);
+			xtables_program_name, me->name);
 		exit(1);
 	}
 
 	if (me->family >= NPROTO) {
 		fprintf(stderr,
 			"%s: BUG: match %s has invalid protocol family\n",
-			program_name, me->name);
+			xtables_program_name, me->name);
 		exit(1);
 	}
 
@@ -559,7 +566,7 @@ void xtables_register_match(struct xtables_match *me)
 		    old->family == me->family) {
 			fprintf(stderr,
 				"%s: match `%s' already registered.\n",
-				program_name, me->name);
+				xtables_program_name, me->name);
 			exit(1);
 		}
 
@@ -583,7 +590,7 @@ void xtables_register_match(struct xtables_match *me)
 
 	if (me->size != XT_ALIGN(me->size)) {
 		fprintf(stderr, "%s: match `%s' has invalid size %u.\n",
-			program_name, me->name, (unsigned int)me->size);
+			xtables_program_name, me->name, (unsigned int)me->size);
 		exit(1);
 	}
 
@@ -600,23 +607,25 @@ void xtables_register_target(struct xtables_target *me)
 {
 	struct xtables_target *old;
 
-	if (strcmp(me->version, program_version) != 0) {
-		fprintf(stderr, "%s: target `%s' v%s (I'm v%s).\n",
-			program_name, me->name, me->version, program_version);
+	if (strcmp(me->version, XTABLES_VERSION) != 0) {
+		fprintf(stderr, "%s: target \"%s\" has version \"%s\", "
+		        "but \"%s\" is required.\n",
+			xtables_program_name, me->name,
+			me->version, XTABLES_VERSION);
 		exit(1);
 	}
 
 	/* Revision field stole a char from name. */
 	if (strlen(me->name) >= XT_FUNCTION_MAXNAMELEN-1) {
 		fprintf(stderr, "%s: target `%s' has invalid name\n",
-			program_name, me->name);
+			xtables_program_name, me->name);
 		exit(1);
 	}
 
 	if (me->family >= NPROTO) {
 		fprintf(stderr,
 			"%s: BUG: target %s has invalid protocol family\n",
-			program_name, me->name);
+			xtables_program_name, me->name);
 		exit(1);
 	}
 
@@ -632,7 +641,7 @@ void xtables_register_target(struct xtables_target *me)
 		    old->family == me->family) {
 			fprintf(stderr,
 				"%s: target `%s' already registered.\n",
-				program_name, me->name);
+				xtables_program_name, me->name);
 			exit(1);
 		}
 
@@ -656,7 +665,7 @@ void xtables_register_target(struct xtables_target *me)
 
 	if (me->size != XT_ALIGN(me->size)) {
 		fprintf(stderr, "%s: target `%s' has invalid size %u.\n",
-			program_name, me->name, (unsigned int)me->size);
+			xtables_program_name, me->name, (unsigned int)me->size);
 		exit(1);
 	}
 
-- 
1.6.1.2

