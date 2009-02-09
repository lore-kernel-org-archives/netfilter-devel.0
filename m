From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/16] libxtables: prefix/order - libdir
Date: Mon,  9 Feb 2009 18:34:50 +0100
Message-ID: <1234200900-5964-7-git-send-email-jengelh@medozas.de>
References: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51466 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534AbZBIRfE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:35:04 -0500
In-Reply-To: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Consolidate the libdir variable initialization code into xtables.c.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in       |    1 +
 include/xtables/internal.h |    2 --
 ip6tables-restore.c        |   11 +----------
 ip6tables-save.c           |   11 +----------
 ip6tables-standalone.c     |   11 +----------
 iptables-restore.c         |   11 +----------
 iptables-save.c            |   11 +----------
 iptables-standalone.c      |   11 +----------
 xtables.c                  |   23 ++++++++++++++++++++---
 9 files changed, 27 insertions(+), 65 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 02a832d..268c42e 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -159,6 +159,7 @@ extern const char *xtables_modprobe_program;
 extern struct xtables_match *xtables_matches;
 extern struct xtables_target *xtables_targets;
 
+extern void xtables_init(void);
 extern void *xtables_calloc(size_t, size_t);
 extern void *xtables_malloc(size_t);
 
diff --git a/include/xtables/internal.h b/include/xtables/internal.h
index 60375cd..21c4401 100644
--- a/include/xtables/internal.h
+++ b/include/xtables/internal.h
@@ -26,8 +26,6 @@ struct afinfo {
 	int so_rev_target;
 };
 
-extern char *lib_dir;
-
 /* This is decleared in ip[6]tables.c */
 extern struct afinfo afinfo;
 
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 097711f..6be1a36 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -130,16 +130,7 @@ int main(int argc, char *argv[])
 	program_version = XTABLES_VERSION;
 	line = 0;
 
-	lib_dir = getenv("XTABLES_LIBDIR");
-	if (lib_dir == NULL) {
-		lib_dir = getenv("IP6TABLES_LIB_DIR");
-		if (lib_dir != NULL)
-			fprintf(stderr, "IP6TABLES_LIB_DIR is deprecated, "
-			        "use XTABLES_LIBDIR.\n");
-	}
-	if (lib_dir == NULL)
-		lib_dir = XTABLES_LIBDIR;
-
+	xtables_init();
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/ip6tables-save.c b/ip6tables-save.c
index 11ef8c4..1b9d00a 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -139,16 +139,7 @@ int main(int argc, char *argv[])
 	program_name = "ip6tables-save";
 	program_version = XTABLES_VERSION;
 
-	lib_dir = getenv("XTABLES_LIBDIR");
-	if (lib_dir == NULL) {
-		lib_dir = getenv("IP6TABLES_LIB_DIR");
-		if (lib_dir != NULL)
-			fprintf(stderr, "IP6TABLES_LIB_DIR is deprecated, "
-			        "use XTABLES_LIBDIR.\n");
-	}
-	if (lib_dir == NULL)
-		lib_dir = XTABLES_LIBDIR;
-
+	xtables_init();
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/ip6tables-standalone.c b/ip6tables-standalone.c
index f4b1f18..9543557 100644
--- a/ip6tables-standalone.c
+++ b/ip6tables-standalone.c
@@ -52,16 +52,7 @@ main(int argc, char *argv[])
 	program_name = "ip6tables";
 	program_version = XTABLES_VERSION;
 
-	lib_dir = getenv("XTABLES_LIBDIR");
-	if (lib_dir == NULL) {
-		lib_dir = getenv("IP6TABLES_LIB_DIR");
-		if (lib_dir != NULL)
-			fprintf(stderr, "IP6TABLES_LIB_DIR is deprecated, "
-			        "use XTABLES_LIBDIR.\n");
-	}
-	if (lib_dir == NULL)
-		lib_dir = XTABLES_LIBDIR;
-
+	xtables_init();
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/iptables-restore.c b/iptables-restore.c
index 3fbc908..d982fca 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -132,16 +132,7 @@ main(int argc, char *argv[])
 	program_version = XTABLES_VERSION;
 	line = 0;
 
-	lib_dir = getenv("XTABLES_LIBDIR");
-	if (lib_dir == NULL) {
-		lib_dir = getenv("IPTABLES_LIB_DIR");
-		if (lib_dir != NULL)
-			fprintf(stderr, "IPTABLES_LIB_DIR is deprecated, "
-			        "use XTABLES_LIBDIR.\n");
-	}
-	if (lib_dir == NULL)
-		lib_dir = XTABLES_LIBDIR;
-
+	xtables_init();
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/iptables-save.c b/iptables-save.c
index 7118d1f..e615de9 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -139,16 +139,7 @@ main(int argc, char *argv[])
 	program_name = "iptables-save";
 	program_version = XTABLES_VERSION;
 
-	lib_dir = getenv("XTABLES_LIBDIR");
-	if (lib_dir == NULL) {
-		lib_dir = getenv("IPTABLES_LIB_DIR");
-		if (lib_dir != NULL)
-			fprintf(stderr, "IPTABLES_LIB_DIR is deprecated, "
-			        "use XTABLES_LIBDIR.\n");
-	}
-	if (lib_dir == NULL)
-		lib_dir = XTABLES_LIBDIR;
-
+	xtables_init();
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/iptables-standalone.c b/iptables-standalone.c
index 3f2432f..c06b286 100644
--- a/iptables-standalone.c
+++ b/iptables-standalone.c
@@ -53,16 +53,7 @@ main(int argc, char *argv[])
 	program_name = "iptables";
 	program_version = XTABLES_VERSION;
 
-	lib_dir = getenv("XTABLES_LIBDIR");
-	if (lib_dir == NULL) {
-		lib_dir = getenv("IPTABLES_LIB_DIR");
-		if (lib_dir != NULL)
-			fprintf(stderr, "IPTABLES_LIB_DIR is deprecated, "
-			        "use XTABLES_LIBDIR.\n");
-	}
-	if (lib_dir == NULL)
-		lib_dir = XTABLES_LIBDIR;
-
+	xtables_init();
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/xtables.c b/xtables.c
index fb5cc62..85bd76c 100644
--- a/xtables.c
+++ b/xtables.c
@@ -44,7 +44,8 @@
 #define PROC_SYS_MODPROBE "/proc/sys/kernel/modprobe"
 #endif
 
-char *lib_dir;
+/* Search path for Xtables .so files */
+static const char *xtables_libdir;
 
 /* the path to command to load kernel module */
 const char *xtables_modprobe_program;
@@ -53,6 +54,20 @@ const char *xtables_modprobe_program;
 struct xtables_match *xtables_matches;
 struct xtables_target *xtables_targets;
 
+void xtables_init(void)
+{
+	xtables_libdir = getenv("XTABLES_LIBDIR");
+	if (xtables_libdir != NULL)
+		return;
+	xtables_libdir = getenv("IPTABLES_LIB_DIR");
+	if (xtables_libdir != NULL) {
+		fprintf(stderr, "IPTABLES_LIB_DIR is deprecated, "
+		        "use XTABLES_LIBDIR.\n");
+		return;
+	}
+	xtables_libdir = XTABLES_LIBDIR;
+}
+
 /**
  * xtables_*alloc - wrappers that exit on failure
  */
@@ -398,7 +413,8 @@ xtables_find_match(const char *name, enum xtables_tryload tryload,
 
 #ifndef NO_SHARED_LIBS
 	if (!ptr && tryload != XTF_DONT_LOAD && tryload != XTF_DURING_LOAD) {
-		ptr = load_extension(lib_dir, afinfo.libprefix, name, false);
+		ptr = load_extension(xtables_libdir, afinfo.libprefix,
+		      name, false);
 
 		if (ptr == NULL && tryload == XTF_LOAD_MUST_SUCCEED)
 			exit_error(PARAMETER_PROBLEM,
@@ -457,7 +473,8 @@ xtables_find_target(const char *name, enum xtables_tryload tryload)
 
 #ifndef NO_SHARED_LIBS
 	if (!ptr && tryload != XTF_DONT_LOAD && tryload != XTF_DURING_LOAD) {
-		ptr = load_extension(lib_dir, afinfo.libprefix, name, true);
+		ptr = load_extension(xtables_libdir, afinfo.libprefix,
+		      name, true);
 
 		if (ptr == NULL && tryload == XTF_LOAD_MUST_SUCCEED)
 			exit_error(PARAMETER_PROBLEM,
-- 
1.6.1.2

