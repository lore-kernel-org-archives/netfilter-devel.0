From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 17/24] Remove support for compilation of conditional extensions
Date: Tue, 4 Mar 2008 17:10:48 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041706280.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Massimiliano Hofer <max@nucleus.it>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36675 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760591AbYCDQKu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:10:50 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This has previously come up on the mailing list; I henceforth decided to 
nuke it.

Jozsef, Massimiliano: Feel free to either (a) get xt_condition and 
xt_ipset into the kernel, then can readd to xtables or (b) get 
xt_condition and xt_ipset into xtables-addons.

===
commit 8de1f0ca5175d07ea467462814c61c5519903c90
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Feb 13 21:35:59 2008 +0100

    Remove support for compilation of conditional extensions
---
 extensions/.condition-test       |    4 -
 extensions/.condition-test6      |    4 -
 extensions/.set-test             |    4 -
 extensions/GNUmakefile.in        |   27 +----
 extensions/libip6t_condition.c   |   94 ----------------
 extensions/libip6t_condition.man |    4 -
 extensions/libipt_SET.c          |  175 ------------------------------
 extensions/libipt_SET.man        |   16 ---
 extensions/libipt_condition.c    |   93 ----------------
 extensions/libipt_condition.man  |    4 -
 extensions/libipt_set.c          |  162 ---------------------------
 extensions/libipt_set.h          |  104 ------------------
 extensions/libipt_set.man        |   17 ---
 13 files changed, 3 insertions(+), 705 deletions(-)
 delete mode 100755 extensions/.condition-test
 delete mode 100755 extensions/.condition-test6
 delete mode 100755 extensions/.set-test
 delete mode 100644 extensions/libip6t_condition.c
 delete mode 100644 extensions/libip6t_condition.man
 delete mode 100644 extensions/libipt_SET.c
 delete mode 100644 extensions/libipt_SET.man
 delete mode 100644 extensions/libipt_condition.c
 delete mode 100644 extensions/libipt_condition.man
 delete mode 100644 extensions/libipt_set.c
 delete mode 100644 extensions/libipt_set.h
 delete mode 100644 extensions/libipt_set.man

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
index b7edce4..1282a33 100644
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
index 56793b2..0000000
--- a/extensions/libip6t_condition.c
+++ /dev/null
@@ -1,94 +0,0 @@
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
-void _init(void);
-void _init(void)
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
diff --git a/extensions/libipt_SET.c b/extensions/libipt_SET.c
deleted file mode 100644
index 91ab488..0000000
--- a/extensions/libipt_SET.c
+++ /dev/null
@@ -1,175 +0,0 @@
-/* Copyright (C) 2000-2002 Joakim Axelsson <gozem@linux.nu>
- *                         Patrick Schaaf <bof@bof.de>
- *                         Martin Josefsson <gandalf@wlug.westbo.se>
- * Copyright (C) 2003-2004 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.  
- */
-
-/* Shared library add-on to iptables to add IP set mangling target. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <ctype.h>
-
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ip_set.h>
-#include <linux/netfilter_ipv4/ipt_set.h>
-#include "libipt_set.h"
-
-/* Function which prints out usage message. */
-static void SET_help(void)
-{
-	printf("SET v%s options:\n"
-	       " --add-set name flags\n"
-	       " --del-set name flags\n"
-	       "		add/del src/dst IP/port from/to named sets,\n"
-	       "		where flags are the comma separated list of\n"
-	       "		'src' and 'dst'.\n"
-	       "\n", IPTABLES_VERSION);
-}
-
-static const struct option SET_opts[] = {
-	{"add-set",   1, 0, '1'},
-	{"del-set",   1, 0, '2'},
-	{0}
-};
-
-/* Initialize the target. */
-static void SET_init(struct xt_entry_target *target)
-{
-	struct ipt_set_info_target *info =
-	    (struct ipt_set_info_target *) target->data;
-
-	memset(info, 0, sizeof(struct ipt_set_info_target));
-	info->add_set.index =
-	info->del_set.index = IP_SET_INVALID_ID;
-
-}
-
-static void
-parse_target(char **argv, int invert, unsigned int *flags,
-             struct ipt_set_info *info, const char *what)
-{
-	if (info->flags[0])
-		exit_error(PARAMETER_PROBLEM,
-			   "--%s can be specified only once", what);
-
-	if (check_inverse(optarg, &invert, NULL, 0))
-		exit_error(PARAMETER_PROBLEM,
-			   "Unexpected `!' after --%s", what);
-
-	if (!argv[optind]
-	    || argv[optind][0] == '-' || argv[optind][0] == '!')
-		exit_error(PARAMETER_PROBLEM,
-			   "--%s requires two args.", what);
-
-	if (strlen(argv[optind-1]) > IP_SET_MAXNAMELEN - 1)
-		exit_error(PARAMETER_PROBLEM,
-			   "setname `%s' too long, max %d characters.",
-			   argv[optind-1], IP_SET_MAXNAMELEN - 1);
-
-	get_set_byname(argv[optind - 1], info);
-	parse_bindings(argv[optind], info);
-	optind++;
-	
-	*flags = 1;
-}
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int SET_parse(int c, char **argv, int invert, unsigned int *flags,
-                     const void *entry, struct xt_entry_target **target)
-{
-	struct ipt_set_info_target *myinfo =
-	    (struct ipt_set_info_target *) (*target)->data;
-
-	switch (c) {
-	case '1':		/* --add-set <set> <flags> */
-		parse_target(argv, invert, flags,
-			     &myinfo->add_set, "add-set");
-		break;
-	case '2':		/* --del-set <set>[:<flags>] <flags> */
-		parse_target(argv, invert, flags,
-			     &myinfo->del_set, "del-set");
-		break;
-
-	default:
-		return 0;
-	}
-	return 1;
-}
-
-/* Final check; must specify at least one. */
-static void SET_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
-			   "You must specify either `--add-set' or `--del-set'");
-}
-
-static void
-print_target(const char *prefix, const struct ipt_set_info *info)
-{
-	int i;
-	char setname[IP_SET_MAXNAMELEN];
-
-	if (info->index == IP_SET_INVALID_ID)
-		return;
-	get_set_byid(setname, info->index);
-	printf("%s %s", prefix, setname);
-	for (i = 0; i < IP_SET_MAX_BINDINGS; i++) {
-		if (!info->flags[i])
-			break;		
-		printf("%s%s",
-		       i == 0 ? " " : ",",
-		       info->flags[i] & IPSET_SRC ? "src" : "dst");
-	}
-	printf(" ");
-}
-
-/* Prints out the targinfo. */
-static void SET_print(const void *ip, const struct xt_entry_target *target,
-                      int numeric)
-{
-	struct ipt_set_info_target *info =
-	    (struct ipt_set_info_target *) target->data;
-
-	print_target("add-set", &info->add_set);
-	print_target("del-set", &info->del_set);
-}
-
-/* Saves the union ipt_targinfo in parsable form to stdout. */
-static void SET_save(const void *ip, const struct xt_entry_target *target)
-{
-	struct ipt_set_info_target *info =
-	    (struct ipt_set_info_target *) target->data;
-
-	print_target("--add-set", &info->add_set);
-	print_target("--del-set", &info->del_set);
-}
-
-static struct iptables_target set_target = {
-	.name		= "SET",
-	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct ipt_set_info_target)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_set_info_target)),
-	.help		= SET_help,
-	.init		= SET_init,
-	.parse		= SET_parse,
-	.final_check	= SET_check,
-	.print		= SET_print,
-	.save		= SET_save,
-	.extra_opts	= SET_opts,
-};
-
-void _init(void);
-void _init(void)
-{
-	register_target(&set_target);
-}
diff --git a/extensions/libipt_SET.man b/extensions/libipt_SET.man
deleted file mode 100644
index 8f25bea..0000000
--- a/extensions/libipt_SET.man
+++ /dev/null
@@ -1,16 +0,0 @@
-This modules adds and/or deletes entries from IP sets which can be defined 
-by ipset(8).
-.TP
-.BR "--add-set " "setname flag[,flag...]"
-add the address(es)/port(s) of the packet to the sets
-.TP
-.BR "--del-set " "setname flag[,flag...]"
-delete the address(es)/port(s) of the packet from the sets,
-where flags are
-.BR "src"
-and/or
-.BR "dst"
-and there can be no more than six of them.
-.TP
-The bindings to follow must previously be defined in order to use 
-multilevel adding/deleting by the SET target.
diff --git a/extensions/libipt_condition.c b/extensions/libipt_condition.c
deleted file mode 100644
index 5bd1c44..0000000
--- a/extensions/libipt_condition.c
+++ /dev/null
@@ -1,93 +0,0 @@
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
-void _init(void);
-void _init(void)
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
diff --git a/extensions/libipt_set.c b/extensions/libipt_set.c
deleted file mode 100644
index 78a02b5..0000000
--- a/extensions/libipt_set.c
+++ /dev/null
@@ -1,162 +0,0 @@
-/* Copyright (C) 2000-2002 Joakim Axelsson <gozem@linux.nu>
- *                         Patrick Schaaf <bof@bof.de>
- *                         Martin Josefsson <gandalf@wlug.westbo.se>
- * Copyright (C) 2003-2004 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.  
- */
-
-/* Shared library add-on to iptables to add IP set matching. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <ctype.h>
-#include <errno.h>
-
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ipt_set.h>
-#include "libipt_set.h"
-
-/* Function which prints out usage message. */
-static void set_help(void)
-{
-	printf("set v%s options:\n"
-	       " [!] --set     name flags\n"
-	       "		'name' is the set name from to match,\n" 
-	       "		'flags' are the comma separated list of\n"
-	       "		'src' and 'dst'.\n"
-	       "\n", IPTABLES_VERSION);
-}
-
-static const struct option set_opts[] = {
-	{"set", 1, 0, '1'},
-	{0}
-};
-
-/* Initialize the match. */
-static void set_init(struct xt_entry_match *match)
-{
-	struct ipt_set_info_match *info = 
-		(struct ipt_set_info_match *) match->data;
-	
-
-	memset(info, 0, sizeof(struct ipt_set_info_match));
-
-}
-
-/* Function which parses command options; returns true if it ate an option */
-static int set_parse(int c, char **argv, int invert, unsigned int *flags,
-                     const void *entry, struct xt_entry_match **match)
-{
-	struct ipt_set_info_match *myinfo = 
-		(struct ipt_set_info_match *) (*match)->data;
-	struct ipt_set_info *info = &myinfo->match_set;
-
-	switch (c) {
-	case '1':		/* --set <set> <flag>[,<flag> */
-		if (info->flags[0])
-			exit_error(PARAMETER_PROBLEM,
-				   "--set can be specified only once");
-
-		check_inverse(optarg, &invert, &optind, 0);
-		if (invert)
-			info->flags[0] |= IPSET_MATCH_INV;
-
-		if (!argv[optind]
-		    || argv[optind][0] == '-'
-		    || argv[optind][0] == '!')
-			exit_error(PARAMETER_PROBLEM,
-				   "--set requires two args.");
-
-		if (strlen(argv[optind-1]) > IP_SET_MAXNAMELEN - 1)
-			exit_error(PARAMETER_PROBLEM,
-				   "setname `%s' too long, max %d characters.",
-				   argv[optind-1], IP_SET_MAXNAMELEN - 1);
-
-		get_set_byname(argv[optind - 1], info);
-		parse_bindings(argv[optind], info);
-		DEBUGP("parse: set index %u\n", info->index);
-		optind++;
-		
-		*flags = 1;
-		break;
-
-	default:
-		return 0;
-	}
-
-	return 1;
-}
-
-/* Final check; must have specified --set. */
-static void set_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
-			   "You must specify `--set' with proper arguments");
-	DEBUGP("final check OK\n");
-}
-
-static void
-print_match(const char *prefix, const struct ipt_set_info *info)
-{
-	int i;
-	char setname[IP_SET_MAXNAMELEN];
-
-	get_set_byid(setname, info->index);
-	printf("%s%s %s", 
-	       (info->flags[0] & IPSET_MATCH_INV) ? "! " : "",
-	       prefix,
-	       setname); 
-	for (i = 0; i < IP_SET_MAX_BINDINGS; i++) {
-		if (!info->flags[i])
-			break;		
-		printf("%s%s",
-		       i == 0 ? " " : ",",
-		       info->flags[i] & IPSET_SRC ? "src" : "dst");
-	}
-	printf(" ");
-}
-
-/* Prints out the matchinfo. */
-static void set_print(const void *ip, const struct xt_entry_match *match,
-                      int numeric)
-{
-	struct ipt_set_info_match *info = 
-		(struct ipt_set_info_match *) match->data;
-
-	print_match("set", &info->match_set);
-}
-
-/* Saves the matchinfo in parsable form to stdout. */
-static void set_save(const void *ip, const struct xt_entry_match *match)
-{
-	struct ipt_set_info_match *info = 
-		(struct ipt_set_info_match *) match->data;
-
-	print_match("--set", &info->match_set);
-}
-
-static struct iptables_match set_match = {
-	.name		= "set",
-	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct ipt_set_info_match)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_set_info_match)),
-	.help		= set_help,
-	.init		= set_init,
-	.parse		= set_parse,
-	.final_check	= set_check,
-	.print		= set_print,
-	.save		= set_save,
-	.extra_opts	= set_opts,
-};
-
-void _init(void);
-void _init(void)
-{
-	register_match(&set_match);
-}
diff --git a/extensions/libipt_set.h b/extensions/libipt_set.h
deleted file mode 100644
index 02de0fa..0000000
--- a/extensions/libipt_set.h
+++ /dev/null
@@ -1,104 +0,0 @@
-#ifndef _LIBIPT_SET_H
-#define _LIBIPT_SET_H
-
-#include <sys/types.h>
-#include <sys/socket.h>
-#include <errno.h>
-
-#ifdef DEBUG
-#define DEBUGP(x, args...) fprintf(stderr, x, ## args)
-#else
-#define DEBUGP(x, args...) 
-#endif
-
-static void
-parse_bindings(const char *optarg, struct ipt_set_info *info)
-{
-	char *saved = strdup(optarg);
-	char *ptr, *tmp = saved;
-	int i = 0;
-	
-	while (i < (IP_SET_MAX_BINDINGS - 1) && tmp != NULL) {
-		ptr = strsep(&tmp, ",");
-		if (strncmp(ptr, "src", 3) == 0)
-			info->flags[i++] |= IPSET_SRC;
-		else if (strncmp(ptr, "dst", 3) == 0)
-			info->flags[i++] |= IPSET_DST;
-		else
-			exit_error(PARAMETER_PROBLEM,
-				   "You must spefify (the comma separated list of) 'src' or 'dst'.");
-	}
-
-	if (tmp)
-		exit_error(PARAMETER_PROBLEM,
-			   "Can't follow bindings deeper than %i.", 
-			   IP_SET_MAX_BINDINGS - 1);
-
-	free(saved);
-}
-
-static int get_set_getsockopt(void *data, socklen_t * size)
-{
-	int sockfd = -1;
-	sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
-	if (sockfd < 0)
-		exit_error(OTHER_PROBLEM,
-			   "Can't open socket to ipset.\n");
-	/* Send! */
-	return getsockopt(sockfd, SOL_IP, SO_IP_SET, data, size);
-}
-
-static void get_set_byname(const char *setname, struct ipt_set_info *info)
-{
-	struct ip_set_req_get_set req;
-	socklen_t size = sizeof(struct ip_set_req_get_set);
-	int res;
-
-	req.op = IP_SET_OP_GET_BYNAME;
-	req.version = IP_SET_PROTOCOL_VERSION;
-	strncpy(req.set.name, setname, IP_SET_MAXNAMELEN);
-	req.set.name[IP_SET_MAXNAMELEN - 1] = '\0';
-	res = get_set_getsockopt(&req, &size);
-	if (res != 0)
-		exit_error(OTHER_PROBLEM,
-			   "Problem when communicating with ipset, errno=%d.\n",
-			   errno);
-	if (size != sizeof(struct ip_set_req_get_set))
-		exit_error(OTHER_PROBLEM,
-			   "Incorrect return size from kernel during ipset lookup, "
-			   "(want %ld, got %ld)\n",
-			   sizeof(struct ip_set_req_get_set), size);
-	if (req.set.index == IP_SET_INVALID_ID)
-		exit_error(PARAMETER_PROBLEM,
-			   "Set %s doesn't exist.\n", setname);
-
-	info->index = req.set.index;
-}
-
-static void get_set_byid(char * setname, ip_set_id_t index)
-{
-	struct ip_set_req_get_set req;
-	socklen_t size = sizeof(struct ip_set_req_get_set);
-	int res;
-
-	req.op = IP_SET_OP_GET_BYINDEX;
-	req.version = IP_SET_PROTOCOL_VERSION;
-	req.set.index = index;
-	res = get_set_getsockopt(&req, &size);
-	if (res != 0)
-		exit_error(OTHER_PROBLEM,
-			   "Problem when communicating with ipset, errno=%d.\n",
-			   errno);
-	if (size != sizeof(struct ip_set_req_get_set))
-		exit_error(OTHER_PROBLEM,
-			   "Incorrect return size from kernel during ipset lookup, "
-			   "(want %ld, got %ld)\n",
-			   sizeof(struct ip_set_req_get_set), size);
-	if (req.set.name[0] == '\0')
-		exit_error(PARAMETER_PROBLEM,
-			   "Set id %i in kernel doesn't exist.\n", index);
-
-	strncpy(setname, req.set.name, IP_SET_MAXNAMELEN);
-}
-
-#endif /*_LIBIPT_SET_H*/
diff --git a/extensions/libipt_set.man b/extensions/libipt_set.man
deleted file mode 100644
index d280577..0000000
--- a/extensions/libipt_set.man
+++ /dev/null
@@ -1,17 +0,0 @@
-This modules macthes IP sets which can be defined by ipset(8).
-.TP
-.BR "--set " "setname flag[,flag...]"
-where flags are
-.BR "src"
-and/or
-.BR "dst" 
-and there can be no more than six of them. Hence the command
-.nf
- iptables -A FORWARD -m set --set test src,dst
-.fi
-will match packets, for which (depending on the type of the set) the source
-address or port number of the packet can be found in the specified set. If 
-there is a binding belonging to the mached set element or there is a default 
-binding for the given set, then the rule will match the packet only if 
-additionally (depending on the type of the set) the destination address or 
-port number of the packet can be found in the set according to the binding.
