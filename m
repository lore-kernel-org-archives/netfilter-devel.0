From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [arpt-compat PATCH] arptables-compat: add mangle target extension
Date: Fri, 13 Feb 2015 11:38:02 +0100
Message-ID: <20150213103801.31735.70857.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:40304 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752390AbbBMKiT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Feb 2015 05:38:19 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support to use the mangle target extensions, along with
the required changes in the surrounding code.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 extensions/GNUmakefile.in         |   46 +++++++-
 extensions/libarpt_mangle.c       |  204 +++++++++++++++++++++++++++++++++++++
 iptables/nft-arp.c                |   23 ++--
 iptables/xtables-arp-standalone.c |   30 +----
 iptables/xtables-arp.c            |   13 ++
 libxtables/xtables.c              |   13 ++
 6 files changed, 284 insertions(+), 45 deletions(-)
 create mode 100644 extensions/libarpt_mangle.c

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 9eb4bf9..4e94bd0 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -40,19 +40,23 @@ endif
 #
 pfx_build_mod := $(patsubst ${srcdir}/libxt_%.c,%,$(sort $(wildcard ${srcdir}/libxt_*.c)))
 pfb_build_mod := $(patsubst ${srcdir}/libebt_%.c,%,$(sort $(wildcard ${srcdir}/libebt_*.c)))
+pfa_build_mod := $(patsubst ${srcdir}/libarpt_%.c,%,$(sort $(wildcard ${srcdir}/libarpt_*.c)))
 pfx_symlinks  := NOTRACK state
 @ENABLE_IPV4_TRUE@ pf4_build_mod := $(patsubst ${srcdir}/libipt_%.c,%,$(sort $(wildcard ${srcdir}/libipt_*.c)))
 @ENABLE_IPV6_TRUE@ pf6_build_mod := $(patsubst ${srcdir}/libip6t_%.c,%,$(sort $(wildcard ${srcdir}/libip6t_*.c)))
 pfx_build_mod := $(filter-out @blacklist_modules@,${pfx_build_mod})
 pfb_build_mod := $(filter-out @blacklist_modules@,${pfb_build_mod})
+pfa_build_mod := $(filter-out @blacklist_modules@,${pfa_build_mod})
 pf4_build_mod := $(filter-out @blacklist_modules@,${pf4_build_mod})
 pf6_build_mod := $(filter-out @blacklist_modules@,${pf6_build_mod})
 pfx_objs      := $(patsubst %,libxt_%.o,${pfx_build_mod})
 pfb_objs      := $(patsubst %,libebt_%.o,${pfb_build_mod})
+pfa_objs      := $(patsubst %,libarpt_%.o,${pfa_build_mod})
 pf4_objs      := $(patsubst %,libipt_%.o,${pf4_build_mod})
 pf6_objs      := $(patsubst %,libip6t_%.o,${pf6_build_mod})
 pfx_solibs    := $(patsubst %,libxt_%.so,${pfx_build_mod} ${pfx_symlinks})
 pfb_solibs    := $(patsubst %,libebt_%.so,${pfb_build_mod})
+pfa_solibs    := $(patsubst %,libarpt_%.so,${pfa_build_mod})
 pf4_solibs    := $(patsubst %,libipt_%.so,${pf4_build_mod})
 pf6_solibs    := $(patsubst %,libip6t_%.so,${pf6_build_mod})
 
@@ -60,14 +64,15 @@ pf6_solibs    := $(patsubst %,libip6t_%.so,${pf6_build_mod})
 #
 # Building blocks
 #
-targets := libext.a libext4.a libext6.a libext_ebt.a matches.man targets.man
+targets := libext.a libext4.a libext6.a libext_ebt.a libext_arpt.a matches.man targets.man
 targets_install :=
 @ENABLE_STATIC_TRUE@ libext_objs := ${pfx_objs}
 @ENABLE_STATIC_TRUE@ libext_ebt_objs := ${pfb_objs}
+@ENABLE_STATIC_TRUE@ libext_arpt_objs := ${pfa_objs}
 @ENABLE_STATIC_TRUE@ libext4_objs := ${pf4_objs}
 @ENABLE_STATIC_TRUE@ libext6_objs := ${pf6_objs}
-@ENABLE_STATIC_FALSE@ targets += ${pfx_solibs} ${pfb_solibs} ${pf4_solibs} ${pf6_solibs}
-@ENABLE_STATIC_FALSE@ targets_install += ${pfx_solibs} ${pfb_solibs} ${pf4_solibs} ${pf6_solibs}
+@ENABLE_STATIC_FALSE@ targets += ${pfx_solibs} ${pfb_solibs} ${pf4_solibs} ${pf6_solibs} ${pfa_solibs}
+@ENABLE_STATIC_FALSE@ targets_install += ${pfx_solibs} ${pfb_solibs} ${pf4_solibs} ${pf6_solibs} ${pfa_solibs}
 
 .SECONDARY:
 
@@ -80,7 +85,7 @@ install: ${targets_install}
 	if test -n "${targets_install}"; then install -pm0755 $^ "${DESTDIR}${xtlibdir}/"; fi;
 
 clean:
-	rm -f *.o *.oo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c initextb.c;
+	rm -f *.o *.oo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c initextb.c initexta.c;
 	rm -f .*.d .*.dd;
 
 distclean: clean
@@ -126,6 +131,9 @@ libext.a: initext.o ${libext_objs}
 libext_ebt.a: initextb.o ${libext_ebt_objs}
 	${AM_VERBOSE_AR} ${AR} crs $@ $^;
 
+libext_arpt.a: initexta.o ${libext_arpt_objs}
+	${AM_VERBOSE_AR} ${AR} crs $@ $^;
+
 libext4.a: initext4.o ${libext4_objs}
 	${AM_VERBOSE_AR} ${AR} crs $@ $^;
 
@@ -134,6 +142,7 @@ libext6.a: initext6.o ${libext6_objs}
 
 initext_func  := $(addprefix xt_,${pfx_build_mod})
 initextb_func := $(addprefix ebt_,${pfb_build_mod})
+initexta_func := $(addprefix arpt_,${pfa_build_mod})
 initext4_func := $(addprefix ipt_,${pf4_build_mod})
 initext6_func := $(addprefix ip6t_,${pf6_build_mod})
 
@@ -147,6 +156,11 @@ initext6_func := $(addprefix ip6t_,${pf6_build_mod})
 	cmp -s $@ $@.tmp || mv $@.tmp $@; \
 	rm -f $@.tmp;
 
+.initexta.dd: FORCE
+	@echo "${initexta_func}" >$@.tmp; \
+	cmp -s $@ $@.tmp || mv $@.tmp $@; \
+	rm -f $@.tmp;
+
 .initext4.dd: FORCE
 	@echo "${initext4_func}" >$@.tmp; \
 	cmp -s $@ $@.tmp || mv $@.tmp $@; \
@@ -189,6 +203,22 @@ initextb.c: .initextb.dd
 	echo "}" >>$@; \
 	);
 
+initexta.c: .initexta.dd
+	${AM_VERBOSE_GEN}
+	@( \
+	echo "" >$@; \
+	for i in ${initexta_func}; do \
+		echo "extern void lib$${i}_init(void);" >>$@; \
+	done; \
+	echo "void init_extensionsa(void);" >>$@; \
+	echo "void init_extensionsa(void)" >>$@; \
+	echo "{" >>$@; \
+	for i in ${initexta_func}; do \
+		echo  " ""lib$${i}_init();" >>$@; \
+	done; \
+	echo "}" >>$@; \
+	);
+
 initext4.c: .initext4.dd
 	${AM_VERBOSE_GEN}
 	@( \
@@ -249,8 +279,8 @@ man_run    = \
 		fi; \
 	done >$@;
 
-matches.man: .initext.dd .initextb.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
-	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pfb_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfx_symlinks}))
+matches.man: .initext.dd .initextb.dd .initexta.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
+	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pfb_build_mod} ${pfa_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfx_symlinks}))
 
-targets.man: .initext.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
-	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pfb_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfx_symlinks}))
+targets.man: .initext.dd .initextb.dd .initexta.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
+	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pfb_build_mod} ${pfa_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfx_symlinks}))
diff --git a/extensions/libarpt_mangle.c b/extensions/libarpt_mangle.c
new file mode 100644
index 0000000..03c31a9
--- /dev/null
+++ b/extensions/libarpt_mangle.c
@@ -0,0 +1,204 @@
+/*
+ * Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> adapted
+ * this code to libxtables for arptables-compat in 2015
+ */
+
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <limits.h>
+#include <getopt.h>
+#include <netinet/ether.h>
+#include <xtables.h>
+#include <linux/netfilter_arp/arpt_mangle.h>
+#include "iptables/nft.h"
+#include "iptables/nft-arp.h"
+
+static void arpmangle_print_help(void)
+{
+	printf(
+	"mangle target options:\n"
+	"--mangle-ip-s IP address\n"
+	"--mangle-ip-d IP address\n"
+	"--mangle-mac-s MAC address\n"
+	"--mangle-mac-d MAC address\n"
+	"--mangle-target target (DROP, CONTINUE or ACCEPT -- default is ACCEPT)\n");
+}
+
+#define MANGLE_IPS    '1'
+#define MANGLE_IPT    '2'
+#define MANGLE_DEVS   '3'
+#define MANGLE_DEVT   '4'
+#define MANGLE_TARGET '5'
+
+static struct option arpmangle_opts[] = {
+	{ .name = "mangle-ip-s",	.has_arg = true, .val = MANGLE_IPS },
+	{ .name = "mangle-ip-d",	.has_arg = true, .val = MANGLE_IPT },
+	{ .name = "mangle-mac-s",	.has_arg = true, .val = MANGLE_DEVS },
+	{ .name = "mangle-mac-d",	.has_arg = true, .val = MANGLE_DEVT },
+	{ .name = "mangle-target",	.has_arg = true, .val = MANGLE_TARGET },
+	XT_GETOPT_TABLEEND,
+};
+
+static void arpmangle_init(struct xt_entry_target *target)
+{
+	struct arpt_mangle *mangle = (struct arpt_mangle *)target->data;
+
+	mangle->target = NF_ACCEPT;
+}
+
+static int
+arpmangle_parse(int c, char **argv, int invert, unsigned int *flags,
+		const void *entry, struct xt_entry_target **target)
+{
+	struct arpt_mangle *mangle = (struct arpt_mangle *)(*target)->data;
+	struct in_addr *ipaddr, mask;
+	struct ether_addr *macaddr;
+	const struct arpt_entry *e = (const struct arpt_entry *)entry;
+	unsigned int nr;
+	int ret = 1;
+
+	memset(&mask, 0, sizeof(mask));
+
+	switch (c) {
+	case MANGLE_IPS:
+		xtables_ipparse_any(optarg, &ipaddr, &mask, &nr);
+		mangle->u_s.src_ip.s_addr = ipaddr->s_addr;
+		free(ipaddr);
+		mangle->flags |= ARPT_MANGLE_SIP;
+		break;
+	case MANGLE_IPT:
+		xtables_ipparse_any(optarg, &ipaddr, &mask, &nr);
+		mangle->u_t.tgt_ip.s_addr = ipaddr->s_addr;
+		free(ipaddr);
+		mangle->flags |= ARPT_MANGLE_TIP;
+		break;
+	case MANGLE_DEVS:
+		if (e->arp.arhln_mask == 0)
+			xtables_error(PARAMETER_PROBLEM,
+				      "no --h-length defined");
+		if (e->arp.invflags & ARPT_INV_ARPHLN)
+			xtables_error(PARAMETER_PROBLEM,
+				      "! --h-length not allowed for "
+				      "--mangle-mac-s");
+		if (e->arp.arhln != 6)
+			xtables_error(PARAMETER_PROBLEM,
+				      "only --h-length 6 supported");
+		macaddr = ether_aton(optarg);
+		if (macaddr == NULL)
+			xtables_error(PARAMETER_PROBLEM,
+				      "invalid source MAC");
+		memcpy(mangle->src_devaddr, macaddr, e->arp.arhln);
+		mangle->flags |= ARPT_MANGLE_SDEV;
+		break;
+	case MANGLE_DEVT:
+		if (e->arp.arhln_mask == 0)
+			xtables_error(PARAMETER_PROBLEM,
+				      "no --h-length defined");
+		if (e->arp.invflags & ARPT_INV_ARPHLN)
+			xtables_error(PARAMETER_PROBLEM,
+				      "! hln not allowed for --mangle-mac-d");
+		if (e->arp.arhln != 6)
+			xtables_error(PARAMETER_PROBLEM,
+				      "only --h-length 6 supported");
+		macaddr = ether_aton(optarg);
+		if (macaddr == NULL)
+			xtables_error(PARAMETER_PROBLEM, "invalid target MAC");
+		memcpy(mangle->tgt_devaddr, macaddr, e->arp.arhln);
+		mangle->flags |= ARPT_MANGLE_TDEV;
+		break;
+	case MANGLE_TARGET:
+		if (!strcmp(optarg, "DROP"))
+			mangle->target = NF_DROP;
+		else if (!strcmp(optarg, "ACCEPT"))
+			mangle->target = NF_ACCEPT;
+		else if (!strcmp(optarg, "CONTINUE"))
+			mangle->target = XT_CONTINUE;
+		else
+			xtables_error(PARAMETER_PROBLEM,
+				      "bad target for --mangle-target");
+		break;
+	default:
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static void arpmangle_final_check(unsigned int flags)
+{
+}
+
+static void print_mac(const unsigned char *mac, int l)
+{
+	int j;
+
+	for (j = 0; j < l; j++)
+		printf("%02x%s", mac[j],
+			(j==l-1) ? "" : ":");
+}
+
+static void
+arpmangle_print(const void *ip, const struct xt_entry_target *target,
+		int numeric)
+{
+	struct arpt_mangle *m = (struct arpt_mangle *)(target->data);
+	char buf[100];
+
+	if (m->flags & ARPT_MANGLE_SIP) {
+		if (numeric)
+			sprintf(buf, "%s",
+				xtables_ipaddr_to_numeric(&(m->u_s.src_ip)));
+		else
+			sprintf(buf, "%s",
+				xtables_ipaddr_to_anyname(&(m->u_s.src_ip)));
+		printf("--mangle-ip-s %s ", buf);
+	}
+	if (m->flags & ARPT_MANGLE_SDEV) {
+		printf("--mangle-mac-s ");
+		print_mac((unsigned char *)m->src_devaddr, 6);
+		printf(" ");
+	}
+	if (m->flags & ARPT_MANGLE_TIP) {
+		if (numeric)
+			sprintf(buf, "%s",
+				xtables_ipaddr_to_numeric(&(m->u_t.tgt_ip)));
+		else
+			sprintf(buf, "%s",
+				xtables_ipaddr_to_anyname(&(m->u_t.tgt_ip)));
+		printf("--mangle-ip-d %s ", buf);
+	}
+	if (m->flags & ARPT_MANGLE_TDEV) {
+		printf("--mangle-mac-d ");
+		print_mac((unsigned char *)m->tgt_devaddr, 6);
+		printf(" ");
+	}
+	if (m->target != NF_ACCEPT) {
+		printf("--mangle-target ");
+		if (m->target == NF_DROP)
+			printf("DROP ");
+		else
+			printf("CONTINUE ");
+	}
+}
+
+static struct xtables_target arpmangle_target = {
+	.name		= "mangle",
+	.revision	= 0,
+	.version	= XTABLES_VERSION,
+	.family		= NFPROTO_ARP,
+	.size		= XT_ALIGN(sizeof(struct arpt_mangle)),
+	.userspacesize	= XT_ALIGN(sizeof(struct arpt_mangle)),
+	.help		= arpmangle_print_help,
+	.init		= arpmangle_init,
+	.parse		= arpmangle_parse,
+	.final_check	= arpmangle_final_check,
+	.print		= arpmangle_print,
+	.extra_opts	= arpmangle_opts,
+};
+
+void _init(void)
+{
+	xtables_register_target(&arpmangle_target);
+}
diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 24b31c5..d51aa8a 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -402,12 +402,13 @@ void nft_rule_to_arptables_command_state(struct nft_rule *r,
 
 	nft_rule_expr_iter_destroy(iter);
 
-	if (cs->target != NULL)
-		cs->jumpto = cs->target->name;
-	else if (cs->jumpto != NULL)
-		cs->target = xtables_find_target(cs->jumpto, XTF_TRY_LOAD);
+	if (cs->jumpto != NULL)
+		return;
+
+	if (cs->target != NULL && cs->target->name != NULL)
+		cs->target = xtables_find_target(cs->target->name, XTF_TRY_LOAD);
 	else
-		cs->jumpto = "";
+		cs->jumpto = "CONTINUE";
 }
 
 static void nft_arp_print_header(unsigned int format, const char *chain,
@@ -585,13 +586,13 @@ nft_arp_print_firewall(struct nft_rule *r, unsigned int num,
 
 	print_fw_details(&cs.fw, format);
 
-	if (strlen(cs.jumpto) > 0) {
-		printf("-j %s\n", cs.jumpto);
+	printf("-j ");
+
+	if (cs.jumpto != NULL) {
+		printf("%s", cs.jumpto);
 	} else if (cs.target) {
-		if (cs.target->print)
-			/* Print the target information. */
-			cs.target->print(&cs.fw, cs.target->t,
-					 format & FMT_NUMERIC);
+		printf("%s ", cs.target->name);
+		cs.target->print(&cs.fw, cs.target->t, format & FMT_NUMERIC);
 	}
 
 	if (!(format & FMT_NOCOUNTS)) {
diff --git a/iptables/xtables-arp-standalone.c b/iptables/xtables-arp-standalone.c
index 182dd9f..6553d28 100644
--- a/iptables/xtables-arp-standalone.c
+++ b/iptables/xtables-arp-standalone.c
@@ -41,18 +41,7 @@
 
 #include "xtables-multi.h"
 
-extern struct xtables_globals xtables_globals;
-extern const char *program_version, *program_name;
-
-static const struct xtables_afinfo afinfo_arp = {
-        .kmod          = "arp_tables",
-        .proc_exists   = "/proc/net/arp_tables_names",
-        .libprefix     = "libarp_",
-        .family        = NFPROTO_ARP,
-        .ipproto       = IPPROTO_IP,
-        .so_rev_match  = -1,
-        .so_rev_target = -1,
-};
+extern struct xtables_globals arptables_globals;
 
 int xtables_arp_main(int argc, char *argv[])
 {
@@ -62,22 +51,17 @@ int xtables_arp_main(int argc, char *argv[])
 		.family = NFPROTO_ARP,
 	};
 
-	xtables_globals.program_name = "arptables";
-	/* This code below could be replaced by xtables_init_all, which
-	 * doesn't support NFPROTO_ARP yet.
-	 */
-	xtables_init();
-	afinfo = &afinfo_arp;
-	ret = xtables_set_params(&xtables_globals);
+	arptables_globals.program_name = "arptables";
+	ret = xtables_init_all(&arptables_globals, NFPROTO_ARP);
 	if (ret < 0) {
-		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
-				xtables_globals.program_name,
-				xtables_globals.program_version);
+		fprintf(stderr, "%s/%s Failed to initialize arptables-compat\n",
+			arptables_globals.program_name,
+			arptables_globals.program_version);
 		exit(1);
 	}
 
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
-	init_extensions();
+	init_extensionsa();
 #endif
 
 	ret = do_commandarp(&h, argc, argv, &table);
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index c92b9e7..20b987f 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -44,6 +44,7 @@
 #include <sys/wait.h>
 #include <net/if.h>
 #include <netinet/ether.h>
+#include <iptables.h>
 #include <xtables.h>
 
 #include "xshared.h"
@@ -152,7 +153,13 @@ static struct option *opts = original_opts;
 static unsigned int global_option_offset = 0;
 
 extern void xtables_exit_error(enum xtables_exittype status, const char *msg, ...);
-extern struct xtables_globals xtables_globals;
+struct xtables_globals arptables_globals = {
+	.option_offset		= 0,
+	.program_version	= IPTABLES_VERSION,
+	.orig_opts		= original_opts,
+	.exit_err		= xtables_exit_error,
+	.compat_rev		= nft_compatible_revision,
+};
 
 /* Table of legal combinations of commands and options.  If any of the
  * given commands make an option legal, that option is legal (applies to
@@ -833,11 +840,11 @@ static struct xtables_target *command_jump(struct arpt_entry *fw,
 	xs_init_target(target);
 
 	if (target->x6_options != NULL)
-		opts = xtables_options_xfrm(xtables_globals.orig_opts,
+		opts = xtables_options_xfrm(arptables_globals.orig_opts,
 					    opts, target->x6_options,
 					    &target->option_offset);
 	else
-		opts = xtables_merge_options(xtables_globals.orig_opts,
+		opts = xtables_merge_options(arptables_globals.orig_opts,
 					     opts, target->extra_opts,
 					     &target->option_offset);
 
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 16e4d96..0200c7a 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -178,6 +178,16 @@ static const struct xtables_afinfo afinfo_bridge = {
 	.so_rev_target = -1,
 };
 
+static const struct xtables_afinfo afinfo_arp = {
+	.kmod          = "arp_tables",
+	.proc_exists   = "/proc/net/eb_tables_names",
+	.libprefix     = "libarpt_",
+	.family        = NFPROTO_ARP,
+	.ipproto       = IPPROTO_IP,
+	.so_rev_match  = -1,
+	.so_rev_target = -1,
+};
+
 const struct xtables_afinfo *afinfo;
 
 /* Search path for Xtables .so files */
@@ -237,6 +247,9 @@ void xtables_set_nfproto(uint8_t nfproto)
 	case NFPROTO_BRIDGE:
 		afinfo = &afinfo_bridge;
 		break;
+	case NFPROTO_ARP:
+		afinfo = &afinfo_arp;
+		break;
 	default:
 		fprintf(stderr, "libxtables: unhandled NFPROTO in %s\n",
 		        __func__);

