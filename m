From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 7/8] libxtables: symbol visibility
Date: Fri,  4 Feb 2011 14:08:53 +0100
Message-ID: <1296824935-4606-8-git-send-email-jengelh@medozas.de>
References: <1296824935-4606-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36784 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490Ab1BDNJE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:09:04 -0500
In-Reply-To: <1296824935-4606-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am                 |    4 +-
 configure.ac                |    2 +
 extensions/GNUmakefile.in   |    2 +-
 include/iptables/internal.h |    6 ++
 iptables.c                  |    2 +-
 m4/gcc4_visibility.m4       |   21 ++++++++
 xtables.c                   |  109 ++++++++++++++++++++++++-------------------
 7 files changed, 94 insertions(+), 52 deletions(-)
 create mode 100644 m4/gcc4_visibility.m4

diff --git a/Makefile.am b/Makefile.am
index cfccbf2..a560113 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -29,11 +29,11 @@ libiptc_libip6tc_la_LDFLAGS = -version-info 0:0:0 ${libiptc_LDFLAGS2}
 lib_LTLIBRARIES      += libxtables.la
 libxtables_la_SOURCES = xtables.c
 libxtables_la_LDFLAGS = -version-info ${libxtables_vcurrent}:0:${libxtables_vage}
+libxtables_la_CFLAGS  = ${AM_CFLAGS} ${GCC_FVISIBILITY_HIDDEN}
 if ENABLE_SHARED
-libxtables_la_CFLAGS  = ${AM_CFLAGS}
 libxtables_la_LIBADD  = -ldl
 else
-libxtables_la_CFLAGS  = ${AM_CFLAGS} -DNO_SHARED_LIBS=1
+libxtables_la_CFLAGS += -DNO_SHARED_LIBS=1
 libxtables_la_LIBADD  =
 endif
 
diff --git a/configure.ac b/configure.ac
index 94d5ab2..cba1dc5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -14,6 +14,8 @@ AM_PROG_CC_C_O
 AC_DISABLE_STATIC
 AM_PROG_LIBTOOL
 
+CHECK_GCC_FVISIBILITY
+
 AC_ARG_WITH([kernel],
 	AS_HELP_STRING([--with-kernel=PATH],
 	[Path to kernel source/build directory]),
diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 74a058c..899a52d 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -18,7 +18,7 @@ LDFLAGS        := @LDFLAGS@
 regular_CFLAGS := @regular_CFLAGS@
 kinclude_CFLAGS := @kinclude_CFLAGS@
 
-AM_CFLAGS      := ${regular_CFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CFLAGS}
+AM_CFLAGS      := ${regular_CFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CFLAGS} -I${top_builddir}
 AM_DEPFLAGS     = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 
 ifeq (${V},)
diff --git a/include/iptables/internal.h b/include/iptables/internal.h
index 531fe4f..89d11cb 100644
--- a/include/iptables/internal.h
+++ b/include/iptables/internal.h
@@ -3,6 +3,12 @@
 
 #include "config.h"
 
+#ifdef HAVE_VISIBILITY_HIDDEN
+#	define EXPORT_SYMBOL __attribute__((visibility("default")))
+#else
+#	define EXPORT_SYMBOL
+#endif
+
 #define IPTABLES_VERSION PACKAGE_VERSION
 
 /**
diff --git a/iptables.c b/iptables.c
index 504bcd8..1bc9d84 100644
--- a/iptables.c
+++ b/iptables.c
@@ -200,7 +200,7 @@ static const int inverse_for_options[NUMBER_OF_OPT] =
 #define prog_name iptables_globals.program_name
 #define prog_vers iptables_globals.program_version
 
-int kernel_version;
+EXPORT_SYMBOL int kernel_version;
 
 /* Primitive headers... */
 /* defined in netinet/in.h */
diff --git a/m4/gcc4_visibility.m4 b/m4/gcc4_visibility.m4
new file mode 100644
index 0000000..84959f3
--- /dev/null
+++ b/m4/gcc4_visibility.m4
@@ -0,0 +1,21 @@
+
+# GCC 4.x -fvisibility=hidden
+
+AC_DEFUN([CHECK_GCC_FVISIBILITY], [
+	AC_LANG_PUSH([C])
+	saved_CFLAGS="$CFLAGS"
+	CFLAGS="$saved_CFLAGS -fvisibility=hidden"
+	AC_CACHE_CHECK([whether compiler accepts -fvisibility=hidden],
+	  [ac_cv_fvisibility_hidden], AC_COMPILE_IFELSE(
+		AC_LANG_PROGRAM([], []),
+		[ac_cv_fvisibility_hidden=yes],
+		[ac_cv_fvisibility_hidden=no]
+	))
+	if test "$ac_cv_fvisibility_hidden" = "yes"; then
+		AC_DEFINE([HAVE_VISIBILITY_HIDDEN], [1],
+		  [True if compiler supports -fvisibility=hidden])
+		AC_SUBST([GCC_FVISIBILITY_HIDDEN], [-fvisibility=hidden])
+	fi
+	CFLAGS="$saved_CFLAGS"
+	AC_LANG_POP([C])
+])
diff --git a/xtables.c b/xtables.c
index fc59f75..4425f38 100644
--- a/xtables.c
+++ b/xtables.c
@@ -50,6 +50,7 @@
 #endif
 #include <getopt.h>
 #include "xshared.h"
+#include "iptables/internal.h"
 
 #define NPROTO	255
 
@@ -59,7 +60,7 @@
 
 void basic_exit_err(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 
-struct xtables_globals *xt_params = NULL;
+EXPORT_SYMBOL struct xtables_globals *xt_params;
 
 void basic_exit_err(enum xtables_exittype status, const char *msg, ...)
 {
@@ -73,7 +74,7 @@ void basic_exit_err(enum xtables_exittype status, const char *msg, ...)
 	exit(status);
 }
 
-void xtables_free_opts(int unused)
+EXPORT_SYMBOL void xtables_free_opts(int unused)
 {
 	if (xt_params->opts != xt_params->orig_opts) {
 		free(xt_params->opts);
@@ -81,10 +82,10 @@ void xtables_free_opts(int unused)
 	}
 }
 
-struct option *xtables_merge_options(struct option *orig_opts,
-				     struct option *oldopts,
-				     const struct option *newopts,
-				     unsigned int *option_offset)
+EXPORT_SYMBOL struct option *
+xtables_merge_options(struct option *orig_opts, struct option *oldopts,
+		      const struct option *newopts,
+		      unsigned int *option_offset)
 {
 	unsigned int num_oold = 0, num_old = 0, num_new = 0, i;
 	struct option *merge, *mp;
@@ -172,11 +173,11 @@ static const struct xtables_afinfo *afinfo;
 static const char *xtables_libdir;
 
 /* the path to command to load kernel module */
-const char *xtables_modprobe_program;
+EXPORT_SYMBOL const char *xtables_modprobe_program;
 
 /* Keeping track of external matches and targets: linked lists.  */
-struct xtables_match *xtables_matches;
-struct xtables_target *xtables_targets;
+EXPORT_SYMBOL struct xtables_match *xtables_matches;
+EXPORT_SYMBOL struct xtables_target *xtables_targets;
 
 void xtables_init(void)
 {
@@ -230,7 +231,7 @@ void xtables_set_nfproto(uint8_t nfproto)
  *
  * Returns -1 on failure to set and 0 on success
  */
-int xtables_set_params(struct xtables_globals *xtp)
+EXPORT_SYMBOL int xtables_set_params(struct xtables_globals *xtp)
 {
 	if (!xtp) {
 		fprintf(stderr, "%s: Illegal global params\n",__func__);
@@ -245,7 +246,8 @@ int xtables_set_params(struct xtables_globals *xtp)
 	return 0;
 }
 
-int xtables_init_all(struct xtables_globals *xtp, uint8_t nfproto)
+EXPORT_SYMBOL int
+xtables_init_all(struct xtables_globals *xtp, uint8_t nfproto)
 {
 	xtables_init();
 	xtables_set_nfproto(nfproto);
@@ -255,7 +257,7 @@ int xtables_init_all(struct xtables_globals *xtp, uint8_t nfproto)
 /**
  * xtables_*alloc - wrappers that exit on failure
  */
-void *xtables_calloc(size_t count, size_t size)
+EXPORT_SYMBOL void *xtables_calloc(size_t count, size_t size)
 {
 	void *p;
 
@@ -267,7 +269,7 @@ void *xtables_calloc(size_t count, size_t size)
 	return p;
 }
 
-void *xtables_malloc(size_t size)
+EXPORT_SYMBOL void *xtables_malloc(size_t size)
 {
 	void *p;
 
@@ -367,7 +369,7 @@ int xtables_insmod(const char *modname, const char *modprobe, bool quiet)
 	return -1;
 }
 
-int xtables_load_ko(const char *modprobe, bool quiet)
+EXPORT_SYMBOL int xtables_load_ko(const char *modprobe, bool quiet)
 {
 	static bool loaded = false;
 	static int ret = -1;
@@ -421,8 +423,9 @@ bool xtables_strtoul(const char *s, char **end, unsigned long *value,
 	return false;
 }
 
-bool xtables_strtoui(const char *s, char **end, unsigned int *value,
-                     unsigned int min, unsigned int max)
+EXPORT_SYMBOL bool
+xtables_strtoui(const char *s, char **end, unsigned int *value,
+		unsigned int min, unsigned int max)
 {
 	unsigned long v;
 	bool ret;
@@ -433,7 +436,7 @@ bool xtables_strtoui(const char *s, char **end, unsigned int *value,
 	return ret;
 }
 
-int xtables_service_to_port(const char *name, const char *proto)
+EXPORT_SYMBOL int xtables_service_to_port(const char *name, const char *proto)
 {
 	struct servent *service;
 
@@ -443,7 +446,7 @@ int xtables_service_to_port(const char *name, const char *proto)
 	return -1;
 }
 
-uint16_t xtables_parse_port(const char *port, const char *proto)
+EXPORT_SYMBOL uint16_t xtables_parse_port(const char *port, const char *proto)
 {
 	unsigned int portnum;
 
@@ -455,8 +458,8 @@ uint16_t xtables_parse_port(const char *port, const char *proto)
 		   "invalid port/service `%s' specified", port);
 }
 
-void xtables_parse_interface(const char *arg, char *vianame,
-			     unsigned char *mask)
+EXPORT_SYMBOL void
+xtables_parse_interface(const char *arg, char *vianame, unsigned char *mask)
 {
 	unsigned int vialen = strlen(arg);
 	unsigned int i;
@@ -547,7 +550,7 @@ static void *load_extension(const char *search_path, const char *af_prefix,
 }
 #endif
 
-struct xtables_match *
+EXPORT_SYMBOL struct xtables_match *
 xtables_find_match(const char *name, enum xtables_tryload tryload,
 		   struct xtables_rule_match **matches)
 {
@@ -628,7 +631,7 @@ xtables_find_match(const char *name, enum xtables_tryload tryload,
 	return ptr;
 }
 
-struct xtables_target *
+EXPORT_SYMBOL struct xtables_target *
 xtables_find_target(const char *name, enum xtables_tryload tryload)
 {
 	struct xtables_target *ptr;
@@ -744,7 +747,7 @@ static void xtables_check_options(const char *name, const struct option *opt)
 		}
 }
 
-void xtables_register_match(struct xtables_match *me)
+EXPORT_SYMBOL void xtables_register_match(struct xtables_match *me)
 {
 	struct xtables_match **i, *old;
 
@@ -825,14 +828,15 @@ void xtables_register_match(struct xtables_match *me)
 	me->mflags = 0;
 }
 
-void xtables_register_matches(struct xtables_match *match, unsigned int n)
+EXPORT_SYMBOL void
+xtables_register_matches(struct xtables_match *match, unsigned int n)
 {
 	do {
 		xtables_register_match(&match[--n]);
 	} while (n > 0);
 }
 
-void xtables_register_target(struct xtables_target *me)
+EXPORT_SYMBOL void xtables_register_target(struct xtables_target *me)
 {
 	struct xtables_target *old;
 
@@ -913,7 +917,8 @@ void xtables_register_target(struct xtables_target *me)
 	me->tflags = 0;
 }
 
-void xtables_register_targets(struct xtables_target *target, unsigned int n)
+EXPORT_SYMBOL void
+xtables_register_targets(struct xtables_target *target, unsigned int n)
 {
 	do {
 		xtables_register_target(&target[--n]);
@@ -944,7 +949,7 @@ void xtables_register_targets(struct xtables_target *target, unsigned int n)
  *
  * Displays an error message and exits the program.
  */
-void xtables_param_act(unsigned int status, const char *p1, ...)
+EXPORT_SYMBOL void xtables_param_act(unsigned int status, const char *p1, ...)
 {
 	const char *p2, *p3;
 	va_list args;
@@ -992,7 +997,8 @@ void xtables_param_act(unsigned int status, const char *p1, ...)
 	va_end(args);
 }
 
-const char *xtables_ipaddr_to_numeric(const struct in_addr *addrp)
+EXPORT_SYMBOL const char *
+xtables_ipaddr_to_numeric(const struct in_addr *addrp)
 {
 	static char buf[20];
 	const unsigned char *bytep = (const void *)&addrp->s_addr;
@@ -1022,7 +1028,7 @@ static const char *ipaddr_to_network(const struct in_addr *addr)
 	return NULL;
 }
 
-const char *xtables_ipaddr_to_anyname(const struct in_addr *addr)
+EXPORT_SYMBOL const char *xtables_ipaddr_to_anyname(const struct in_addr *addr)
 {
 	const char *name;
 
@@ -1033,7 +1039,7 @@ const char *xtables_ipaddr_to_anyname(const struct in_addr *addr)
 	return xtables_ipaddr_to_numeric(addr);
 }
 
-const char *xtables_ipmask_to_numeric(const struct in_addr *mask)
+EXPORT_SYMBOL const char *xtables_ipmask_to_numeric(const struct in_addr *mask)
 {
 	static char buf[20];
 	uint32_t maskaddr, bits;
@@ -1104,12 +1110,12 @@ static struct in_addr *__numeric_to_ipaddr(const char *dotted, bool is_mask)
 	return &addr;
 }
 
-struct in_addr *xtables_numeric_to_ipaddr(const char *dotted)
+EXPORT_SYMBOL struct in_addr *xtables_numeric_to_ipaddr(const char *dotted)
 {
 	return __numeric_to_ipaddr(dotted, false);
 }
 
-struct in_addr *xtables_numeric_to_ipmask(const char *dotted)
+EXPORT_SYMBOL struct in_addr *xtables_numeric_to_ipmask(const char *dotted)
 {
 	return __numeric_to_ipaddr(dotted, true);
 }
@@ -1197,8 +1203,9 @@ static struct in_addr *parse_ipmask(const char *mask)
 	return &maskaddr;
 }
 
-void xtables_ipparse_multiple(const char *name, struct in_addr **addrpp,
-                              struct in_addr **maskpp, unsigned int *naddrs)
+EXPORT_SYMBOL void
+xtables_ipparse_multiple(const char *name, struct in_addr **addrpp,
+			 struct in_addr **maskpp, unsigned int *naddrs)
 {
 	struct in_addr *addrp;
 	char buf[256], *p;
@@ -1284,8 +1291,9 @@ void xtables_ipparse_multiple(const char *name, struct in_addr **addrpp,
  * 	m{^($hostname|$networkname|$ipaddr)(/$mask)?}
  * "1.2.3.4/5", "1.2.3.4", "hostname", "networkname"
  */
-void xtables_ipparse_any(const char *name, struct in_addr **addrpp,
-                         struct in_addr *maskp, unsigned int *naddrs)
+EXPORT_SYMBOL void
+xtables_ipparse_any(const char *name, struct in_addr **addrpp,
+		    struct in_addr *maskp, unsigned int *naddrs)
 {
 	unsigned int i, j, k, n;
 	struct in_addr *addrp;
@@ -1318,7 +1326,8 @@ void xtables_ipparse_any(const char *name, struct in_addr **addrpp,
 	}
 }
 
-const char *xtables_ip6addr_to_numeric(const struct in6_addr *addrp)
+EXPORT_SYMBOL const char *
+xtables_ip6addr_to_numeric(const struct in6_addr *addrp)
 {
 	/* 0000:0000:0000:0000:0000:000.000.000.000
 	 * 0000:0000:0000:0000:0000:0000:0000:0000 */
@@ -1351,7 +1360,8 @@ static const char *ip6addr_to_host(const struct in6_addr *addr)
 	return hostname;
 }
 
-const char *xtables_ip6addr_to_anyname(const struct in6_addr *addr)
+EXPORT_SYMBOL const char *
+xtables_ip6addr_to_anyname(const struct in6_addr *addr)
 {
 	const char *name;
 
@@ -1385,7 +1395,8 @@ static int ip6addr_prefix_length(const struct in6_addr *k)
 	return bits;
 }
 
-const char *xtables_ip6mask_to_numeric(const struct in6_addr *addrp)
+EXPORT_SYMBOL const char *
+xtables_ip6mask_to_numeric(const struct in6_addr *addrp)
 {
 	static char buf[50+2];
 	int l = ip6addr_prefix_length(addrp);
@@ -1399,7 +1410,7 @@ const char *xtables_ip6mask_to_numeric(const struct in6_addr *addrp)
 	return buf;
 }
 
-struct in6_addr *xtables_numeric_to_ip6addr(const char *num)
+EXPORT_SYMBOL struct in6_addr *xtables_numeric_to_ip6addr(const char *num)
 {
 	static struct in6_addr ap;
 	int err;
@@ -1508,7 +1519,7 @@ static struct in6_addr *parse_ip6mask(char *mask)
 	return &maskaddr;
 }
 
-void
+EXPORT_SYMBOL void
 xtables_ip6parse_multiple(const char *name, struct in6_addr **addrpp,
 		      struct in6_addr **maskpp, unsigned int *naddrs)
 {
@@ -1592,8 +1603,9 @@ xtables_ip6parse_multiple(const char *name, struct in6_addr **addrpp,
 			(*addrpp+i)->s6_addr32[j] &= (*maskpp+i)->s6_addr32[j];
 }
 
-void xtables_ip6parse_any(const char *name, struct in6_addr **addrpp,
-                          struct in6_addr *maskp, unsigned int *naddrs)
+EXPORT_SYMBOL void
+xtables_ip6parse_any(const char *name, struct in6_addr **addrpp,
+		     struct in6_addr *maskp, unsigned int *naddrs)
 {
 	static const struct in6_addr zero_addr;
 	struct in6_addr *addrp;
@@ -1629,7 +1641,7 @@ void xtables_ip6parse_any(const char *name, struct in6_addr **addrpp,
 	}
 }
 
-void xtables_save_string(const char *value)
+EXPORT_SYMBOL void xtables_save_string(const char *value)
 {
 	static const char no_quote_chars[] = "_-0123456789"
 		"abcdefghijklmnopqrstuvwxyz"
@@ -1670,8 +1682,9 @@ void xtables_save_string(const char *value)
  * Check for option-intrapositional negation.
  * Do not use in new code.
  */
-int xtables_check_inverse(const char option[], int *invert,
-			  int *my_optind, int argc, char **argv)
+EXPORT_SYMBOL int
+xtables_check_inverse(const char *option, int *invert, int *my_optind,
+		      int argc, char **argv)
 {
 	if (option == NULL || strcmp(option, "!") != 0)
 		return false;
@@ -1695,7 +1708,7 @@ int xtables_check_inverse(const char option[], int *invert,
 	return true;
 }
 
-const struct xtables_pprot xtables_chain_protos[] = {
+EXPORT_SYMBOL const struct xtables_pprot xtables_chain_protos[] = {
 	{"tcp",       IPPROTO_TCP},
 	{"sctp",      IPPROTO_SCTP},
 	{"udp",       IPPROTO_UDP},
@@ -1711,7 +1724,7 @@ const struct xtables_pprot xtables_chain_protos[] = {
 	{NULL},
 };
 
-uint16_t
+EXPORT_SYMBOL uint16_t
 xtables_parse_protocol(const char *s)
 {
 	unsigned int proto;
-- 
1.7.1

