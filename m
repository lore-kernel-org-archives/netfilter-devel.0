From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 03/10] Remove support for compilation of conditional extensions
Date: Tue, 15 Apr 2008 12:33:21 +0200
Message-ID: <bfc44342f0ecd2278412e98409f6d98ae307eb69.1208255176.git.jengelh@computergmbh.de>
References: <1208255608-8044-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34597 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbYDOKda (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 06:33:30 -0400
In-Reply-To: <1208255608-8044-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <0e1521015bea15f495f191fa5534eb65ad9bd43f.1208255176.git.jengelh@computergmbh.de>
References: <0e1521015bea15f495f191fa5534eb65ad9bd43f.1208255176.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 extensions/.condition-test             |    4 -
 extensions/.condition-test6            |    4 -
 extensions/.set-test                   |    4 -
 extensions/GNUmakefile.in              |   27 +--
 extensions/libip6t_condition.c         |   95 -----
 extensions/libip6t_condition.man       |    4 -
 extensions/libipt_condition.c          |   94 -----
 extensions/libipt_condition.man        |    4 -
 include/linux/netfilter_ipv4/ip_set.h  |  498 ++++++++++++++++++++++++
 include/linux/netfilter_ipv4/ipt_set.h |   21 +
 10 files changed, 522 insertions(+), 233 deletions(-)
 delete mode 100755 extensions/.condition-test
 delete mode 100755 extensions/.condition-test6
 delete mode 100755 extensions/.set-test
 delete mode 100644 extensions/libip6t_condition.c
 delete mode 100644 extensions/libip6t_condition.man
 delete mode 100644 extensions/libipt_condition.c
 delete mode 100644 extensions/libipt_condition.man
 create mode 100644 include/linux/netfilter_ipv4/ip_set.h
 create mode 100644 include/linux/netfilter_ipv4/ipt_set.h

diff --git a/extensions/.condition-test b/extensions/.condition-test
deleted file mode 100755
index 2470a18..0000000
--- a/extensions/.condition-test
+++ /dev/null
@@ -1,4 +0,0 @@
-#!/bin/sh
-[ "$1" == "provides" -o \
--f "$KERNEL_DIR/include/linux/netfilter_ipv4/ipt_condition.h" ] && \
-echo "condition";
diff --git a/extensions/.condition-test6 b/extensions/.condition-test6
deleted file mode 100755
index 15a0f04..0000000
--- a/extensions/.condition-test6
+++ /dev/null
@@ -1,4 +0,0 @@
-#!/bin/sh
-[ "$1" == "provides" -o \
--f "$KERNEL_DIR/include/linux/netfilter_ipv6/ip6t_condition.h" ] && \
-echo "condition";
diff --git a/extensions/.set-test b/extensions/.set-test
deleted file mode 100755
index 754abfd..0000000
--- a/extensions/.set-test
+++ /dev/null
@@ -1,4 +0,0 @@
-#! /bin/sh
-[ "$1" == "provides" -o \
--f "$KERNEL_DIR/include/linux/netfilter_ipv4/ip_set.h" ] && \
-echo "set SET";
diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index ee20469..31e6fb7 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -32,30 +32,9 @@ endif
 #
 #	Wildcard module list
 #
-pfx_all_mod := $(patsubst ${srcdir}/libxt_%.c,%,$(wildcard ${srcdir}/libxt_*.c))
-pf4_all_mod := $(patsubst ${srcdir}/libipt_%.c,%,$(wildcard ${srcdir}/libipt_*.c))
-pf6_all_mod := $(patsubst ${srcdir}/libip6t_%.c,%,$(wildcard ${srcdir}/libip6t_*.c))
-
-#
-#	Conditional module list
-#
-pfx_cond_mod := $(foreach i,$(wildcard ${srcdir}/.*-testx),$(shell KERNEL_DIR=${ksourcedir} ${i} provides))
-pf4_cond_mod := $(foreach i,$(wildcard ${srcdir}/.*-test),$(shell KERNEL_DIR=${ksourcedir} ${i} provides))
-pf6_cond_mod := $(foreach i,$(wildcard ${srcdir}/.*-test6),$(shell KERNEL_DIR=${ksourcedir} ${i} provides))
-
-#
-#	Conditional modules to build
-#
-pfx_bc_mod := $(foreach i,$(wildcard ${srcdir}/.*-testx),$(shell KERNEL_DIR=${ksourcedir} ${i}))
-pf4_bc_mod := $(foreach i,$(wildcard ${srcdir}/.*-test),$(shell KERNEL_DIR=${ksourcedir} ${i}))
-pf6_bc_mod := $(foreach i,$(wildcard ${srcdir}/.*-test6),$(shell KERNEL_DIR=${ksourcedir} ${i}))
-
-#
-#	Total list of modules to build
-#
-pfx_build_mod := $(filter-out ${pfx_cond_mod},${pfx_all_mod}) ${pfx_bc_mod}
-pf4_build_mod := $(filter-out ${pf4_cond_mod},${pf4_all_mod}) ${pf4_bc_mod}
-pf6_build_mod := $(filter-out ${pf6_cond_mod},${pf6_all_mod}) ${pf6_bc_mod}
+pfx_build_mod := $(patsubst ${srcdir}/libxt_%.c,%,$(wildcard ${srcdir}/libxt_*.c))
+pf4_build_mod := $(patsubst ${srcdir}/libipt_%.c,%,$(wildcard ${srcdir}/libipt_*.c))
+pf6_build_mod := $(patsubst ${srcdir}/libip6t_%.c,%,$(wildcard ${srcdir}/libip6t_*.c))
 pfx_objs      := $(patsubst %,libxt_%.o,${pfx_build_mod})
 pf4_objs      := $(patsubst %,libipt_%.o,${pf4_build_mod})
 pf6_objs      := $(patsubst %,libip6t_%.o,${pf6_build_mod})
diff --git a/extensions/libip6t_condition.c b/extensions/libip6t_condition.c
deleted file mode 100644
index 03e2722..0000000
--- a/extensions/libip6t_condition.c
+++ /dev/null
@@ -1,95 +0,0 @@
-/* Shared library add-on to ip6tables for condition match */
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <getopt.h>
-#include <ip6tables.h>
-
-#include<linux/netfilter_ipv6/ip6_tables.h>
-#include<linux/netfilter_ipv6/ip6t_condition.h>
-
-static void condition_help(void)
-{
-	printf("condition match v%s options:\n"
-	       "--condition [!] filename       "
-	       "Match on boolean value stored in /proc file\n",
-	       IPTABLES_VERSION);
-}
-
-static const struct option condition_opts[] = {
-	{ .name = "condition", .has_arg = 1, .flag = 0, .val = 'X' },
-	{ .name = 0 }
-};
-
-static int
-condition_parse(int c, char **argv, int invert, unsigned int *flags,
-                const void *entry, struct xt_entry_match **match)
-{
-	struct condition6_info *info =
-	    (struct condition6_info *) (*match)->data;
-
-	if (c == 'X') {
-		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
-				   "Can't specify multiple conditions");
-
-		check_inverse(optarg, &invert, &optind, 0);
-
-		if (strlen(argv[optind - 1]) < CONDITION6_NAME_LEN)
-			strcpy(info->name, argv[optind - 1]);
-		else
-			exit_error(PARAMETER_PROBLEM,
-				   "File name too long");
-
-		info->invert = invert;
-		*flags = 1;
-		return 1;
-	}
-
-	return 0;
-}
-
-static void condition_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
-			   "Condition match: must specify --condition");
-}
-
-static void condition_print(const void *ip, const struct xt_entry_match *match,
-                            int numeric)
-{
-	const struct condition6_info *info =
-	    (const struct condition6_info *) match->data;
-
-	printf("condition %s%s ", (info->invert) ? "!" : "", info->name);
-}
-
-
-static void condition_save(const void *ip, const struct xt_entry_match *match)
-{
-	const struct condition6_info *info =
-	    (const struct condition6_info *) match->data;
-
-	printf("--condition %s\"%s\" ", (info->invert) ? "! " : "", info->name);
-}
-
-static struct ip6tables_match condition_match6 = {
-	.name = "condition",
-	.version = IPTABLES_VERSION,
-	.size = IP6T_ALIGN(sizeof(struct condition6_info)),
-	.userspacesize = IP6T_ALIGN(sizeof(struct condition6_info)),
-	.help = condition_help,
-	.parse = condition_parse,
-	.final_check = condition_check,
-	.print = condition_print,
-	.save = condition_save,
-	.extra_opts = condition_opts,
-};
-
-
-void
-_init(void)
-{
-	register_match6(&condition_match6);
-}
diff --git a/extensions/libip6t_condition.man b/extensions/libip6t_condition.man
deleted file mode 100644
index e0bba75..0000000
--- a/extensions/libip6t_condition.man
+++ /dev/null
@@ -1,4 +0,0 @@
-This matches if a specific /proc filename is '0' or '1'.
-.TP
-.BR "--condition " "[!] \fIfilename"
-Match on boolean value stored in /proc/net/ip6t_condition/filename file
diff --git a/extensions/libipt_condition.c b/extensions/libipt_condition.c
deleted file mode 100644
index 4a98dd8..0000000
--- a/extensions/libipt_condition.c
+++ /dev/null
@@ -1,94 +0,0 @@
-/* Shared library add-on to iptables for condition match */
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <getopt.h>
-#include <iptables.h>
-
-#include<linux/netfilter_ipv4/ip_tables.h>
-#include<linux/netfilter_ipv4/ipt_condition.h>
-
-static void condition_help(void)
-{
-	printf("condition match v%s options:\n"
-	       "--condition [!] filename       "
-	       "Match on boolean value stored in /proc file\n",
-	       IPTABLES_VERSION);
-}
-
-static const struct option condition_opts[] = {
-	{ .name = "condition", .has_arg = 1, .flag = 0, .val = 'X' },
-	{ .name = 0 }
-};
-
-static int condition_parse(int c, char **argv, int invert, unsigned int *flags,
-                           const void *entry, struct xt_entry_match **match)
-{
-	struct condition_info *info =
-	    (struct condition_info *) (*match)->data;
-
-	if (c == 'X') {
-		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
-				   "Can't specify multiple conditions");
-
-		check_inverse(optarg, &invert, &optind, 0);
-
-		if (strlen(argv[optind - 1]) < CONDITION_NAME_LEN)
-			strcpy(info->name, argv[optind - 1]);
-		else
-			exit_error(PARAMETER_PROBLEM,
-				   "File name too long");
-
-		info->invert = invert;
-		*flags = 1;
-		return 1;
-	}
-
-	return 0;
-}
-
-static void condition_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
-			   "Condition match: must specify --condition");
-}
-
-static void condition_print(const void *ip, const struct xt_entry_match *match,
-                            int numeric)
-{
-	const struct condition_info *info =
-	    (const struct condition_info *) match->data;
-
-	printf("condition %s%s ", (info->invert) ? "!" : "", info->name);
-}
-
-
-static void condition_save(const void *ip, const struct xt_entry_match *match)
-{
-	const struct condition_info *info =
-	    (const struct condition_info *) match->data;
-
-	printf("--condition %s\"%s\" ", (info->invert) ? "! " : "", info->name);
-}
-
-static struct iptables_match condition_match = {
-	.name 		= "condition",
-	.version 	= IPTABLES_VERSION,
-	.size 		= IPT_ALIGN(sizeof(struct condition_info)),
-	.userspacesize 	= IPT_ALIGN(sizeof(struct condition_info)),
-	.help 		= condition_help,
-	.parse 		= condition_parse,
-	.final_check	= condition_check,
-	.print 		= condition_print,
-	.save 		= condition_save,
-	.extra_opts 	= condition_opts,
-};
-
-
-void
-_init(void)
-{
-	register_match(&condition_match);
-}
diff --git a/extensions/libipt_condition.man b/extensions/libipt_condition.man
deleted file mode 100644
index ce2aa95..0000000
--- a/extensions/libipt_condition.man
+++ /dev/null
@@ -1,4 +0,0 @@
-This matches if a specific /proc filename is '0' or '1'.
-.TP
-.BI "--condition " "[!] \fIfilename\fP"
-Match on boolean value stored in /proc/net/ipt_condition/filename file
diff --git a/include/linux/netfilter_ipv4/ip_set.h b/include/linux/netfilter_ipv4/ip_set.h
new file mode 100644
index 0000000..92a746e
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ip_set.h
@@ -0,0 +1,498 @@
+#ifndef _IP_SET_H
+#define _IP_SET_H
+
+/* Copyright (C) 2000-2002 Joakim Axelsson <gozem@linux.nu>
+ *                         Patrick Schaaf <bof@bof.de>
+ *                         Martin Josefsson <gandalf@wlug.westbo.se>
+ * Copyright (C) 2003-2004 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.  
+ */
+
+#if 0
+#define IP_SET_DEBUG
+#endif
+
+/*
+ * A sockopt of such quality has hardly ever been seen before on the open
+ * market!  This little beauty, hardly ever used: above 64, so it's
+ * traditionally used for firewalling, not touched (even once!) by the
+ * 2.0, 2.2 and 2.4 kernels!
+ *
+ * Comes with its own certificate of authenticity, valid anywhere in the
+ * Free world!
+ *
+ * Rusty, 19.4.2000
+ */
+#define SO_IP_SET 		83
+
+/*
+ * Heavily modify by Joakim Axelsson 08.03.2002
+ * - Made it more modulebased
+ *
+ * Additional heavy modifications by Jozsef Kadlecsik 22.02.2004
+ * - bindings added
+ * - in order to "deal with" backward compatibility, renamed to ipset
+ */
+
+/* 
+ * Used so that the kernel module and ipset-binary can match their versions 
+ */
+#define IP_SET_PROTOCOL_VERSION 2
+
+#define IP_SET_MAXNAMELEN 32	/* set names and set typenames */
+
+/* Lets work with our own typedef for representing an IP address.
+ * We hope to make the code more portable, possibly to IPv6...
+ *
+ * The representation works in HOST byte order, because most set types
+ * will perform arithmetic operations and compare operations.
+ * 
+ * For now the type is an uint32_t.
+ *
+ * Make sure to ONLY use the functions when translating and parsing
+ * in order to keep the host byte order and make it more portable:
+ *  parse_ip()
+ *  parse_mask()
+ *  parse_ipandmask()
+ *  ip_tostring()
+ * (Joakim: where are they???)
+ */
+
+typedef uint32_t ip_set_ip_t;
+
+/* Sets are identified by an id in kernel space. Tweak with ip_set_id_t
+ * and IP_SET_INVALID_ID if you want to increase the max number of sets.
+ */
+typedef uint16_t ip_set_id_t;
+
+#define IP_SET_INVALID_ID	65535
+
+/* How deep we follow bindings */
+#define IP_SET_MAX_BINDINGS	6
+
+/*
+ * Option flags for kernel operations (ipt_set_info)
+ */
+#define IPSET_SRC 		0x01	/* Source match/add */
+#define IPSET_DST		0x02	/* Destination match/add */
+#define IPSET_MATCH_INV		0x04	/* Inverse matching */
+
+/*
+ * Set features
+ */
+#define IPSET_TYPE_IP		0x01	/* IP address type of set */
+#define IPSET_TYPE_PORT		0x02	/* Port type of set */
+#define IPSET_DATA_SINGLE	0x04	/* Single data storage */
+#define IPSET_DATA_DOUBLE	0x08	/* Double data storage */
+
+/* Reserved keywords */
+#define IPSET_TOKEN_DEFAULT	":default:"
+#define IPSET_TOKEN_ALL		":all:"
+
+/* SO_IP_SET operation constants, and their request struct types.
+ *
+ * Operation ids:
+ *	  0-99:	 commands with version checking
+ *	100-199: add/del/test/bind/unbind
+ *	200-299: list, save, restore
+ */
+
+/* Single shot operations: 
+ * version, create, destroy, flush, rename and swap 
+ *
+ * Sets are identified by name.
+ */
+
+#define IP_SET_REQ_STD		\
+	unsigned op;		\
+	unsigned version;	\
+	char name[IP_SET_MAXNAMELEN]
+
+#define IP_SET_OP_CREATE	0x00000001	/* Create a new (empty) set */
+struct ip_set_req_create {
+	IP_SET_REQ_STD;
+	char typename[IP_SET_MAXNAMELEN];
+};
+
+#define IP_SET_OP_DESTROY	0x00000002	/* Remove a (empty) set */
+struct ip_set_req_std {
+	IP_SET_REQ_STD;
+};
+
+#define IP_SET_OP_FLUSH		0x00000003	/* Remove all IPs in a set */
+/* Uses ip_set_req_std */
+
+#define IP_SET_OP_RENAME	0x00000004	/* Rename a set */
+/* Uses ip_set_req_create */
+
+#define IP_SET_OP_SWAP		0x00000005	/* Swap two sets */
+/* Uses ip_set_req_create */
+
+union ip_set_name_index {
+	char name[IP_SET_MAXNAMELEN];
+	ip_set_id_t index;
+};
+
+#define IP_SET_OP_GET_BYNAME	0x00000006	/* Get set index by name */
+struct ip_set_req_get_set {
+	unsigned op;
+	unsigned version;
+	union ip_set_name_index set;
+};
+
+#define IP_SET_OP_GET_BYINDEX	0x00000007	/* Get set name by index */
+/* Uses ip_set_req_get_set */
+
+#define IP_SET_OP_VERSION	0x00000100	/* Ask kernel version */
+struct ip_set_req_version {
+	unsigned op;
+	unsigned version;
+};
+
+/* Double shots operations: 
+ * add, del, test, bind and unbind.
+ *
+ * First we query the kernel to get the index and type of the target set,
+ * then issue the command. Validity of IP is checked in kernel in order
+ * to minimalize sockopt operations.
+ */
+
+/* Get minimal set data for add/del/test/bind/unbind IP */
+#define IP_SET_OP_ADT_GET	0x00000010	/* Get set and type */
+struct ip_set_req_adt_get {
+	unsigned op;
+	unsigned version;
+	union ip_set_name_index set;
+	char typename[IP_SET_MAXNAMELEN];
+};
+
+#define IP_SET_REQ_BYINDEX	\
+	unsigned op;		\
+	ip_set_id_t index;
+
+struct ip_set_req_adt {
+	IP_SET_REQ_BYINDEX;
+};
+
+#define IP_SET_OP_ADD_IP	0x00000101	/* Add an IP to a set */
+/* Uses ip_set_req_adt, with type specific addage */
+
+#define IP_SET_OP_DEL_IP	0x00000102	/* Remove an IP from a set */
+/* Uses ip_set_req_adt, with type specific addage */
+
+#define IP_SET_OP_TEST_IP	0x00000103	/* Test an IP in a set */
+/* Uses ip_set_req_adt, with type specific addage */
+
+#define IP_SET_OP_BIND_SET	0x00000104	/* Bind an IP to a set */
+/* Uses ip_set_req_bind, with type specific addage */
+struct ip_set_req_bind {
+	IP_SET_REQ_BYINDEX;
+	char binding[IP_SET_MAXNAMELEN];
+};
+
+#define IP_SET_OP_UNBIND_SET	0x00000105	/* Unbind an IP from a set */
+/* Uses ip_set_req_bind, with type speficic addage 
+ * index = 0 means unbinding for all sets */
+
+#define IP_SET_OP_TEST_BIND_SET	0x00000106	/* Test binding an IP to a set */
+/* Uses ip_set_req_bind, with type specific addage */
+
+/* Multiple shots operations: list, save, restore.
+ *
+ * - check kernel version and query the max number of sets
+ * - get the basic information on all sets
+ *   and size required for the next step
+ * - get actual set data: header, data, bindings
+ */
+
+/* Get max_sets and the index of a queried set
+ */
+#define IP_SET_OP_MAX_SETS	0x00000020
+struct ip_set_req_max_sets {
+	unsigned op;
+	unsigned version;
+	ip_set_id_t max_sets;		/* max_sets */
+	ip_set_id_t sets;		/* real number of sets */
+	union ip_set_name_index set;	/* index of set if name used */
+};
+
+/* Get the id and name of the sets plus size for next step */
+#define IP_SET_OP_LIST_SIZE	0x00000201
+#define IP_SET_OP_SAVE_SIZE	0x00000202
+struct ip_set_req_setnames {
+	unsigned op;
+	ip_set_id_t index;		/* set to list/save */
+	size_t size;			/* size to get setdata/bindings */
+	/* followed by sets number of struct ip_set_name_list */
+};
+
+struct ip_set_name_list {
+	char name[IP_SET_MAXNAMELEN];
+	char typename[IP_SET_MAXNAMELEN];
+	ip_set_id_t index;
+	ip_set_id_t id;
+};
+
+/* The actual list operation */
+#define IP_SET_OP_LIST		0x00000203
+struct ip_set_req_list {
+	IP_SET_REQ_BYINDEX;
+	/* sets number of struct ip_set_list in reply */ 
+};
+
+struct ip_set_list {
+	ip_set_id_t index;
+	ip_set_id_t binding;
+	u_int32_t ref;
+	size_t header_size;	/* Set header data of header_size */
+	size_t members_size;	/* Set members data of members_size */
+	size_t bindings_size;	/* Set bindings data of bindings_size */
+};
+
+struct ip_set_hash_list {
+	ip_set_ip_t ip;
+	ip_set_id_t binding;
+};
+
+/* The save operation */
+#define IP_SET_OP_SAVE		0x00000204
+/* Uses ip_set_req_list, in the reply replaced by
+ * sets number of struct ip_set_save plus a marker
+ * ip_set_save followed by ip_set_hash_save structures.
+ */
+struct ip_set_save {
+	ip_set_id_t index;
+	ip_set_id_t binding;
+	size_t header_size;	/* Set header data of header_size */
+	size_t members_size;	/* Set members data of members_size */
+};
+
+/* At restoring, ip == 0 means default binding for the given set: */
+struct ip_set_hash_save {
+	ip_set_ip_t ip;
+	ip_set_id_t id;
+	ip_set_id_t binding;
+};
+
+/* The restore operation */
+#define IP_SET_OP_RESTORE	0x00000205
+/* Uses ip_set_req_setnames followed by ip_set_restore structures
+ * plus a marker ip_set_restore, followed by ip_set_hash_save 
+ * structures.
+ */
+struct ip_set_restore {
+	char name[IP_SET_MAXNAMELEN];
+	char typename[IP_SET_MAXNAMELEN];
+	ip_set_id_t index;
+	size_t header_size;	/* Create data of header_size */
+	size_t members_size;	/* Set members data of members_size */
+};
+
+static inline int bitmap_bytes(ip_set_ip_t a, ip_set_ip_t b)
+{
+	return 4 * ((((b - a + 8) / 8) + 3) / 4);
+}
+
+#ifdef __KERNEL__
+
+#define ip_set_printk(format, args...) 			\
+	do {							\
+		printk("%s: %s: ", __FILE__, __FUNCTION__);	\
+		printk(format "\n" , ## args);			\
+	} while (0)
+
+#if defined(IP_SET_DEBUG)
+#define DP(format, args...) 					\
+	do {							\
+		printk("%s: %s (DBG): ", __FILE__, __FUNCTION__);\
+		printk(format "\n" , ## args);			\
+	} while (0)
+#define IP_SET_ASSERT(x)					\
+	do {							\
+		if (!(x))					\
+			printk("IP_SET_ASSERT: %s:%i(%s)\n",	\
+				__FILE__, __LINE__, __FUNCTION__); \
+	} while (0)
+#else
+#define DP(format, args...)
+#define IP_SET_ASSERT(x)
+#endif
+
+struct ip_set;
+
+/*
+ * The ip_set_type definition - one per set type, e.g. "ipmap".
+ *
+ * Each individual set has a pointer, set->type, going to one
+ * of these structures. Function pointers inside the structure implement
+ * the real behaviour of the sets.
+ *
+ * If not mentioned differently, the implementation behind the function
+ * pointers of a set_type, is expected to return 0 if ok, and a negative
+ * errno (e.g. -EINVAL) on error.
+ */
+struct ip_set_type {
+	struct list_head list;	/* next in list of set types */
+
+	/* test for IP in set (kernel: iptables -m set src|dst)
+	 * return 0 if not in set, 1 if in set.
+	 */
+	int (*testip_kernel) (struct ip_set *set,
+			      const struct sk_buff * skb, 
+			      ip_set_ip_t *ip,
+			      const u_int32_t *flags,
+			      unsigned char index);
+
+	/* test for IP in set (userspace: ipset -T set IP)
+	 * return 0 if not in set, 1 if in set.
+	 */
+	int (*testip) (struct ip_set *set,
+		       const void *data, size_t size,
+		       ip_set_ip_t *ip);
+
+	/*
+	 * Size of the data structure passed by when
+	 * adding/deletin/testing an entry.
+	 */
+	size_t reqsize;
+
+	/* Add IP into set (userspace: ipset -A set IP)
+	 * Return -EEXIST if the address is already in the set,
+	 * and -ERANGE if the address lies outside the set bounds.
+	 * If the address was not already in the set, 0 is returned.
+	 */
+	int (*addip) (struct ip_set *set, 
+		      const void *data, size_t size,
+		      ip_set_ip_t *ip);
+
+	/* Add IP into set (kernel: iptables ... -j SET set src|dst)
+	 * Return -EEXIST if the address is already in the set,
+	 * and -ERANGE if the address lies outside the set bounds.
+	 * If the address was not already in the set, 0 is returned.
+	 */
+	int (*addip_kernel) (struct ip_set *set,
+			     const struct sk_buff * skb, 
+			     ip_set_ip_t *ip,
+			     const u_int32_t *flags,
+			     unsigned char index);
+
+	/* remove IP from set (userspace: ipset -D set --entry x)
+	 * Return -EEXIST if the address is NOT in the set,
+	 * and -ERANGE if the address lies outside the set bounds.
+	 * If the address really was in the set, 0 is returned.
+	 */
+	int (*delip) (struct ip_set *set, 
+		      const void *data, size_t size,
+		      ip_set_ip_t *ip);
+
+	/* remove IP from set (kernel: iptables ... -j SET --entry x)
+	 * Return -EEXIST if the address is NOT in the set,
+	 * and -ERANGE if the address lies outside the set bounds.
+	 * If the address really was in the set, 0 is returned.
+	 */
+	int (*delip_kernel) (struct ip_set *set,
+			     const struct sk_buff * skb, 
+			     ip_set_ip_t *ip,
+			     const u_int32_t *flags,
+			     unsigned char index);
+
+	/* new set creation - allocated type specific items
+	 */
+	int (*create) (struct ip_set *set,
+		       const void *data, size_t size);
+
+	/* retry the operation after successfully tweaking the set
+	 */
+	int (*retry) (struct ip_set *set);
+
+	/* set destruction - free type specific items
+	 * There is no return value.
+	 * Can be called only when child sets are destroyed.
+	 */
+	void (*destroy) (struct ip_set *set);
+
+	/* set flushing - reset all bits in the set, or something similar.
+	 * There is no return value.
+	 */
+	void (*flush) (struct ip_set *set);
+
+	/* Listing: size needed for header
+	 */
+	size_t header_size;
+
+	/* Listing: Get the header
+	 *
+	 * Fill in the information in "data".
+	 * This function is always run after list_header_size() under a 
+	 * writelock on the set. Therefor is the length of "data" always 
+	 * correct. 
+	 */
+	void (*list_header) (const struct ip_set *set, 
+			     void *data);
+
+	/* Listing: Get the size for the set members
+	 */
+	int (*list_members_size) (const struct ip_set *set);
+
+	/* Listing: Get the set members
+	 *
+	 * Fill in the information in "data".
+	 * This function is always run after list_member_size() under a 
+	 * writelock on the set. Therefor is the length of "data" always 
+	 * correct. 
+	 */
+	void (*list_members) (const struct ip_set *set,
+			      void *data);
+
+	char typename[IP_SET_MAXNAMELEN];
+	unsigned char features;
+	int protocol_version;
+
+	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
+	struct module *me;
+};
+
+extern int ip_set_register_set_type(struct ip_set_type *set_type);
+extern void ip_set_unregister_set_type(struct ip_set_type *set_type);
+
+/* A generic ipset */
+struct ip_set {
+	char name[IP_SET_MAXNAMELEN];	/* the name of the set */
+	rwlock_t lock;			/* lock for concurrency control */
+	ip_set_id_t id;			/* set id for swapping */
+	ip_set_id_t binding;		/* default binding for the set */
+	atomic_t ref;			/* in kernel and in hash references */
+	struct ip_set_type *type; 	/* the set types */
+	void *data;			/* pooltype specific data */
+};
+
+/* Structure to bind set elements to sets */
+struct ip_set_hash {
+	struct list_head list;		/* list of clashing entries in hash */
+	ip_set_ip_t ip;			/* ip from set */
+	ip_set_id_t id;			/* set id */
+	ip_set_id_t binding;		/* set we bind the element to */
+};
+
+/* register and unregister set references */
+extern ip_set_id_t ip_set_get_byname(const char name[IP_SET_MAXNAMELEN]);
+extern ip_set_id_t ip_set_get_byindex(ip_set_id_t id);
+extern void ip_set_put(ip_set_id_t id);
+
+/* API for iptables set match, and SET target */
+extern void ip_set_addip_kernel(ip_set_id_t id,
+				const struct sk_buff *skb,
+				const u_int32_t *flags);
+extern void ip_set_delip_kernel(ip_set_id_t id,
+				const struct sk_buff *skb,
+				const u_int32_t *flags);
+extern int ip_set_testip_kernel(ip_set_id_t id,
+				const struct sk_buff *skb,
+				const u_int32_t *flags);
+
+#endif				/* __KERNEL__ */
+
+#endif /*_IP_SET_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_set.h b/include/linux/netfilter_ipv4/ipt_set.h
new file mode 100644
index 0000000..2a18b93
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ipt_set.h
@@ -0,0 +1,21 @@
+#ifndef _IPT_SET_H
+#define _IPT_SET_H
+
+#include <linux/netfilter_ipv4/ip_set.h>
+
+struct ipt_set_info {
+	ip_set_id_t index;
+	u_int32_t flags[IP_SET_MAX_BINDINGS + 1];
+};
+
+/* match info */
+struct ipt_set_info_match {
+	struct ipt_set_info match_set;
+};
+
+struct ipt_set_info_target {
+	struct ipt_set_info add_set;
+	struct ipt_set_info del_set;
+};
+
+#endif /*_IPT_SET_H*/
-- 
1.5.5.rc3

