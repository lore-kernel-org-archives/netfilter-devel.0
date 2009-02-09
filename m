From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 16/16] libxtables: move afinfo around
Date: Mon,  9 Feb 2009 18:35:00 +0100
Message-ID: <1234200900-5964-17-git-send-email-jengelh@medozas.de>
References: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51475 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbZBIRfH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:35:07 -0500
In-Reply-To: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libxtables should not rely on the program executable providing the
magic constants for using [gs]etsockopt.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in          |    1 +
 include/xtables/internal.h.in |   24 -------------
 ip6tables-restore.c           |    1 +
 ip6tables-save.c              |    1 +
 ip6tables-standalone.c        |    1 +
 ip6tables.c                   |    9 -----
 iptables-restore.c            |    1 +
 iptables-save.c               |    1 +
 iptables-standalone.c         |    1 +
 iptables.c                    |    9 -----
 xtables.c                     |   74 +++++++++++++++++++++++++++++++++++-----
 11 files changed, 71 insertions(+), 52 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 07217d6..02750fb 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -189,6 +189,7 @@ extern struct xtables_match *xtables_matches;
 extern struct xtables_target *xtables_targets;
 
 extern void xtables_init(void);
+extern void xtables_set_nfproto(uint8_t);
 extern void *xtables_calloc(size_t, size_t);
 extern void *xtables_malloc(size_t);
 
diff --git a/include/xtables/internal.h.in b/include/xtables/internal.h.in
index 2143829..81ddb48 100644
--- a/include/xtables/internal.h.in
+++ b/include/xtables/internal.h.in
@@ -7,30 +7,6 @@
 #	define XT_LIB_DIR "/usr/local/lib/iptables"
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
-/* This is decleared in ip[6]tables.c */
-extern struct afinfo afinfo;
-
 /**
  * Program's own name and version.
  */
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index beb640b..acaf97b 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -132,6 +132,7 @@ int main(int argc, char *argv[])
 
 	xtables_program_name = program_name;
 	xtables_init();
+	xtables_set_nfproto(NFPROTO_IPV6);
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/ip6tables-save.c b/ip6tables-save.c
index 86ec6b2..32b5992 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -141,6 +141,7 @@ int main(int argc, char *argv[])
 
 	xtables_program_name = program_name;
 	xtables_init();
+	xtables_set_nfproto(NFPROTO_IPV6);
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/ip6tables-standalone.c b/ip6tables-standalone.c
index 3ab114e..cea4818 100644
--- a/ip6tables-standalone.c
+++ b/ip6tables-standalone.c
@@ -54,6 +54,7 @@ main(int argc, char *argv[])
 
 	xtables_program_name = program_name;
 	xtables_init();
+	xtables_set_nfproto(NFPROTO_IPV6);
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/ip6tables.c b/ip6tables.c
index 53163b7..233974f 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -199,15 +199,6 @@ struct pprot {
 	u_int8_t num;
 };
 
-struct afinfo afinfo = {
-	.family		= NFPROTO_IPV6,
-	.libprefix	= "libip6t_",
-	.ipproto	= IPPROTO_IPV6,
-	.kmod		= "ip6_tables",
-	.so_rev_match	= IP6T_SO_GET_REVISION_MATCH,
-	.so_rev_target	= IP6T_SO_GET_REVISION_TARGET,
-};
-
 static const char *
 proto_to_name(u_int8_t proto, int nolookup)
 {
diff --git a/iptables-restore.c b/iptables-restore.c
index 56812ee..810806f 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -134,6 +134,7 @@ main(int argc, char *argv[])
 
 	xtables_program_name = program_name;
 	xtables_init();
+	xtables_set_nfproto(NFPROTO_IPV4);
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/iptables-save.c b/iptables-save.c
index d08ec4b..c4306fd 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -141,6 +141,7 @@ main(int argc, char *argv[])
 
 	xtables_program_name = program_name;
 	xtables_init();
+	xtables_set_nfproto(NFPROTO_IPV4);
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/iptables-standalone.c b/iptables-standalone.c
index 9190873..ece7cf4 100644
--- a/iptables-standalone.c
+++ b/iptables-standalone.c
@@ -55,6 +55,7 @@ main(int argc, char *argv[])
 
 	xtables_program_name = program_name;
 	xtables_init();
+	xtables_set_nfproto(NFPROTO_IPV4);
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
diff --git a/iptables.c b/iptables.c
index b43aadf..f1a5d33 100644
--- a/iptables.c
+++ b/iptables.c
@@ -194,15 +194,6 @@ const char *program_name;
 
 int kernel_version;
 
-struct afinfo afinfo = {
-	.family		= NFPROTO_IPV4,
-	.libprefix	= "libipt_",
-	.ipproto	= IPPROTO_IP,
-	.kmod		= "ip_tables",
-	.so_rev_match	= IPT_SO_GET_REVISION_MATCH,
-	.so_rev_target	= IPT_SO_GET_REVISION_TARGET,
-};
-
 /* Primitive headers... */
 /* defined in netinet/in.h */
 #if 0
diff --git a/xtables.c b/xtables.c
index cf64352..6c95475 100644
--- a/xtables.c
+++ b/xtables.c
@@ -32,7 +32,8 @@
 #include <arpa/inet.h>
 
 #include <xtables.h>
-#include <ip6tables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
 #include <libiptc/libxtc.h>
 
 #ifndef NO_SHARED_LIBS
@@ -46,6 +47,44 @@
 #endif
 
 /**
+ * xtables_afinfo - protocol family dependent information
+ * @kmod:		kernel module basename (e.g. "ip_tables")
+ * @libprefix:		prefix of .so library name (e.g. "libipt_")
+ * @family:		nfproto family
+ * @ipproto:		used by setsockopt (e.g. IPPROTO_IP)
+ * @so_rev_match:	optname to check revision support of match
+ * @so_rev_target:	optname to check revision support of target
+ */
+struct xtables_afinfo {
+	const char *kmod;
+	const char *libprefix;
+	uint8_t family;
+	uint8_t ipproto;
+	int so_rev_match;
+	int so_rev_target;
+};
+
+static const struct xtables_afinfo afinfo_ipv4 = {
+	.kmod          = "ip_tables",
+	.libprefix     = "libipt_",
+	.family	       = NFPROTO_IPV4,
+	.ipproto       = IPPROTO_IP,
+	.so_rev_match  = IPT_SO_GET_REVISION_MATCH,
+	.so_rev_target = IPT_SO_GET_REVISION_TARGET,
+};
+
+static const struct xtables_afinfo afinfo_ipv6 = {
+	.kmod          = "ip6_tables",
+	.libprefix     = "libip6t_",
+	.family        = NFPROTO_IPV6,
+	.ipproto       = IPPROTO_IPV6,
+	.so_rev_match  = IP6T_SO_GET_REVISION_MATCH,
+	.so_rev_target = IP6T_SO_GET_REVISION_TARGET,
+};
+
+static const struct xtables_afinfo *afinfo;
+
+/**
  * Program will set this to its own name.
  */
 const char *xtables_program_name;
@@ -74,6 +113,21 @@ void xtables_init(void)
 	xtables_libdir = XTABLES_LIBDIR;
 }
 
+void xtables_set_nfproto(uint8_t nfproto)
+{
+	switch (nfproto) {
+	case NFPROTO_IPV4:
+		afinfo = &afinfo_ipv4;
+		break;
+	case NFPROTO_IPV6:
+		afinfo = &afinfo_ipv6;
+		break;
+	default:
+		fprintf(stderr, "libxtables: unhandled NFPROTO in %s\n",
+		        __func__);
+	}
+}
+
 /**
  * xtables_*alloc - wrappers that exit on failure
  */
@@ -177,7 +231,7 @@ int xtables_load_ko(const char *modprobe, bool quiet)
 	static int ret = -1;
 
 	if (!loaded) {
-		ret = xtables_insmod(afinfo.kmod, modprobe, quiet);
+		ret = xtables_insmod(afinfo->kmod, modprobe, quiet);
 		loaded = (ret == 0);
 	}
 
@@ -387,7 +441,7 @@ xtables_find_match(const char *name, enum xtables_tryload tryload,
 
 #ifndef NO_SHARED_LIBS
 	if (!ptr && tryload != XTF_DONT_LOAD && tryload != XTF_DURING_LOAD) {
-		ptr = load_extension(xtables_libdir, afinfo.libprefix,
+		ptr = load_extension(xtables_libdir, afinfo->libprefix,
 		      name, false);
 
 		if (ptr == NULL && tryload == XTF_LOAD_MUST_SUCCEED)
@@ -447,7 +501,7 @@ xtables_find_target(const char *name, enum xtables_tryload tryload)
 
 #ifndef NO_SHARED_LIBS
 	if (!ptr && tryload != XTF_DONT_LOAD && tryload != XTF_DURING_LOAD) {
-		ptr = load_extension(xtables_libdir, afinfo.libprefix,
+		ptr = load_extension(xtables_libdir, afinfo->libprefix,
 		      name, true);
 
 		if (ptr == NULL && tryload == XTF_LOAD_MUST_SUCCEED)
@@ -480,7 +534,7 @@ static int compatible_revision(const char *name, u_int8_t revision, int opt)
 	socklen_t s = sizeof(rev);
 	int max_rev, sockfd;
 
-	sockfd = socket(afinfo.family, SOCK_RAW, IPPROTO_RAW);
+	sockfd = socket(afinfo->family, SOCK_RAW, IPPROTO_RAW);
 	if (sockfd < 0) {
 		if (errno == EPERM) {
 			/* revision 0 is always supported. */
@@ -501,7 +555,7 @@ static int compatible_revision(const char *name, u_int8_t revision, int opt)
 	strcpy(rev.name, name);
 	rev.revision = revision;
 
-	max_rev = getsockopt(sockfd, afinfo.ipproto, opt, &rev, &s);
+	max_rev = getsockopt(sockfd, afinfo->ipproto, opt, &rev, &s);
 	if (max_rev < 0) {
 		/* Definitely don't support this? */
 		if (errno == ENOENT || errno == EPROTONOSUPPORT) {
@@ -524,12 +578,12 @@ static int compatible_revision(const char *name, u_int8_t revision, int opt)
 
 static int compatible_match_revision(const char *name, u_int8_t revision)
 {
-	return compatible_revision(name, revision, afinfo.so_rev_match);
+	return compatible_revision(name, revision, afinfo->so_rev_match);
 }
 
 static int compatible_target_revision(const char *name, u_int8_t revision)
 {
-	return compatible_revision(name, revision, afinfo.so_rev_target);
+	return compatible_revision(name, revision, afinfo->so_rev_target);
 }
 
 void xtables_register_match(struct xtables_match *me)
@@ -559,7 +613,7 @@ void xtables_register_match(struct xtables_match *me)
 	}
 
 	/* ignore not interested match */
-	if (me->family != afinfo.family && me->family != AF_UNSPEC)
+	if (me->family != afinfo->family && me->family != AF_UNSPEC)
 		return;
 
 	old = xtables_find_match(me->name, XTF_DURING_LOAD, NULL);
@@ -632,7 +686,7 @@ void xtables_register_target(struct xtables_target *me)
 	}
 
 	/* ignore not interested target */
-	if (me->family != afinfo.family && me->family != AF_UNSPEC)
+	if (me->family != afinfo->family && me->family != AF_UNSPEC)
 		return;
 
 	old = xtables_find_target(me->name, XTF_DURING_LOAD);
-- 
1.6.1.2

