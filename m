From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [RFC ebtables-compat PATCH v2] extensions: add ebt 802_3 extension
Date: Wed, 17 Dec 2014 12:06:56 +0100
Message-ID: <20141217110642.31635.84255.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:51539 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750790AbaLQLHJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Dec 2014 06:07:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the first ebtables extension to ebtables-compat.
The original 802_3 code is adapted to the xtables environment.

I tried to mimic as much as possible the original ebtables code paths.

With this patch, ebtables-compat is able to send the 802_3 match to the kernel,
but the kernel-to-userspace path is not tested and should be adjusted
in follow-up patches.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: address comments by Pablo.

 extensions/GNUmakefile.in        |   12 +-
 extensions/libebt_802_3.c        |  160 +++++++++++++++++++++++++++++
 iptables/Makefile.am             |    4 -
 iptables/nft-bridge.c            |    6 +
 iptables/nft-bridge.h            |    6 +
 iptables/xtables-eb-standalone.c |   32 +-----
 iptables/xtables-eb.c            |  208 +++++++++++++++++++++++++++-----------
 libxtables/xtables.c             |   13 ++
 8 files changed, 350 insertions(+), 91 deletions(-)
 create mode 100644 extensions/libebt_802_3.c

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 7b4f891..9eb4bf9 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -60,10 +60,10 @@ pf6_solibs    := $(patsubst %,libip6t_%.so,${pf6_build_mod})
 #
 # Building blocks
 #
-targets := libext.a libext4.a libext6.a matches.man targets.man
+targets := libext.a libext4.a libext6.a libext_ebt.a matches.man targets.man
 targets_install :=
 @ENABLE_STATIC_TRUE@ libext_objs := ${pfx_objs}
-@ENABLE_STATIC_TRUE@ libextb_objs := ${pfb_objs}
+@ENABLE_STATIC_TRUE@ libext_ebt_objs := ${pfb_objs}
 @ENABLE_STATIC_TRUE@ libext4_objs := ${pf4_objs}
 @ENABLE_STATIC_TRUE@ libext6_objs := ${pf6_objs}
 @ENABLE_STATIC_FALSE@ targets += ${pfx_solibs} ${pfb_solibs} ${pf4_solibs} ${pf6_solibs}
@@ -80,7 +80,7 @@ install: ${targets_install}
 	if test -n "${targets_install}"; then install -pm0755 $^ "${DESTDIR}${xtlibdir}/"; fi;
 
 clean:
-	rm -f *.o *.oo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c;
+	rm -f *.o *.oo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c initextb.c;
 	rm -f .*.d .*.dd;
 
 distclean: clean
@@ -123,7 +123,7 @@ lib%.o: ${srcdir}/lib%.c
 libext.a: initext.o ${libext_objs}
 	${AM_VERBOSE_AR} ${AR} crs $@ $^;
 
-libextb.a: initextb.o ${libextb_objs}
+libext_ebt.a: initextb.o ${libext_ebt_objs}
 	${AM_VERBOSE_AR} ${AR} crs $@ $^;
 
 libext4.a: initext4.o ${libext4_objs}
@@ -180,8 +180,8 @@ initextb.c: .initextb.dd
 	for i in ${initextb_func}; do \
 		echo "extern void lib$${i}_init(void);" >>$@; \
 	done; \
-	echo "void init_extensions(void);" >>$@; \
-	echo "void init_extensions(void)" >>$@; \
+	echo "void init_extensionsb(void);" >>$@; \
+	echo "void init_extensionsb(void)" >>$@; \
 	echo "{" >>$@; \
 	for i in ${initextb_func}; do \
 		echo  " ""lib$${i}_init();" >>$@; \
diff --git a/extensions/libebt_802_3.c b/extensions/libebt_802_3.c
new file mode 100644
index 0000000..3ca80f7
--- /dev/null
+++ b/extensions/libebt_802_3.c
@@ -0,0 +1,160 @@
+/* 802_3
+ *
+ * Author:
+ * Chris Vitale <csv@bluetail.com>
+ *
+ * May 2003
+ *
+ * Adapted by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
+ * to use libxtables for ebtables-compat
+ */
+
+#include <stdbool.h>
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <xtables.h>
+#include <linux/netfilter_bridge/ebt_802_3.h>
+
+#define _802_3_SAP	'1'
+#define _802_3_TYPE	'2'
+
+static const struct option br802_3_opts[] = {
+	{ .name = "802_3-sap",	.has_arg = true, .val = _802_3_SAP },
+	{ .name = "802_3-type",	.has_arg = true, .val = _802_3_TYPE },
+	XT_GETOPT_TABLEEND,
+};
+
+static void br802_3_print_help(void)
+{
+	printf(
+"802_3 options:\n"
+"--802_3-sap [!] protocol       : 802.3 DSAP/SSAP- 1 byte value (hex)\n"
+"  DSAP and SSAP are always the same.  One SAP applies to both fields\n"
+"--802_3-type [!] protocol      : 802.3 SNAP Type- 2 byte value (hex)\n"
+"  Type implies SAP value 0xaa\n");
+}
+
+static void br802_3_init(struct xt_entry_match *match)
+{
+	struct ebt_802_3_info *info = (struct ebt_802_3_info *)match->data;
+
+	info->invflags = 0;
+	info->bitmask = 0;
+}
+
+/*static int parse(int c, char **argv, int argc, const struct ebt_u_entry *entry,
+   unsigned int *flags, struct ebt_entry_match **match)*/
+static int
+br802_3_parse(int c, char **argv, int invert, unsigned int *flags,
+	      const void *entry, struct xt_entry_match **match)
+{
+	struct ebt_802_3_info *info = (struct ebt_802_3_info *) (*match)->data;
+	unsigned int i;
+	char *end;
+
+	switch (c) {
+	case _802_3_SAP:
+		if (invert)
+			info->invflags |= EBT_802_3_SAP;
+		i = strtoul(optarg, &end, 16);
+		if (i > 255 || *end != '\0')
+			xtables_error(PARAMETER_PROBLEM,
+				      "Problem with specified "
+					"sap hex value, %x",i);
+		info->sap = i; /* one byte, so no byte order worries */
+		info->bitmask |= EBT_802_3_SAP;
+		break;
+	case _802_3_TYPE:
+		if (invert)
+			info->invflags |= EBT_802_3_TYPE;
+		i = strtoul(optarg, &end, 16);
+		if (i > 65535 || *end != '\0') {
+			xtables_error(PARAMETER_PROBLEM,
+				      "Problem with the specified "
+					"type hex value, %x",i);
+		}
+		info->type = htons(i);
+		info->bitmask |= EBT_802_3_TYPE;
+		break;
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+static void
+br802_3_final_check(unsigned int flags)
+{
+	/*if (!(entry->bitmask & EBT_802_3))
+		ebt_print_error("For 802.3 DSAP/SSAP filtering the protocol "
+				"must be LENGTH");
+	*/
+	if (!flags)
+		xtables_error(PARAMETER_PROBLEM,
+			      "You must specify proper arguments");
+}
+
+/*static void print(const struct ebt_u_entry *entry,
+   const struct ebt_entry_match *match)*/
+static void br802_3_print(const void *ip, const struct xt_entry_match *match,
+			  int numeric)
+{
+	struct ebt_802_3_info *info = (struct ebt_802_3_info *)match->data;
+
+	if (info->bitmask & EBT_802_3_SAP) {
+		printf("--802_3-sap ");
+		if (info->invflags & EBT_802_3_SAP)
+			printf("! ");
+		printf("0x%.2x ", info->sap);
+	}
+	if (info->bitmask & EBT_802_3_TYPE) {
+		printf("--802_3-type ");
+		if (info->invflags & EBT_802_3_TYPE)
+			printf("! ");
+		printf("0x%.4x ", ntohs(info->type));
+	}
+}
+/*
+static int compare(const struct ebt_entry_match *m1,
+   const struct ebt_entry_match *m2)
+{
+	struct ebt_802_3_info *info1 = (struct ebt_802_3_info *)m1->data;
+	struct ebt_802_3_info *info2 = (struct ebt_802_3_info *)m2->data;
+
+	if (info1->bitmask != info2->bitmask)
+		return 0;
+	if (info1->invflags != info2->invflags)
+		return 0;
+	if (info1->bitmask & EBT_802_3_SAP) {
+		if (info1->sap != info2->sap)
+			return 0;
+	}
+	if (info1->bitmask & EBT_802_3_TYPE) {
+		if (info1->type != info2->type)
+			return 0;
+	}
+	return 1;
+}
+*/
+static struct xtables_match br802_3_match =
+{
+	.name		= "802_3",
+	.revision	= 0,
+	.version	= XTABLES_VERSION,
+	.family		= NFPROTO_BRIDGE,
+	.size		= XT_ALIGN(sizeof(struct ebt_802_3_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct ebt_802_3_info)),
+	.init		= br802_3_init,
+	.help		= br802_3_print_help,
+	.parse		= br802_3_parse,
+	.final_check	= br802_3_final_check,
+	.print		= br802_3_print,
+	.extra_opts	= br802_3_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&br802_3_match);
+}
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index b3e417b..c66e533 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -29,7 +29,7 @@ xtables_multi_LDADD   += ../libxtables/libxtables.la -lm
 if ENABLE_NFTABLES
 xtables_compat_multi_SOURCES  = xtables-compat-multi.c iptables-xml.c
 xtables_compat_multi_CFLAGS   = ${AM_CFLAGS}
-xtables_compat_multi_LDADD    = ../extensions/libext.a
+xtables_compat_multi_LDADD    = ../extensions/libext.a ../extensions/libext_ebt.a
 if ENABLE_STATIC
 xtables_compat_multi_CFLAGS  += -DALL_INCLUSIVE
 endif
@@ -42,7 +42,7 @@ xtables_compat_multi_SOURCES += xtables-save.c xtables-restore.c \
 				xtables-arp-standalone.c xtables-arp.c \
 				getethertype.c nft-bridge.c \
 				xtables-eb-standalone.c xtables-eb.c
-xtables_compat_multi_LDADD   += ${libmnl_LIBS} ${libnftnl_LIBS} ../extensions/libext4.a ../extensions/libext6.a
+xtables_compat_multi_LDADD   += ${libmnl_LIBS} ${libnftnl_LIBS} ../extensions/libext4.a ../extensions/libext6.a ../extensions/libext_ebt.a
 # yacc and lex generate dirty code
 xtables_compat_multi-xtables-config-parser.o xtables_compat_multi-xtables-config-syntax.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-declarations -Wno-implicit-function-declaration -Wno-nested-externs -Wno-undef -Wno-redundant-decls
 xtables_compat_multi_SOURCES += xshared.c
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index a1bd906..9772b5f 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -135,6 +135,7 @@ static int _add_action(struct nft_rule *r, struct ebtables_command_state *cs)
 static int nft_bridge_add(struct nft_rule *r, void *data)
 {
 	struct ebtables_command_state *cs = data;
+	struct xtables_rule_match *matchp;
 	struct ebt_entry *fw = &cs->fw;
 	uint32_t op;
 	char *addr;
@@ -179,6 +180,11 @@ static int nft_bridge_add(struct nft_rule *r, void *data)
 		add_cmp_u16(r, fw->ethproto, op);
 	}
 
+	for (matchp = cs->matches; matchp; matchp = matchp->next) {
+		if (add_match(r, matchp->match->m) < 0)
+			break;
+	}
+
 	return _add_action(r, cs);
 }
 
diff --git a/iptables/nft-bridge.h b/iptables/nft-bridge.h
index 1e3f0a1..fd8bc9f 100644
--- a/iptables/nft-bridge.h
+++ b/iptables/nft-bridge.h
@@ -90,6 +90,12 @@ struct ebtables_command_state {
 	struct xtables_rule_match *matches;
 	const char *jumpto;
 	struct xt_counters counters;
+	int invert;
+	int c;
+	char **argv;
+	int proto_used;
+	char *protocol;
+	unsigned int options;
 };
 
 void nft_rule_to_ebtables_command_state(struct nft_rule *r,
diff --git a/iptables/xtables-eb-standalone.c b/iptables/xtables-eb-standalone.c
index 1c3cbf0..914d137 100644
--- a/iptables/xtables-eb-standalone.c
+++ b/iptables/xtables-eb-standalone.c
@@ -36,22 +36,12 @@
 #include <errno.h>
 #include <string.h>
 #include <xtables.h>
+#include <iptables.h>
 #include "nft.h"
 
 #include "xtables-multi.h"
 
-extern struct xtables_globals xtables_globals;
-extern const char *program_version, *program_name;
-
-static const struct xtables_afinfo afinfo_bridge = {
-        .kmod          = "eb_tables",
-        .proc_exists   = "/proc/net/eb_tables_names",
-        .libprefix     = "libeb_",
-        .family        = NFPROTO_BRIDGE,
-        .ipproto       = IPPROTO_IP,
-        .so_rev_match  = -1,
-        .so_rev_target = -1,
-};
+extern struct xtables_globals ebtables_globals;
 
 int xtables_eb_main(int argc, char *argv[])
 {
@@ -61,24 +51,18 @@ int xtables_eb_main(int argc, char *argv[])
 		.family = NFPROTO_BRIDGE,
 	};
 
-	xtables_globals.program_name = "ebtables";
-	/* This code below could be replaced by xtables_init_all, which
-	 * doesn't support NFPROTO_BRIDGE yet.
-	 */
-	xtables_init();
-	afinfo = &afinfo_bridge;
-	ret = xtables_set_params(&xtables_globals);
+	ebtables_globals.program_name = "ebtables";
+	ret = xtables_init_all(&ebtables_globals, NFPROTO_BRIDGE);
 	if (ret < 0) {
-		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
-				xtables_globals.program_name,
-				xtables_globals.program_version);
+		fprintf(stderr, "%s/%s Failed to initialize ebtables-compat\n",
+			ebtables_globals.program_name,
+			ebtables_globals.program_version);
 		exit(1);
 	}
 
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
-	init_extensions();
+	init_extensionsb();
 #endif
-
 	ret = do_commandeb(&h, argc, argv, &table);
 	if (ret)
 		ret = nft_commit(&h);
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index b924daf..22ae4fd 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -30,6 +30,7 @@
 #include <signal.h>
 #include <net/if.h>
 #include <netinet/ether.h>
+#include <iptables.h>
 #include <xtables.h>
 
 #include <linux/netfilter_bridge.h>
@@ -39,10 +40,6 @@
 #include "nft.h"
 #include "nft-bridge.h"
 
-extern struct xtables_globals xtables_globals;
-#define prog_name xtables_globals.program_name
-#define prog_vers xtables_globals.program_version
-
 /*
  * From include/ebtables_u.h
  */
@@ -141,44 +138,6 @@ static int ebt_check_inverse2(const char option[], int argc, char **argv)
 }
 
 /*
- * From libebtc.c
- */
-
-/* The four target names, from libebtc.c */
-const char* ebt_standard_targets[NUM_STANDARD_TARGETS] =
-{
-	"ACCEPT",
-	"DROP",
-	"CONTINUE",
-	"RETURN",
-};
-
-/* Prints all registered extensions */
-static void ebt_list_extensions(const struct xtables_target *t,
-				const struct xtables_rule_match *m)
-{
-	printf("%s v%s\n", prog_name, prog_vers);
-	printf("Loaded userspace extensions:\n");
-	/*printf("\nLoaded tables:\n");
-        while (tbl) {
-		printf("%s\n", tbl->name);
-                tbl = tbl->next;
-	}*/
-	printf("\nLoaded targets:\n");
-        for (t = xtables_targets; t; t = t->next) {
-		printf("%s\n", t->name);
-	}
-	printf("\nLoaded matches:\n");
-        for (; m != NULL; m = m->next)
-		printf("%s\n", m->match->name);
-	/*printf("\nLoaded watchers:\n");
-        while (w) {
-		printf("%s\n", w->name);
-                w = w->next;
-	}*/
-}
-
-/*
  * Glue code to use libxtables
  */
 static int parse_rule_number(const char *rule)
@@ -341,8 +300,92 @@ static struct option ebt_original_options[] =
 	{ 0 }
 };
 
+void xtables_exit_error(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
+
 static struct option *ebt_options = ebt_original_options;
 
+struct xtables_globals ebtables_globals = {
+	.option_offset 		= 0,
+	.program_version	= IPTABLES_VERSION,
+	.orig_opts		= ebt_original_options,
+	.exit_err		= xtables_exit_error,
+	.compat_rev		= nft_compatible_revision,
+};
+
+#define opts ebtables_globals.opts
+#define prog_name ebtables_globals.program_name
+#define prog_vers ebtables_globals.program_version
+
+/*
+ * From libebtc.c
+ */
+
+/* The four target names, from libebtc.c */
+const char* ebt_standard_targets[NUM_STANDARD_TARGETS] =
+{
+	"ACCEPT",
+	"DROP",
+	"CONTINUE",
+	"RETURN",
+};
+
+/* Prints all registered extensions */
+static void ebt_list_extensions(const struct xtables_target *t,
+				const struct xtables_rule_match *m)
+{
+	printf("%s v%s\n", prog_name, prog_vers);
+	printf("Loaded userspace extensions:\n");
+	/*printf("\nLoaded tables:\n");
+        while (tbl) {
+		printf("%s\n", tbl->name);
+                tbl = tbl->next;
+	}*/
+	printf("\nLoaded targets:\n");
+        for (t = xtables_targets; t; t = t->next) {
+		printf("%s\n", t->name);
+	}
+	printf("\nLoaded matches:\n");
+        for (; m != NULL; m = m->next)
+		printf("%s\n", m->match->name);
+	/*printf("\nLoaded watchers:\n");
+        while (w) {
+		printf("%s\n", w->name);
+                w = w->next;
+	}*/
+}
+
+#define OPTION_OFFSET 256
+static struct option *merge_options(struct option *oldopts,
+				    const struct option *newopts,
+				    unsigned int *options_offset)
+{
+	unsigned int num_old, num_new, i;
+	struct option *merge;
+
+	if (!newopts || !oldopts || !options_offset)
+		xtables_error(OTHER_PROBLEM, "merge wrong");
+	for (num_old = 0; oldopts[num_old].name; num_old++);
+	for (num_new = 0; newopts[num_new].name; num_new++);
+
+	ebtables_globals.option_offset += OPTION_OFFSET;
+	*options_offset = ebtables_globals.option_offset;
+
+	merge = malloc(sizeof(struct option) * (num_new + num_old + 1));
+	if (!merge)
+		return NULL;
+	memcpy(merge, oldopts, num_old * sizeof(struct option));
+	for (i = 0; i < num_new; i++) {
+		merge[num_old + i] = newopts[i];
+		merge[num_old + i].val += *options_offset;
+	}
+	memset(merge + num_old + num_new, 0, sizeof(struct option));
+	/* Only free dynamically allocated stuff */
+	if (oldopts != ebt_original_options)
+		free(oldopts);
+
+	return merge;
+}
+
 /*
  * More glue code.
  */
@@ -370,11 +413,11 @@ static struct xtables_target *command_jump(struct ebtables_command_state *cs,
 	xs_init_target(target);
 
 	if (target->x6_options != NULL)
-		ebt_options = xtables_options_xfrm(xtables_globals.orig_opts,
+		ebt_options = xtables_options_xfrm(ebtables_globals.orig_opts,
 					    ebt_options, target->x6_options,
 					    &target->option_offset);
 	else
-		ebt_options = xtables_merge_options(xtables_globals.orig_opts,
+		ebt_options = xtables_merge_options(ebtables_globals.orig_opts,
 					     ebt_options, target->extra_opts,
 					     &target->option_offset);
 
@@ -569,6 +612,42 @@ static int parse_iface(char *iface, char *option)
 	return 0;
 }
 
+/* This code is very similar to iptables/xtables.c:command_match() */
+static void ebt_load_match(const char *name)
+{
+	struct xtables_match *m;
+	size_t size;
+	opts = ebt_original_options;
+
+	m = xtables_find_match(name, XTF_LOAD_MUST_SUCCEED, NULL);
+	if (m == NULL)
+		xtables_error(OTHER_PROBLEM, "Unable to load %s match", name);
+
+	size = XT_ALIGN(sizeof(struct xt_entry_match)) + m->size;
+	m->m = xtables_calloc(1, size);
+	m->m->u.match_size = size;
+	strcpy(m->m->u.user.name, m->name);
+	m->m->u.user.revision = m->revision;
+	xs_init_match(m);
+
+	opts = merge_options(opts, m->extra_opts, &m->option_offset);
+	if (opts == NULL)
+		xtables_error(OTHER_PROBLEM, "Can't alloc memory");
+}
+
+static void ebt_load_matches(void)
+{
+	ebt_load_match("802_3");
+}
+
+static void ebt_add_match(struct xtables_match *m,
+			  struct xtables_rule_match **rule_matches)
+{
+	if (xtables_find_match(m->name, XTF_LOAD_MUST_SUCCEED, rule_matches) == NULL)
+		xtables_error(OTHER_PROBLEM,
+			      "Unable to add match %s", m->name);
+}
+
 /* We use exec_style instead of #ifdef's because ebtables.so is a shared object. */
 int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table)
 {
@@ -581,6 +660,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table)
 	int ret = 0;
 	unsigned int flags = 0;
 	struct xtables_target *t;
+	struct xtables_match *m;
 	struct ebtables_command_state cs;
 	char command = 'h';
 	const char *chain = NULL;
@@ -589,6 +669,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table)
 	int selected_chain = -1;
 
 	memset(&cs, 0, sizeof(cs));
+	cs.argv = argv;
 
 	if (nft_init(h, xtables_bridge) < 0)
 		xtables_error(OTHER_PROBLEM,
@@ -598,14 +679,30 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table)
 	if (h->ops == NULL)
 		xtables_error(PARAMETER_PROBLEM, "Unknown family");
 
+	/* manually registering ebt matches, given the original ebtables parser
+	 * don't use '-m matchname' and the match can't loaded dinamically when
+	 * the user calls it.
+	 */
+	ebt_load_matches();
+
+	/* clear mflags in case do_commandeb gets called a second time
+	 * (we clear the global list of all matches for security)*/
+	for (m = xtables_matches; m; m = m->next)
+		m->mflags = 0;
+
 	for (t = xtables_targets; t; t = t->next) {
 		t->tflags = 0;
 		t->used = 0;
 	}
 
+	/* prevent getopt to spoil our error reporting */
+	opterr = false;
+
 	/* Getopt saves the day */
 	while ((c = getopt_long(argc, argv,
-	   "-A:D:C:I:N:E:X::L::Z::F::P:Vhi:o:j:c:p:s:d:t:M:", ebt_options, NULL)) != -1) {
+	   "-A:D:C:I:N:E:X::L::Z::F::P:Vhi:o:j:c:p:s:d:t:M:", opts, NULL)) != -1) {
+		cs.c = c;
+		cs.invert = ebt_invert;
 		switch (c) {
 
 		case 'A': /* Add a rule */
@@ -1070,19 +1167,12 @@ big_iface_length:
 			}*/
 
 			/* Is it a match_option? */
-			/*for (m = ebt_matches; m; m = m->next)
-				if (m->parse(c - m->option_offset, argv, argc, new_entry, &m->flags, &m->m))
-					break;
-
-			if (m != NULL) {
-				if (ebt_errormsg[0] != '\0')
-					return -1;
-				if (m->used == 0) {
-					ebt_add_match(new_entry, m);
-					m->used = 1;
+			for (m = xtables_matches; m; m = m->next) {
+				if (m->parse(c - m->option_offset, argv, ebt_invert, &m->mflags, NULL, &m->m)) {
+					ebt_add_match(m, &cs.matches);
+					goto check_extension;
 				}
-				goto check_extension;
-			}*/
+			}
 
 			/* Is it a watcher option? */
 			/*for (w = ebt_watchers; w; w = w->next)
@@ -1102,8 +1192,8 @@ big_iface_length:
 			if (w->used == 0) {
 				ebt_add_watcher(new_entry, w);
 				w->used = 1;
-			}
-check_extension: */
+			}*/
+check_extension:
 			if (command != 'A' && command != 'I' &&
 			    command != 'D' && command != 'C')
 				xtables_error(PARAMETER_PROBLEM,
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 6841124..6985a27 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -168,6 +168,16 @@ static const struct xtables_afinfo afinfo_ipv6 = {
 	.so_rev_target = IP6T_SO_GET_REVISION_TARGET,
 };
 
+static const struct xtables_afinfo afinfo_bridge = {
+	.kmod          = "eb_tables",
+	.proc_exists   = "/proc/net/eb_tables_names",
+	.libprefix     = "libebt_",
+	.family        = NFPROTO_BRIDGE,
+	.ipproto       = IPPROTO_IP,
+	.so_rev_match  = -1,
+	.so_rev_target = -1,
+};
+
 const struct xtables_afinfo *afinfo;
 
 /* Search path for Xtables .so files */
@@ -224,6 +234,9 @@ void xtables_set_nfproto(uint8_t nfproto)
 	case NFPROTO_IPV6:
 		afinfo = &afinfo_ipv6;
 		break;
+	case NFPROTO_BRIDGE:
+		afinfo = &afinfo_bridge;
+		break;
 	default:
 		fprintf(stderr, "libxtables: unhandled NFPROTO in %s\n",
 		        __func__);

