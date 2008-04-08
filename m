From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 06/24] Fix all remaining warnings (missing declarations,
 missing prototypes)
Date: Tue, 8 Apr 2008 18:14:08 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804081809320.2229@fbirervta.pbzchgretzou.qr>
References: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de> <d9e426312f2513c8d719a8ca65c50d3bde57a10b.1207495183.git.jengelh@computergmbh.de> <47F8EF28.1000801@trash.net> <alpine.LNX.1.10.0804081640050.2229@fbirervta.pbzchgretzou.qr>
 <47FB8F97.7000406@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44905 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbYDHQOK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:14:10 -0400
In-Reply-To: <47FB8F97.7000406@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2008-04-08 17:30, Patrick McHardy wrote:
> I meant something like:

> include/x_tables.h:
>
> extern void _init(void);
> extern void _exit(void);
>
> Actually this should really be defined by gcc in my opinion.

man dlopen => says _init and _exit (in their original meaning) are obsolete.


Anyway, it's just a name. Patch below. Though include/xtables/internal.h
is just small, I plan on moving more defs in there soonish.
Rationale behind that is that external packages like Xtables-addons
really only needs xtables.h and not the internal(.h) pieces. Okay?


===
commit 45679164d6bf17f0e66d6213796a02698ae42a28
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Mon Feb 11 00:54:00 2008 +0100

    Fix all remaining warnings (missing declarations, missing prototypes)
---
 configure.ac                |    6 +-----
 extensions/GNUmakefile.in   |    2 ++
 extensions/libip6t_policy.c |    5 -----
 extensions/libipt_ULOG.c    |    2 +-
 include/iptables.h          |    2 --
 include/libiptc/libip6tc.h  |    2 ++
 include/libiptc/libiptc.h   |    2 ++
 include/xtables.h           |    7 +++++++
 include/xtables/internal.h  |    6 ++++++
 ip6tables-multi.h           |    8 ++++++++
 ip6tables-restore.c         |    4 +++-
 ip6tables-save.c            |    1 +
 ip6tables-standalone.c      |    1 +
 ip6tables.c                 |    6 ++----
 iptables-multi.h            |    9 +++++++++
 iptables-restore.c          |    3 ++-
 iptables-save.c             |    1 +
 iptables-standalone.c       |    1 +
 iptables-xml.c              |    1 +
 iptables.c                  |    4 +---
 libiptc/libiptc.c           |    9 ++++-----
 21 files changed, 55 insertions(+), 27 deletions(-)
 create mode 100644 include/xtables/internal.h
 create mode 100644 ip6tables-multi.h
 create mode 100644 iptables-multi.h

diff --git a/configure.ac b/configure.ac
index 87fca6c..c816b2e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -41,13 +41,9 @@ regular_CFLAGS="-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 \
 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
 	-Winline -pipe -DIPTABLES_VERSION=\\\"$PACKAGE_VERSION\\\" \
 	-DIPT_LIB_DIR=\\\"\${iptdir}\\\" -DIP6T_LIB_DIR=\\\"\${iptdir}\\\"";
+regular_CFLAGS="$regular_CFLAGS -DXTABLES_INTERNAL"
 kinclude_CFLAGS="-I\"$kbuilddir/include\" -I\"$ksourcedir/include\"";
 
-# Remove workarounds soon
-regular_CFLAGS="$regular_CFLAGS -Wno-aggregate-return \
-	-Wno-missing-declarations -Wno-missing-prototypes \
-        -Wno-unused-parameter"
-
 AC_SUBST([regular_CFLAGS kinclude_CFLAGS])
 AC_SUBST([kbuilddir])
 AC_SUBST([ksourcedir])
diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 4892409..cf094f2 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -143,6 +143,7 @@ initext4.c: .initext4.dd
 	for i in ${initext_func}; do \
 		echo "extern void lib$${i}_init(void);" >>$@; \
 	done; \
+	echo -en "void init_extensions(void);\n" >>$@; \
 	echo -en "void init_extensions(void)\n""{\n" >>$@; \
 	for i in ${initext_func}; do \
 		echo -e "\t""lib$${i}_init();" >>$@; \
@@ -157,6 +158,7 @@ initext6.c: .initext6.dd
 	for i in ${initext6_func}; do \
 		echo "extern void lib$${i}_init(void);" >>$@; \
 	done; \
+	echo -en "void init_extensions(void);\n" >>$@; \
 	echo -en "void init_extensions(void)\n""{\n" >>$@; \
 	for i in ${initext6_func}; do \
 		echo -e "\t""lib$${i}_init();" >>$@; \
diff --git a/extensions/libip6t_policy.c b/extensions/libip6t_policy.c
index f706f98..41e5c32 100644
--- a/extensions/libip6t_policy.c
+++ b/extensions/libip6t_policy.c
@@ -126,11 +126,6 @@ mask_to_numeric(const struct in6_addr *addrp)
 	return buf;
 }
 
-/* These should be in include/ip6tables.h... */
-extern u_int16_t parse_protocol(const char *s);
-
-/* End duplicated code from ip6tables.c */
-
 static int parse_direction(char *s)
 {
 	if (strcmp(s, "in") == 0)
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index 6fb2c66..31990a6 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -21,7 +21,7 @@
 #include "../include/linux/netfilter_ipv4/ipt_ULOG.h"
 
 
-void print_groups(unsigned int gmask)
+static void print_groups(unsigned int gmask)
 {
 	int b;
 	unsigned int test;
diff --git a/include/iptables.h b/include/iptables.h
index f39410c..7ce9080 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -24,8 +24,6 @@ extern int line;
 extern void register_match(struct iptables_match *me);
 extern void register_target(struct iptables_target *me);
 
-extern u_int16_t parse_protocol(const char *s);
-
 extern int do_command(int argc, char *argv[], char **table,
 		      iptc_handle_t *handle);
 extern int delete_chain(const ipt_chainlabel chain, int verbose,
diff --git a/include/libiptc/libip6tc.h b/include/libiptc/libip6tc.h
index 5069689..6e8a565 100644
--- a/include/libiptc/libip6tc.h
+++ b/include/libiptc/libip6tc.h
@@ -152,4 +152,6 @@ const char *ip6tc_strerror(int err);
 /* Return prefix length, or -1 if not contiguous */
 int ipv6_prefix_length(const struct in6_addr *a);
 
+extern void dump_entries6(const ip6tc_handle_t);
+
 #endif /* _LIBIP6TC_H */
diff --git a/include/libiptc/libiptc.h b/include/libiptc/libiptc.h
index 30f5b7d..1f6f95d 100644
--- a/include/libiptc/libiptc.h
+++ b/include/libiptc/libiptc.h
@@ -159,6 +159,8 @@ int iptc_get_raw_socket(void);
 /* Translates errno numbers into more human-readable form than strerror. */
 const char *iptc_strerror(int err);
 
+extern void dump_entries(const iptc_handle_t);
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/include/xtables.h b/include/xtables.h
index 4b75e2c..157f355 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -267,4 +267,11 @@ extern void save_string(const char *value);
 #	define _init __attribute__((constructor)) _INIT
 #endif
 
+/* Present in both iptables.c and ip6tables.c */
+extern u_int16_t parse_protocol(const char *s);
+
+#ifdef XTABLES_INTERNAL
+#	include <xtables/internal.h>
+#endif
+
 #endif /* _XTABLES_H */
diff --git a/include/xtables/internal.h b/include/xtables/internal.h
new file mode 100644
index 0000000..3be72e3
--- /dev/null
+++ b/include/xtables/internal.h
@@ -0,0 +1,6 @@
+#ifndef _XTABLES_INTERNAL_H
+#define _XTABLES_INTERNAL_H 1
+
+extern void _init(void);
+
+#endif /* _XTABLES_INTERNAL_H */
diff --git a/ip6tables-multi.h b/ip6tables-multi.h
new file mode 100644
index 0000000..551029a
--- /dev/null
+++ b/ip6tables-multi.h
@@ -0,0 +1,8 @@
+#ifndef _IP6TABLES_MULTI_H
+#define _IP6TABLES_MULTI_H 1
+
+extern int ip6tables_main(int, char **);
+extern int ip6tables_save_main(int, char **);
+extern int ip6tables_restore_main(int, char **);
+
+#endif /* _IP6TABLES_MULTI_H */
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 570bd51..e9cc0ff 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -18,6 +18,7 @@
 #include "ip6tables.h"
 #include "xtables.h"
 #include "libiptc/libip6tc.h"
+#include "ip6tables-multi.h"
 
 #ifdef DEBUG
 #define DEBUGP(x, args...) fprintf(stderr, x, ## args)
@@ -55,7 +56,8 @@ static void print_usage(const char *name, const char *version)
 	exit(1);
 }
 
-ip6tc_handle_t create_handle(const char *tablename, const char* modprobe)
+static ip6tc_handle_t create_handle(const char *tablename,
+                                    const char *modprobe)
 {
 	ip6tc_handle_t handle;
 
diff --git a/ip6tables-save.c b/ip6tables-save.c
index c73d354..e7eade1 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -16,6 +16,7 @@
 #include <arpa/inet.h>
 #include "libiptc/libip6tc.h"
 #include "ip6tables.h"
+#include "ip6tables-multi.h"
 
 #ifndef NO_SHARED_LIBS
 #include <dlfcn.h>
diff --git a/ip6tables-standalone.c b/ip6tables-standalone.c
index b7dfd17..4029c1f 100644
--- a/ip6tables-standalone.c
+++ b/ip6tables-standalone.c
@@ -35,6 +35,7 @@
 #include <stdlib.h>
 #include <errno.h>
 #include <ip6tables.h>
+#include "ip6tables-multi.h"
 
 #ifdef IPTABLES_MULTI
 int
diff --git a/ip6tables.c b/ip6tables.c
index 4b517e5..e5602f7 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -41,6 +41,7 @@
 #include <fcntl.h>
 #include <sys/types.h>
 #include <sys/socket.h>
+#include "ip6tables-multi.h"
 
 #ifndef TRUE
 #define TRUE 1
@@ -186,9 +187,6 @@ static int inverse_for_options[NUMBER_OF_OPT] =
 const char *program_version;
 const char *program_name;
 
-/* Extra debugging from libiptc */
-extern void dump_entries6(const ip6tc_handle_t handle);
-
 /* A few hardcoded protocols for 'all' and in case the user has no
    /etc/protocols */
 struct pprot {
@@ -1140,7 +1138,7 @@ generate_entry(const struct ip6t_entry *fw,
 	return e;
 }
 
-void clear_rule_matches(struct ip6tables_rule_match **matches)
+static void clear_rule_matches(struct ip6tables_rule_match **matches)
 {
 	struct ip6tables_rule_match *matchp, *tmp;
 
diff --git a/iptables-multi.h b/iptables-multi.h
new file mode 100644
index 0000000..a9912b0
--- /dev/null
+++ b/iptables-multi.h
@@ -0,0 +1,9 @@
+#ifndef _IPTABLES_MULTI_H
+#define _IPTABLES_MULTI_H 1
+
+extern int iptables_main(int, char **);
+extern int iptables_save_main(int, char **);
+extern int iptables_restore_main(int, char **);
+extern int iptables_xml_main(int, char **);
+
+#endif /* _IPTABLES_MULTI_H */
diff --git a/iptables-restore.c b/iptables-restore.c
index 44263ce..b751d2c 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -15,6 +15,7 @@
 #include "iptables.h"
 #include "xtables.h"
 #include "libiptc/libiptc.h"
+#include "iptables-multi.h"
 
 #ifdef DEBUG
 #define DEBUGP(x, args...) fprintf(stderr, x, ## args)
@@ -54,7 +55,7 @@ static void print_usage(const char *name, const char *version)
 	exit(1);
 }
 
-iptc_handle_t create_handle(const char *tablename, const char* modprobe )
+static iptc_handle_t create_handle(const char *tablename, const char *modprobe)
 {
 	iptc_handle_t handle;
 
diff --git a/iptables-save.c b/iptables-save.c
index f82c8a7..c0c37ed 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -15,6 +15,7 @@
 #include <netdb.h>
 #include "libiptc/libiptc.h"
 #include "iptables.h"
+#include "iptables-multi.h"
 
 #ifndef NO_SHARED_LIBS
 #include <dlfcn.h>
diff --git a/iptables-standalone.c b/iptables-standalone.c
index e5c7841..55c7ce9 100644
--- a/iptables-standalone.c
+++ b/iptables-standalone.c
@@ -36,6 +36,7 @@
 #include <errno.h>
 #include <string.h>
 #include <iptables.h>
+#include "iptables-multi.h"
 
 #ifdef IPTABLES_MULTI
 int
diff --git a/iptables-xml.c b/iptables-xml.c
index 94f2e39..d922efe 100644
--- a/iptables-xml.c
+++ b/iptables-xml.c
@@ -16,6 +16,7 @@
 #include <stdarg.h>
 #include "iptables.h"
 #include "libiptc/libiptc.h"
+#include "iptables-multi.h"
 
 #ifdef DEBUG
 #define DEBUGP(x, args...) fprintf(stderr, x, ## args)
diff --git a/iptables.c b/iptables.c
index 0363aba..b2a4b53 100644
--- a/iptables.c
+++ b/iptables.c
@@ -190,8 +190,6 @@ const char *program_name;
 
 int kernel_version;
 
-extern void dump_entries(const iptc_handle_t handle);
-
 /* A few hardcoded protocols for 'all' and in case the user has no
    /etc/protocols */
 struct pprot {
@@ -1143,7 +1141,7 @@ generate_entry(const struct ipt_entry *fw,
 	return e;
 }
 
-void clear_rule_matches(struct iptables_rule_match **matches)
+static void clear_rule_matches(struct iptables_rule_match **matches)
 {
 	struct iptables_rule_match *matchp, *tmp;
 
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index fe6b09b..de8dc60 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -1474,7 +1474,7 @@ TC_NEXT_RULE(const STRUCT_ENTRY *prev, TC_HANDLE_T *handle)
 }
 
 /* How many rules in this chain? */
-unsigned int
+static unsigned int
 TC_NUM_RULES(const char *chain, TC_HANDLE_T *handle)
 {
 	struct chain_head *c;
@@ -1490,9 +1490,8 @@ TC_NUM_RULES(const char *chain, TC_HANDLE_T *handle)
 	return c->num_rules;
 }
 
-const STRUCT_ENTRY *TC_GET_RULE(const char *chain,
-				unsigned int n,
-				TC_HANDLE_T *handle)
+static const STRUCT_ENTRY *
+TC_GET_RULE(const char *chain, unsigned int n, TC_HANDLE_T *handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
@@ -1514,7 +1513,7 @@ const STRUCT_ENTRY *TC_GET_RULE(const char *chain,
 }
 
 /* Returns a pointer to the target name of this position. */
-const char *standard_target_map(int verdict)
+static const char *standard_target_map(int verdict)
 {
 	switch (verdict) {
 		case RETURN:
