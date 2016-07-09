From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft v4 1/3] include: cache ip_tables.h, ip6_tables.h, arp_tables.h and ebtables.h
Date: Sat,  9 Jul 2016 12:24:52 +0200
Message-ID: <20160709102454.2978-1-pablombg@gmail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36307 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbcGIK0W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Jul 2016 06:26:22 -0400
Received: by mail-wm0-f67.google.com with SMTP id x83so9724618wma.3
        for <netfilter-devel@vger.kernel.org>; Sat, 09 Jul 2016 03:26:21 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira <pablo@netfilter.org>

The xt over nft support that comes in follow up patches need this, and update
the corresponding Makefile.am.

Based on patch from Arturo Borrero Gonzalez.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

Resubmission of xt compat support preparatory patch.

Changes in v4:
  - None in this patch.

 configure.ac                               |   4 +
 include/linux/Makefile.am                  |   7 +-
 include/linux/netfilter_arp/Makefile.am    |   1 +
 include/linux/netfilter_arp/arp_tables.h   | 204 ++++++++++++++++++++++
 include/linux/netfilter_bridge/Makefile.am |   1 +
 include/linux/netfilter_bridge/ebtables.h  | 266 +++++++++++++++++++++++++++++
 include/linux/netfilter_ipv4/Makefile.am   |   1 +
 include/linux/netfilter_ipv4/ip_tables.h   | 227 ++++++++++++++++++++++++
 include/linux/netfilter_ipv6/Makefile.am   |   1 +
 include/linux/netfilter_ipv6/ip6_tables.h  | 265 ++++++++++++++++++++++++++++
 10 files changed, 976 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/netfilter_arp/Makefile.am
 create mode 100644 include/linux/netfilter_arp/arp_tables.h
 create mode 100644 include/linux/netfilter_bridge/Makefile.am
 create mode 100644 include/linux/netfilter_bridge/ebtables.h
 create mode 100644 include/linux/netfilter_ipv4/Makefile.am
 create mode 100644 include/linux/netfilter_ipv4/ip_tables.h
 create mode 100644 include/linux/netfilter_ipv6/Makefile.am
 create mode 100644 include/linux/netfilter_ipv6/ip6_tables.h

diff --git a/configure.ac b/configure.ac
index 877f530..a1d7723 100644
--- a/configure.ac
+++ b/configure.ac
@@ -132,6 +132,10 @@ AC_CONFIG_FILES([					\
 		include/Makefile			\
 		include/linux/Makefile			\
 		include/linux/netfilter/Makefile	\
+		include/linux/netfilter_arp/Makefile	\
+		include/linux/netfilter_bridge/Makefile	\
+		include/linux/netfilter_ipv4/Makefile	\
+		include/linux/netfilter_ipv6/Makefile	\
 		doc/Makefile				\
 		files/Makefile				\
 		files/nftables/Makefile			\
diff --git a/include/linux/Makefile.am b/include/linux/Makefile.am
index 9fb010b..eb9fc4e 100644
--- a/include/linux/Makefile.am
+++ b/include/linux/Makefile.am
@@ -1,4 +1,9 @@
-SUBDIRS = netfilter
+SUBDIRS =		netfilter		\
+			netfilter_arp		\
+			netfilter_bridge	\
+			netfilter_ipv4		\
+			netfilter_ipv6
+
 noinst_HEADERS =	netfilter_arp.h		\
 			netfilter_bridge.h	\
 			netfilter_decnet.h	\
diff --git a/include/linux/netfilter_arp/Makefile.am b/include/linux/netfilter_arp/Makefile.am
new file mode 100644
index 0000000..0a16c1a
--- /dev/null
+++ b/include/linux/netfilter_arp/Makefile.am
@@ -0,0 +1 @@
+noinst_HEADERS =	arp_tables.h
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
diff --git a/include/linux/netfilter_bridge/Makefile.am b/include/linux/netfilter_bridge/Makefile.am
new file mode 100644
index 0000000..d2e8b38
--- /dev/null
+++ b/include/linux/netfilter_bridge/Makefile.am
@@ -0,0 +1 @@
+noinst_HEADERS =	ebtables.h
diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
new file mode 100644
index 0000000..a225911
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -0,0 +1,266 @@
+/*
+ *  ebtables
+ *
+ *	Authors:
+ *	Bart De Schuymer		<bdschuym@pandora.be>
+ *
+ *  ebtables.c,v 2.0, April, 2002
+ *
+ *  This code is stongly inspired on the iptables code which is
+ *  Copyright (C) 1999 Paul `Rusty' Russell & Michael J. Neuling
+ */
+
+#ifndef __LINUX_BRIDGE_EFF_H
+#define __LINUX_BRIDGE_EFF_H
+#include <linux/netfilter_bridge.h>
+
+#define EBT_TABLE_MAXNAMELEN 32
+#define EBT_CHAIN_MAXNAMELEN EBT_TABLE_MAXNAMELEN
+#define EBT_FUNCTION_MAXNAMELEN EBT_TABLE_MAXNAMELEN
+
+/* verdicts >0 are "branches" */
+#define EBT_ACCEPT   -1
+#define EBT_DROP     -2
+#define EBT_CONTINUE -3
+#define EBT_RETURN   -4
+#define NUM_STANDARD_TARGETS   4
+/* ebtables target modules store the verdict inside an int. We can
+ * reclaim a part of this int for backwards compatible extensions.
+ * The 4 lsb are more than enough to store the verdict. */
+#define EBT_VERDICT_BITS 0x0000000F
+
+struct xt_match;
+struct xt_target;
+
+struct ebt_counter {
+	uint64_t pcnt;
+	uint64_t bcnt;
+};
+
+struct ebt_replace {
+	char name[EBT_TABLE_MAXNAMELEN];
+	unsigned int valid_hooks;
+	/* nr of rules in the table */
+	unsigned int nentries;
+	/* total size of the entries */
+	unsigned int entries_size;
+	/* start of the chains */
+	struct ebt_entries *hook_entry[NF_BR_NUMHOOKS];
+	/* nr of counters userspace expects back */
+	unsigned int num_counters;
+	/* where the kernel will put the old counters */
+	struct ebt_counter *counters;
+	char *entries;
+};
+
+struct ebt_replace_kernel {
+	char name[EBT_TABLE_MAXNAMELEN];
+	unsigned int valid_hooks;
+	/* nr of rules in the table */
+	unsigned int nentries;
+	/* total size of the entries */
+	unsigned int entries_size;
+	/* start of the chains */
+	struct ebt_entries *hook_entry[NF_BR_NUMHOOKS];
+	/* nr of counters userspace expects back */
+	unsigned int num_counters;
+	/* where the kernel will put the old counters */
+	struct ebt_counter *counters;
+	char *entries;
+};
+
+struct ebt_entries {
+	/* this field is always set to zero
+	 * See EBT_ENTRY_OR_ENTRIES.
+	 * Must be same size as ebt_entry.bitmask */
+	unsigned int distinguisher;
+	/* the chain name */
+	char name[EBT_CHAIN_MAXNAMELEN];
+	/* counter offset for this chain */
+	unsigned int counter_offset;
+	/* one standard (accept, drop, return) per hook */
+	int policy;
+	/* nr. of entries */
+	unsigned int nentries;
+	/* entry list */
+	char data[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
+};
+
+/* used for the bitmask of struct ebt_entry */
+
+/* This is a hack to make a difference between an ebt_entry struct and an
+ * ebt_entries struct when traversing the entries from start to end.
+ * Using this simplifies the code a lot, while still being able to use
+ * ebt_entries.
+ * Contrary, iptables doesn't use something like ebt_entries and therefore uses
+ * different techniques for naming the policy and such. So, iptables doesn't
+ * need a hack like this.
+ */
+#define EBT_ENTRY_OR_ENTRIES 0x01
+/* these are the normal masks */
+#define EBT_NOPROTO 0x02
+#define EBT_802_3 0x04
+#define EBT_SOURCEMAC 0x08
+#define EBT_DESTMAC 0x10
+#define EBT_F_MASK (EBT_NOPROTO | EBT_802_3 | EBT_SOURCEMAC | EBT_DESTMAC \
+   | EBT_ENTRY_OR_ENTRIES)
+
+#define EBT_IPROTO 0x01
+#define EBT_IIN 0x02
+#define EBT_IOUT 0x04
+#define EBT_ISOURCE 0x8
+#define EBT_IDEST 0x10
+#define EBT_ILOGICALIN 0x20
+#define EBT_ILOGICALOUT 0x40
+#define EBT_INV_MASK (EBT_IPROTO | EBT_IIN | EBT_IOUT | EBT_ILOGICALIN \
+   | EBT_ILOGICALOUT | EBT_ISOURCE | EBT_IDEST)
+
+struct ebt_entry_match {
+	union {
+		char name[EBT_FUNCTION_MAXNAMELEN];
+		struct xt_match *match;
+	} u;
+	/* size of data */
+	unsigned int match_size;
+	unsigned char data[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
+};
+
+struct ebt_entry_watcher {
+	union {
+		char name[EBT_FUNCTION_MAXNAMELEN];
+		struct xt_target *watcher;
+	} u;
+	/* size of data */
+	unsigned int watcher_size;
+	unsigned char data[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
+};
+
+struct ebt_entry_target {
+	union {
+		char name[EBT_FUNCTION_MAXNAMELEN];
+		struct xt_target *target;
+	} u;
+	/* size of data */
+	unsigned int target_size;
+	unsigned char data[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
+};
+
+#define EBT_STANDARD_TARGET "standard"
+struct ebt_standard_target {
+	struct ebt_entry_target target;
+	int verdict;
+};
+
+/* one entry */
+struct ebt_entry {
+	/* this needs to be the first field */
+	unsigned int bitmask;
+	unsigned int invflags;
+	__be16 ethproto;
+	/* the physical in-dev */
+	char in[IFNAMSIZ];
+	/* the logical in-dev */
+	char logical_in[IFNAMSIZ];
+	/* the physical out-dev */
+	char out[IFNAMSIZ];
+	/* the logical out-dev */
+	char logical_out[IFNAMSIZ];
+	unsigned char sourcemac[ETH_ALEN];
+	unsigned char sourcemsk[ETH_ALEN];
+	unsigned char destmac[ETH_ALEN];
+	unsigned char destmsk[ETH_ALEN];
+	/* sizeof ebt_entry + matches */
+	unsigned int watchers_offset;
+	/* sizeof ebt_entry + matches + watchers */
+	unsigned int target_offset;
+	/* sizeof ebt_entry + matches + watchers + target */
+	unsigned int next_offset;
+	unsigned char elems[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
+};
+
+/* {g,s}etsockopt numbers */
+#define EBT_BASE_CTL            128
+
+#define EBT_SO_SET_ENTRIES      (EBT_BASE_CTL)
+#define EBT_SO_SET_COUNTERS     (EBT_SO_SET_ENTRIES+1)
+#define EBT_SO_SET_MAX          (EBT_SO_SET_COUNTERS+1)
+
+#define EBT_SO_GET_INFO         (EBT_BASE_CTL)
+#define EBT_SO_GET_ENTRIES      (EBT_SO_GET_INFO+1)
+#define EBT_SO_GET_INIT_INFO    (EBT_SO_GET_ENTRIES+1)
+#define EBT_SO_GET_INIT_ENTRIES (EBT_SO_GET_INIT_INFO+1)
+#define EBT_SO_GET_MAX          (EBT_SO_GET_INIT_ENTRIES+1)
+
+
+/* blatently stolen from ip_tables.h
+ * fn returns 0 to continue iteration */
+#define EBT_MATCH_ITERATE(e, fn, args...)                   \
+({                                                          \
+	unsigned int __i;                                   \
+	int __ret = 0;                                      \
+	struct ebt_entry_match *__match;                    \
+	                                                    \
+	for (__i = sizeof(struct ebt_entry);                \
+	     __i < (e)->watchers_offset;                    \
+	     __i += __match->match_size +                   \
+	     sizeof(struct ebt_entry_match)) {              \
+		__match = (void *)(e) + __i;                \
+		                                            \
+		__ret = fn(__match , ## args);              \
+		if (__ret != 0)                             \
+			break;                              \
+	}                                                   \
+	if (__ret == 0) {                                   \
+		if (__i != (e)->watchers_offset)            \
+			__ret = -EINVAL;                    \
+	}                                                   \
+	__ret;                                              \
+})
+
+#define EBT_WATCHER_ITERATE(e, fn, args...)                 \
+({                                                          \
+	unsigned int __i;                                   \
+	int __ret = 0;                                      \
+	struct ebt_entry_watcher *__watcher;                \
+	                                                    \
+	for (__i = e->watchers_offset;                      \
+	     __i < (e)->target_offset;                      \
+	     __i += __watcher->watcher_size +               \
+	     sizeof(struct ebt_entry_watcher)) {            \
+		__watcher = (void *)(e) + __i;              \
+		                                            \
+		__ret = fn(__watcher , ## args);            \
+		if (__ret != 0)                             \
+			break;                              \
+	}                                                   \
+	if (__ret == 0) {                                   \
+		if (__i != (e)->target_offset)              \
+			__ret = -EINVAL;                    \
+	}                                                   \
+	__ret;                                              \
+})
+
+#define EBT_ENTRY_ITERATE(entries, size, fn, args...)       \
+({                                                          \
+	unsigned int __i;                                   \
+	int __ret = 0;                                      \
+	struct ebt_entry *__entry;                          \
+	                                                    \
+	for (__i = 0; __i < (size);) {                      \
+		__entry = (void *)(entries) + __i;          \
+		__ret = fn(__entry , ## args);              \
+		if (__ret != 0)                             \
+			break;                              \
+		if (__entry->bitmask != 0)                  \
+			__i += __entry->next_offset;        \
+		else                                        \
+			__i += sizeof(struct ebt_entries);  \
+	}                                                   \
+	if (__ret == 0) {                                   \
+		if (__i != (size))                          \
+			__ret = -EINVAL;                    \
+	}                                                   \
+	__ret;                                              \
+})
+
+#endif /* __LINUX_BRIDGE_EFF_H */
diff --git a/include/linux/netfilter_ipv4/Makefile.am b/include/linux/netfilter_ipv4/Makefile.am
new file mode 100644
index 0000000..fec4253
--- /dev/null
+++ b/include/linux/netfilter_ipv4/Makefile.am
@@ -0,0 +1 @@
+noinst_HEADERS =	ip_tables.h
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
new file mode 100644
index 0000000..38542b4
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -0,0 +1,227 @@
+/*
+ * 25-Jul-1998 Major changes to allow for ip chain table
+ *
+ * 3-Jan-2000 Named tables to allow packet selection for different uses.
+ */
+
+/*
+ * 	Format of an IP firewall descriptor
+ *
+ * 	src, dst, src_mask, dst_mask are always stored in network byte order.
+ * 	flags are stored in host byte order (of course).
+ * 	Port numbers are stored in HOST byte order.
+ */
+
+#ifndef _IPTABLES_H
+#define _IPTABLES_H
+
+#include <linux/types.h>
+
+#include <linux/netfilter_ipv4.h>
+
+#include <linux/netfilter/x_tables.h>
+
+#define IPT_FUNCTION_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
+#define IPT_TABLE_MAXNAMELEN XT_TABLE_MAXNAMELEN
+#define ipt_match xt_match
+#define ipt_target xt_target
+#define ipt_table xt_table
+#define ipt_get_revision xt_get_revision
+#define ipt_entry_match xt_entry_match
+#define ipt_entry_target xt_entry_target
+#define ipt_standard_target xt_standard_target
+#define ipt_error_target xt_error_target
+#define ipt_counters xt_counters
+#define IPT_CONTINUE XT_CONTINUE
+#define IPT_RETURN XT_RETURN
+
+/* This group is older than old (iptables < v1.4.0-rc1~89) */
+#include <linux/netfilter/xt_tcpudp.h>
+#define ipt_udp xt_udp
+#define ipt_tcp xt_tcp
+#define IPT_TCP_INV_SRCPT	XT_TCP_INV_SRCPT
+#define IPT_TCP_INV_DSTPT	XT_TCP_INV_DSTPT
+#define IPT_TCP_INV_FLAGS	XT_TCP_INV_FLAGS
+#define IPT_TCP_INV_OPTION	XT_TCP_INV_OPTION
+#define IPT_TCP_INV_MASK	XT_TCP_INV_MASK
+#define IPT_UDP_INV_SRCPT	XT_UDP_INV_SRCPT
+#define IPT_UDP_INV_DSTPT	XT_UDP_INV_DSTPT
+#define IPT_UDP_INV_MASK	XT_UDP_INV_MASK
+
+/* The argument to IPT_SO_ADD_COUNTERS. */
+#define ipt_counters_info xt_counters_info
+/* Standard return verdict, or do jump. */
+#define IPT_STANDARD_TARGET XT_STANDARD_TARGET
+/* Error verdict. */
+#define IPT_ERROR_TARGET XT_ERROR_TARGET
+
+/* fn returns 0 to continue iteration */
+#define IPT_MATCH_ITERATE(e, fn, args...) \
+	XT_MATCH_ITERATE(struct ipt_entry, e, fn, ## args)
+
+/* fn returns 0 to continue iteration */
+#define IPT_ENTRY_ITERATE(entries, size, fn, args...) \
+	XT_ENTRY_ITERATE(struct ipt_entry, entries, size, fn, ## args)
+
+/* Yes, Virginia, you have to zero the padding. */
+struct ipt_ip {
+	/* Source and destination IP addr */
+	struct in_addr src, dst;
+	/* Mask for src and dest IP addr */
+	struct in_addr smsk, dmsk;
+	char iniface[IFNAMSIZ], outiface[IFNAMSIZ];
+	unsigned char iniface_mask[IFNAMSIZ], outiface_mask[IFNAMSIZ];
+
+	/* Protocol, 0 = ANY */
+	__u16 proto;
+
+	/* Flags word */
+	__u8 flags;
+	/* Inverse flags */
+	__u8 invflags;
+};
+
+/* Values for "flag" field in struct ipt_ip (general ip structure). */
+#define IPT_F_FRAG		0x01	/* Set if rule is a fragment rule */
+#define IPT_F_GOTO		0x02	/* Set if jump is a goto */
+#define IPT_F_MASK		0x03	/* All possible flag bits mask. */
+
+/* Values for "inv" field in struct ipt_ip. */
+#define IPT_INV_VIA_IN		0x01	/* Invert the sense of IN IFACE. */
+#define IPT_INV_VIA_OUT		0x02	/* Invert the sense of OUT IFACE */
+#define IPT_INV_TOS		0x04	/* Invert the sense of TOS. */
+#define IPT_INV_SRCIP		0x08	/* Invert the sense of SRC IP. */
+#define IPT_INV_DSTIP		0x10	/* Invert the sense of DST OP. */
+#define IPT_INV_FRAG		0x20	/* Invert the sense of FRAG. */
+#define IPT_INV_PROTO		XT_INV_PROTO
+#define IPT_INV_MASK		0x7F	/* All possible flag bits mask. */
+
+/* This structure defines each of the firewall rules.  Consists of 3
+   parts which are 1) general IP header stuff 2) match specific
+   stuff 3) the target to perform if the rule matches */
+struct ipt_entry {
+	struct ipt_ip ip;
+
+	/* Mark with fields that we care about. */
+	unsigned int nfcache;
+
+	/* Size of ipt_entry + matches */
+	__u16 target_offset;
+	/* Size of ipt_entry + matches + target */
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
+#define IPT_BASE_CTL		64
+
+#define IPT_SO_SET_REPLACE	(IPT_BASE_CTL)
+#define IPT_SO_SET_ADD_COUNTERS	(IPT_BASE_CTL + 1)
+#define IPT_SO_SET_MAX		IPT_SO_SET_ADD_COUNTERS
+
+#define IPT_SO_GET_INFO			(IPT_BASE_CTL)
+#define IPT_SO_GET_ENTRIES		(IPT_BASE_CTL + 1)
+#define IPT_SO_GET_REVISION_MATCH	(IPT_BASE_CTL + 2)
+#define IPT_SO_GET_REVISION_TARGET	(IPT_BASE_CTL + 3)
+#define IPT_SO_GET_MAX			IPT_SO_GET_REVISION_TARGET
+
+/* ICMP matching stuff */
+struct ipt_icmp {
+	__u8 type;				/* type to match */
+	__u8 code[2];				/* range of code */
+	__u8 invflags;				/* Inverse flags */
+};
+
+/* Values for "inv" field for struct ipt_icmp. */
+#define IPT_ICMP_INV	0x01	/* Invert the sense of type/code test */
+
+/* The argument to IPT_SO_GET_INFO */
+struct ipt_getinfo {
+	/* Which table: caller fills this in. */
+	char name[XT_TABLE_MAXNAMELEN];
+
+	/* Kernel fills these in. */
+	/* Which hook entry points are valid: bitmask */
+	unsigned int valid_hooks;
+
+	/* Hook entry points: one per netfilter hook. */
+	unsigned int hook_entry[NF_INET_NUMHOOKS];
+
+	/* Underflow points. */
+	unsigned int underflow[NF_INET_NUMHOOKS];
+
+	/* Number of entries */
+	unsigned int num_entries;
+
+	/* Size of entries. */
+	unsigned int size;
+};
+
+/* The argument to IPT_SO_SET_REPLACE. */
+struct ipt_replace {
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
+	unsigned int hook_entry[NF_INET_NUMHOOKS];
+
+	/* Underflow points. */
+	unsigned int underflow[NF_INET_NUMHOOKS];
+
+	/* Information about old entries: */
+	/* Number of counters (must be equal to current number of entries). */
+	unsigned int num_counters;
+	/* The old entries' counters. */
+	struct xt_counters *counters;
+
+	/* The entries (hang off end: not really an array). */
+	struct ipt_entry entries[0];
+};
+
+/* The argument to IPT_SO_GET_ENTRIES. */
+struct ipt_get_entries {
+	/* Which table: user fills this in. */
+	char name[XT_TABLE_MAXNAMELEN];
+
+	/* User fills this in: total entry size. */
+	unsigned int size;
+
+	/* The entries. */
+	struct ipt_entry entrytable[0];
+};
+
+/* Helper functions */
+static __inline__ struct xt_entry_target *
+ipt_get_target(struct ipt_entry *e)
+{
+	return (void *)e + e->target_offset;
+}
+
+/*
+ *	Main firewall chains definitions and global var's definitions.
+ */
+#endif /* _IPTABLES_H */
diff --git a/include/linux/netfilter_ipv6/Makefile.am b/include/linux/netfilter_ipv6/Makefile.am
new file mode 100644
index 0000000..bec6c3f
--- /dev/null
+++ b/include/linux/netfilter_ipv6/Makefile.am
@@ -0,0 +1 @@
+noinst_HEADERS =	ip6_tables.h
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
new file mode 100644
index 0000000..4432dd1
--- /dev/null
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -0,0 +1,265 @@
+/*
+ * 25-Jul-1998 Major changes to allow for ip chain table
+ *
+ * 3-Jan-2000 Named tables to allow packet selection for different uses.
+ */
+
+/*
+ * 	Format of an IP6 firewall descriptor
+ *
+ * 	src, dst, src_mask, dst_mask are always stored in network byte order.
+ * 	flags are stored in host byte order (of course).
+ * 	Port numbers are stored in HOST byte order.
+ */
+
+#ifndef _IP6_TABLES_H
+#define _IP6_TABLES_H
+
+#include <linux/types.h>
+
+#include <linux/netfilter_ipv6.h>
+
+#include <linux/netfilter/x_tables.h>
+
+#define IP6T_FUNCTION_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
+#define IP6T_TABLE_MAXNAMELEN XT_TABLE_MAXNAMELEN
+#define ip6t_match xt_match
+#define ip6t_target xt_target
+#define ip6t_table xt_table
+#define ip6t_get_revision xt_get_revision
+#define ip6t_entry_match xt_entry_match
+#define ip6t_entry_target xt_entry_target
+#define ip6t_standard_target xt_standard_target
+#define ip6t_error_target xt_error_target
+#define ip6t_counters xt_counters
+#define IP6T_CONTINUE XT_CONTINUE
+#define IP6T_RETURN XT_RETURN
+
+/* Pre-iptables-1.4.0 */
+#include <linux/netfilter/xt_tcpudp.h>
+#define ip6t_tcp xt_tcp
+#define ip6t_udp xt_udp
+#define IP6T_TCP_INV_SRCPT	XT_TCP_INV_SRCPT
+#define IP6T_TCP_INV_DSTPT	XT_TCP_INV_DSTPT
+#define IP6T_TCP_INV_FLAGS	XT_TCP_INV_FLAGS
+#define IP6T_TCP_INV_OPTION	XT_TCP_INV_OPTION
+#define IP6T_TCP_INV_MASK	XT_TCP_INV_MASK
+#define IP6T_UDP_INV_SRCPT	XT_UDP_INV_SRCPT
+#define IP6T_UDP_INV_DSTPT	XT_UDP_INV_DSTPT
+#define IP6T_UDP_INV_MASK	XT_UDP_INV_MASK
+
+#define ip6t_counters_info xt_counters_info
+#define IP6T_STANDARD_TARGET XT_STANDARD_TARGET
+#define IP6T_ERROR_TARGET XT_ERROR_TARGET
+#define IP6T_MATCH_ITERATE(e, fn, args...) \
+	XT_MATCH_ITERATE(struct ip6t_entry, e, fn, ## args)
+#define IP6T_ENTRY_ITERATE(entries, size, fn, args...) \
+	XT_ENTRY_ITERATE(struct ip6t_entry, entries, size, fn, ## args)
+
+/* Yes, Virginia, you have to zero the padding. */
+struct ip6t_ip6 {
+	/* Source and destination IP6 addr */
+	struct in6_addr src, dst;		
+	/* Mask for src and dest IP6 addr */
+	struct in6_addr smsk, dmsk;
+	char iniface[IFNAMSIZ], outiface[IFNAMSIZ];
+	unsigned char iniface_mask[IFNAMSIZ], outiface_mask[IFNAMSIZ];
+
+	/* Upper protocol number
+	 * - The allowed value is 0 (any) or protocol number of last parsable
+	 *   header, which is 50 (ESP), 59 (No Next Header), 135 (MH), or
+	 *   the non IPv6 extension headers.
+	 * - The protocol numbers of IPv6 extension headers except of ESP and
+	 *   MH do not match any packets.
+	 * - You also need to set IP6T_FLAGS_PROTO to "flags" to check protocol.
+	 */
+	__u16 proto;
+	/* TOS to match iff flags & IP6T_F_TOS */
+	__u8 tos;
+
+	/* Flags word */
+	__u8 flags;
+	/* Inverse flags */
+	__u8 invflags;
+};
+
+/* Values for "flag" field in struct ip6t_ip6 (general ip6 structure). */
+#define IP6T_F_PROTO		0x01	/* Set if rule cares about upper 
+					   protocols */
+#define IP6T_F_TOS		0x02	/* Match the TOS. */
+#define IP6T_F_GOTO		0x04	/* Set if jump is a goto */
+#define IP6T_F_MASK		0x07	/* All possible flag bits mask. */
+
+/* Values for "inv" field in struct ip6t_ip6. */
+#define IP6T_INV_VIA_IN		0x01	/* Invert the sense of IN IFACE. */
+#define IP6T_INV_VIA_OUT		0x02	/* Invert the sense of OUT IFACE */
+#define IP6T_INV_TOS		0x04	/* Invert the sense of TOS. */
+#define IP6T_INV_SRCIP		0x08	/* Invert the sense of SRC IP. */
+#define IP6T_INV_DSTIP		0x10	/* Invert the sense of DST OP. */
+#define IP6T_INV_FRAG		0x20	/* Invert the sense of FRAG. */
+#define IP6T_INV_PROTO		XT_INV_PROTO
+#define IP6T_INV_MASK		0x7F	/* All possible flag bits mask. */
+
+/* This structure defines each of the firewall rules.  Consists of 3
+   parts which are 1) general IP header stuff 2) match specific
+   stuff 3) the target to perform if the rule matches */
+struct ip6t_entry {
+	struct ip6t_ip6 ipv6;
+
+	/* Mark with fields that we care about. */
+	unsigned int nfcache;
+
+	/* Size of ipt_entry + matches */
+	__u16 target_offset;
+	/* Size of ipt_entry + matches + target */
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
+/* Standard entry */
+struct ip6t_standard {
+	struct ip6t_entry entry;
+	struct xt_standard_target target;
+};
+
+struct ip6t_error {
+	struct ip6t_entry entry;
+	struct xt_error_target target;
+};
+
+#define IP6T_ENTRY_INIT(__size)						       \
+{									       \
+	.target_offset	= sizeof(struct ip6t_entry),			       \
+	.next_offset	= (__size),					       \
+}
+
+#define IP6T_STANDARD_INIT(__verdict)					       \
+{									       \
+	.entry		= IP6T_ENTRY_INIT(sizeof(struct ip6t_standard)),       \
+	.target		= XT_TARGET_INIT(XT_STANDARD_TARGET,		       \
+					 sizeof(struct xt_standard_target)),   \
+	.target.verdict	= -(__verdict) - 1,				       \
+}
+
+#define IP6T_ERROR_INIT							       \
+{									       \
+	.entry		= IP6T_ENTRY_INIT(sizeof(struct ip6t_error)),	       \
+	.target		= XT_TARGET_INIT(XT_ERROR_TARGET,		       \
+					 sizeof(struct xt_error_target)),      \
+	.target.errorname = "ERROR",					       \
+}
+
+/*
+ * New IP firewall options for [gs]etsockopt at the RAW IP level.
+ * Unlike BSD Linux inherits IP options so you don't have to use
+ * a raw socket for this. Instead we check rights in the calls.
+ *
+ * ATTENTION: check linux/in6.h before adding new number here.
+ */
+#define IP6T_BASE_CTL			64
+
+#define IP6T_SO_SET_REPLACE		(IP6T_BASE_CTL)
+#define IP6T_SO_SET_ADD_COUNTERS	(IP6T_BASE_CTL + 1)
+#define IP6T_SO_SET_MAX			IP6T_SO_SET_ADD_COUNTERS
+
+#define IP6T_SO_GET_INFO		(IP6T_BASE_CTL)
+#define IP6T_SO_GET_ENTRIES		(IP6T_BASE_CTL + 1)
+#define IP6T_SO_GET_REVISION_MATCH	(IP6T_BASE_CTL + 4)
+#define IP6T_SO_GET_REVISION_TARGET	(IP6T_BASE_CTL + 5)
+#define IP6T_SO_GET_MAX			IP6T_SO_GET_REVISION_TARGET
+
+/* ICMP matching stuff */
+struct ip6t_icmp {
+	__u8 type;				/* type to match */
+	__u8 code[2];				/* range of code */
+	__u8 invflags;				/* Inverse flags */
+};
+
+/* Values for "inv" field for struct ipt_icmp. */
+#define IP6T_ICMP_INV	0x01	/* Invert the sense of type/code test */
+
+/* The argument to IP6T_SO_GET_INFO */
+struct ip6t_getinfo {
+	/* Which table: caller fills this in. */
+	char name[XT_TABLE_MAXNAMELEN];
+
+	/* Kernel fills these in. */
+	/* Which hook entry points are valid: bitmask */
+	unsigned int valid_hooks;
+
+	/* Hook entry points: one per netfilter hook. */
+	unsigned int hook_entry[NF_INET_NUMHOOKS];
+
+	/* Underflow points. */
+	unsigned int underflow[NF_INET_NUMHOOKS];
+
+	/* Number of entries */
+	unsigned int num_entries;
+
+	/* Size of entries. */
+	unsigned int size;
+};
+
+/* The argument to IP6T_SO_SET_REPLACE. */
+struct ip6t_replace {
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
+	unsigned int hook_entry[NF_INET_NUMHOOKS];
+
+	/* Underflow points. */
+	unsigned int underflow[NF_INET_NUMHOOKS];
+
+	/* Information about old entries: */
+	/* Number of counters (must be equal to current number of entries). */
+	unsigned int num_counters;
+	/* The old entries' counters. */
+	struct xt_counters *counters;
+
+	/* The entries (hang off end: not really an array). */
+	struct ip6t_entry entries[0];
+};
+
+/* The argument to IP6T_SO_GET_ENTRIES. */
+struct ip6t_get_entries {
+	/* Which table: user fills this in. */
+	char name[XT_TABLE_MAXNAMELEN];
+
+	/* User fills this in: total entry size. */
+	unsigned int size;
+
+	/* The entries. */
+	struct ip6t_entry entrytable[0];
+};
+
+/* Helper functions */
+static __inline__ struct xt_entry_target *
+ip6t_get_target(struct ip6t_entry *e)
+{
+	return (void *)e + e->target_offset;
+}
+
+/*
+ *	Main firewall chains definitions and global var's definitions.
+ */
+
+#endif /* _IP6_TABLES_H */
-- 
2.9.0

