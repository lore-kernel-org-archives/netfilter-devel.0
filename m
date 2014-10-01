From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH 1/3] xtables: bootstrap xtables-eb for nftables
Date: Wed,  1 Oct 2014 16:47:08 +0200
Message-ID: <1412174830-3620-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43713 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaJAOnK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:43:10 -0400
Received: by mail-wi0-f172.google.com with SMTP id n3so800483wiv.17
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Oct 2014 07:43:08 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch bootstraps xtables-eb for the nftables compatibility layer

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 include/linux/netfilter_bridge.h            |   33 +
 include/linux/netfilter_bridge/ebtables.h   |  276 +++++++
 include/linux/netfilter_bridge/ethernetdb.h |   58 ++
 iptables/Makefile.am                        |    6 +-
 iptables/getethertype.c                     |  161 ++++
 iptables/nft.c                              |   28 +
 iptables/nft.h                              |    9 +
 iptables/xtables-compat-multi               |  210 +++++
 iptables/xtables-compat-multi.c             |    1 +
 iptables/xtables-eb-standalone.c            |   87 ++
 iptables/xtables-eb.c                       | 1186 +++++++++++++++++++++++++++
 iptables/xtables-ebtables.h                 |   49 ++
 iptables/xtables-multi.c                    |    1 +
 iptables/xtables-multi.h                    |    1 +
 14 files changed, 2104 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/netfilter_bridge.h
 create mode 100644 include/linux/netfilter_bridge/ebtables.h
 create mode 100644 include/linux/netfilter_bridge/ethernetdb.h
 create mode 100644 iptables/getethertype.c
 create mode 100755 iptables/xtables-compat-multi
 create mode 100644 iptables/xtables-eb-standalone.c
 create mode 100644 iptables/xtables-eb.c
 create mode 100644 iptables/xtables-ebtables.h

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
new file mode 100644
index 0000000..71e9299
--- /dev/null
+++ b/include/linux/netfilter_bridge.h
@@ -0,0 +1,33 @@
+#ifndef __LINUX_BRIDGE_NETFILTER_H
+#define __LINUX_BRIDGE_NETFILTER_H
+
+/* bridge-specific defines for netfilter. 
+ */
+#include <limits.h>
+
+/* Bridge Hooks */
+/* After promisc drops, checksum checks. */
+#define NF_BR_PRE_ROUTING	0
+/* If the packet is destined for this box. */
+#define NF_BR_LOCAL_IN		1
+/* If the packet is destined for another interface. */
+#define NF_BR_FORWARD		2
+/* Packets coming from a local process. */
+#define NF_BR_LOCAL_OUT		3
+/* Packets about to hit the wire. */
+#define NF_BR_POST_ROUTING	4
+/* Not really a hook, but used for the ebtables broute table */
+#define NF_BR_BROUTING		5
+#define NF_BR_NUMHOOKS		6
+
+enum nf_br_hook_priorities {
+	NF_BR_PRI_FIRST = INT_MIN,
+	NF_BR_PRI_FILTER_BRIDGED = -200,
+	NF_BR_PRI_FILTER_OTHER = 200,
+	NF_BR_PRI_NAT_DST_BRIDGED = -300,
+	NF_BR_PRI_NAT_DST_OTHER = 100,
+	NF_BR_PRI_NAT_SRC = 300,
+	NF_BR_PRI_LAST = INT_MAX,
+};
+
+#endif
diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
new file mode 100644
index 0000000..f7ed1dc
--- /dev/null
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -0,0 +1,276 @@
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
+/* Local copy of the kernel file, needed for Sparc64 support */
+#ifndef __LINUX_BRIDGE_EFF_H
+#define __LINUX_BRIDGE_EFF_H
+#include <net/if.h>
+#include <linux/netfilter_bridge.h>
+#include <linux/if_ether.h>
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
+struct ebt_counter
+{
+	uint64_t pcnt;
+	uint64_t bcnt;
+};
+
+struct ebt_replace
+{
+	char name[EBT_TABLE_MAXNAMELEN];
+	unsigned int valid_hooks;
+	/* nr of rules in the table */
+	unsigned int nentries;
+	/* total size of the entries */
+	unsigned int entries_size;
+	/* start of the chains */
+#ifdef KERNEL_64_USERSPACE_32
+	uint64_t hook_entry[NF_BR_NUMHOOKS];
+#else
+	struct ebt_entries *hook_entry[NF_BR_NUMHOOKS];
+#endif
+	/* nr of counters userspace expects back */
+	unsigned int num_counters;
+	/* where the kernel will put the old counters */
+#ifdef KERNEL_64_USERSPACE_32
+	uint64_t counters;
+	uint64_t entries;
+#else
+	struct ebt_counter *counters;
+	char *entries;
+#endif
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
+ * Using this simplifies the code alot, while still being able to use
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
+struct ebt_entry_match
+{
+	union {
+		char name[EBT_FUNCTION_MAXNAMELEN];
+		struct ebt_match *match;
+	} u;
+	/* size of data */
+	unsigned int match_size;
+#ifdef KERNEL_64_USERSPACE_32
+	unsigned int pad;
+#endif
+	unsigned char data[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
+};
+
+struct ebt_entry_watcher
+{
+	union {
+		char name[EBT_FUNCTION_MAXNAMELEN];
+		struct ebt_watcher *watcher;
+	} u;
+	/* size of data */
+	unsigned int watcher_size;
+#ifdef KERNEL_64_USERSPACE_32
+	unsigned int pad;
+#endif
+	unsigned char data[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
+};
+
+struct ebt_entry_target
+{
+	union {
+		char name[EBT_FUNCTION_MAXNAMELEN];
+		struct ebt_target *target;
+	} u;
+	/* size of data */
+	unsigned int target_size;
+#ifdef KERNEL_64_USERSPACE_32
+	unsigned int pad;
+#endif
+	unsigned char data[0] __attribute__ ((aligned (__alignof__(struct ebt_replace))));
+};
+
+#define EBT_STANDARD_TARGET "standard"
+struct ebt_standard_target
+{
+	struct ebt_entry_target target;
+	int verdict;
+#ifdef KERNEL_64_USERSPACE_32
+	unsigned int pad;
+#endif
+};
+
+/* one entry */
+struct ebt_entry {
+	/* this needs to be the first field */
+	unsigned int bitmask;
+	unsigned int invflags;
+	uint16_t ethproto;
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
+#endif
diff --git a/include/linux/netfilter_bridge/ethernetdb.h b/include/linux/netfilter_bridge/ethernetdb.h
new file mode 100644
index 0000000..46d8bfd
--- /dev/null
+++ b/include/linux/netfilter_bridge/ethernetdb.h
@@ -0,0 +1,58 @@
+/*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License as published by
+* the Free Software Foundation; either version 2 of the License, or
+* (at your option) any later version.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+*/
+
+/* All data returned by the network data base library are supplied in
+   host order and returned in network order (suitable for use in
+   system calls).  */
+
+#ifndef	_ETHERNETDB_H
+#define	_ETHERNETDB_H	1
+
+#include <features.h>
+#include <netinet/in.h>
+#include <stdint.h>
+
+/* Absolute file name for network data base files.  */
+#ifndef	_PATH_ETHERTYPES
+#define	_PATH_ETHERTYPES	"/etc/ethertypes"
+#endif				/* _PATH_ETHERTYPES */
+
+struct ethertypeent {
+	char *e_name;		/* Official ethernet type name.  */
+	char **e_aliases;	/* Alias list.  */
+	int e_ethertype;	/* Ethernet type number.  */
+};
+
+/* Open ethertype data base files and mark them as staying open even
+   after a later search if STAY_OPEN is non-zero.  */
+extern void setethertypeent(int __stay_open) __THROW;
+
+/* Close ethertype data base files and clear `stay open' flag.  */
+extern void endethertypeent(void) __THROW;
+
+/* Get next entry from ethertype data base file.  Open data base if
+   necessary.  */
+extern struct ethertypeent *getethertypeent(void) __THROW;
+
+/* Return entry from ethertype data base for network with NAME.  */
+extern struct ethertypeent *getethertypebyname(__const char *__name)
+    __THROW;
+
+/* Return entry from ethertype data base which number is PROTO.  */
+extern struct ethertypeent *getethertypebynumber(int __ethertype) __THROW;
+
+
+#endif				/* ethernetdb.h */
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index aaaade8..b3e417b 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -39,7 +39,9 @@ xtables_compat_multi_SOURCES += xtables-save.c xtables-restore.c \
 				xtables-standalone.c xtables.c nft.c \
 				nft-shared.c nft-ipv4.c nft-ipv6.c nft-arp.c \
 				xtables-config.c xtables-events.c \
-				xtables-arp-standalone.c xtables-arp.c
+				xtables-arp-standalone.c xtables-arp.c \
+				getethertype.c nft-bridge.c \
+				xtables-eb-standalone.c xtables-eb.c
 xtables_compat_multi_LDADD   += ${libmnl_LIBS} ${libnftnl_LIBS} ../extensions/libext4.a ../extensions/libext6.a
 # yacc and lex generate dirty code
 xtables_compat_multi-xtables-config-parser.o xtables_compat_multi-xtables-config-syntax.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-declarations -Wno-implicit-function-declaration -Wno-nested-externs -Wno-undef -Wno-redundant-decls
@@ -67,7 +69,7 @@ endif
 if ENABLE_NFTABLES
 x_sbin_links  = iptables-compat iptables-compat-restore iptables-compat-save \
 		ip6tables-compat ip6tables-compat-restore ip6tables-compat-save \
-		arptables-compat xtables-config xtables-events
+		arptables-compat ebtables-compat xtables-config xtables-events
 endif
 
 iptables-extensions.8: iptables-extensions.8.tmpl ../extensions/matches.man ../extensions/targets.man
diff --git a/iptables/getethertype.c b/iptables/getethertype.c
new file mode 100644
index 0000000..7c9ef3d
--- /dev/null
+++ b/iptables/getethertype.c
@@ -0,0 +1,161 @@
+/*
+* getethertype.c
+*
+* This file was part of the NYS Library.
+*
+** The NYS Library is free software; you can redistribute it and/or
+** modify it under the terms of the GNU Library General Public License as
+** published by the Free Software Foundation; either version 2 of the
+** License, or (at your option) any later version.
+*
+* This program is free software; you can redistribute it and/or modify
+* it under the terms of the GNU General Public License as published by
+* the Free Software Foundation; either version 2 of the License, or
+* (at your option) any later version.
+*
+* This program is distributed in the hope that it will be useful,
+* but WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+* GNU General Public License for more details.
+*
+* You should have received a copy of the GNU General Public License
+* along with this program; if not, write to the Free Software
+* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+*/
+
+/********************************************************************
+* Description: Ethertype name service switch and the ethertypes 
+* database access functions
+* Author: Nick Fedchik <fnm@ukrsat.com>
+* Checker: Bart De Schuymer <bdschuym@pandora.be>
+* Origin: uClibc-0.9.16/libc/inet/getproto.c
+* Created at: Mon Nov 11 12:20:11 EET 2002
+********************************************************************/
+
+#include <ctype.h>
+#include <features.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <netdb.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <netinet/ether.h>
+#include <net/ethernet.h>
+
+#include <linux/netfilter_bridge/ethernetdb.h>
+
+#define	MAXALIASES	35
+
+static FILE *etherf = NULL;
+static char line[BUFSIZ + 1];
+static struct ethertypeent et_ent;
+static char *ethertype_aliases[MAXALIASES];
+static int ethertype_stayopen;
+
+void setethertypeent(int f)
+{
+	if (etherf == NULL)
+		etherf = fopen(_PATH_ETHERTYPES, "r");
+	else
+		rewind(etherf);
+	ethertype_stayopen |= f;
+}
+
+void endethertypeent(void)
+{
+	if (etherf) {
+		fclose(etherf);
+		etherf = NULL;
+	}
+	ethertype_stayopen = 0;
+}
+
+struct ethertypeent *getethertypeent(void)
+{
+	char *e;
+	char *endptr;
+	register char *cp, **q;
+
+	if (etherf == NULL
+	    && (etherf = fopen(_PATH_ETHERTYPES, "r")) == NULL) {
+		return (NULL);
+	}
+
+again:
+	if ((e = fgets(line, BUFSIZ, etherf)) == NULL) {
+		return (NULL);
+	}
+	if (*e == '#')
+		goto again;
+	cp = strpbrk(e, "#\n");
+	if (cp == NULL)
+		goto again;
+	*cp = '\0';
+	et_ent.e_name = e;
+	cp = strpbrk(e, " \t");
+	if (cp == NULL)
+		goto again;
+	*cp++ = '\0';
+	while (*cp == ' ' || *cp == '\t')
+		cp++;
+	e = strpbrk(cp, " \t");
+	if (e != NULL)
+		*e++ = '\0';
+// Check point
+	et_ent.e_ethertype = strtol(cp, &endptr, 16);
+	if (*endptr != '\0'
+	    || (et_ent.e_ethertype < ETH_ZLEN
+		|| et_ent.e_ethertype > 0xFFFF))
+		goto again;	// Skip invalid etherproto type entry
+	q = et_ent.e_aliases = ethertype_aliases;
+	if (e != NULL) {
+		cp = e;
+		while (cp && *cp) {
+			if (*cp == ' ' || *cp == '\t') {
+				cp++;
+				continue;
+			}
+			if (q < &ethertype_aliases[MAXALIASES - 1])
+				*q++ = cp;
+			cp = strpbrk(cp, " \t");
+			if (cp != NULL)
+				*cp++ = '\0';
+		}
+	}
+	*q = NULL;
+	return (&et_ent);
+}
+
+
+struct ethertypeent *getethertypebyname(const char *name)
+{
+	register struct ethertypeent *e;
+	register char **cp;
+
+	setethertypeent(ethertype_stayopen);
+	while ((e = getethertypeent()) != NULL) {
+		if (strcasecmp(e->e_name, name) == 0)
+			break;
+		for (cp = e->e_aliases; *cp != 0; cp++)
+			if (strcasecmp(*cp, name) == 0)
+				goto found;
+	}
+found:
+	if (!ethertype_stayopen)
+		endethertypeent();
+	return (e);
+}
+
+struct ethertypeent *getethertypebynumber(int type)
+{
+	register struct ethertypeent *e;
+
+	setethertypeent(ethertype_stayopen);
+	while ((e = getethertypeent()) != NULL)
+		if (e->e_ethertype == type)
+			break;
+	if (!ethertype_stayopen)
+		endethertypeent();
+	return (e);
+}
diff --git a/iptables/nft.c b/iptables/nft.c
index e3b07e0..fe8e380 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -489,6 +489,34 @@ struct builtin_table xtables_arp[TABLES_MAX] = {
 	},
 };
 
+#include <linux/netfilter_bridge.h>
+
+struct builtin_table xtables_bridge[TABLES_MAX] = {
+	[FILTER] = {
+	.name = "filter",
+	.chains = {
+			{
+				.name   = "INPUT",
+				.type   = "filter",
+				.prio   = NF_BR_PRI_FILTER_BRIDGED,
+				.hook   = NF_BR_LOCAL_IN,
+			},
+			{
+				.name   = "FORWARD",
+				.type   = "filter",
+				.prio   = NF_BR_PRI_FILTER_BRIDGED,
+				.hook   = NF_BR_FORWARD,
+			},
+			{
+				.name   = "OUTPUT",
+				.type   = "filter",
+				.prio   = NF_BR_PRI_FILTER_BRIDGED,
+				.hook   = NF_BR_LOCAL_OUT,
+			},
+		},
+	},
+};
+
 int nft_table_add(struct nft_handle *h, struct nft_table *t, uint16_t flags)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
diff --git a/iptables/nft.h b/iptables/nft.h
index 339d7bc..c4aedd2 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -41,6 +41,7 @@ struct nft_handle {
 
 extern struct builtin_table xtables_ipv4[TABLES_MAX];
 extern struct builtin_table xtables_arp[TABLES_MAX];
+extern struct builtin_table xtables_bridge[TABLES_MAX];
 
 int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
 	     int (*cb)(const struct nlmsghdr *nlh, void *data),
@@ -138,6 +139,8 @@ const char *nft_strerror(int err);
 int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table, bool restore);
 /* For xtables-arptables.c */
 int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table);
+/* For xtables-eb.c */
+int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table);
 
 /*
  * Parse config for tables and chain helper functions
@@ -170,4 +173,10 @@ int nft_arp_rule_insert(struct nft_handle *h, const char *chain,
 
 void nft_rule_to_arpt_entry(struct nft_rule *r, struct arpt_entry *fw);
 
+/*
+ * BRIDGE
+ */
+
+struct ebt_entry;
+
 #endif
diff --git a/iptables/xtables-compat-multi b/iptables/xtables-compat-multi
new file mode 100755
index 0000000..f127195
--- /dev/null
+++ b/iptables/xtables-compat-multi
@@ -0,0 +1,210 @@
+#! /bin/sh
+
+# xtables-compat-multi - temporary wrapper script for .libs/xtables-compat-multi
+# Generated by libtool (GNU libtool) 2.4.2
+#
+# The xtables-compat-multi program cannot be directly executed until all the libtool
+# libraries that it depends on are installed.
+#
+# This wrapper script should never be moved out of the build directory.
+# If it is, it will not operate correctly.
+
+# Sed substitution that helps us do robust quoting.  It backslashifies
+# metacharacters that are still active within double-quoted strings.
+sed_quote_subst='s/\([`"$\\]\)/\\\1/g'
+
+# Be Bourne compatible
+if test -n "${ZSH_VERSION+set}" && (emulate sh) >/dev/null 2>&1; then
+  emulate sh
+  NULLCMD=:
+  # Zsh 3.x and 4.x performs word splitting on ${1+"$@"}, which
+  # is contrary to our usage.  Disable this feature.
+  alias -g '${1+"$@"}'='"$@"'
+  setopt NO_GLOB_SUBST
+else
+  case `(set -o) 2>/dev/null` in *posix*) set -o posix;; esac
+fi
+BIN_SH=xpg4; export BIN_SH # for Tru64
+DUALCASE=1; export DUALCASE # for MKS sh
+
+# The HP-UX ksh and POSIX shell print the target directory to stdout
+# if CDPATH is set.
+(unset CDPATH) >/dev/null 2>&1 && unset CDPATH
+
+relink_command=""
+
+# This environment variable determines our operation mode.
+if test "$libtool_install_magic" = "%%%MAGIC variable%%%"; then
+  # install mode needs the following variables:
+  generated_by_libtool_version='2.4.2'
+  notinst_deplibs=' ../libxtables/libxtables.la'
+else
+  # When we are sourced in execute mode, $file and $ECHO are already set.
+  if test "$libtool_execute_magic" != "%%%MAGIC variable%%%"; then
+    file="$0"
+
+# A function that is used when there is no print builtin or printf.
+func_fallback_echo ()
+{
+  eval 'cat <<_LTECHO_EOF
+$1
+_LTECHO_EOF'
+}
+    ECHO="printf %s\\n"
+  fi
+
+# Very basic option parsing. These options are (a) specific to
+# the libtool wrapper, (b) are identical between the wrapper
+# /script/ and the wrapper /executable/ which is used only on
+# windows platforms, and (c) all begin with the string --lt-
+# (application programs are unlikely to have options which match
+# this pattern).
+#
+# There are only two supported options: --lt-debug and
+# --lt-dump-script. There is, deliberately, no --lt-help.
+#
+# The first argument to this parsing function should be the
+# script's ../libtool value, followed by no.
+lt_option_debug=
+func_parse_lt_options ()
+{
+  lt_script_arg0=$0
+  shift
+  for lt_opt
+  do
+    case "$lt_opt" in
+    --lt-debug) lt_option_debug=1 ;;
+    --lt-dump-script)
+        lt_dump_D=`$ECHO "X$lt_script_arg0" | /bin/sed -e 's/^X//' -e 's%/[^/]*$%%'`
+        test "X$lt_dump_D" = "X$lt_script_arg0" && lt_dump_D=.
+        lt_dump_F=`$ECHO "X$lt_script_arg0" | /bin/sed -e 's/^X//' -e 's%^.*/%%'`
+        cat "$lt_dump_D/$lt_dump_F"
+        exit 0
+      ;;
+    --lt-*)
+        $ECHO "Unrecognized --lt- option: '$lt_opt'" 1>&2
+        exit 1
+      ;;
+    esac
+  done
+
+  # Print the debug banner immediately:
+  if test -n "$lt_option_debug"; then
+    echo "xtables-compat-multi:xtables-compat-multi:${LINENO}: libtool wrapper (GNU libtool) 2.4.2" 1>&2
+  fi
+}
+
+# Used when --lt-debug. Prints its arguments to stdout
+# (redirection is the responsibility of the caller)
+func_lt_dump_args ()
+{
+  lt_dump_args_N=1;
+  for lt_arg
+  do
+    $ECHO "xtables-compat-multi:xtables-compat-multi:${LINENO}: newargv[$lt_dump_args_N]: $lt_arg"
+    lt_dump_args_N=`expr $lt_dump_args_N + 1`
+  done
+}
+
+# Core function for launching the target application
+func_exec_program_core ()
+{
+
+      if test -n "$lt_option_debug"; then
+        $ECHO "xtables-compat-multi:xtables-compat-multi:${LINENO}: newargv[0]: $progdir/$program" 1>&2
+        func_lt_dump_args ${1+"$@"} 1>&2
+      fi
+      exec "$progdir/$program" ${1+"$@"}
+
+      $ECHO "$0: cannot exec $program $*" 1>&2
+      exit 1
+}
+
+# A function to encapsulate launching the target application
+# Strips options in the --lt-* namespace from $@ and
+# launches target application with the remaining arguments.
+func_exec_program ()
+{
+  case " $* " in
+  *\ --lt-*)
+    for lt_wr_arg
+    do
+      case $lt_wr_arg in
+      --lt-*) ;;
+      *) set x "$@" "$lt_wr_arg"; shift;;
+      esac
+      shift
+    done ;;
+  esac
+  func_exec_program_core ${1+"$@"}
+}
+
+  # Parse options
+  func_parse_lt_options "$0" ${1+"$@"}
+
+  # Find the directory that this script lives in.
+  thisdir=`$ECHO "$file" | /bin/sed 's%/[^/]*$%%'`
+  test "x$thisdir" = "x$file" && thisdir=.
+
+  # Follow symbolic links until we get to the real thisdir.
+  file=`ls -ld "$file" | /bin/sed -n 's/.*-> //p'`
+  while test -n "$file"; do
+    destdir=`$ECHO "$file" | /bin/sed 's%/[^/]*$%%'`
+
+    # If there was a directory component, then change thisdir.
+    if test "x$destdir" != "x$file"; then
+      case "$destdir" in
+      [\\/]* | [A-Za-z]:[\\/]*) thisdir="$destdir" ;;
+      *) thisdir="$thisdir/$destdir" ;;
+      esac
+    fi
+
+    file=`$ECHO "$file" | /bin/sed 's%^.*/%%'`
+    file=`ls -ld "$thisdir/$file" | /bin/sed -n 's/.*-> //p'`
+  done
+
+  # Usually 'no', except on cygwin/mingw when embedded into
+  # the cwrapper.
+  WRAPPER_SCRIPT_BELONGS_IN_OBJDIR=no
+  if test "$WRAPPER_SCRIPT_BELONGS_IN_OBJDIR" = "yes"; then
+    # special case for '.'
+    if test "$thisdir" = "."; then
+      thisdir=`pwd`
+    fi
+    # remove .libs from thisdir
+    case "$thisdir" in
+    *[\\/].libs ) thisdir=`$ECHO "$thisdir" | /bin/sed 's%[\\/][^\\/]*$%%'` ;;
+    .libs )   thisdir=. ;;
+    esac
+  fi
+
+  # Try to get the absolute directory name.
+  absdir=`cd "$thisdir" && pwd`
+  test -n "$absdir" && thisdir="$absdir"
+
+  program='xtables-compat-multi'
+  progdir="$thisdir/.libs"
+
+
+  if test -f "$progdir/$program"; then
+    # Add our own library path to LD_LIBRARY_PATH
+    LD_LIBRARY_PATH="/usr/local/lib:/usr/lib:/home/giuseppe/git/iptables/libxtables/.libs:$LD_LIBRARY_PATH"
+
+    # Some systems cannot cope with colon-terminated LD_LIBRARY_PATH
+    # The second colon is a workaround for a bug in BeOS R4 sed
+    LD_LIBRARY_PATH=`$ECHO "$LD_LIBRARY_PATH" | /bin/sed 's/::*$//'`
+
+    export LD_LIBRARY_PATH
+
+    if test "$libtool_execute_magic" != "%%%MAGIC variable%%%"; then
+      # Run the actual program with our arguments.
+      func_exec_program ${1+"$@"}
+    fi
+  else
+    # The program doesn't exist.
+    $ECHO "$0: error: \`$progdir/$program' does not exist" 1>&2
+    $ECHO "This script is just a wrapper for $program." 1>&2
+    $ECHO "See the libtool documentation for more information." 1>&2
+    exit 1
+  fi
+fi
diff --git a/iptables/xtables-compat-multi.c b/iptables/xtables-compat-multi.c
index 4781052..ed8ad07 100644
--- a/iptables/xtables-compat-multi.c
+++ b/iptables/xtables-compat-multi.c
@@ -28,6 +28,7 @@ static const struct subcommand multi_subcommands[] = {
 	{"ip6tables-compat-restore",	xtables_ip6_restore_main},
 	{"arptables",			xtables_arp_main},
 	{"arptables-compat",		xtables_arp_main},
+	{"ebtables-compat",		xtables_eb_main},
 	{"xtables-config",		xtables_config_main},
 	{"xtables-events",		xtables_events_main},
 	{NULL},
diff --git a/iptables/xtables-eb-standalone.c b/iptables/xtables-eb-standalone.c
new file mode 100644
index 0000000..f634761
--- /dev/null
+++ b/iptables/xtables-eb-standalone.c
@@ -0,0 +1,87 @@
+/*
+ * Author: Paul.Russell@rustcorp.com.au and mneuling@radlogic.com.au
+ *
+ * Based on the ipchains code by Paul Russell and Michael Neuling
+ *
+ * (C) 2000-2002 by the netfilter coreteam <coreteam@netfilter.org>:
+ * 		    Paul 'Rusty' Russell <rusty@rustcorp.com.au>
+ * 		    Marc Boucher <marc+nf@mbsi.ca>
+ * 		    James Morris <jmorris@intercode.com.au>
+ * 		    Harald Welte <laforge@gnumonks.org>
+ * 		    Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ *
+ *	arptables -- IP firewall administration for kernels with
+ *	firewall table (aimed for the 2.3 kernels)
+ *
+ *	See the accompanying manual page arptables(8) for information
+ *	about proper usage of this program.
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License as published by
+ *	the Free Software Foundation; either version 2 of the License, or
+ *	(at your option) any later version.
+ *
+ *	This program is distributed in the hope that it will be useful,
+ *	but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *	GNU General Public License for more details.
+ *
+ *	You should have received a copy of the GNU General Public License
+ *	along with this program; if not, write to the Free Software
+ *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <string.h>
+#include <xtables.h>
+#include "nft.h"
+
+#include "xtables-multi.h"
+
+extern struct xtables_globals xtables_globals;
+extern const char *program_version, *program_name;
+
+static const struct xtables_afinfo afinfo_bridge = {
+        .kmod          = "eb_tables",
+        .proc_exists   = "/proc/net/eb_tables_names",
+        .libprefix     = "libeb_",
+        .family        = NFPROTO_BRIDGE,
+        .ipproto       = IPPROTO_IP,
+        .so_rev_match  = -1,
+        .so_rev_target = -1,
+};
+
+int xtables_eb_main(int argc, char *argv[])
+{
+	int ret;
+	char *table = "filter";
+	struct nft_handle h = {
+		.family = NFPROTO_BRIDGE,
+	};
+
+	xtables_globals.program_name = "xtables-eb";
+	/* This code below could be replaced by xtables_init_all, which
+	 * doesn't support NFPROTO_BRIDGE yet.
+	 */
+	xtables_init();
+	afinfo = &afinfo_bridge;
+	ret = xtables_set_params(&xtables_globals);
+	if (ret < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
+				xtables_globals.program_name,
+				xtables_globals.program_version);
+		exit(1);
+	}
+
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
+	init_extensions();
+#endif
+
+	ret = do_commandeb(&h, argc, argv, &table);
+	if (ret)
+		ret = nft_commit(&h);
+
+	exit(!ret);
+}
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
new file mode 100644
index 0000000..a7ace58
--- /dev/null
+++ b/iptables/xtables-eb.c
@@ -0,0 +1,1186 @@
+/*
+ * ebtables.c, v2.0 July 2002
+ *
+ * Author: Bart De Schuymer
+ *
+ *  This code was stongly inspired on the iptables code which is
+ *  Copyright (C) 1999 Paul `Rusty' Russell & Michael J. Neuling
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <getopt.h>
+#include <string.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <inttypes.h>
+#include <signal.h>
+#include <net/if.h>
+#include <netinet/ether.h>
+#include <xtables.h>
+
+#include "xshared.h"
+#include "nft.h"
+
+#include <linux/netfilter_bridge/ethernetdb.h>
+
+/* Checks whether a command has already been specified */
+#define OPT_COMMANDS (flags & OPT_COMMAND || flags & OPT_ZERO)
+
+#define OPT_COMMAND	0x01
+#define OPT_TABLE	0x02
+#define OPT_IN		0x04
+#define OPT_OUT		0x08
+#define OPT_JUMP	0x10
+#define OPT_PROTOCOL	0x20
+#define OPT_SOURCE	0x40
+#define OPT_DEST	0x80
+#define OPT_ZERO	0x100
+#define OPT_LOGICALIN	0x200
+#define OPT_LOGICALOUT	0x400
+#define OPT_KERNELDATA	0x800 /* This value is also defined in ebtablesd.c */
+#define OPT_COUNT	0x1000 /* This value is also defined in libebtc.c */
+#define OPT_CNT_INCR	0x2000 /* This value is also defined in libebtc.c */
+#define OPT_CNT_DECR	0x4000 /* This value is also defined in libebtc.c */
+
+#define EXEC_STYLE_PRG    0
+#define EXEC_STYLE_DAEMON 1
+
+/* Default command line options. Do not mess around with the already
+ * assigned numbers unless you know what you are doing */
+static struct option ebt_original_options[] =
+{
+	{ "append"         , required_argument, 0, 'A' },
+	{ "insert"         , required_argument, 0, 'I' },
+	{ "delete"         , required_argument, 0, 'D' },
+	{ "list"           , optional_argument, 0, 'L' },
+	{ "Lc"             , no_argument      , 0, 4   },
+	{ "Ln"             , no_argument      , 0, 5   },
+	{ "Lx"             , no_argument      , 0, 6   },
+	{ "Lmac2"          , no_argument      , 0, 12  },
+	{ "zero"           , optional_argument, 0, 'Z' },
+	{ "flush"          , optional_argument, 0, 'F' },
+	{ "policy"         , required_argument, 0, 'P' },
+	{ "in-interface"   , required_argument, 0, 'i' },
+	{ "in-if"          , required_argument, 0, 'i' },
+	{ "logical-in"     , required_argument, 0, 2   },
+	{ "logical-out"    , required_argument, 0, 3   },
+	{ "out-interface"  , required_argument, 0, 'o' },
+	{ "out-if"         , required_argument, 0, 'o' },
+	{ "version"        , no_argument      , 0, 'V' },
+	{ "help"           , no_argument      , 0, 'h' },
+	{ "jump"           , required_argument, 0, 'j' },
+	{ "set-counters"   , required_argument, 0, 'c' },
+	{ "change-counters", required_argument, 0, 'C' },
+	{ "proto"          , required_argument, 0, 'p' },
+	{ "protocol"       , required_argument, 0, 'p' },
+	{ "db"             , required_argument, 0, 'b' },
+	{ "source"         , required_argument, 0, 's' },
+	{ "src"            , required_argument, 0, 's' },
+	{ "destination"    , required_argument, 0, 'd' },
+	{ "dst"            , required_argument, 0, 'd' },
+	{ "table"          , required_argument, 0, 't' },
+	{ "modprobe"       , required_argument, 0, 'M' },
+	{ "new-chain"      , required_argument, 0, 'N' },
+	{ "rename-chain"   , required_argument, 0, 'E' },
+	{ "delete-chain"   , optional_argument, 0, 'X' },
+	{ "atomic-init"    , no_argument      , 0, 7   },
+	{ "atomic-commit"  , no_argument      , 0, 8   },
+	{ "atomic-file"    , required_argument, 0, 9   },
+	{ "atomic-save"    , no_argument      , 0, 10  },
+	{ "init-table"     , no_argument      , 0, 11  },
+	{ "concurrent"     , no_argument      , 0, 13  },
+	{ 0 }
+};
+
+const char *PROGVERSION = XTABLES_VERSION;
+const char *PROGNAME = "xtables-eb";
+
+static struct option *ebt_options = ebt_original_options;
+
+extern struct xtables_globals xtables_globals;
+
+unsigned char eb_mac_type_unicast[ETH_ALEN] =   {0,0,0,0,0,0};
+unsigned char eb_msk_type_unicast[ETH_ALEN] =   {1,0,0,0,0,0};
+unsigned char eb_mac_type_multicast[ETH_ALEN] = {1,0,0,0,0,0};
+unsigned char eb_msk_type_multicast[ETH_ALEN] = {1,0,0,0,0,0};
+unsigned char eb_mac_type_broadcast[ETH_ALEN] = {255,255,255,255,255,255};
+unsigned char eb_msk_type_broadcast[ETH_ALEN] = {255,255,255,255,255,255};
+unsigned char eb_mac_type_bridge_group[ETH_ALEN] = {0x01,0x80,0xc2,0,0,0};
+unsigned char eb_msk_type_bridge_group[ETH_ALEN] = {255,255,255,255,255,255};
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
+/* 0: default
+ * 1: the inverse '!' of the option has already been specified */
+int ebt_invert = 0;
+
+/* Prints all registered extensions */
+static void ebt_list_extensions(const struct xtables_target *t,
+				const struct xtables_rule_match *m)
+{
+	printf("%s v%s\n", PROGNAME, PROGVERSION);
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
+int ebt_get_mac_and_mask(const char *from, unsigned char *to,
+  unsigned char *mask)
+{
+	char *p;
+	int i;
+	struct ether_addr *addr = NULL;
+
+	if (strcasecmp(from, "Unicast") == 0) {
+		memcpy(to, eb_mac_type_unicast, ETH_ALEN);
+		memcpy(mask, eb_msk_type_unicast, ETH_ALEN);
+		return 0;
+	}
+	if (strcasecmp(from, "Multicast") == 0) {
+		memcpy(to, eb_mac_type_multicast, ETH_ALEN);
+		memcpy(mask, eb_msk_type_multicast, ETH_ALEN);
+		return 0;
+	}
+	if (strcasecmp(from, "Broadcast") == 0) {
+		memcpy(to, eb_mac_type_broadcast, ETH_ALEN);
+		memcpy(mask, eb_msk_type_broadcast, ETH_ALEN);
+		return 0;
+	}
+	if (strcasecmp(from, "BGA") == 0) {
+		memcpy(to, eb_mac_type_bridge_group, ETH_ALEN);
+		memcpy(mask, eb_msk_type_bridge_group, ETH_ALEN);
+		return 0;
+	}
+	if ( (p = strrchr(from, '/')) != NULL) {
+		*p = '\0';
+		if (!(addr = ether_aton(p + 1)))
+			return -1;
+		memcpy(mask, addr, ETH_ALEN);
+	} else
+		memset(mask, 0xff, ETH_ALEN);
+	if (!(addr = ether_aton(from)))
+		return -1;
+	memcpy(to, addr, ETH_ALEN);
+	for (i = 0; i < ETH_ALEN; i++)
+		to[i] &= mask[i];
+	return 0;
+}
+
+
+static void print_help(const struct xtables_target *t,
+		       const struct xtables_rule_match *m)
+{
+	printf("%s %s\n", PROGNAME, PROGVERSION);
+	printf(
+"Usage:\n"
+"ebtables -[ADI] chain rule-specification [options]\n"
+"ebtables -P chain target\n"
+"ebtables -[LFZ] [chain]\n"
+"ebtables -[NX] [chain]\n"
+"ebtables -E old-chain-name new-chain-name\n\n"
+"Commands:\n"
+"--append -A chain             : append to chain\n"
+"--delete -D chain             : delete matching rule from chain\n"
+"--delete -D chain rulenum     : delete rule at position rulenum from chain\n"
+"--change-counters -C chain\n"
+"          [rulenum] pcnt bcnt : change counters of existing rule\n"
+"--insert -I chain rulenum     : insert rule at position rulenum in chain\n"
+"--list   -L [chain]           : list the rules in a chain or in all chains\n"
+"--flush  -F [chain]           : delete all rules in chain or in all chains\n"
+"--init-table                  : replace the kernel table with the initial table\n"
+"--zero   -Z [chain]           : put counters on zero in chain or in all chains\n"
+"--policy -P chain target      : change policy on chain to target\n"
+"--new-chain -N chain          : create a user defined chain\n"
+"--rename-chain -E old new     : rename a chain\n"
+"--delete-chain -X [chain]     : delete a user defined chain\n"
+"--atomic-commit               : update the kernel w/t table contained in <FILE>\n"
+"--atomic-init                 : put the initial kernel table into <FILE>\n"
+"--atomic-save                 : put the current kernel table into <FILE>\n"
+"--atomic-file file            : set <FILE> to file\n\n"
+"Options:\n"
+"--proto  -p [!] proto         : protocol hexadecimal, by name or LENGTH\n"
+"--src    -s [!] address[/mask]: source mac address\n"
+"--dst    -d [!] address[/mask]: destination mac address\n"
+"--in-if  -i [!] name[+]       : network input interface name\n"
+"--out-if -o [!] name[+]       : network output interface name\n"
+"--logical-in  [!] name[+]     : logical bridge input interface name\n"
+"--logical-out [!] name[+]     : logical bridge output interface name\n"
+"--set-counters -c chain\n"
+"          pcnt bcnt           : set the counters of the to be added rule\n"
+"--modprobe -M program         : try to insert modules using this program\n"
+"--concurrent                  : use a file lock to support concurrent scripts\n"
+"--version -V                  : print package version\n\n"
+"Environment variable:\n"
+/*ATOMIC_ENV_VARIABLE "          : if set <FILE> (see above) will equal its value"*/
+"\n\n");
+	for (; m != NULL; m = m->next) {
+		printf("\n");
+		m->match->help();
+	}
+	t->help();
+	printf("\n");
+	/*if (table->help)
+		table->help(ebt_hooknames);*/
+}
+
+/* Execute command L */
+static int list_rules(struct nft_handle *h, const char *chain, const char *table,
+		       int rulenum, int verbose, int numeric, int expanded,
+		       int linenumbers)
+{
+	unsigned int format;
+
+	format = FMT_OPTIONS;
+	if (!verbose)
+		format |= FMT_NOCOUNTS;
+	else
+		format |= FMT_VIA;
+
+	if (numeric)
+		format |= FMT_NUMERIC;
+
+	if (!expanded)
+		format |= FMT_KILOMEGAGIGA;
+
+	if (linenumbers)
+		format |= FMT_LINENUMBERS;
+
+	return nft_rule_list(h, chain, table, rulenum, format);
+}
+
+static int parse_rule_range(const char *argv, int *rule_nr, int *rule_nr_end)
+{
+	char *colon = strchr(argv, ':'), *buffer;
+
+	if (colon) {
+		*colon = '\0';
+		if (*(colon + 1) == '\0')
+			*rule_nr_end = -1; /* Until the last rule */
+		else {
+			*rule_nr_end = strtol(colon + 1, &buffer, 10);
+			if (*buffer != '\0' || *rule_nr_end == 0)
+				return -1;
+		}
+	}
+	if (colon == argv)
+		*rule_nr = 1; /* Beginning with the first rule */
+	else {
+		*rule_nr = strtol(argv, &buffer, 10);
+		if (*buffer != '\0' || *rule_nr == 0)
+			return -1;
+	}
+	if (!colon)
+		*rule_nr_end = *rule_nr;
+	return 0;
+}
+
+/* Incrementing or decrementing rules in daemon mode is not supported as the
+ * involved code overload is not worth it (too annoying to take the increased
+ * counters in the kernel into account). */
+static int parse_change_counters_rule(int argc, char **argv, int *rule_nr, int *rule_nr_end, int exec_style, struct xtables_ebt_entry *fw)
+{
+	char *buffer;
+	int ret = 0;
+
+	if (optind + 1 >= argc || (argv[optind][0] == '-' && (argv[optind][1] < '0' || argv[optind][1] > '9')) ||
+	    (argv[optind + 1][0] == '-' && (argv[optind + 1][1] < '0'  && argv[optind + 1][1] > '9')))
+		xtables_error(PARAMETER_PROBLEM,
+			      "The command -C needs at least 2 arguments");
+	if (optind + 2 < argc && (argv[optind + 2][0] != '-' || (argv[optind + 2][1] >= '0' && argv[optind + 2][1] <= '9'))) {
+		if (optind + 3 != argc)
+			xtables_error(PARAMETER_PROBLEM,
+				      "No extra options allowed with -C start_nr[:end_nr] pcnt bcnt");
+		if (parse_rule_range(argv[optind], rule_nr, rule_nr_end))
+			xtables_error(PARAMETER_PROBLEM,
+				      "Something is wrong with the rule number specification '%s'", argv[optind]);
+		optind++;
+	}
+
+	if (argv[optind][0] == '+') {
+		if (exec_style == EXEC_STYLE_DAEMON)
+daemon_incr:
+			xtables_error(PARAMETER_PROBLEM,
+				      "Incrementing rule counters (%s) not allowed in daemon mode", argv[optind]);
+		ret += 1;
+		fw->counters.pcnt = strtoull(argv[optind] + 1, &buffer, 10);
+	} else if (argv[optind][0] == '-') {
+		if (exec_style == EXEC_STYLE_DAEMON)
+daemon_decr:
+			xtables_error(PARAMETER_PROBLEM,
+				      "Decrementing rule counters (%s) not allowed in daemon mode", argv[optind]);
+		ret += 2;
+		fw->counters.pcnt = strtoull(argv[optind] + 1, &buffer, 10);
+	} else
+		fw->counters.pcnt = strtoull(argv[optind], &buffer, 10);
+
+	if (*buffer != '\0')
+		goto invalid;
+	optind++;
+	if (argv[optind][0] == '+') {
+		if (exec_style == EXEC_STYLE_DAEMON)
+			goto daemon_incr;
+		ret += 3;
+		fw->counters.bcnt = strtoull(argv[optind] + 1, &buffer, 10);
+	} else if (argv[optind][0] == '-') {
+		if (exec_style == EXEC_STYLE_DAEMON)
+			goto daemon_decr;
+		ret += 6;
+		fw->counters.bcnt = strtoull(argv[optind] + 1, &buffer, 10);
+	} else
+		fw->counters.bcnt = strtoull(argv[optind], &buffer, 10);
+
+	if (*buffer != '\0')
+		goto invalid;
+	optind++;
+	return ret;
+invalid:
+	xtables_error(PARAMETER_PROBLEM,"Packet counter '%s' invalid", argv[optind]);
+}
+
+
+/* Can't be zero. */
+static int
+parse_rulenumber(const char *rule)
+{
+	unsigned int rulenum;
+
+	if (!xtables_strtoui(rule, NULL, &rulenum, 1, INT_MAX))
+		xtables_error(PARAMETER_PROBLEM,
+			      "Invalid rule number `%s'", rule);
+
+	return rulenum;
+}
+
+static int parse_iface(char *iface, char *option)
+{
+	char *c;
+
+	if ((c = strchr(iface, '+'))) {
+		if (*(c + 1) != '\0') {
+			xtables_error(PARAMETER_PROBLEM,
+				      "Spurious characters after '+'" 
+				      "wildcard for '%s'", option);
+			return -1;
+		} else
+			*c = IF_WILDCARD;
+	}
+
+	return 0;
+}
+
+/* Make sure the same option wasn't specified twice. This is used
+ * in the parse functions of the extensions and ebtables.c */
+static void check_option(unsigned int *flags, unsigned int mask)
+{
+	if (*flags & mask)
+		xtables_error(PARAMETER_PROBLEM,
+			      "Multiple use of same option not allowed");
+	*flags |= mask;
+}
+
+static int check_inverse(const char option[], int argc, char **argv)
+{
+	if (!option)
+		return ebt_invert;
+	if (strcmp(option, "!") == 0) {
+		if (ebt_invert == 1)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Double use of '!' not allowed");
+		if (optind >= argc)
+			optarg = NULL;
+		else
+			optarg = argv[optind];
+		optind++;
+		ebt_invert = 1;
+		return 1;
+	}
+	return ebt_invert;
+}
+
+static const char *
+parse_target(const char *targetname)
+{
+	const char *ptr;
+
+	if (strlen(targetname) < 1)
+		xtables_error(PARAMETER_PROBLEM,
+			      "Invalid target name (too short)");
+
+	if (strlen(targetname)+1 > EBT_CHAIN_MAXNAMELEN)
+		xtables_error(PARAMETER_PROBLEM,
+			      "Invalid target '%s' (%d chars max)",
+			      targetname, EBT_CHAIN_MAXNAMELEN);
+
+	for (ptr = targetname; *ptr; ptr++)
+		if (isspace(*ptr))
+			xtables_error(PARAMETER_PROBLEM,
+				      "Invalid target name `%s'", targetname);
+	return targetname;
+}
+
+static struct xtables_target *command_jump(struct xtables_ebt_entry *fw,
+					   const char *jumpto)
+{
+	struct xtables_target *target;
+	size_t size;
+
+	/* XTF_TRY_LOAD (may be chain name) */
+	target = xtables_find_target(jumpto, XTF_TRY_LOAD);
+
+	if (!target)
+		return NULL;
+
+	size = XT_ALIGN(sizeof(struct xt_entry_target))
+		+ target->size;
+
+	target->t = xtables_calloc(1, size);
+	target->t->u.target_size = size;
+	strncpy(target->t->u.user.name, jumpto, sizeof(target->t->u.user.name));
+	target->t->u.user.name[sizeof(target->t->u.user.name)-1] = '\0';
+	target->t->u.user.revision = target->revision;
+
+	xs_init_target(target);
+
+	if (target->x6_options != NULL)
+		ebt_options = xtables_options_xfrm(xtables_globals.orig_opts,
+					    ebt_options, target->x6_options,
+					    &target->option_offset);
+	else
+		ebt_options = xtables_merge_options(xtables_globals.orig_opts,
+					     ebt_options, target->extra_opts,
+					     &target->option_offset);
+
+	return target;
+}
+
+static int
+append_entry(struct nft_handle *h,
+	     const char *chain,
+	     const char *table,
+	     struct xtables_ebt_entry *fw,
+	     int rulenum,
+	     bool verbose, bool append)
+{
+	int ret = 1;
+
+	if (append)
+		ret = nft_rule_append(h, chain, table, fw, 0,
+				      verbose);
+	else
+		ret = nft_rule_insert(h, chain, table, fw,
+				      rulenum, verbose);
+
+	return ret;
+}
+
+static int
+delete_entry(struct nft_handle *h,
+	     const char *chain,
+	     const char *table,
+	     struct xtables_ebt_entry *fw,
+	     int rulenum,
+	     int rulenum_end,
+	     bool verbose)
+{
+	int ret = 1;
+
+	if (rulenum == -1)
+		ret = nft_rule_delete(h, chain, table, fw, verbose);
+	else {
+		do {
+			ret = nft_rule_delete_num(h, chain, table,
+						  rulenum, verbose);
+			rulenum++;
+		} while (rulenum < rulenum_end);
+	}
+
+	return ret;
+}
+
+static int
+get_current_chain(const char *chain)
+{
+	if (strcmp(chain, "PREROUTING") == 0)
+		return NF_BR_PRE_ROUTING;
+
+	if (strcmp(chain, "INPUT") == 0)
+		return NF_BR_LOCAL_IN;
+
+	if (strcmp(chain, "FORWARD") == 0)
+		return NF_BR_FORWARD;
+
+	if (strcmp(chain, "OUTPUT") == 0)
+		return NF_BR_LOCAL_OUT;
+
+	if (strcmp(chain, "POSTROUTING") == 0)
+		return NF_BR_POST_ROUTING;
+
+	return -1;
+}
+
+/* We use exec_style instead of #ifdef's because ebtables.so is a shared object. */
+/*int do_commandeb(int argc, char *argv[], int exec_style,
+               struct ebt_u_replace *replace_)*/
+int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table)
+{
+	struct xtables_ebt_entry fw;
+	char *buffer;
+	char command = 'h';
+	const char *chain = NULL;
+	const char *newname = NULL;
+	const char *policy = NULL;
+	int exec_style = EXEC_STYLE_PRG;
+	int c, i;
+	int zerochain = -1; /* Needed for the -Z option (we can have -Z <this> -L <that>) */
+	int selected_chain = -1;
+	int chcounter = 0; /* Needed for -C */
+	int rulenum = 0;
+	int rulenum_end = 0;
+	int ret = 0;
+	unsigned int flags = 0;
+	struct xtables_target *t;
+
+	memset(&fw, 0, sizeof(fw));
+
+	if (nft_init(h, xtables_bridge) < 0)
+		xtables_error(OTHER_PROBLEM,
+			      "Could not initialize nftables layer.");
+
+	h->ops = nft_family_ops_lookup(h->family);
+	if (h->ops == NULL)
+		xtables_error(PARAMETER_PROBLEM, "Unknown family");
+
+	for (t = xtables_targets; t; t = t->next) {
+		t->tflags = 0;
+		t->used = 0;
+	}
+
+	/* Getopt saves the day */
+	while ((c = getopt_long(argc, argv,
+	   "-A:D:C:I:N:E:X::L::Z::F::P:Vhi:o:j:c:p:s:d:t:M:", ebt_options, NULL)) != -1) {
+		switch (c) {
+
+		case 'A': /* Add a rule */
+		case 'D': /* Delete a rule */
+		case 'C': /* Change counters */
+		case 'P': /* Define policy */
+		case 'I': /* Insert a rule */
+		case 'N': /* Make a user defined chain */
+		case 'E': /* Rename chain */
+		case 'X': /* Delete chain */
+			/* We allow -N chainname -P policy */
+			if (command == 'N' && c == 'P') {
+				command = c;
+				optind--; /* No table specified */
+				goto handle_P;
+			}
+			if (OPT_COMMANDS)
+				xtables_error(PARAMETER_PROBLEM,
+					      "Multiple commands are not allowed");
+
+			command = c;
+			chain = optarg;
+			selected_chain = get_current_chain(chain);
+			flags |= OPT_COMMAND;
+			/*if (!(replace->flags & OPT_KERNELDATA))
+				ebt_get_kernel_table(replace, 0);*/
+			/*if (optarg && (optarg[0] == '-' || !strcmp(optarg, "!")))
+				ebt_print_error2("No chain name specified");*/
+			if (c == 'N') {
+				ret = nft_chain_user_add(h, chain, *table);
+				break;
+			} else if (c == 'X') {
+				ret = nft_chain_user_del(h, chain, *table);
+				break;
+			}
+
+			if (c == 'E') {
+				ret = nft_chain_user_rename(h, chain, *table, newname);
+				break;
+			} else if (c == 'D' && optind < argc && (argv[optind][0] != '-' || (argv[optind][1] >= '0' && argv[optind][1] <= '9'))) {
+				if (optind != argc - 1)
+					xtables_error(PARAMETER_PROBLEM,
+							 "No extra options allowed with -D start_nr[:end_nr]");
+				if (parse_rule_range(argv[optind], &rulenum, &rulenum_end))
+					xtables_error(PARAMETER_PROBLEM,
+							 "Problem with the specified rule number(s) '%s'", argv[optind]);
+				optind++;
+			} else if (c == 'C') {
+				if ((chcounter = parse_change_counters_rule(argc, argv, &rulenum, &rulenum_end, exec_style, &fw)) == -1)
+					return -1;
+			} else if (c == 'I') {
+				if (optind >= argc || (argv[optind][0] == '-' && (argv[optind][1] < '0' || argv[optind][1] > '9')))
+					rulenum = 1;
+				else {
+					rulenum = parse_rulenumber(argv[optind]);
+					optind++;
+				}
+			} else if (c == 'P') {
+handle_P:
+				if (optind >= argc)
+					xtables_error(PARAMETER_PROBLEM,
+						      "No policy specified");
+				for (i = 0; i < NUM_STANDARD_TARGETS; i++)
+					if (!strcmp(argv[optind], ebt_standard_targets[i])) {
+						policy = argv[optind];
+						printf("policy: %s\n", policy);
+						if (-i-1 == EBT_CONTINUE)
+							xtables_error(PARAMETER_PROBLEM,
+								      "Wrong policy '%s'",
+								      argv[optind]);
+						break;
+					}
+				if (i == NUM_STANDARD_TARGETS)
+					xtables_error(PARAMETER_PROBLEM,
+						      "Unknown policy '%s'", argv[optind]);
+				optind++;
+			}
+			break;
+		case 'L': /* List */
+		case 'F': /* Flush */
+		case 'Z': /* Zero counters */
+			if (c == 'Z') {
+				if ((flags & OPT_ZERO) || (flags & OPT_COMMAND && command != 'L'))
+print_zero:
+					xtables_error(PARAMETER_PROBLEM,
+						      "Command -Z only allowed together with command -L");
+				flags |= OPT_ZERO;
+			} else {
+				if (flags & OPT_COMMAND)
+					xtables_error(PARAMETER_PROBLEM,
+						      "Multiple commands are not allowed");
+				command = c;
+				flags |= OPT_COMMAND;
+				if (flags & OPT_ZERO && c != 'L')
+					goto print_zero;
+			}
+
+#ifdef SILENT_DAEMON
+			if (c== 'L' && exec_style == EXEC_STYLE_DAEMON)
+				xtables_error(PARAMETER_PROBLEM,
+					      "-L not supported in daemon mode");
+#endif
+
+			/*if (!(replace->flags & OPT_KERNELDATA))
+				ebt_get_kernel_table(replace, 0);
+			i = -1;
+			if (optind < argc && argv[optind][0] != '-') {
+				if ((i = ebt_get_chainnr(replace, argv[optind])) == -1)
+					ebt_print_error2("Chain '%s' doesn't exist", argv[optind]);
+				optind++;
+			}
+			if (i != -1) {
+				if (c == 'Z')
+					zerochain = i;
+				else
+					replace->selected_chain = i;
+			}*/
+			break;
+		case 'V': /* Version */
+			if (OPT_COMMANDS)
+				xtables_error(PARAMETER_PROBLEM,
+					      "Multiple commands are not allowed");
+			command = 'V';
+			if (exec_style == EXEC_STYLE_DAEMON)
+				xtables_error(PARAMETER_PROBLEM,
+					      "%s %s\n", PROGNAME, PROGVERSION);
+			printf("%s %s\n", PROGNAME, PROGVERSION);
+			exit(0);
+		case 'h': /* Help */
+#ifdef SILENT_DAEMON
+			if (exec_style == EXEC_STYLE_DAEMON)
+				xtables_error(PARAMETER_PROBLEM,
+					      "-h not supported in daemon mode");
+#endif
+			if (OPT_COMMANDS)
+				xtables_error(PARAMETER_PROBLEM,
+					      "Multiple commands are not allowed");
+			command = 'h';
+
+			/* All other arguments should be extension names */
+			while (optind < argc) {
+				/*struct ebt_u_match *m;
+				struct ebt_u_watcher *w;*/
+
+				if (!strcasecmp("list_extensions", argv[optind])) {
+					ebt_list_extensions(xtables_targets, fw.matches);
+					exit(0);
+				}
+				/*if ((m = ebt_find_match(argv[optind])))
+					ebt_add_match(new_entry, m);
+				else if ((w = ebt_find_watcher(argv[optind])))
+					ebt_add_watcher(new_entry, w);
+				else {*/
+					if (!(t = xtables_find_target(argv[optind], XTF_TRY_LOAD)))
+						xtables_error(PARAMETER_PROBLEM,"Extension '%s' not found", argv[optind]);
+					if (flags & OPT_JUMP)
+						xtables_error(PARAMETER_PROBLEM,"Sorry, you can only see help for one target extension at a time");
+					flags |= OPT_JUMP;
+					fw.target = t;
+				//}
+				optind++;
+			}
+			break;
+		case 't': /* Table */
+			if (OPT_COMMANDS)
+				xtables_error(PARAMETER_PROBLEM,
+					      "Please put the -t option first");
+			check_option(&flags, OPT_TABLE);
+			if (strlen(optarg) > EBT_TABLE_MAXNAMELEN - 1)
+				xtables_error(PARAMETER_PROBLEM,
+					      "Table name length cannot exceed %d characters",
+					      EBT_TABLE_MAXNAMELEN - 1);
+			*table = optarg;
+			break;
+		case 'i': /* Input interface */
+		case 2  : /* Logical input interface */
+		case 'o': /* Output interface */
+		case 3  : /* Logical output interface */
+		case 'j': /* Target */
+		case 'p': /* Net family protocol */
+		case 's': /* Source mac */
+		case 'd': /* Destination mac */
+		case 'c': /* Set counters */
+			if (!OPT_COMMANDS)
+				xtables_error(PARAMETER_PROBLEM,
+					      "No command specified");
+			if (command != 'A' && command != 'D' && command != 'I' && command != 'C')
+				xtables_error(PARAMETER_PROBLEM,
+					      "Command and option do not match");
+			if (c == 'i') {
+				check_option(&flags, OPT_IN);
+				if (selected_chain > 2 && selected_chain < NF_BR_BROUTING)
+					xtables_error(PARAMETER_PROBLEM,
+						      "Use -i only in INPUT, FORWARD, PREROUTING and BROUTING chains");
+				if (check_inverse(optarg, argc, argv))
+					fw.invflags |= EBT_IIN;
+
+				if (strlen(optarg) >= IFNAMSIZ)
+big_iface_length:
+					xtables_error(PARAMETER_PROBLEM,
+						      "Interface name length cannot exceed %d characters",
+						      IFNAMSIZ - 1);
+				xtables_parse_interface(optarg, fw.in, fw.in_mask);	
+				break;
+			} else if (c == 2) {
+				check_option(&flags, OPT_LOGICALIN);
+				if (selected_chain > 2 && selected_chain < NF_BR_BROUTING)
+					xtables_error(PARAMETER_PROBLEM,
+						      "Use --logical-in only in INPUT, FORWARD, PREROUTING and BROUTING chains");
+				if (check_inverse(optarg, argc, argv))
+					fw.invflags |= EBT_ILOGICALIN;
+
+				if (strlen(optarg) >= IFNAMSIZ)
+					goto big_iface_length;
+				strcpy(fw.logical_in, optarg);
+				if (parse_iface(fw.logical_in, "--logical-in"))
+					return -1;
+				break;
+			} else if (c == 'o') {
+				check_option(&flags, OPT_OUT);
+				if (selected_chain < 2 || selected_chain == NF_BR_BROUTING)
+					xtables_error(PARAMETER_PROBLEM,
+						      "Use -o only in OUTPUT, FORWARD and POSTROUTING chains");
+				if (check_inverse(optarg, argc, argv))
+					fw.invflags |= EBT_IOUT;
+
+				if (strlen(optarg) >= IFNAMSIZ)
+					goto big_iface_length;
+
+				xtables_parse_interface(optarg, fw.out, fw.out_mask);
+				break;
+			} else if (c == 3) {
+				check_option(&flags, OPT_LOGICALOUT);
+				if (selected_chain < 2 || selected_chain == NF_BR_BROUTING)
+					xtables_error(PARAMETER_PROBLEM,
+						      "Use --logical-out only in OUTPUT, FORWARD and POSTROUTING chains");
+				if (check_inverse(optarg, argc, argv))
+					fw.invflags |= EBT_ILOGICALOUT;
+
+				if (strlen(optarg) >= IFNAMSIZ)
+					goto big_iface_length;
+				strcpy(fw.logical_out, optarg);
+				if (parse_iface(fw.logical_out, "--logical-out"))
+					return -1;
+				break;
+			} else if (c == 'j') {
+				check_option(&flags, OPT_JUMP);
+				fw.jumpto = parse_target(optarg);
+				fw.target = command_jump(&fw, fw.jumpto);
+				break;
+			} else if (c == 's') {
+				check_option(&flags, OPT_SOURCE);
+				if (check_inverse(optarg, argc, argv))
+					fw.invflags |= EBT_ISOURCE;
+
+				if (ebt_get_mac_and_mask(optarg, fw.sourcemac, fw.sourcemsk))
+					xtables_error(PARAMETER_PROBLEM, "Problem with specified source mac '%s'", optarg);
+				fw.bitmask |= EBT_SOURCEMAC;
+				break;
+			} else if (c == 'd') {
+				check_option(&flags, OPT_DEST);
+				if (check_inverse(optarg, argc, argv))
+					fw.invflags |= EBT_IDEST;
+
+				if (ebt_get_mac_and_mask(optarg, fw.destmac, fw.destmsk))
+					xtables_error(PARAMETER_PROBLEM, "Problem with specified destination mac '%s'", optarg);
+				fw.bitmask |= EBT_DESTMAC;
+				break;
+			} else if (c == 'c') {
+				check_option(&flags, OPT_COUNT);
+				if (check_inverse(optarg, argc, argv))
+					xtables_error(PARAMETER_PROBLEM,
+						      "Unexpected '!' after -c");
+				if (optind >= argc || optarg[0] == '-' || argv[optind][0] == '-')
+					xtables_error(PARAMETER_PROBLEM,
+						      "Option -c needs 2 arguments");
+
+				fw.counters.pcnt = strtoull(optarg, &buffer, 10);
+				if (*buffer != '\0')
+					xtables_error(PARAMETER_PROBLEM,
+						      "Packet counter '%s' invalid",
+						      optarg);
+				fw.counters.bcnt = strtoull(argv[optind], &buffer, 10);
+				if (*buffer != '\0')
+					xtables_error(PARAMETER_PROBLEM,
+						      "Packet counter '%s' invalid",
+						      argv[optind]);
+				optind++;
+				break;
+			}
+			check_option(&flags, OPT_PROTOCOL);
+			if (check_inverse(optarg, argc, argv))
+				fw.invflags |= EBT_IPROTO;
+
+			fw.bitmask &= ~((unsigned int)EBT_NOPROTO);
+			i = strtol(optarg, &buffer, 16);
+			if (*buffer == '\0' && (i < 0 || i > 0xFFFF))
+				xtables_error(PARAMETER_PROBLEM,
+					      "Problem with the specified protocol");
+			if (*buffer != '\0') {
+				struct ethertypeent *ent;
+
+				if (!strcasecmp(optarg, "LENGTH")) {
+					fw.bitmask |= EBT_802_3;
+					break;
+				}
+				ent = getethertypebyname(optarg);
+				if (!ent)
+					xtables_error(PARAMETER_PROBLEM,
+						      "Problem with the specified Ethernet protocol '%s', perhaps "_PATH_ETHERTYPES " is missing", optarg);
+				fw.ethproto = ent->e_ethertype;
+			} else
+				fw.ethproto = i;
+
+			if (fw.ethproto < 0x0600)
+				xtables_error(PARAMETER_PROBLEM,
+					      "Sorry, protocols have values above or equal to 0x0600");
+			break;
+		case 4  : /* Lc */
+#ifdef SILENT_DAEMON
+			if (exec_style == EXEC_STYLE_DAEMON)
+				xtables_error(PARAMETER_PROBLEM,
+					      "--Lc is not supported in daemon mode");
+#endif
+			check_option(&flags, LIST_C);
+			if (command != 'L')
+				xtables_error(PARAMETER_PROBLEM,
+					      "Use --Lc with -L");
+			flags |= LIST_C;
+			break;
+		case 5  : /* Ln */
+#ifdef SILENT_DAEMON
+			if (exec_style == EXEC_STYLE_DAEMON)
+				xtables_error(PARAMETER_PROBLEM,
+					      "--Ln is not supported in daemon mode");
+#endif
+			check_option(&flags, LIST_N);
+			if (command != 'L')
+				xtables_error(PARAMETER_PROBLEM,
+					      "Use --Ln with -L");
+			if (flags & LIST_X)
+				xtables_error(PARAMETER_PROBLEM,
+					      "--Lx is not compatible with --Ln");
+			flags |= LIST_N;
+			break;
+		case 6  : /* Lx */
+#ifdef SILENT_DAEMON
+			if (exec_style == EXEC_STYLE_DAEMON)
+				xtables_error(PARAMETER_PROBLEM,
+					      "--Lx is not supported in daemon mode");
+#endif
+			check_option(&flags, LIST_X);
+			if (command != 'L')
+				xtables_error(PARAMETER_PROBLEM,
+					      "Use --Lx with -L");
+			if (flags & LIST_N)
+				xtables_error(PARAMETER_PROBLEM,
+					      "--Lx is not compatible with --Ln");
+			flags |= LIST_X;
+			break;
+		case 12 : /* Lmac2 */
+#ifdef SILENT_DAEMON
+			if (exec_style == EXEC_STYLE_DAEMON)
+				xtables_error(PARAMETER_PROBLEM,
+					      "--Lmac2 is not supported in daemon mode");
+#endif
+			check_option(&flags, LIST_MAC2);
+			if (command != 'L')
+				xtables_error(PARAMETER_PROBLEM,
+					       "Use --Lmac2 with -L");
+			flags |= LIST_MAC2;
+			break;
+		case 8 : /* atomic-commit */
+/*			if (exec_style == EXEC_STYLE_DAEMON)
+				ebt_print_error2("--atomic-commit is not supported in daemon mode");
+			replace->command = c;
+			if (OPT_COMMANDS)
+				ebt_print_error2("Multiple commands are not allowed");
+			replace->flags |= OPT_COMMAND;
+			if (!replace->filename)
+				ebt_print_error2("No atomic file specified");*/
+			/* Get the information from the file */
+			/*ebt_get_table(replace, 0);*/
+			/* We don't want the kernel giving us its counters,
+			 * they would overwrite the counters extracted from
+			 * the file */
+			/*replace->num_counters = 0;*/
+			/* Make sure the table will be written to the kernel */
+			/*free(replace->filename);
+			replace->filename = NULL;
+			break;*/
+		/*case 7 :*/ /* atomic-init */
+		/*case 10:*/ /* atomic-save */
+		/*case 11:*/ /* init-table */
+		/*	if (exec_style == EXEC_STYLE_DAEMON) {
+				if (c == 7) {
+					ebt_print_error2("--atomic-init is not supported in daemon mode");
+				} else if (c == 10)
+					ebt_print_error2("--atomic-save is not supported in daemon mode");
+				ebt_print_error2("--init-table is not supported in daemon mode");
+			}
+			replace->command = c;
+			if (OPT_COMMANDS)
+				ebt_print_error2("Multiple commands are not allowed");
+			if (c != 11 && !replace->filename)
+				ebt_print_error2("No atomic file specified");
+			replace->flags |= OPT_COMMAND;
+			{
+				char *tmp = replace->filename;*/
+
+				/* Get the kernel table */
+				/*replace->filename = NULL;
+				ebt_get_kernel_table(replace, c == 10 ? 0 : 1);
+				replace->filename = tmp;
+			}
+			break;
+		case 9 :*/ /* atomic */
+			/*if (exec_style == EXEC_STYLE_DAEMON)
+				ebt_print_error2("--atomic is not supported in daemon mode");
+			if (OPT_COMMANDS)
+				ebt_print_error2("--atomic has to come before the command");*/
+			/* A possible memory leak here, but this is not
+			 * executed in daemon mode */
+			/*replace->filename = (char *)malloc(strlen(optarg) + 1);
+			strcpy(replace->filename, optarg);
+			break;
+		case 13 : *//* concurrent */
+			/*signal(SIGINT, sighandler);
+			signal(SIGTERM, sighandler);
+			use_lockfd = 1;
+			break;*/
+		case 1 :
+			if (!strcmp(optarg, "!"))
+				check_inverse(optarg, argc, argv);
+			else
+				xtables_error(PARAMETER_PROBLEM,
+					      "Bad argument : '%s'", optarg);
+			/* ebt_check_inverse() did optind++ */
+			optind--;
+			continue;
+		default:
+			/* Is it a target option? */
+			/*t = (struct ebt_u_target *)new_entry->t;
+			if ((t->parse(c - t->option_offset, argv, argc, new_entry, &t->flags, &t->t))) {
+				if (ebt_errormsg[0] != '\0')
+					return -1;
+				goto check_extension;
+			}*/
+
+			/* Is it a match_option? */
+			/*for (m = ebt_matches; m; m = m->next)
+				if (m->parse(c - m->option_offset, argv, argc, new_entry, &m->flags, &m->m))
+					break;
+
+			if (m != NULL) {
+				if (ebt_errormsg[0] != '\0')
+					return -1;
+				if (m->used == 0) {
+					ebt_add_match(new_entry, m);
+					m->used = 1;
+				}
+				goto check_extension;
+			}*/
+
+			/* Is it a watcher option? */
+			/*for (w = ebt_watchers; w; w = w->next)
+				if (w->parse(c - w->option_offset, argv, argc, new_entry, &w->flags, &w->w))
+					break;
+
+			if (w == NULL && c == '?')
+				ebt_print_error2("Unknown argument: '%s'", argv[optind - 1], (char)optopt, (char)c);
+			else if (w == NULL) {
+				if (!strcmp(t->name, "standard"))
+					ebt_print_error2("Unknown argument: don't forget the -t option");
+				else
+					ebt_print_error2("Target-specific option does not correspond with specified target");
+			}
+			if (ebt_errormsg[0] != '\0')
+				return -1;
+			if (w->used == 0) {
+				ebt_add_watcher(new_entry, w);
+				w->used = 1;
+			}*/
+check_extension:
+			if (command != 'A' && command != 'I' &&
+			    command != 'D' && command != 'C')
+				xtables_error(PARAMETER_PROBLEM,
+					      "Extensions only for -A, -I, -D and -C");
+		}
+		ebt_invert = 0;
+	}
+
+	/* Just in case we didn't catch an error */
+	/*if (ebt_errormsg[0] != '\0')
+		return -1;
+
+	if (!(table = ebt_find_table(replace->name)))
+		ebt_print_error2("Bad table name");*/
+
+	if (command == 'h' && !(flags & OPT_ZERO)) {
+		print_help(fw.target, fw.matches);
+		if (exec_style == EXEC_STYLE_PRG)
+			exit(0);
+	}
+
+	/* Do the final checks */
+	/*if (replace->command == 'A' || replace->command == 'I' ||
+	   replace->command == 'D' || replace->command == 'C') {*/
+		/* This will put the hook_mask right for the chains */
+		/*ebt_check_for_loops(replace);
+		if (ebt_errormsg[0] != '\0')
+			return -1;
+		entries = ebt_to_chain(replace);
+		m_l = new_entry->m_list;
+		w_l = new_entry->w_list;
+		t = (struct ebt_u_target *)new_entry->t;
+		while (m_l) {
+			m = (struct ebt_u_match *)(m_l->m);
+			m->final_check(new_entry, m->m, replace->name,
+			   entries->hook_mask, 0);
+			if (ebt_errormsg[0] != '\0')
+				return -1;
+			m_l = m_l->next;
+		}
+		while (w_l) {
+			w = (struct ebt_u_watcher *)(w_l->w);
+			w->final_check(new_entry, w->w, replace->name,
+			   entries->hook_mask, 0);
+			if (ebt_errormsg[0] != '\0')
+				return -1;
+			w_l = w_l->next;
+		}
+		t->final_check(new_entry, t->t, replace->name,
+		   entries->hook_mask, 0);
+		if (ebt_errormsg[0] != '\0')
+			return -1;
+	}*/
+	/* So, the extensions can work with the host endian.
+	 * The kernel does not have to do this of course */
+	fw.ethproto = htons(fw.ethproto);
+
+	if (command == 'P') {
+		if (selected_chain < NF_BR_NUMHOOKS && strcmp(policy, "RETURN")==0)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Policy RETURN only allowed for user defined chains");
+		ret = nft_chain_set(h, *table, chain, policy, NULL);
+		if (ret < 0)
+			xtables_error(PARAMETER_PROBLEM, "Wrong policy");
+	} else if (command == 'L') {
+		ret = list_rules(h, chain, *table, rulenum,
+				 flags&OPT_VERBOSE,
+				 flags&OPT_NUMERIC,
+				 /*flags&OPT_EXPANDED*/0,
+				 flags&LIST_N);
+		if (!(flags & OPT_ZERO) && exec_style == EXEC_STYLE_PRG)
+			exit(0);
+	}
+	if (flags & OPT_ZERO) {
+		selected_chain = zerochain;
+		ret = nft_chain_zero_counters(h, chain, *table);
+	} else if (command == 'F') {
+		ret = nft_rule_flush(h, chain, *table);
+	} else if (command == 'A') {
+		ret = append_entry(h, chain, *table, &fw, 0,
+				   flags&OPT_VERBOSE, true);
+	} else if (command == 'I') {
+		ret = append_entry(h, chain, *table, &fw, rulenum - 1,
+				   flags&OPT_VERBOSE, false);
+	} else if (command == 'D') {
+		ret = delete_entry(h, chain, *table, &fw, rulenum - 1,
+				   rulenum_end, flags&OPT_VERBOSE);
+	} /*else if (replace->command == 'C') {
+		ebt_change_counters(replace, new_entry, rule_nr, rule_nr_end, &(new_entry->cnt_surplus), chcounter);
+		if (ebt_errormsg[0] != '\0')
+			return -1;
+	}*/
+	/* Commands -N, -E, -X, --atomic-commit, --atomic-commit, --atomic-save,
+	 * --init-table fall through */
+
+	/*if (ebt_errormsg[0] != '\0')
+		return -1;
+	if (table->check)
+		table->check(replace);
+
+	if (exec_style == EXEC_STYLE_PRG) {*//* Implies ebt_errormsg[0] == '\0' */
+		/*ebt_deliver_table(replace);
+
+		if (replace->nentries)
+			ebt_deliver_counters(replace);*/
+	return ret;
+}
diff --git a/iptables/xtables-ebtables.h b/iptables/xtables-ebtables.h
new file mode 100644
index 0000000..1e479b1
--- /dev/null
+++ b/iptables/xtables-ebtables.h
@@ -0,0 +1,49 @@
+#ifndef _XTABLES_EBTABLES_H_
+#define _XTABLES_EBTABLES_H_
+
+#include <netinet/in.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter/x_tables.h>
+
+/* We use replace->flags, so we can't use the following values:
+ * 0x01 == OPT_COMMAND, 0x02 == OPT_TABLE, 0x100 == OPT_ZERO */
+#define LIST_N    0x04
+#define LIST_C    0x08
+#define LIST_X    0x10
+#define LIST_MAC2 0x20
+
+/* Be backwards compatible, so don't use '+' in kernel */
+#define IF_WILDCARD 1
+
+extern unsigned char eb_mac_type_unicast[ETH_ALEN];
+extern unsigned char eb_msk_type_unicast[ETH_ALEN];
+extern unsigned char eb_mac_type_multicast[ETH_ALEN];
+extern unsigned char eb_msk_type_multicast[ETH_ALEN];
+extern unsigned char eb_mac_type_broadcast[ETH_ALEN];
+extern unsigned char eb_msk_type_broadcast[ETH_ALEN];
+extern unsigned char eb_mac_type_bridge_group[ETH_ALEN];
+extern unsigned char eb_msk_type_bridge_group[ETH_ALEN];
+
+int ebt_get_mac_and_mask(const char *from, unsigned char *to, unsigned char *mask);
+
+struct xtables_ebt_entry {
+	unsigned int bitmask;
+	unsigned int invflags;
+	unsigned int flags;
+	uint16_t ethproto;
+	char in[IFNAMSIZ];
+	char logical_in[IFNAMSIZ];
+	unsigned char in_mask[IFNAMSIZ];
+	char out[IFNAMSIZ];
+	char logical_out[IFNAMSIZ];
+	unsigned char out_mask[IFNAMSIZ];
+	unsigned char sourcemac[ETH_ALEN];
+	unsigned char sourcemsk[ETH_ALEN];
+	unsigned char destmac[ETH_ALEN];
+	unsigned char destmsk[ETH_ALEN];
+	struct xtables_rule_match *matches;
+	struct xtables_target *target;
+	struct xt_counters counters;
+	const char *jumpto;
+};
+#endif
diff --git a/iptables/xtables-multi.c b/iptables/xtables-multi.c
index 5f48735..47e16f2 100644
--- a/iptables/xtables-multi.c
+++ b/iptables/xtables-multi.c
@@ -43,6 +43,7 @@ static const struct subcommand multi_subcommands[] = {
 	{"xtables-config",      xtables_config_main},
 	{"xtables-events",      xtables_events_main},
 	{"xtables-arp",		xtables_arp_main},
+	{"xtables-eb",		xtables_eb_main},
 #endif
 	{NULL},
 };
diff --git a/iptables/xtables-multi.h b/iptables/xtables-multi.h
index e706894..21e60b2 100644
--- a/iptables/xtables-multi.h
+++ b/iptables/xtables-multi.h
@@ -10,6 +10,7 @@ extern int xtables_ip6_main(int, char **);
 extern int xtables_ip6_save_main(int, char **);
 extern int xtables_ip6_restore_main(int, char **);
 extern int xtables_arp_main(int, char **);
+extern int xtables_eb_main(int, char **);
 extern int xtables_config_main(int, char **);
 extern int xtables_events_main(int, char **);
 #endif
-- 
1.8.3.2

