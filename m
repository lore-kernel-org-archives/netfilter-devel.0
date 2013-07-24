From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [xtables-arptables PATCH] xtables: Bootstrap xtables-arptables
 compatible tool for nftables
Date: Wed, 24 Jul 2013 09:58:16 +0200
Message-ID: <20130724075808.4219.71684.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58425 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab3GXH6b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jul 2013 03:58:31 -0400
Received: by mail-wi0-f170.google.com with SMTP id ey16so4767481wid.5
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jul 2013 00:58:30 -0700 (PDT)
Received: from [127.0.0.1] ([37.77.119.234])
        by mx.google.com with ESMTPSA id fs8sm3450688wib.0.2013.07.24.00.58.27
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Wed, 24 Jul 2013 00:58:28 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xtables: Bootstrap xtables-arptables compatible tool for nftables

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/Makefile.am                    |    4 
 iptables/nft-arptables.c                |  214 ++++
 iptables/nft-arptables.h                |   95 ++
 iptables/xtables-arptables-standalone.c |   58 +
 iptables/xtables-arptables.c            | 1632 +++++++++++++++++++++++++++++++
 iptables/xtables-multi.c                |    1 
 iptables/xtables-multi.h                |    1 
 7 files changed, 2004 insertions(+), 1 deletions(-)
 create mode 100644 iptables/nft-arptables.c
 create mode 100644 iptables/nft-arptables.h
 create mode 100644 iptables/xtables-arptables-standalone.c
 create mode 100644 iptables/xtables-arptables.c

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index fb26a32..ac9edf6 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -31,7 +31,9 @@ xtables_multi_SOURCES += xtables-config-parser.y xtables-config-syntax.l
 xtables_multi_SOURCES += xtables-save.c xtables-restore.c \
 			 xtables-standalone.c xtables.c nft.c \
 			 nft-shared.c nft-ipv4.c nft-ipv6.c \
-			 xtables-config.c xtables-events.c
+			 xtables-config.c xtables-events.c \
+			 nft-arptables.c xtables-arptables.c \
+			 xtables-arptables-standalone.c			 
 xtables_multi_LDADD   += -lmnl -lnftables ${libmnl_LIBS} ${libnftables_LIBS}
 xtables_multi_CFLAGS  += -DENABLE_NFTABLES
 # yacc and lex generate dirty code
diff --git a/iptables/nft-arptables.c b/iptables/nft-arptables.c
new file mode 100644
index 0000000..ef9dfdd
--- /dev/null
+++ b/iptables/nft-arptables.c
@@ -0,0 +1,214 @@
+/*
+ * (C) 2013 by Giuseppe Longo <giuseppelng@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <errno.h>
+
+#include <linux/netlink.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter/nf_tables_compat.h>
+
+#include <libiptc/libxtc.h>
+#include <libiptc/xtcshared.h>
+
+#include <stdlib.h>
+#include <string.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <netinet/ip6.h>
+
+#include <libmnl/libmnl.h>
+#include <libnftables/table.h>
+#include <libnftables/chain.h>
+#include <libnftables/rule.h>
+#include <libnftables/expr.h>
+
+#include "nft-arptables.h"
+#include "xshared.h" /* proto_to_name */
+#include "nft-shared.h"
+#include "xtables-config-parser.h"
+
+extern struct builtin_table arp_tables[TABLES_MAX] = {
+	[FILTER] = {
+		.name	= "filter",
+		.chains = {
+			{
+				.name	= "INPUT",
+				.type	= "filter",
+				.prio	= 0,	/* NF_IP_PRI_FILTER */
+				.hook	= NF_INET_LOCAL_IN,
+			},
+			{
+				.name	= "FORWARD",
+				.type	= "filter",
+				.prio	= 0,	/* NF_IP_PRI_FILTER */
+				.hook	= NF_INET_FORWARD,
+			},
+			{
+				.name	= "OUTPUT",
+				.type	= "filter",
+				.prio	= 0,	/* NF_IP_PRI_FILTER */
+				.hook	= NF_INET_LOCAL_OUT,
+			},
+		},
+	},
+};
+
+static int 
+nft_arp_chain_user_add(struct nft_handle *h, const char *chain,
+		       const char *table)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	struct nft_chain *c;
+	int ret;
+
+	/* If built-in chains don't exist for this table, create them */
+	if (nft_xtables_config_load(h, ARPTABLES_CONFIG_DEFAULT, 0) < 0)
+		nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
+
+	nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
+
+	c = nft_chain_alloc();
+	if (c == NULL) {
+		DEBUGP("cannot allocate chain\n");
+		return -1;
+	}
+
+	nft_chain_attr_set(c, NFT_CHAIN_ATTR_TABLE, (char *)table);
+	nft_chain_attr_set(c, NFT_CHAIN_ATTR_NAME, (char *)chain);
+
+	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, h->family,
+                                       NLM_F_ACK|NLM_F_EXCL, h->seq);
+	nft_chain_nlmsg_build_payload(nlh, c);
+	nft_chain_free(c);
+
+	ret = mnl_talk(h, nlh, NULL, NULL);
+	if (ret < 0) {
+		if (errno != EEXIST)
+			perror("mnl_talk:nft_chain_add");
+	}
+
+	/* the core expects 1 for success and 0 for error */
+	return ret == 0 ? 1 : 0;
+}
+
+static const char *policy_name[NF_ACCEPT+1] = {
+	[NF_DROP] = "DROP",
+	[NF_ACCEPT] = "ACCEPT",
+};
+
+static void
+print_header(unsigned int format, const char *chain, const char *pol,
+            const struct xt_counters *counters, bool basechain, uint32_t refs)
+{
+	printf("Chain %s", chain);
+	if (basechain) {
+		printf(" (policy %s", pol);
+		if (!(format & FMT_NOCOUNTS)) {
+			fputc(' ', stdout);
+			print_num(counters->pcnt, (format|FMT_NOTABLE));
+			fputs("packets, ", stdout);
+			print_num(counters->bcnt, (format|FMT_NOTABLE));
+			fputs("bytes", stdout);
+		}
+		printf(")\n");
+	} else {
+		printf(" (%u references)\n", refs);
+	}
+
+	if (format & FMT_LINENUMBERS)
+		printf(FMT("%-4s ", "%s "), "num");
+	if (!(format & FMT_NOCOUNTS)) {
+		if (format & FMT_KILOMEGAGIGA) {
+			printf(FMT("%5s ","%s "), "pkts");
+			printf(FMT("%5s ","%s "), "bytes");
+		} else {
+			printf(FMT("%8s ","%s "), "pkts");
+			printf(FMT("%10s ","%s "), "bytes");
+		}
+	}
+	if (!(format & FMT_NOTARGET))
+		printf(FMT("%-9s ","%s "), "target");
+	fputs(" prot ", stdout);
+	if (format & FMT_OPTIONS)
+		fputs("opt", stdout);
+	if (format & FMT_VIA) {
+		printf(FMT(" %-6s ","%s "), "in");
+		printf(FMT("%-6s ","%s "), "out");
+	}
+	printf(FMT(" %-19s ","%s "), "source");
+	printf(FMT(" %-19s "," %s "), "destination");
+	printf("\n");
+}
+
+static int 
+nft_arp_rule_list(struct nft_handle *h, const char *chain, const char *table,
+		  int rulenum, unsigned int format)
+{
+	struct nft_chain_list *list;
+	struct nft_chain_list_iter *iter;
+	struct nft_chain *c;
+	bool found = false;
+
+	/* If built-in chains don't exist for this table, create them */
+	if (nft_xtables_config_load(h, ARPTABLES_CONFIG_DEFAULT, 0) < 0)
+		nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
+
+	list = nft_chain_dump(h);
+
+	iter = nft_chain_list_iter_create(list);
+	if (iter == NULL) {
+		DEBUGP("cannot allocate rule list iterator\n");
+		return 0;
+	}
+
+	c = nft_chain_list_iter_next(iter);
+	while (c != NULL) {
+		const char *chain_table =
+			nft_chain_attr_get_str(c, NFT_CHAIN_ATTR_TABLE);
+		const char *chain_name =
+			nft_chain_attr_get_str(c, NFT_CHAIN_ATTR_NAME);
+		uint32_t policy =
+			nft_chain_attr_get_u32(c, NFT_CHAIN_ATTR_POLICY);
+		uint32_t refs =
+			nft_chain_attr_get_u32(c, NFT_CHAIN_ATTR_USE);
+		struct xt_counters ctrs = {
+			.pcnt = nft_chain_attr_get_u64(c, NFT_CHAIN_ATTR_PACKETS),
+			.bcnt = nft_chain_attr_get_u64(c, NFT_CHAIN_ATTR_BYTES),
+		};
+		bool basechain = false;
+
+		if (nft_chain_attr_get(c, NFT_CHAIN_ATTR_HOOKNUM))
+			basechain = true;
+
+		if (strcmp(table, chain_table) != 0)
+			goto next;
+		if (chain && strcmp(chain, chain_name) != 0)
+			goto next;
+
+		if (found) printf("\n");
+
+		print_header(format, chain_name, policy_name[policy], &ctrs,
+				basechain, refs);
+
+		//__nft_rule_list(h, c, table, rulenum, format, print_firewall);
+
+		found = true;
+
+next:
+		c = nft_chain_list_iter_next(iter);
+	}
+
+	nft_chain_list_free(list);
+
+	return 1;
+}
diff --git a/iptables/nft-arptables.h b/iptables/nft-arptables.h
new file mode 100644
index 0000000..e573324
--- /dev/null
+++ b/iptables/nft-arptables.h
@@ -0,0 +1,95 @@
+/*
+ * (C) 2013 by Giuseppe Longo <giuseppelng@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef _NFT_ARPTABLES_H_
+#define _NFT_ARPTABLES_H_
+
+#include "nft.h"
+
+typedef char arpt_chainlabel[32];
+
+enum exittype {
+	OTHER_PROBLEM = 1,
+	PARAMETER_PROBLEM,
+	VERSION_PROBLEM
+};
+
+/*******************************/
+/* REMOVE LATER, PUT IN KERNEL */
+/*******************************/
+struct arpt_entry_match
+{
+	int iets;
+};
+
+/*******************************/
+/* END OF KERNEL REPLACEMENTS  */
+/*******************************/
+
+/* Include file for additions: new matches and targets. */
+
+struct arptables_match
+{
+	struct arptables_match *next;
+
+	arpt_chainlabel name;
+
+	const char *version;
+
+	/* Size of match data. */
+	size_t size;
+
+	/* Size of match data relevent for userspace comparison purposes */
+	size_t userspacesize;
+
+	/* Function which prints out usage message. */
+	void (*help)(void);
+
+	/* Initialize the match. */
+	void (*init)(struct arpt_entry_match *m, unsigned int *nfcache);
+
+	/* Function which parses command options; returns true if it
+		ate an option */
+	int (*parse)(int c, char **argv, int invert, unsigned int *flags,
+			const struct arpt_entry *entry,
+			unsigned int *nfcache,
+			struct arpt_entry_match **match);
+
+	/* Final check; exit if not ok. */
+	void (*final_check)(unsigned int flags);
+
+	/* Prints out the match iff non-NULL: put space at end */
+	void (*print)(const struct arpt_arp *ip,
+			const struct arpt_entry_match *match, int numeric);
+
+	/* Saves the match info in parsable form to stdout. */
+	void (*save)(const struct arpt_arp *ip,
+			const struct arpt_entry_match *match);
+
+	/* Pointer to list of extra command-line options */
+	const struct option *extra_opts;
+
+	/* Ignore these men behind the curtain: */
+	unsigned int option_offset;
+	struct arpt_entry_match *m;
+	unsigned int mflags;
+	unsigned int used;
+	unsigned int loaded; /* simulate loading so options are merged properly */
+};
+
+const char *program_name, *program_version;
+
+/* For nft_arptables.c */
+int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table);
+
+/*
+ * Parse config for tables and chain helper functions
+ */
+#define ARPTABLES_CONFIG_DEFAULT  "/etc/arptables.conf"
+
+#endif
diff --git a/iptables/xtables-arptables-standalone.c b/iptables/xtables-arptables-standalone.c
new file mode 100644
index 0000000..a98ceea
--- /dev/null
+++ b/iptables/xtables-arptables-standalone.c
@@ -0,0 +1,58 @@
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
+#include "nft-arptables.h"
+
+int 
+xtables_arptables_main(int argc, char *argv[])
+{
+	int ret;
+	char *table = "filter";
+	extern struct builtin_table arp_tables[TABLES_MAX];
+        struct nft_handle h = {
+                .family = NFPROTO_ARP,
+        };
+
+	program_name = "xtables-arptables";
+
+	nft_init(&h, arp_tables, ARPTABLES_CONFIG_DEFAULT);
+
+	ret = do_commandarp(&h, argc, argv, &table);
+
+	exit(!ret);
+}
+
diff --git a/iptables/xtables-arptables.c b/iptables/xtables-arptables.c
new file mode 100644
index 0000000..fc3c2ff
--- /dev/null
+++ b/iptables/xtables-arptables.c
@@ -0,0 +1,1632 @@
+/* Code to take an arptables-style command line and do it. */
+
+/*
+ * arptables:
+ * Author: Bart De Schuymer <bdschuym@pandora.be>, but
+ * almost all code is from the iptables userspace program, which has main
+ * authors: Paul.Russell@rustcorp.com.au and mneuling@radlogic.com.au
+ *
+ *     This program is free software; you can redistribute it and/or modify
+ *     it under the terms of the GNU General Public License as published by
+ *     the Free Software Foundation; either version 2 of the License, or
+ *     (at your option) any later version.
+ *
+ *     This program is distributed in the hope that it will be useful,
+ *     but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *     GNU General Public License for more details.
+ *
+ *     You should have received a copy of the GNU General Public License
+ *     along with this program; if not, write to the Free Software
+ *     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <getopt.h>
+#include <string.h>
+#include <netdb.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <inttypes.h>
+#include <dlfcn.h>
+#include <ctype.h>
+#include <stdarg.h>
+#include <limits.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/wait.h>
+#include <net/if.h>
+#include <linux/netfilter_arp/arp_tables.h>
+#include "nft-arptables.h"
+
+#ifndef TRUE
+#define TRUE 1
+#endif
+#ifndef FALSE
+#define FALSE 0
+#endif
+
+#define NUMBER_OF_CMD  13
+static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
+			'N', 'X', 'P', 'E' };
+
+#define OPTION_OFFSET 256
+
+#define OPT_NONE       0x00000U
+#define OPT_NUMERIC    0x00001U
+#define OPT_S_IP       0x00002U
+#define OPT_D_IP       0x00004U
+#define OPT_S_MAC      0x00008U
+#define OPT_D_MAC      0x00010U
+#define OPT_H_LENGTH   0x00020U
+#define OPT_P_LENGTH   0x00040U
+#define OPT_OPCODE     0x00080U
+#define OPT_H_TYPE     0x00100U
+#define OPT_P_TYPE     0x00200U
+#define OPT_JUMP       0x00400U
+#define OPT_VERBOSE    0x00800U
+#define OPT_VIANAMEIN  0x01000U
+#define OPT_VIANAMEOUT 0x02000U
+#define OPT_LINENUMBERS 0x04000U
+#define OPT_COUNTERS   0x08000U
+#define NUMBER_OF_OPT  16
+
+#define ETH_ALEN 6
+static const char optflags[NUMBER_OF_OPT]
+= { 'n', 's', 'd', 2, 3, 7, 8, 4, 5, 6, 'j', 'v', 'i', 'o', '0', 'c'};
+
+static struct option original_opts[] = {
+	{ "append", 1, 0, 'A' },
+	{ "delete", 1, 0,  'D' },
+	{ "insert", 1, 0,  'I' },
+	{ "replace", 1, 0,  'R' },
+	{ "list", 2, 0,  'L' },
+	{ "flush", 2, 0,  'F' },
+	{ "zero", 2, 0,  'Z' },
+	{ "new-chain", 1, 0,  'N' },
+	{ "delete-chain", 2, 0,  'X' },
+	{ "rename-chain", 1, 0,  'E' },
+	{ "policy", 1, 0,  'P' },
+	{ "source-ip", 1, 0, 's' },
+	{ "destination-ip", 1, 0,  'd' },
+	{ "src-ip", 1, 0,  's' },
+	{ "dst-ip", 1, 0,  'd' },
+	{ "source-mac", 1, 0, 2},
+	{ "destination-mac", 1, 0, 3},
+	{ "src-mac", 1, 0, 2},
+	{ "dst-mac", 1, 0, 3},
+	{ "h-length", 1, 0,  'l' },
+	{ "p-length", 1, 0,  8 },
+	{ "opcode", 1, 0,  4 },
+	{ "h-type", 1, 0,  5 },
+	{ "proto-type", 1, 0,  6 },
+	{ "in-interface", 1, 0, 'i' },
+	{ "jump", 1, 0, 'j' },
+	{ "table", 1, 0, 't' },
+	{ "match", 1, 0, 'm' },
+	{ "numeric", 0, 0, 'n' },
+	{ "out-interface", 1, 0, 'o' },
+	{ "verbose", 0, 0, 'v' },
+	{ "exact", 0, 0, 'x' },
+	{ "version", 0, 0, 'V' },
+	{ "help", 2, 0, 'h' },
+	{ "line-numbers", 0, 0, '0' },
+	{ "modprobe", 1, 0, 'M' },
+	{ 0 }
+};
+
+int RUNTIME_NF_ARP_NUMHOOKS = 3;
+
+static struct option *opts = original_opts;
+static unsigned int global_option_offset = 0;
+
+/* Table of legal combinations of commands and options.  If any of the
+ * given commands make an option legal, that option is legal (applies to
+ * CMD_LIST and CMD_ZERO only).
+ * Key:
+ *  +  compulsory
+ *  x  illegal
+ *     optional
+ */
+
+static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
+/* Well, it's better than "Re: Linux vs FreeBSD" */
+{
+       /*     -n  -s  -d  -p  -j  -v  -x  -i  -o  -f  --line */
+/*INSERT*/    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
+/*DELETE*/    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
+/*DELETE_NUM*/{' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
+/*REPLACE*/   {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
+/*APPEND*/    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
+/*LIST*/      {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
+/*FLUSH*/     {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
+/*ZERO*/      {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
+/*NEW_CHAIN*/ {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
+/*DEL_CHAIN*/ {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
+/*SET_POLICY*/{' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
+/*CHECK*/     {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
+/*RENAME*/    {' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',' '}
+};
+
+static int inverse_for_options[NUMBER_OF_OPT] =
+{
+/* -n */ 0,
+/* -s */ ARPT_INV_SRCIP,
+/* -d */ ARPT_INV_TGTIP,
+/* 2 */ ARPT_INV_SRCDEVADDR,
+/* 3 */ ARPT_INV_TGTDEVADDR,
+/* -l */ ARPT_INV_ARPHLN,
+/* 8 */ 0,
+/* 4 */ ARPT_INV_ARPOP,
+/* 5 */ ARPT_INV_ARPHRD,
+/* 6 */ ARPT_INV_ARPPRO,
+/* -j */ 0,
+/* -v */ 0,
+/* -i */ ARPT_INV_VIA_IN,
+/* -o */ ARPT_INV_VIA_OUT,
+/*--line*/ 0,
+/* -c */ 0,
+};
+
+const char *program_version = "0.1";
+//const char *program_name;
+
+/* A few hardcoded protocols for 'all' and in case the user has no
+ *    /etc/protocols */
+struct pprot {
+	char *name;
+	u_int8_t num;
+};
+
+/* Primitive headers... */
+/* defined in netinet/in.h */
+#if 0
+#ifndef IPPROTO_ESP
+#define IPPROTO_ESP 50
+#endif
+#ifndef IPPROTO_AH
+#define IPPROTO_AH 51
+#endif
+#endif
+
+/***********************************************/
+/* ARPTABLES SPECIFIC NEW FUNCTIONS ADDED HERE */
+/***********************************************/
+
+unsigned char mac_type_unicast[ETH_ALEN] =   {0,0,0,0,0,0};
+unsigned char msk_type_unicast[ETH_ALEN] =   {1,0,0,0,0,0};
+unsigned char mac_type_multicast[ETH_ALEN] = {1,0,0,0,0,0};
+unsigned char msk_type_multicast[ETH_ALEN] = {1,0,0,0,0,0};
+unsigned char mac_type_broadcast[ETH_ALEN] = {255,255,255,255,255,255};
+unsigned char msk_type_broadcast[ETH_ALEN] = {255,255,255,255,255,255};
+
+/* a few names */
+static char *opcodes[] =
+{
+	"Request",
+	"Reply",
+	"Request_Reverse",
+	"Reply_Reverse",
+	"DRARP_Request",
+	"DRARP_Reply",
+	"DRARP_Error",
+	"InARP_Request",
+	"ARP_NAK",
+};
+#define NUMOPCODES 9
+
+/*
+ *  * put the mac address into 6 (ETH_ALEN) bytes
+ *   */
+static int getmac_and_mask(char *from, char *to, char *mask)
+{
+	char *p;
+	int i;
+	struct ether_addr *addr;
+
+	if (strcasecmp(from, "Unicast") == 0) {
+		memcpy(to, mac_type_unicast, ETH_ALEN);
+		memcpy(mask, msk_type_unicast, ETH_ALEN);
+		return 0;
+	}
+	if (strcasecmp(from, "Multicast") == 0) {
+		memcpy(to, mac_type_multicast, ETH_ALEN);
+		memcpy(mask, msk_type_multicast, ETH_ALEN);
+		return 0;
+	}
+	if (strcasecmp(from, "Broadcast") == 0) {
+		memcpy(to, mac_type_broadcast, ETH_ALEN);
+		memcpy(mask, msk_type_broadcast, ETH_ALEN);
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
+static int getlength_and_mask(char *from, uint8_t *to, uint8_t *mask)
+{
+	char *p, *buffer;
+	int i;
+
+	if ( (p = strrchr(from, '/')) != NULL) {
+		*p = '\0';
+		i = strtol(p+1, &buffer, 10);
+		if (*buffer != '\0' || i < 0 || i > 255)
+			return -1;
+		*mask = (uint8_t)i;
+	} else
+		*mask = 255;
+	i = strtol(from, &buffer, 10);
+	if (*buffer != '\0' || i < 0 || i > 255)
+		return -1;
+	*to = (uint8_t)i;
+	return 0;
+}
+
+static int get16_and_mask(char *from, uint16_t *to, uint16_t *mask, int base)
+{
+	char *p, *buffer;
+	int i;
+
+	if ( (p = strrchr(from, '/')) != NULL) {
+		*p = '\0';
+		i = strtol(p+1, &buffer, base);
+		if (*buffer != '\0' || i < 0 || i > 65535)
+			return -1;
+		*mask = htons((uint16_t)i);
+	} else
+		*mask = 65535;
+	i = strtol(from, &buffer, base);
+	if (*buffer != '\0' || i < 0 || i > 65535)
+		return -1;
+	*to = htons((uint16_t)i);
+	return 0;
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
+static void print_mac_and_mask(const unsigned char *mac, const unsigned char *mask, int l)
+{
+	int i;
+
+	print_mac(mac, l);
+	for (i = 0; i < l ; i++)
+		if (mask[i] != 255)
+			break;
+	if (i == l)
+		return;
+	printf("/");
+	print_mac(mask, l);
+}
+
+/*********************************************/
+/* ARPTABLES SPECIFIC NEW FUNCTIONS END HERE */
+/*********************************************/
+
+static int
+string_to_number(const char *s, unsigned int min, unsigned int max,
+                unsigned int *ret)
+{
+	long number;
+	char *end;
+
+	/* Handle hex, octal, etc. */
+	errno = 0;
+	number = strtol(s, &end, 0);
+	if (*end == '\0' && end != s) {
+		/* we parsed a number, let's see if we want this */
+		if (errno != ERANGE && min <= number && number <= max) {
+			*ret = number;
+			return 0;
+		}
+	}
+	return -1;
+}
+
+static struct in_addr *
+dotted_to_addr(const char *dotted)
+{
+	static struct in_addr addr;
+	unsigned char *addrp;
+	char *p, *q;
+	unsigned int onebyte;
+	int i;
+	char buf[20];
+
+	/* copy dotted string, because we need to modify it */
+	strncpy(buf, dotted, sizeof(buf) - 1);
+	addrp = (unsigned char *) &(addr.s_addr);
+
+	p = buf;
+	for (i = 0; i < 3; i++) {
+		if ((q = strchr(p, '.')) == NULL)
+			return (struct in_addr *) NULL;
+
+		*q = '\0';
+		if (string_to_number(p, 0, 255, &onebyte) == -1)
+			return (struct in_addr *) NULL;
+
+		addrp[i] = (unsigned char) onebyte;
+		p = q + 1;
+	}
+
+	/* we've checked 3 bytes, now we check the last one */
+	if (string_to_number(p, 0, 255, &onebyte) == -1)
+		return (struct in_addr *) NULL;
+
+	addrp[3] = (unsigned char) onebyte;
+
+	return &addr;
+}
+
+static struct in_addr *
+network_to_addr(const char *name)
+{
+	struct netent *net;
+	static struct in_addr addr;
+
+	if ((net = getnetbyname(name)) != NULL) {
+		if (net->n_addrtype != AF_INET)
+			return (struct in_addr *) NULL;
+		addr.s_addr = htonl((unsigned long) net->n_net);
+		return &addr;
+	}
+
+	return (struct in_addr *) NULL;
+}
+
+static void
+inaddrcpy(struct in_addr *dst, struct in_addr *src)
+{
+	/* memcpy(dst, src, sizeof(struct in_addr)); */
+	dst->s_addr = src->s_addr;
+}
+
+static void
+exit_tryhelp(int status)
+{
+	fprintf(stderr, "Try `%s -h' or '%s --help' for more information.\n",
+			program_name, program_name );
+	exit(status);
+}
+
+static void
+exit_error(enum exittype status, char *msg, ...)
+{
+	va_list args;
+
+	va_start(args, msg);
+	fprintf(stderr, "%s v%s: ", program_name, program_version);
+	vfprintf(stderr, msg, args);
+	va_end(args);
+	fprintf(stderr, "\n");
+	if (status == PARAMETER_PROBLEM)
+		exit_tryhelp(status);
+	if (status == VERSION_PROBLEM)
+		fprintf(stderr,
+			"Perhaps arptables or your kernel needs to be upgraded.\n");
+	exit(status);
+}
+
+static void
+exit_printhelp(void)
+{
+	struct arptables_match *m = NULL;
+	struct arptables_target *t = NULL;
+	int i;
+
+       printf("%s v%s\n\n"
+"Usage: %s -[AD] chain rule-specification [options]\n"
+"       %s -[RI] chain rulenum rule-specification [options]\n"
+"       %s -D chain rulenum [options]\n"
+"       %s -[LFZ] [chain] [options]\n"
+"       %s -[NX] chain\n"
+"       %s -E old-chain-name new-chain-name\n"
+"       %s -P chain target [options]\n"
+"       %s -h (print this help information)\n\n",
+		program_name, program_version, program_name, program_name,
+		program_name, program_name, program_name, program_name,
+		program_name, program_name);
+
+	printf(
+"Commands:\n"
+"Either long or short options are allowed.\n"
+"  --append  -A chain          Append to chain\n"
+"  --delete  -D chain          Delete matching rule from chain\n"
+"  --delete  -D chain rulenum\n"
+"                              Delete rule rulenum (1 = first) from chain\n"
+"  --insert  -I chain [rulenum]\n"
+"                              Insert in chain as rulenum (default 1=first)\n"
+"  --replace -R chain rulenum\n"
+"                              Replace rule rulenum (1 = first) in chain\n"
+"  --list    -L [chain]                List the rules in a chain or all chains\n"
+"  --flush   -F [chain]                Delete all rules in  chain or all chains\n"
+"  --zero    -Z [chain]                Zero counters in chain or all chains\n"
+"  --new     -N chain          Create a new user-defined chain\n"
+"  --delete-chain\n"
+"            -X [chain]                Delete a user-defined chain\n"
+"  --policy  -P chain target\n"
+"                              Change policy on chain to target\n"
+"  --rename-chain\n"
+"            -E old-chain new-chain\n"
+"                              Change chain name, (moving any references)\n"
+"Options:\n"
+"  --source-ip -s [!] address[/mask]\n"
+"                              source specification\n"
+"  --destination-ip -d [!] address[/mask]\n"
+"                              destination specification\n"
+"  --source-mac [!] address[/mask]\n"
+"  --destination-mac [!] address[/mask]\n"
+"  --h-length   -l   length[/mask] hardware length (nr of bytes)\n"
+"  --opcode code[/mask] operation code (2 bytes)\n"
+"  --h-type   type[/mask]  hardware type (2 bytes, hexadecimal)\n"
+"  --proto-type   type[/mask]  protocol type (2 bytes)\n"
+"  --in-interface -i [!] input name[+]\n"
+"                              network interface name ([+] for wildcard)\n"
+"  --out-interface -o [!] output name[+]\n"
+"                              network interface name ([+] for wildcard)\n"
+"  --jump      -j target\n"
+"                              target for rule (may load target extension)\n"
+"  --match     -m match\n"
+"                              extended match (may load extension)\n"
+"  --numeric   -n              numeric output of addresses and ports\n"
+"  --table     -t table        table to manipulate (default: `filter')\n"
+"  --verbose   -v              verbose mode\n"
+"  --line-numbers              print line numbers when listing\n"
+"  --exact     -x              expand numbers (display exact values)\n"
+"  --modprobe=<command>                try to insert modules using this command\n"
+"  --set-counters PKTS BYTES   set the counter during insert/append\n"
+"[!] --version -V              print package version.\n");
+	printf(" opcode strings: \n");
+	for (i = 0; i < NUMOPCODES; i++)
+		printf(" %d = %s\n", i + 1, opcodes[i]);
+	printf(
+" hardware type string: 1 = Ethernet\n"
+" protocol type string: 0x800 = IPv4\n");
+
+	/* Print out any special helps. A user might like to be able
+		to add a --help to the commandline, and see expected
+		results. So we call help for all matches & targets */
+	/*for (t=arptables_targets;t;t=t->next) {
+		printf("\n");
+		t->help();
+	}
+	for (m=arptables_matches;m;m=m->next) {
+		printf("\n");
+		m->help();
+	}*/
+	exit(0);
+}
+
+static void
+generic_opt_check(int command, int options)
+{
+	int i, j, legal = 0;
+
+	/* Check that commands are valid with options.  Complicated by the
+	* fact that if an option is legal with *any* command given, it is
+	* legal overall (ie. -z and -l).
+	*/
+	for (i = 0; i < NUMBER_OF_OPT; i++) {
+		legal = 0; /* -1 => illegal, 1 => legal, 0 => undecided. */
+
+		for (j = 0; j < NUMBER_OF_CMD; j++) {
+			if (!(command & (1<<j)))
+				continue;
+
+			if (!(options & (1<<i))) {
+				if (commands_v_options[j][i] == '+')
+					exit_error(PARAMETER_PROBLEM,
+							"You need to supply the `-%c' "
+							"option for this command\n",
+							optflags[i]);
+			} else {
+				if (commands_v_options[j][i] != 'x')
+					legal = 1;
+				else if (legal == 0)
+					legal = -1;
+			}
+		}
+		if (legal == -1)
+			exit_error(PARAMETER_PROBLEM,
+					"Illegal option `-%c' with this command\n",
+					optflags[i]);
+	}
+}
+
+static char
+opt2char(int option)
+{
+	const char *ptr;
+	for (ptr = optflags; option > 1; option >>= 1, ptr++);
+
+	return *ptr;
+}
+
+static char
+cmd2char(int option)
+{
+	const char *ptr;
+	for (ptr = cmdflags; option > 1; option >>= 1, ptr++);
+
+	return *ptr;
+}
+
+static void
+add_command(unsigned int *cmd, const int newcmd, const unsigned int othercmds, int invert)
+{
+	if (invert)
+		exit_error(PARAMETER_PROBLEM, "unexpected ! flag");
+	if (*cmd & (~othercmds))
+		exit_error(PARAMETER_PROBLEM, "Can't use -%c with -%c\n",
+				cmd2char(newcmd), cmd2char(*cmd & (~othercmds)));
+	*cmd |= newcmd;
+}
+
+static int
+check_inverse(const char option[], int *invert, int *optind, int argc)
+{
+	if (option && strcmp(option, "!") == 0) {
+		if (*invert)
+			exit_error(PARAMETER_PROBLEM,
+					"Multiple `!' flags not allowed");
+		*invert = TRUE;
+		if (optind) {
+			*optind = *optind+1;
+			if (argc && *optind > argc)
+				exit_error(PARAMETER_PROBLEM,
+						"no argument following `!'");
+		}
+
+		return TRUE;
+	}
+	return FALSE;
+}
+
+static void *
+fw_calloc(size_t count, size_t size)
+{
+	void *p;
+
+	if ((p = calloc(count, size)) == NULL) {
+		perror("arptables: calloc failed");
+		exit(1);
+	}
+	return p;
+}
+
+static void *
+fw_malloc(size_t size)
+{
+	void *p;
+
+	if ((p = malloc(size)) == NULL) {
+		perror("arptables: malloc failed");
+		exit(1);
+	}
+	return p;
+}
+
+static struct in_addr *
+host_to_addr(const char *name, unsigned int *naddr)
+{
+	struct hostent *host;
+	struct in_addr *addr;
+	unsigned int i;
+
+	*naddr = 0;
+	if ((host = gethostbyname(name)) != NULL) {
+		if (host->h_addrtype != AF_INET ||
+			host->h_length != sizeof(struct in_addr))
+			return (struct in_addr *) NULL;
+
+		while (host->h_addr_list[*naddr] != (char *) NULL)
+			(*naddr)++;
+		addr = fw_calloc(*naddr, sizeof(struct in_addr));
+		for (i = 0; i < *naddr; i++)
+			inaddrcpy(&(addr[i]),
+					(struct in_addr *) host->h_addr_list[i]);
+		return addr;
+	}
+
+	return (struct in_addr *) NULL;
+}
+
+static char *
+addr_to_host(const struct in_addr *addr)
+{
+	struct hostent *host;
+
+	if ((host = gethostbyaddr((char *) addr,
+					sizeof(struct in_addr), AF_INET)) != NULL)
+		return (char *) host->h_name;
+
+	return (char *) NULL;
+}
+
+/*
+ *     All functions starting with "parse" should succeed, otherwise
+ *     the program fails.
+ *     Most routines return pointers to static data that may change
+ *     between calls to the same or other routines with a few exceptions:
+ *     "host_to_addr", "parse_hostnetwork", and "parse_hostnetworkmask"
+ *     return global static data.
+ */
+
+static struct in_addr *
+parse_hostnetwork(const char *name, unsigned int *naddrs)
+{
+	struct in_addr *addrp, *addrptmp;
+
+	if ((addrptmp = dotted_to_addr(name)) != NULL ||
+		(addrptmp = network_to_addr(name)) != NULL) {
+		addrp = fw_malloc(sizeof(struct in_addr));
+		inaddrcpy(addrp, addrptmp);
+		*naddrs = 1;
+		return addrp;
+	}
+	if ((addrp = host_to_addr(name, naddrs)) != NULL)
+		return addrp;
+
+	exit_error(PARAMETER_PROBLEM, "host/network `%s' not found", name);
+}
+
+static struct in_addr *
+parse_mask(char *mask)
+{
+	static struct in_addr maskaddr;
+	struct in_addr *addrp;
+	unsigned int bits;
+
+	if (mask == NULL) {
+		/* no mask at all defaults to 32 bits */
+		maskaddr.s_addr = 0xFFFFFFFF;
+		return &maskaddr;
+	}
+	if ((addrp = dotted_to_addr(mask)) != NULL)
+		/* dotted_to_addr already returns a network byte order addr */
+		return addrp;
+	if (string_to_number(mask, 0, 32, &bits) == -1)
+		exit_error(PARAMETER_PROBLEM,
+				"invalid mask `%s' specified", mask);
+	if (bits != 0) {
+		maskaddr.s_addr = htonl(0xFFFFFFFF << (32 - bits));
+		return &maskaddr;
+	}
+
+	maskaddr.s_addr = 0L;
+	return &maskaddr;
+}
+
+static void
+parse_hostnetworkmask(const char *name, struct in_addr **addrpp,
+                     struct in_addr *maskp, unsigned int *naddrs)
+{
+	struct in_addr *addrp;
+	char buf[256];
+	char *p;
+	int i, j, k, n;
+
+	strncpy(buf, name, sizeof(buf) - 1);
+	if ((p = strrchr(buf, '/')) != NULL) {
+		*p = '\0';
+		addrp = parse_mask(p + 1);
+	} else
+		addrp = parse_mask(NULL);
+	inaddrcpy(maskp, addrp);
+
+	/* if a null mask is given, the name is ignored, like in "any/0" */
+	if (maskp->s_addr == 0L)
+		strcpy(buf, "0.0.0.0");
+
+	addrp = *addrpp = parse_hostnetwork(buf, naddrs);
+	n = *naddrs;
+	for (i = 0, j = 0; i < n; i++) {
+		addrp[j++].s_addr &= maskp->s_addr;
+		for (k = 0; k < j - 1; k++) {
+			if (addrp[k].s_addr == addrp[j - 1].s_addr) {
+				(*naddrs)--;
+				j--;
+				break;
+			}
+		}
+	}
+}
+
+static void
+parse_interface(const char *arg, char *vianame, unsigned char *mask)
+{
+	int vialen = strlen(arg);
+	unsigned int i;
+
+	memset(mask, 0, IFNAMSIZ);
+	memset(vianame, 0, IFNAMSIZ);
+
+	if (vialen + 1 > IFNAMSIZ)
+		exit_error(PARAMETER_PROBLEM,
+				"interface name `%s' must be shorter than IFNAMSIZ"
+				" (%i)", arg, IFNAMSIZ-1);
+
+	strcpy(vianame, arg);
+	if (vialen == 0)
+		memset(mask, 0, IFNAMSIZ);
+	else if (vianame[vialen - 1] == '+') {
+		memset(mask, 0xFF, vialen - 1);
+		memset(mask + vialen - 1, 0, IFNAMSIZ - vialen + 1);
+		/* Don't remove `+' here! -HW */
+	} else {
+		/* Include nul-terminator in match */
+		memset(mask, 0xFF, vialen + 1);
+		memset(mask + vialen + 1, 0, IFNAMSIZ - vialen - 1);
+		for (i = 0; vianame[i]; i++) {
+			if (!isalnum(vianame[i])
+				&& vianame[i] != '_'
+				&& vianame[i] != '.') {
+				printf("Warning: wierd character in interface"
+					" `%s' (No aliases, :, ! or *).\n",
+					vianame);
+				break;
+			}
+		}
+	}
+}
+
+/* Can't be zero. */
+static int
+parse_rulenumber(const char *rule)
+{
+	unsigned int rulenum;
+
+	if (string_to_number(rule, 1, INT_MAX, &rulenum) == -1)
+		exit_error(PARAMETER_PROBLEM,
+				"Invalid rule number `%s'", rule);
+
+	return rulenum;
+}
+
+static const char *
+parse_target(const char *targetname)
+{
+	/*const char *ptr;
+
+	if (strlen(targetname) < 1)
+		exit_error(PARAMETER_PROBLEM,
+				"Invalid target name (too short)");
+
+	if (strlen(targetname)+1 > sizeof(arpt_chainlabel))
+		exit_error(PARAMETER_PROBLEM,
+				"Invalid target name `%s' (%zu chars max)",
+				targetname, sizeof(arpt_chainlabel)-1);
+
+	for (ptr = targetname; *ptr; ptr++)
+		if (isspace(*ptr))
+			exit_error(PARAMETER_PROBLEM,
+					"Invalid target name `%s'", targetname);*/
+	return targetname;
+}
+
+static char *
+addr_to_network(const struct in_addr *addr)
+{
+	struct netent *net;
+
+	if ((net = getnetbyaddr((long) ntohl(addr->s_addr), AF_INET)) != NULL)
+		return (char *) net->n_name;
+
+	return (char *) NULL;
+}
+
+static char *
+addr_to_dotted(const struct in_addr *addrp)
+{
+	static char buf[20];
+	const unsigned char *bytep;
+
+	bytep = (const unsigned char *) &(addrp->s_addr);
+	sprintf(buf, "%d.%d.%d.%d", bytep[0], bytep[1], bytep[2], bytep[3]);
+	return buf;
+}
+
+static char *
+addr_to_anyname(const struct in_addr *addr)
+{
+	char *name;
+
+	if ((name = addr_to_host(addr)) != NULL ||
+		(name = addr_to_network(addr)) != NULL)
+		return name;
+
+	return addr_to_dotted(addr);
+}
+
+static char *
+mask_to_dotted(const struct in_addr *mask)
+{
+	int i;
+	static char buf[20];
+	u_int32_t maskaddr, bits;
+
+	maskaddr = ntohl(mask->s_addr);
+
+	if (maskaddr == 0xFFFFFFFFL)
+		/* we don't want to see "/32" */
+		return "";
+
+	i = 32;
+	bits = 0xFFFFFFFEL;
+	while (--i >= 0 && maskaddr != bits)
+		bits <<= 1;
+	if (i >= 0)
+		sprintf(buf, "/%d", i);
+	else
+		/* mask was not a decent combination of 1's and 0's */
+		sprintf(buf, "/%s", addr_to_dotted(mask));
+
+	return buf;
+}
+
+static void
+set_option(unsigned int *options, unsigned int option, u_int16_t *invflg,
+          int invert)
+{
+	if (*options & option)
+		exit_error(PARAMETER_PROBLEM, "multiple -%c flags not allowed",
+				opt2char(option));
+	*options |= option;
+
+	if (invert) {
+		unsigned int i;
+		for (i = 0; 1 << i != option; i++);
+
+		if (!inverse_for_options[i])
+			exit_error(PARAMETER_PROBLEM,
+					"cannot have ! before -%c",
+					opt2char(option));
+		*invflg |= inverse_for_options[i];
+	}
+}
+
+static int
+list_entries(struct nft_handle *h, const char *chain, const char *table,
+            int rulenum, int verbose, int numeric, int expanded,
+            int linenumbers)
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
+	/* FIXME should return found or not, and errno = ENOENT in such case */
+	return 0;//nft_arp_rule_list(h, chain, table, rulenum, format);
+}
+
+int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
+{
+	//struct arpt_entry fw, *e = NULL;
+	int invert = 0;
+	unsigned int nsaddrs = 0, ndaddrs = 0;
+	struct in_addr *saddrs = NULL, *daddrs = NULL;
+
+	int c, verbose = 0;
+	const char *chain = NULL;
+	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
+	const char *policy = NULL, *newname = NULL;
+	unsigned int rulenum = 0, options = 0, command = 0;
+	const char *pcnt = NULL, *bcnt = NULL;
+	int ret = 1;
+	/*      struct arptables_match *m;*/
+	struct arptables_target *target = NULL;
+	struct arptables_target *t;
+	const char *jumpto = "";
+	char *protocol = NULL;
+
+	//memset(&fw, 0, sizeof(fw));
+	opts = original_opts;
+	global_option_offset = 0;
+
+	/* re-set optind to 0 in case do_command gets called
+	* a second time */
+	optind = 0;
+
+	/* clear mflags in case do_command gets called a second time
+	* (we clear the global list of all matches for security)*/
+/*     for (m = arptables_matches; m; m = m->next) {
+		m->mflags = 0;
+		m->used = 0;
+	}*/
+
+/*     for (t = arptables_targets; t; t = t->next) {
+		t->tflags = 0;
+		t->used = 0;
+	}*/
+
+	/* Suppress error messages: we may add new options if we
+		demand-load a protocol. */
+	opterr = 0;
+
+	while ((c = getopt_long(argc, argv,
+		"-A:D:R:I:L::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:l:i:vnt:m:c:",
+						opts, NULL)) != -1) {
+		switch (c) {
+			/*
+			* Command selection
+			*/
+		case 'A':
+			add_command(&command, CMD_APPEND, CMD_NONE,
+					invert);
+			chain = optarg;
+			break;
+
+		case 'D':
+			add_command(&command, CMD_DELETE, CMD_NONE,
+					invert);
+			chain = optarg;
+			if (optind < argc && argv[optind][0] != '-'
+				&& argv[optind][0] != '!') {
+				rulenum = parse_rulenumber(argv[optind++]);
+				command = CMD_DELETE_NUM;
+			}
+			break;
+
+		case 'R':
+			add_command(&command, CMD_REPLACE, CMD_NONE,
+					invert);
+			chain = optarg;
+			if (optind < argc && argv[optind][0] != '-'
+				&& argv[optind][0] != '!')
+				rulenum = parse_rulenumber(argv[optind++]);
+			else
+				exit_error(PARAMETER_PROBLEM,
+						"-%c requires a rule number",
+						cmd2char(CMD_REPLACE));
+			break;
+
+		case 'I':
+			add_command(&command, CMD_INSERT, CMD_NONE,
+					invert);
+			chain = optarg;
+			if (optind < argc && argv[optind][0] != '-'
+				&& argv[optind][0] != '!')
+				rulenum = parse_rulenumber(argv[optind++]);
+			else rulenum = 1;
+			break;
+
+		case 'L':
+			add_command(&command, CMD_LIST, CMD_ZERO,
+					invert);
+			if (optarg) chain = optarg;
+			else if (optind < argc && argv[optind][0] != '-'
+				&& argv[optind][0] != '!')
+				chain = argv[optind++];
+			break;
+
+		case 'F':
+			add_command(&command, CMD_FLUSH, CMD_NONE,
+					invert);
+			if (optarg) chain = optarg;
+			else if (optind < argc && argv[optind][0] != '-'
+				&& argv[optind][0] != '!')
+				chain = argv[optind++];
+			break;
+
+		case 'Z':
+			add_command(&command, CMD_ZERO, CMD_LIST,
+					invert);
+			if (optarg) chain = optarg;
+			else if (optind < argc && argv[optind][0] != '-'
+				&& argv[optind][0] != '!')
+				chain = argv[optind++];
+			break;
+
+		case 'N':
+			if (optarg && *optarg == '-')
+				exit_error(PARAMETER_PROBLEM,
+						"chain name not allowed to start "
+						"with `-'\n");
+/*			if (find_target(optarg, TRY_LOAD))
+				exit_error(PARAMETER_PROBLEM,
+						"chain name may not clash "
+						"with target name\n");*/
+			add_command(&command, CMD_NEW_CHAIN, CMD_NONE,
+					invert);
+			chain = optarg;
+			break;
+
+		case 'X':
+			add_command(&command, CMD_DELETE_CHAIN, CMD_NONE,
+					invert);
+			if (optarg) chain = optarg;
+			else if (optind < argc && argv[optind][0] != '-'
+				&& argv[optind][0] != '!')
+				chain = argv[optind++];
+			break;
+
+		case 'E':
+			add_command(&command, CMD_RENAME_CHAIN, CMD_NONE,
+					invert);
+			chain = optarg;
+			if (optind < argc && argv[optind][0] != '-'
+				&& argv[optind][0] != '!')
+				newname = argv[optind++];
+			else
+				exit_error(PARAMETER_PROBLEM,
+						"-%c requires old-chain-name and "
+						"new-chain-name",
+						cmd2char(CMD_RENAME_CHAIN));
+			break;
+
+		case 'P':
+			add_command(&command, CMD_SET_POLICY, CMD_NONE,
+					invert);
+			chain = optarg;
+			if (optind < argc && argv[optind][0] != '-'
+				&& argv[optind][0] != '!')
+				policy = argv[optind++];
+			else
+				exit_error(PARAMETER_PROBLEM,
+						"-%c requires a chain and a policy",
+						cmd2char(CMD_SET_POLICY));
+			break;
+
+		case 'h':
+			if (!optarg)
+				optarg = argv[optind];
+
+			/* arptables -p icmp -h */
+			/*if (!arptables_matches && protocol)
+				find_match(protocol, TRY_LOAD);*/
+
+			exit_printhelp();
+			break;
+
+		case 's':
+			check_inverse(optarg, &invert, &optind, argc);
+			/*set_option(&options, OPT_S_IP, &fw.arp.invflags,
+					invert);*/
+			shostnetworkmask = argv[optind-1];
+			break;
+
+		case 'd':
+			check_inverse(optarg, &invert, &optind, argc);
+			/*set_option(&options, OPT_D_IP, &fw.arp.invflags,
+					invert);*/
+			dhostnetworkmask = argv[optind-1];
+			break;
+
+		case 2:/* src-mac */
+			check_inverse(optarg, &invert, &optind, argc);
+			/*set_option(&options, OPT_S_MAC, &fw.arp.invflags,
+					invert);
+			if (getmac_and_mask(argv[optind - 1],
+				fw.arp.src_devaddr.addr, fw.arp.src_devaddr.mask))
+				exit_error(PARAMETER_PROBLEM, "Problem with specified "
+						"source mac");*/
+			break;
+
+		case 3:/* dst-mac */
+			check_inverse(optarg, &invert, &optind, argc);
+			/*set_option(&options, OPT_D_MAC, &fw.arp.invflags,
+					invert);
+
+			if (getmac_and_mask(argv[optind - 1],
+				fw.arp.tgt_devaddr.addr, fw.arp.tgt_devaddr.mask))
+				exit_error(PARAMETER_PROBLEM, "Problem with specified "
+						"destination mac");*/
+			break;
+
+		case 'l':/* hardware length */
+			check_inverse(optarg, &invert, &optind, argc);
+			/*set_option(&options, OPT_H_LENGTH, &fw.arp.invflags,
+					invert);
+			getlength_and_mask(argv[optind - 1], &fw.arp.arhln,
+						&fw.arp.arhln_mask);*/
+			break;
+
+		case 8:/* protocol length */
+			exit_error(PARAMETER_PROBLEM, "not supported");
+/*
+			check_inverse(optarg, &invert, &optind, argc);
+			set_option(&options, OPT_P_LENGTH, &fw.arp.invflags,
+					invert);
+
+			getlength_and_mask(argv[optind - 1], &fw.arp.arpln,
+						&fw.arp.arpln_mask);
+			break;
+*/
+
+		case 4:/* opcode */
+			check_inverse(optarg, &invert, &optind, argc);
+			/*set_option(&options, OPT_OPCODE, &fw.arp.invflags,
+					invert);
+			if (get16_and_mask(argv[optind - 1], &fw.arp.arpop, &fw.arp.arpop_mask, 10)) {
+				int i;
+
+				for (i = 0; i < NUMOPCODES; i++)
+					if (!strcasecmp(opcodes[i], optarg))
+						break;
+				if (i == NUMOPCODES)
+					exit_error(PARAMETER_PROBLEM, "Problem with specified opcode");
+				fw.arp.arpop = htons(i+1);
+			}*/
+			break;
+
+		case 5:/* h-type */
+			check_inverse(optarg, &invert, &optind, argc);
+			/*set_option(&options, OPT_H_TYPE, &fw.arp.invflags,
+					invert);
+			if (get16_and_mask(argv[optind - 1], &fw.arp.arhrd, &fw.arp.arhrd_mask, 16)) {
+				if (strcasecmp(argv[optind-1], "Ethernet"))
+					exit_error(PARAMETER_PROBLEM, "Problem with specified hardware type");
+				fw.arp.arhrd = htons(1);
+			}*/
+			break;
+
+		case 6:/* proto-type */
+			check_inverse(optarg, &invert, &optind, argc);
+			/*set_option(&options, OPT_P_TYPE, &fw.arp.invflags,
+					invert);
+			if (get16_and_mask(argv[optind - 1], &fw.arp.arpro, &fw.arp.arpro_mask, 0)) {
+				if (strcasecmp(argv[optind-1], "ipv4"))
+					exit_error(PARAMETER_PROBLEM, "Problem with specified protocol type");
+				fw.arp.arpro = htons(0x800);
+			}*/
+			break;
+
+		case 'j':
+			/*set_option(&options, OPT_JUMP, &fw.arp.invflags,
+					invert);*/
+			jumpto = parse_target(optarg);
+			/* TRY_LOAD (may be chain name) */
+			/*target = find_target(jumpto, TRY_LOAD);
+
+			if (target) {
+				size_t size;
+
+				size = ARPT_ALIGN(sizeof(struct arpt_entry_target))
+					+ target->size;
+
+				target->t = fw_calloc(1, size);
+				target->t->u.target_size = size;
+				strcpy(target->t->u.user.name, jumpto);
+
+				//target->init(target->t, &fw.nfcache);
+
+				target->init(target->t);
+
+				opts = merge_options(opts, target->extra_opts, &target->option_offset);
+			}*/
+			break;
+
+		case 'i':
+			check_inverse(optarg, &invert, &optind, argc);
+			/*set_option(&options, OPT_VIANAMEIN, &fw.arp.invflags,
+					invert);
+			parse_interface(argv[optind-1],
+					fw.arp.iniface,
+					fw.arp.iniface_mask);*/
+/*			fw.nfcache |= NFC_IP_IF_IN; */
+			break;
+
+		case 'o':
+			check_inverse(optarg, &invert, &optind, argc);
+			/*set_option(&options, OPT_VIANAMEOUT, &fw.arp.invflags,
+					invert);
+			parse_interface(argv[optind-1],
+					fw.arp.outiface,
+					fw.arp.outiface_mask);*/
+			/* fw.nfcache |= NFC_IP_IF_OUT; */
+			break;
+
+		case 'v':
+			if (!verbose)
+				/*set_option(&options, OPT_VERBOSE,
+						&fw.arp.invflags, invert);*/
+			verbose++;
+			break;
+
+		case 'm': /*{
+			size_t size;
+
+			if (invert)
+				exit_error(PARAMETER_PROBLEM,
+						"unexpected ! flag before --match");
+
+			m = find_match(optarg, LOAD_MUST_SUCCEED);
+			size = ARPT_ALIGN(sizeof(struct arpt_entry_match))
+					+ m->size;
+			m->m = fw_calloc(1, size);
+			m->m->u.match_size = size;
+			strcpy(m->m->u.user.name, m->name);
+			m->init(m->m, &fw.nfcache);
+			opts = merge_options(opts, m->extra_opts, &m->option_offset);
+		}*/
+		break;
+
+		case 'n':
+			/*set_option(&options, OPT_NUMERIC, &fw.arp.invflags,
+					invert);*/
+			break;
+
+		case 't':
+			if (invert)
+				exit_error(PARAMETER_PROBLEM,
+						"unexpected ! flag before --table");
+			*table = argv[optind-1];
+			break;
+
+		case 'V':
+			if (invert)
+				printf("Not %s ;-)\n", program_version);
+			else
+				printf("%s v%s\n",
+					program_name, program_version);
+			exit(0);
+
+		case '0':
+			/*set_option(&options, OPT_LINENUMBERS, &fw.arp.invflags,
+					invert);*/
+			break;
+
+		case 'M':
+			//modprobe = optarg;
+			break;
+
+		case 'c':
+
+			/*set_option(&options, OPT_COUNTERS, &fw.arp.invflags,
+					invert);*/
+			pcnt = optarg;
+			if (optind < argc && argv[optind][0] != '-'
+				&& argv[optind][0] != '!')
+				bcnt = argv[optind++];
+			else
+				exit_error(PARAMETER_PROBLEM,
+					"-%c requires packet and byte counter",
+					opt2char(OPT_COUNTERS));
+
+	/*                     if (sscanf(pcnt, "%"PRIu64, &fw.counters.pcnt) != 1)
+				exit_error(PARAMETER_PROBLEM,
+					"-%c packet counter not numeric",
+					opt2char(OPT_COUNTERS));
+
+			if (sscanf(bcnt, "%"PRIu64, &fw.counters.bcnt) != 1)
+				exit_error(PARAMETER_PROBLEM,
+					"-%c byte counter not numeric",
+					opt2char(OPT_COUNTERS));*/
+			break;
+
+
+		case 1: /* non option */
+			if (optarg[0] == '!' && optarg[1] == '\0') {
+				if (invert)
+					exit_error(PARAMETER_PROBLEM,
+							"multiple consecutive ! not"
+							" allowed");
+				invert = TRUE;
+				optarg[0] = '\0';
+				continue;
+			}
+			printf("Bad argument `%s'\n", optarg);
+			exit_tryhelp(2);
+			break;
+
+		default:
+			break;
+			/* FIXME: This scheme doesn't allow two of the same
+				matches --RR */
+			/*if (!target
+				|| !(target->parse(c - target->option_offset,
+						argv, invert,
+						&target->tflags,
+						&fw, &target->t))) {*/
+	/*
+				for (m = arptables_matches; m; m = m->next) {
+					if (!m->used)
+						continue;
+
+					if (m->parse(c - m->option_offset,
+							argv, invert,
+							&m->mflags,
+							&fw,
+							&fw.nfcache,
+							&m->m))
+						break;
+				}
+*/
+
+				/* If you listen carefully, you can
+					actually hear this code suck. */
+
+				/* some explanations (after four different bugs
+				* in 3 different releases): If we encountere a
+				* parameter, that has not been parsed yet,
+				* it's not an option of an explicitly loaded
+				* match or a target.  However, we support
+				* implicit loading of the protocol match
+				* extension.  '-p tcp' means 'l4 proto 6' and
+				* at the same time 'load tcp protocol match on
+				* demand if we specify --dport'.
+				*
+				* To make this work, we need to make sure:
+				* - the parameter has not been parsed by
+				*   a match (m above)
+				* - a protocol has been specified
+				* - the protocol extension has not been
+				*   loaded yet, or is loaded and unused
+				*   [think of arptables-restore!]
+				* - the protocol extension can be successively
+				*   loaded
+				*/
+/*
+				if (m == NULL
+					&& protocol
+					&& (!find_proto(protocol, DONT_LOAD,
+							options&OPT_NUMERIC)
+					|| (find_proto(protocol, DONT_LOAD,
+							options&OPT_NUMERIC)
+						&& (proto_used == 0))
+					)
+					&& (m = find_proto(protocol, TRY_LOAD,
+							options&OPT_NUMERIC))) {
+					Try loading protocol */
+/*
+					size_t size;
+
+					proto_used = 1;
+
+					size = ARPT_ALIGN(sizeof(struct arpt_entry_match))
+							+ m->size;
+
+					m->m = fw_calloc(1, size);
+					m->m->u.match_size = size;
+					strcpy(m->m->u.user.name, m->name);
+					m->init(m->m, &fw.nfcache);
+
+					opts = merge_options(opts,
+						m->extra_opts, &m->option_offset);
+
+					optind--;
+					continue;
+				}
+				if (!m)
+					exit_error(PARAMETER_PROBLEM,
+							"Unknown arg `%s'",
+							argv[optind-1]);
+*/
+                       //}
+		}
+		invert = FALSE;
+	}
+/*
+	for (m = arptables_matches; m; m = m->next) {
+		if (!m->used)
+			continue;
+
+		m->final_check(m->mflags);
+	}
+*/
+
+	/*if (target)
+		target->final_check(target->tflags);*/
+
+	/* Fix me: must put inverse options checking here --MN */
+
+	if (optind < argc)
+		exit_error(PARAMETER_PROBLEM,
+				"unknown arguments found on commandline");
+	if (!command)
+		exit_error(PARAMETER_PROBLEM, "no command specified");
+	if (invert)
+		exit_error(PARAMETER_PROBLEM,
+				"nothing appropriate following !");
+
+	if (command & (CMD_REPLACE | CMD_INSERT | CMD_DELETE | CMD_APPEND)) {
+		if (!(options & OPT_D_IP))
+			dhostnetworkmask = "0.0.0.0/0";
+		if (!(options & OPT_S_IP))
+			shostnetworkmask = "0.0.0.0/0";
+	}
+
+	/*     if (shostnetworkmask)
+		parse_hostnetworkmask(shostnetworkmask, &saddrs,
+					&(fw.arp.smsk), &nsaddrs);
+
+	if (dhostnetworkmask)
+		parse_hostnetworkmask(dhostnetworkmask, &daddrs,
+					&(fw.arp.tmsk), &ndaddrs);*/
+
+	/*if ((nsaddrs > 1 || ndaddrs > 1) &&
+		(fw.arp.invflags & (ARPT_INV_SRCIP | ARPT_INV_TGTIP)))
+		exit_error(PARAMETER_PROBLEM, "! not allowed with multiple"
+				" source or destination IP addresses");*/
+
+	if (command == CMD_REPLACE && (nsaddrs != 1 || ndaddrs != 1))
+		exit_error(PARAMETER_PROBLEM, "Replacement rule does not "
+				"specify a unique address");
+
+	generic_opt_check(command, options);
+
+	/*if (chain && strlen(chain) > ARPT_FUNCTION_MAXNAMELEN)
+		exit_error(PARAMETER_PROBLEM,
+				"chain name `%s' too long (must be under %i chars)",
+				chain, ARPT_FUNCTION_MAXNAMELEN);*/
+
+	/* only allocate handle if we weren't called with a handle */
+	/*if (!*handle)
+		*handle = arptc_init(*table);*/
+
+	/*if (!*handle) {
+		// try to insmod the module if arptc_init failed
+		arptables_insmod("arp_tables", modprobe);
+		*handle = arptc_init(*table);
+	}*/
+
+/*	if (!*handle)
+		exit_error(VERSION_PROBLEM,
+				"can't initialize arptables table `%s': %s",
+				*table, arptc_strerror(errno));*/
+
+	if (command == CMD_APPEND
+		|| command == CMD_DELETE
+		|| command == CMD_INSERT
+		|| command == CMD_REPLACE) {
+		if (strcmp(chain, "PREROUTING") == 0
+			|| strcmp(chain, "INPUT") == 0) {
+			/* -o not valid with incoming packets. */
+			if (options & OPT_VIANAMEOUT)
+				exit_error(PARAMETER_PROBLEM,
+						"Can't use -%c with %s\n",
+						opt2char(OPT_VIANAMEOUT),
+						chain);
+		}
+
+		if (strcmp(chain, "POSTROUTING") == 0
+			|| strcmp(chain, "OUTPUT") == 0) {
+			/* -i not valid with outgoing packets */
+			if (options & OPT_VIANAMEIN)
+				exit_error(PARAMETER_PROBLEM,
+						"Can't use -%c with %s\n",
+						opt2char(OPT_VIANAMEIN),
+						chain);
+		}
+
+/*		if (target && arptc_is_chain(jumpto, *handle)) {
+			printf("Warning: using chain %s, not extension\n",
+				jumpto);
+
+			target = NULL;
+		}*/
+
+		/* If they didn't specify a target, or it's a chain
+		   name, use standard. */
+		/*if (!target
+			&& (strlen(jumpto) == 0
+			|| arptc_is_chain(jumpto, *handle))) {
+			size_t size;
+
+			target = find_target(ARPT_STANDARD_TARGET,
+						LOAD_MUST_SUCCEED);
+
+			size = sizeof(struct arpt_entry_target)
+				+ target->size;
+			target->t = fw_calloc(1, size);
+			target->t->u.target_size = size;
+			strcpy(target->t->u.user.name, jumpto);
+			target->init(target->t);
+		}*/
+
+		if (!target) {
+			/* it is no chain, and we can't load a plugin.
+			* We cannot know if the plugin is corrupt, non
+			* existant OR if the user just misspelled a
+			* chain. */
+			//find_target(jumpto, LOAD_MUST_SUCCEED);
+		} else {
+			//e = generate_entry(&fw, arptables_matches, target->t);
+		}
+	}
+
+	switch (command) {
+	case CMD_APPEND:
+		/*ret = append_entry(chain, e,
+					nsaddrs, saddrs, ndaddrs, daddrs,
+					options&OPT_VERBOSE,
+					handle);*/
+		break;
+	case CMD_DELETE:
+		/*ret = delete_entry(chain, e,
+					nsaddrs, saddrs, ndaddrs, daddrs,
+					options&OPT_VERBOSE,
+					handle);*/
+		break;
+	case CMD_DELETE_NUM:
+		/*ret = arptc_delete_num_entry(chain, rulenum - 1, handle);*/
+		break;
+	case CMD_REPLACE:
+		/*ret = replace_entry(chain, e, rulenum - 1,
+					saddrs, daddrs, options&OPT_VERBOSE,
+					handle);*/
+		break;
+	case CMD_INSERT:
+		/*ret = insert_entry(chain, e, rulenum - 1,
+					nsaddrs, saddrs, ndaddrs, daddrs,
+					options&OPT_VERBOSE,
+					handle);*/
+		break;
+	case CMD_LIST:
+		ret = list_entries(h, chain, *table,
+					rulenum,
+					options&OPT_VERBOSE,
+					options&OPT_NUMERIC,
+					/*options&OPT_EXPANDED*/0,
+					options&OPT_LINENUMBERS);
+		break;
+	case CMD_FLUSH:
+		/*ret = flush_entries(chain, options&OPT_VERBOSE, handle);*/
+		break;
+	case CMD_ZERO:
+		/*ret = zero_entries(chain, options&OPT_VERBOSE, handle);*/
+		break;
+	case CMD_LIST|CMD_ZERO:
+		ret = list_entries(h, chain, *table,
+					rulenum,
+					options&OPT_VERBOSE,
+					options&OPT_NUMERIC,
+					/*options&OPT_EXPANDED*/0,
+					options&OPT_LINENUMBERS);
+		/*if (ret)
+			ret = zero_entries(chain,
+						options&OPT_VERBOSE, handle);*/
+		break;
+	case CMD_NEW_CHAIN:
+		/*ret = nft_arp_chain_user_add(h, chain, *table);*/
+		break;
+	case CMD_DELETE_CHAIN:
+		/*ret = delete_chain(chain, options&OPT_VERBOSE, handle);*/
+		break;
+	case CMD_RENAME_CHAIN:
+		/*ret = arptc_rename_chain(chain, newname,      handle);*/
+		break;
+	case CMD_SET_POLICY:
+		/*ret = arptc_set_policy(chain, policy, NULL, handle);*/
+		break;
+	default:
+		/* We should never reach this... */
+		exit_tryhelp(2);
+	}
+
+/*	if (verbose > 1)
+		dump_entries(*handle);*/
+
+	return ret;
+}
diff --git a/iptables/xtables-multi.c b/iptables/xtables-multi.c
index 5732ba3..3b1f891 100644
--- a/iptables/xtables-multi.c
+++ b/iptables/xtables-multi.c
@@ -42,6 +42,7 @@ static const struct subcommand multi_subcommands[] = {
 	{"xtables-restore",     xtables_restore_main},
 	{"xtables-config",      xtables_config_main},
 	{"xtables-events",      xtables_events_main},
+	{"xtables-arptables",	xtables_arptables_main},
 #endif
 	{NULL},
 };
diff --git a/iptables/xtables-multi.h b/iptables/xtables-multi.h
index c609ea5..98c8c40 100644
--- a/iptables/xtables-multi.h
+++ b/iptables/xtables-multi.h
@@ -7,5 +7,6 @@ extern int xtables_save_main(int, char **);
 extern int xtables_restore_main(int, char **);
 extern int xtables_config_main(int, char **);
 extern int xtables_events_main(int, char **);
+extern int xtables_arptables_main(int, char **);
 
 #endif /* _XTABLES_MULTI_H */

