From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 2/3] libxtables: Add NFPROTO_ARP support for libarpt_* prefixed extensions
Date: Fri,  6 Sep 2013 10:51:49 +0300
Message-ID: <1378453910-17954-3-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1378453910-17954-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:8636 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab3IFHv5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Sep 2013 03:51:57 -0400
In-Reply-To: <1378453910-17954-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This will be useful for arptables-nftables to reuse libxtables thus avoiding
to port libarptc.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 configure.ac                             |   5 +
 extensions/GNUmakefile.in                |  52 ++++++--
 include/linux/netfilter_arp.h            |  19 +++
 include/linux/netfilter_arp/arp_tables.h | 204 +++++++++++++++++++++++++++++++
 libxtables/xtables.c                     |  14 +++
 5 files changed, 286 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/netfilter_arp.h
 create mode 100644 include/linux/netfilter_arp/arp_tables.h

diff --git a/configure.ac b/configure.ac
index 1c713e8..fb2011c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -39,6 +39,9 @@ AC_ARG_ENABLE([ipv4],
 AC_ARG_ENABLE([ipv6],
 	AS_HELP_STRING([--disable-ipv6], [Do not build ip6tables]),
 	[enable_ipv6="$enableval"], [enable_ipv6="yes"])
+AC_ARG_ENABLE([arp],
+	AS_HELP_STRING([--disable-arp], [Do not build xtables-arptables]),
+	[enable_arp="$enableval"], [enable_arp="yes"])
 AC_ARG_ENABLE([largefile],
 	AS_HELP_STRING([--disable-largefile], [Do not build largefile support]),
 	[enable_largefile="$enableval"],
@@ -101,6 +104,7 @@ AM_CONDITIONAL([ENABLE_STATIC], [test "$enable_static" = "yes"])
 AM_CONDITIONAL([ENABLE_SHARED], [test "$enable_shared" = "yes"])
 AM_CONDITIONAL([ENABLE_IPV4], [test "$enable_ipv4" = "yes"])
 AM_CONDITIONAL([ENABLE_IPV6], [test "$enable_ipv6" = "yes"])
+AM_CONDITIONAL([ENABLE_ARP], [test "$enable_arp" = "yes"])
 AM_CONDITIONAL([ENABLE_LARGEFILE], [test "$enable_largefile" = "yes"])
 AM_CONDITIONAL([ENABLE_DEVEL], [test "$enable_devel" = "yes"])
 AM_CONDITIONAL([ENABLE_LIBIPQ], [test "$enable_libipq" = "yes"])
@@ -211,6 +215,7 @@ echo "
 Iptables Configuration:
   IPv4 support:				${enable_ipv4}
   IPv6 support:				${enable_ipv6}
+  ARP support:				${enable_arp}
   Devel support:			${enable_devel}
   IPQ support:				${enable_libipq}
   Large file support:			${enable_largefile}
diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 14e7c57..38b6dd4 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -42,27 +42,32 @@ pfx_build_mod := $(patsubst ${srcdir}/libxt_%.c,%,$(sort $(wildcard ${srcdir}/li
 pfx_symlinks  := NOTRACK state
 @ENABLE_IPV4_TRUE@ pf4_build_mod := $(patsubst ${srcdir}/libipt_%.c,%,$(sort $(wildcard ${srcdir}/libipt_*.c)))
 @ENABLE_IPV6_TRUE@ pf6_build_mod := $(patsubst ${srcdir}/libip6t_%.c,%,$(sort $(wildcard ${srcdir}/libip6t_*.c)))
+@ENABLE_ARP_TRUE@ pfa_build_mod := $(patsubst ${srcdir}/libarpt_%.c,%,$(sort $(wildcard ${srcdir}/libarpt_*.c)))
 pfx_build_mod := $(filter-out @blacklist_modules@,${pfx_build_mod})
 pf4_build_mod := $(filter-out @blacklist_modules@,${pf4_build_mod})
 pf6_build_mod := $(filter-out @blacklist_modules@,${pf6_build_mod})
+pfa_build_mod := $(filter-out @blacklist_modules@,${pfa_build_mod})
 pfx_objs      := $(patsubst %,libxt_%.o,${pfx_build_mod})
 pf4_objs      := $(patsubst %,libipt_%.o,${pf4_build_mod})
 pf6_objs      := $(patsubst %,libip6t_%.o,${pf6_build_mod})
+pfa_objs      := $(patsubst %,libarpt_%.o,${pfa_build_mod})
 pfx_solibs    := $(patsubst %,libxt_%.so,${pfx_build_mod} ${pfx_symlinks})
 pf4_solibs    := $(patsubst %,libipt_%.so,${pf4_build_mod})
 pf6_solibs    := $(patsubst %,libip6t_%.so,${pf6_build_mod})
+pfa_solibs    := $(patsubst %,libarpt_%.so,${pfa_build_mod})
 
 
 #
 # Building blocks
 #
-targets := libext.a libext4.a libext6.a matches.man targets.man
+targets := libext.a libext4.a libext6.a libexta.a matches.man targets.man
 targets_install :=
 @ENABLE_STATIC_TRUE@ libext_objs := ${pfx_objs}
 @ENABLE_STATIC_TRUE@ libext4_objs := ${pf4_objs}
 @ENABLE_STATIC_TRUE@ libext6_objs := ${pf6_objs}
-@ENABLE_STATIC_FALSE@ targets += ${pfx_solibs} ${pf4_solibs} ${pf6_solibs}
-@ENABLE_STATIC_FALSE@ targets_install += ${pfx_solibs} ${pf4_solibs} ${pf6_solibs}
+@ENABLE_STATIC_TRUE@ libexta_objs := ${pfa_objs}
+@ENABLE_STATIC_FALSE@ targets += ${pfx_solibs} ${pf4_solibs} ${pf6_solibs} ${pfa_solibs}
+@ENABLE_STATIC_FALSE@ targets_install += ${pfx_solibs} ${pf4_solibs} ${pf6_solibs} ${pfa_solibs}
 
 .SECONDARY:
 
@@ -75,7 +80,7 @@ install: ${targets_install}
 	if test -n "${targets_install}"; then install -pm0755 $^ "${DESTDIR}${xtlibdir}/"; fi;
 
 clean:
-	rm -f *.o *.oo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c;
+	rm -f *.o *.oo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c initexta.c;
 	rm -f .*.d .*.dd;
 
 distclean: clean
@@ -126,9 +131,13 @@ libext4.a: initext4.o ${libext4_objs}
 libext6.a: initext6.o ${libext6_objs}
 	${AM_VERBOSE_AR} ${AR} crs $@ $^;
 
+libexta.a: initexta.o ${libexta_objs}
+	${AM_VERBOSE_AR} ${AR} crs $@ $^;
+
 initext_func  := $(addprefix xt_,${pfx_build_mod})
 initext4_func := $(addprefix ipt_,${pf4_build_mod})
 initext6_func := $(addprefix ip6t_,${pf6_build_mod})
+initexta_func := $(addprefix arpt_,${pfa_build_mod})
 
 .initext.dd: FORCE
 	@echo "${initext_func}" >$@.tmp; \
@@ -145,6 +154,11 @@ initext6_func := $(addprefix ip6t_,${pf6_build_mod})
 	cmp -s $@ $@.tmp || mv $@.tmp $@; \
 	rm -f $@.tmp;
 
+.initexta.dd: FORCE
+	@echo "${initexta_func}" >$@.tmp; \
+	cmp -s $@ $@.tmp || mv $@.tmp $@; \
+	rm -f $@.tmp;
+
 initext.c: .initext.dd
 	${AM_VERBOSE_GEN}
 	@( \
@@ -193,6 +207,22 @@ initext6.c: .initext6.dd
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
+		echo " ""lib$${i}_init();" >>$@; \
+	done; \
+	echo "}" >>$@; \
+	);
+
 #
 #	Manual pages
 #
@@ -219,10 +249,16 @@ man_run    = \
 			echo ".SS $$ext (IPv4-specific)"; \
 			cat "$$f" || exit $$?; \
 		fi; \
+		f="${srcdir}/libarpt_$$ext.man"; \
+		if [ -f "$$f" ]; then \
+			echo -e "\t+ $$f" >&2; \
+			echo ".SS $$ext (ARP-specific)"; \
+			cat "$$f" || exit $$?; \
+		fi; \
 	done >$@;
 
-matches.man: .initext.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
-	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfx_symlinks}))
+matches.man: .initext.dd .initext4.dd .initext6.dd .initexta.dd $(wildcard ${srcdir}/lib*.man)
+	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfa_build_mod} ${pfx_symlinks}))
 
-targets.man: .initext.dd .initext4.dd .initext6.dd $(wildcard ${srcdir}/lib*.man)
-	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfx_symlinks}))
+targets.man: .initext.dd .initext4.dd .initext6.dd .initexta.dd $(wildcard ${srcdir}/lib*.man)
+	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf4_build_mod} ${pf6_build_mod} ${pfa_build_mod} ${pfx_symlinks}))
diff --git a/include/linux/netfilter_arp.h b/include/linux/netfilter_arp.h
new file mode 100644
index 0000000..92bc6dd
--- /dev/null
+++ b/include/linux/netfilter_arp.h
@@ -0,0 +1,19 @@
+#ifndef __LINUX_ARP_NETFILTER_H
+#define __LINUX_ARP_NETFILTER_H
+
+/* ARP-specific defines for netfilter.
+ * (C)2002 Rusty Russell IBM -- This code is GPL.
+ */
+
+#include <linux/netfilter.h>
+
+/* There is no PF_ARP. */
+#define NF_ARP		0
+
+/* ARP Hooks */
+#define NF_ARP_IN	0
+#define NF_ARP_OUT	1
+#define NF_ARP_FORWARD	2
+#define NF_ARP_NUMHOOKS	3
+
+#endif /* __LINUX_ARP_NETFILTER_H */
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
new file mode 100644
index 0000000..bb1ec64
--- /dev/null
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -0,0 +1,204 @@
+/*
+ * 	Format of an ARP firewall descriptor
+ *
+ * 	src, tgt, src_mask, tgt_mask, arpop, arpop_mask are always stored in
+ *	network byte order.
+ * 	flags are stored in host byte order (of course).
+ */
+
+#ifndef _ARPTABLES_H
+#define _ARPTABLES_H
+
+#include <linux/types.h>
+
+#include <linux/netfilter_arp.h>
+
+#include <linux/netfilter/x_tables.h>
+
+#define ARPT_FUNCTION_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
+#define ARPT_TABLE_MAXNAMELEN XT_TABLE_MAXNAMELEN
+#define arpt_entry_target xt_entry_target
+#define arpt_standard_target xt_standard_target
+#define arpt_error_target xt_error_target
+#define ARPT_CONTINUE XT_CONTINUE
+#define ARPT_RETURN XT_RETURN
+#define arpt_counters_info xt_counters_info
+#define arpt_counters xt_counters
+#define ARPT_STANDARD_TARGET XT_STANDARD_TARGET
+#define ARPT_ERROR_TARGET XT_ERROR_TARGET
+#define ARPT_ENTRY_ITERATE(entries, size, fn, args...) \
+	XT_ENTRY_ITERATE(struct arpt_entry, entries, size, fn, ## args)
+
+#define ARPT_DEV_ADDR_LEN_MAX 16
+
+struct arpt_devaddr_info {
+	char addr[ARPT_DEV_ADDR_LEN_MAX];
+	char mask[ARPT_DEV_ADDR_LEN_MAX];
+};
+
+/* Yes, Virginia, you have to zero the padding. */
+struct arpt_arp {
+	/* Source and target IP addr */
+	struct in_addr src, tgt;
+	/* Mask for src and target IP addr */
+	struct in_addr smsk, tmsk;
+
+	/* Device hw address length, src+target device addresses */
+	__u8 arhln, arhln_mask;
+	struct arpt_devaddr_info src_devaddr;
+	struct arpt_devaddr_info tgt_devaddr;
+
+	/* ARP operation code. */
+	__be16 arpop, arpop_mask;
+
+	/* ARP hardware address and protocol address format. */
+	__be16 arhrd, arhrd_mask;
+	__be16 arpro, arpro_mask;
+
+	/* The protocol address length is only accepted if it is 4
+	 * so there is no use in offering a way to do filtering on it.
+	 */
+
+	char iniface[IFNAMSIZ], outiface[IFNAMSIZ];
+	unsigned char iniface_mask[IFNAMSIZ], outiface_mask[IFNAMSIZ];
+
+	/* Flags word */
+	__u8 flags;
+	/* Inverse flags */
+	__u16 invflags;
+};
+
+/* Values for "flag" field in struct arpt_ip (general arp structure).
+ * No flags defined yet.
+ */
+#define ARPT_F_MASK		0x00	/* All possible flag bits mask. */
+
+/* Values for "inv" field in struct arpt_arp. */
+#define ARPT_INV_VIA_IN		0x0001	/* Invert the sense of IN IFACE. */
+#define ARPT_INV_VIA_OUT	0x0002	/* Invert the sense of OUT IFACE */
+#define ARPT_INV_SRCIP		0x0004	/* Invert the sense of SRC IP. */
+#define ARPT_INV_TGTIP		0x0008	/* Invert the sense of TGT IP. */
+#define ARPT_INV_SRCDEVADDR	0x0010	/* Invert the sense of SRC DEV ADDR. */
+#define ARPT_INV_TGTDEVADDR	0x0020	/* Invert the sense of TGT DEV ADDR. */
+#define ARPT_INV_ARPOP		0x0040	/* Invert the sense of ARP OP. */
+#define ARPT_INV_ARPHRD		0x0080	/* Invert the sense of ARP HRD. */
+#define ARPT_INV_ARPPRO		0x0100	/* Invert the sense of ARP PRO. */
+#define ARPT_INV_ARPHLN		0x0200	/* Invert the sense of ARP HLN. */
+#define ARPT_INV_MASK		0x03FF	/* All possible flag bits mask. */
+
+/* This structure defines each of the firewall rules.  Consists of 3
+   parts which are 1) general ARP header stuff 2) match specific
+   stuff 3) the target to perform if the rule matches */
+struct arpt_entry
+{
+	struct arpt_arp arp;
+
+	/* Size of arpt_entry + matches */
+	__u16 target_offset;
+	/* Size of arpt_entry + matches + target */
+	__u16 next_offset;
+
+	/* Back pointer */
+	unsigned int comefrom;
+
+	/* Packet and byte counters. */
+	struct xt_counters counters;
+
+	/* The matches (if any), then the target. */
+	unsigned char elems[0];
+};
+
+/*
+ * New IP firewall options for [gs]etsockopt at the RAW IP level.
+ * Unlike BSD Linux inherits IP options so you don't have to use a raw
+ * socket for this. Instead we check rights in the calls.
+ *
+ * ATTENTION: check linux/in.h before adding new number here.
+ */
+#define ARPT_BASE_CTL		96
+
+#define ARPT_SO_SET_REPLACE		(ARPT_BASE_CTL)
+#define ARPT_SO_SET_ADD_COUNTERS	(ARPT_BASE_CTL + 1)
+#define ARPT_SO_SET_MAX			ARPT_SO_SET_ADD_COUNTERS
+
+#define ARPT_SO_GET_INFO		(ARPT_BASE_CTL)
+#define ARPT_SO_GET_ENTRIES		(ARPT_BASE_CTL + 1)
+/* #define ARPT_SO_GET_REVISION_MATCH	(APRT_BASE_CTL + 2) */
+#define ARPT_SO_GET_REVISION_TARGET	(ARPT_BASE_CTL + 3)
+#define ARPT_SO_GET_MAX			(ARPT_SO_GET_REVISION_TARGET)
+
+/* The argument to ARPT_SO_GET_INFO */
+struct arpt_getinfo {
+	/* Which table: caller fills this in. */
+	char name[XT_TABLE_MAXNAMELEN];
+
+	/* Kernel fills these in. */
+	/* Which hook entry points are valid: bitmask */
+	unsigned int valid_hooks;
+
+	/* Hook entry points: one per netfilter hook. */
+	unsigned int hook_entry[NF_ARP_NUMHOOKS];
+
+	/* Underflow points. */
+	unsigned int underflow[NF_ARP_NUMHOOKS];
+
+	/* Number of entries */
+	unsigned int num_entries;
+
+	/* Size of entries. */
+	unsigned int size;
+};
+
+/* The argument to ARPT_SO_SET_REPLACE. */
+struct arpt_replace {
+	/* Which table. */
+	char name[XT_TABLE_MAXNAMELEN];
+
+	/* Which hook entry points are valid: bitmask.  You can't
+           change this. */
+	unsigned int valid_hooks;
+
+	/* Number of entries */
+	unsigned int num_entries;
+
+	/* Total size of new entries */
+	unsigned int size;
+
+	/* Hook entry points. */
+	unsigned int hook_entry[NF_ARP_NUMHOOKS];
+
+	/* Underflow points. */
+	unsigned int underflow[NF_ARP_NUMHOOKS];
+
+	/* Information about old entries: */
+	/* Number of counters (must be equal to current number of entries). */
+	unsigned int num_counters;
+	/* The old entries' counters. */
+	struct xt_counters *counters;
+
+	/* The entries (hang off end: not really an array). */
+	struct arpt_entry entries[0];
+};
+
+/* The argument to ARPT_SO_GET_ENTRIES. */
+struct arpt_get_entries {
+	/* Which table: user fills this in. */
+	char name[XT_TABLE_MAXNAMELEN];
+
+	/* User fills this in: total entry size. */
+	unsigned int size;
+
+	/* The entries. */
+	struct arpt_entry entrytable[0];
+};
+
+/* Helper functions */
+static __inline__ struct xt_entry_target *arpt_get_target(struct arpt_entry *e)
+{
+	return (void *)e + e->target_offset;
+}
+
+/*
+ *	Main firewall chains definitions and global var's definitions.
+ */
+#endif /* _ARPTABLES_H */
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index e2e9949..20fd6d8 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -46,6 +46,7 @@
 #include <limits.h> /* INT_MAX in ip_tables.h/ip6_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_arp/arp_tables.h>
 #include <libiptc/libxtc.h>
 
 #ifndef NO_SHARED_LIBS
@@ -168,6 +169,16 @@ static const struct xtables_afinfo afinfo_ipv6 = {
 	.so_rev_target = IP6T_SO_GET_REVISION_TARGET,
 };
 
+static const struct xtables_afinfo afinfo_arp = {
+	.kmod          = "arp_tables",
+	.proc_exists   = "/proc/net/arp_tables_names",
+	.libprefix     = "libarpt_",
+	.family        = NFPROTO_ARP,
+	.ipproto       = -1,
+	.so_rev_match  = -1, /* ARPT_SO_GET_REVISION_MATCH is not defined */
+	.so_rev_target = ARPT_SO_GET_REVISION_TARGET,
+};
+
 const struct xtables_afinfo *afinfo;
 
 /* Search path for Xtables .so files */
@@ -224,6 +235,9 @@ void xtables_set_nfproto(uint8_t nfproto)
 	case NFPROTO_IPV6:
 		afinfo = &afinfo_ipv6;
 		break;
+	case NFPROTO_ARP:
+		afinfo = &afinfo_arp;
+		break;
 	default:
 		fprintf(stderr, "libxtables: unhandled NFPROTO in %s\n",
 		        __func__);
-- 
1.8.3.2

