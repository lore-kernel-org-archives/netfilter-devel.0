From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 03/13] xtables.h: move non-exported parts to internal.h
Date: Thu, 10 Apr 2008 09:38:08 +0200
Message-ID: <d9eeb7296c3dcc442cf64e79e6c5bfd7e66ceea0.1207813085.git.jengelh@computergmbh.de>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50172 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbYDJHiT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2008 03:38:19 -0400
In-Reply-To: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
In-Reply-To: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A number of enums, structs, functions are not used by modules, so
they do not need exporting.
---
 include/xtables.h          |   61 ------------------------------------
 include/xtables/internal.h |   60 +++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 61 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index 157f355..5eba8ac 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -7,10 +7,6 @@
 #include <libiptc/libxtc.h>
 #include <stdbool.h>
 
-#ifndef XT_LIB_DIR
-#define XT_LIB_DIR "/usr/local/lib/iptables"
-#endif
-
 #ifndef IPPROTO_SCTP
 #define IPPROTO_SCTP 132
 #endif
@@ -21,43 +17,6 @@
 #define IPPROTO_UDPLITE	136
 #endif
 
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
-enum xt_tryload {
-	DONT_LOAD,
-	DURING_LOAD,
-	TRY_LOAD,
-	LOAD_MUST_SUCCEED
-};
-
-struct xtables_rule_match
-{
-	struct xtables_rule_match *next;
-	struct xtables_match *match;
-	/* Multiple matches of the same type: the ones before
-	   the current one are completed from parsing point of view */
-	unsigned int completed;
-};
-
 /* Include file for additions: new matches and targets. */
 struct xtables_match
 {
@@ -171,30 +130,10 @@ struct xtables_target
 #endif
 };
 
-extern char *lib_dir;
-
-extern void *fw_calloc(size_t count, size_t size);
-extern void *fw_malloc(size_t size);
-
-extern const char *modprobe_program;
-extern int xtables_insmod(const char *modname, const char *modprobe, int quiet);
-extern int load_xtables_ko(const char *modprobe, int quiet);
-
-/* This is decleared in ip[6]tables.c */
-extern struct afinfo afinfo;
-
-/* Keeping track of external matches and targets: linked lists.  */
-extern struct xtables_match *xtables_matches;
-extern struct xtables_target *xtables_targets;
-
 /* Your shared library should call one of these. */
 extern void xtables_register_match(struct xtables_match *me);
 extern void xtables_register_target(struct xtables_target *me);
 
-extern struct xtables_match *find_match(const char *name, enum xt_tryload,
-					struct xtables_rule_match **match);
-extern struct xtables_target *find_target(const char *name, enum xt_tryload);
-
 extern int string_to_number_ll(const char *s,
 			       unsigned long long min,
 			       unsigned long long max,
diff --git a/include/xtables/internal.h b/include/xtables/internal.h
index 3be72e3..24a5078 100644
--- a/include/xtables/internal.h
+++ b/include/xtables/internal.h
@@ -1,6 +1,66 @@
 #ifndef _XTABLES_INTERNAL_H
 #define _XTABLES_INTERNAL_H 1
 
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
+enum xt_tryload {
+	DONT_LOAD,
+	DURING_LOAD,
+	TRY_LOAD,
+	LOAD_MUST_SUCCEED
+};
+
+struct xtables_rule_match {
+	struct xtables_rule_match *next;
+	struct xtables_match *match;
+	/* Multiple matches of the same type: the ones before
+	   the current one are completed from parsing point of view */
+	unsigned int completed;
+};
+
+extern char *lib_dir;
+
+extern void *fw_calloc(size_t count, size_t size);
+extern void *fw_malloc(size_t size);
+
+extern const char *modprobe_program;
+extern int xtables_insmod(const char *modname, const char *modprobe, int quiet);
+extern int load_xtables_ko(const char *modprobe, int quiet);
+
+/* This is decleared in ip[6]tables.c */
+extern struct afinfo afinfo;
+
+/* Keeping track of external matches and targets: linked lists.  */
+extern struct xtables_match *xtables_matches;
+extern struct xtables_target *xtables_targets;
+
+extern struct xtables_match *find_match(const char *name, enum xt_tryload,
+					struct xtables_rule_match **match);
+extern struct xtables_target *find_target(const char *name, enum xt_tryload);
+
 extern void _init(void);
 
 #endif /* _XTABLES_INTERNAL_H */
-- 
1.5.5.rc3

