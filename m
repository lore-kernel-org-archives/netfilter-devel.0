Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C15C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 14:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73799619F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 14:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351630AbhI3OHE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Sep 2021 10:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351745AbhI3OHE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Sep 2021 10:07:04 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794DAC06176A
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Sep 2021 07:05:21 -0700 (PDT)
Received: from localhost ([::1]:51714 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mVwgZ-0007RC-Oi; Thu, 30 Sep 2021 16:05:19 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 12/17] nft: Merge xtables-arp-standalone.c into xtables-standalone.c
Date:   Thu, 30 Sep 2021 16:04:14 +0200
Message-Id: <20210930140419.6170-13-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210930140419.6170-1-phil@nwl.cc>
References: <20210930140419.6170-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

By declaring the relevant family_ops callbacks for arptables, the code
becomes ready to just use do_commandx() instead of a dedicated parser.

As a side-effect, this enables a bunch of new features in arptables-nft:

* Support '-C' command
* Support '-S' command
* Support rule indexes just like xtables, e.g. in '-I' or '-R' commands
* Reject chain names starting with '!'
* Support '-c N,M' counter syntax

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Avoid segfault if arptables-nft is called with '-p' option, just
  ignore it like Legacy arptables does.
---
 iptables/Makefile.am              |   2 +-
 iptables/nft-arp.c                |  95 ++++-
 iptables/xtables-arp-standalone.c |  63 ---
 iptables/xtables-arp.c            | 638 +-----------------------------
 iptables/xtables-restore.c        |   2 +-
 iptables/xtables-standalone.c     |  19 +-
 iptables/xtables.c                |  44 ++-
 7 files changed, 171 insertions(+), 692 deletions(-)
 delete mode 100644 iptables/xtables-arp-standalone.c

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index f789521042f87..0258264c4c705 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -37,7 +37,7 @@ xtables_nft_multi_SOURCES += xtables-save.c xtables-restore.c \
 				xtables-standalone.c xtables.c nft.c \
 				nft-shared.c nft-ipv4.c nft-ipv6.c nft-arp.c \
 				xtables-monitor.c nft-cache.c \
-				xtables-arp-standalone.c xtables-arp.c \
+				xtables-arp.c \
 				nft-bridge.c nft-cmd.c nft-chain.c \
 				xtables-eb-standalone.c xtables-eb.c \
 				xtables-eb-translate.c \
diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index b37ffbb592023..32eb91add4f1e 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -617,7 +617,8 @@ static void nft_arp_post_parse(int command,
 	cs->arp.counters.pcnt = args->pcnt_cnt;
 	cs->arp.counters.bcnt = args->bcnt_cnt;
 
-	if (command & (CMD_REPLACE | CMD_INSERT | CMD_DELETE | CMD_APPEND)) {
+	if (command & (CMD_REPLACE | CMD_INSERT |
+			CMD_DELETE | CMD_APPEND | CMD_CHECK)) {
 		if (!(cs->options & OPT_DESTINATION))
 			args->dhostnetworkmask = "0.0.0.0/0";
 		if (!(cs->options & OPT_SOURCE))
@@ -702,6 +703,94 @@ static void nft_arp_init_cs(struct iptables_command_state *cs)
 	cs->arp.arp.arhrd_mask = 65535;
 }
 
+static int
+nft_arp_add_entry(struct nft_handle *h,
+		  const char *chain, const char *table,
+		  struct iptables_command_state *cs,
+		  struct xtables_args *args, bool verbose,
+		  bool append, int rulenum)
+{
+	unsigned int i, j;
+	int ret = 1;
+
+	for (i = 0; i < args->s.naddrs; i++) {
+		cs->arp.arp.src.s_addr = args->s.addr.v4[i].s_addr;
+		cs->arp.arp.smsk.s_addr = args->s.mask.v4[i].s_addr;
+		for (j = 0; j < args->d.naddrs; j++) {
+			cs->arp.arp.tgt.s_addr = args->d.addr.v4[j].s_addr;
+			cs->arp.arp.tmsk.s_addr = args->d.mask.v4[j].s_addr;
+			if (append) {
+				ret = nft_cmd_rule_append(h, chain, table, cs, NULL,
+						          verbose);
+			} else {
+				ret = nft_cmd_rule_insert(h, chain, table, cs,
+						          rulenum, verbose);
+			}
+		}
+	}
+
+	return ret;
+}
+
+static int
+nft_arp_delete_entry(struct nft_handle *h,
+		     const char *chain, const char *table,
+		     struct iptables_command_state *cs,
+		     struct xtables_args *args, bool verbose)
+{
+	unsigned int i, j;
+	int ret = 1;
+
+	for (i = 0; i < args->s.naddrs; i++) {
+		cs->arp.arp.src.s_addr = args->s.addr.v4[i].s_addr;
+		cs->arp.arp.smsk.s_addr = args->s.mask.v4[i].s_addr;
+		for (j = 0; j < args->d.naddrs; j++) {
+			cs->arp.arp.tgt.s_addr = args->d.addr.v4[j].s_addr;
+			cs->arp.arp.tmsk.s_addr = args->d.mask.v4[j].s_addr;
+			ret = nft_cmd_rule_delete(h, chain, table, cs, verbose);
+		}
+	}
+
+	return ret;
+}
+
+static int
+nft_arp_check_entry(struct nft_handle *h,
+		    const char *chain, const char *table,
+		    struct iptables_command_state *cs,
+		    struct xtables_args *args, bool verbose)
+{
+	unsigned int i, j;
+	int ret = 1;
+
+	for (i = 0; i < args->s.naddrs; i++) {
+		cs->arp.arp.src.s_addr = args->s.addr.v4[i].s_addr;
+		cs->arp.arp.smsk.s_addr = args->s.mask.v4[i].s_addr;
+		for (j = 0; j < args->d.naddrs; j++) {
+			cs->arp.arp.tgt.s_addr = args->d.addr.v4[j].s_addr;
+			cs->arp.arp.tmsk.s_addr = args->d.mask.v4[j].s_addr;
+			ret = nft_cmd_rule_check(h, chain, table, cs, verbose);
+		}
+	}
+
+	return ret;
+}
+
+static int
+nft_arp_replace_entry(struct nft_handle *h,
+		      const char *chain, const char *table,
+		      struct iptables_command_state *cs,
+		      struct xtables_args *args, bool verbose,
+		      int rulenum)
+{
+	cs->arp.arp.src.s_addr = args->s.addr.v4->s_addr;
+	cs->arp.arp.tgt.s_addr = args->d.addr.v4->s_addr;
+	cs->arp.arp.smsk.s_addr = args->s.mask.v4->s_addr;
+	cs->arp.arp.tmsk.s_addr = args->d.mask.v4->s_addr;
+
+	return nft_cmd_rule_replace(h, chain, table, cs, rulenum, verbose);
+}
+
 struct nft_family_ops nft_family_ops_arp = {
 	.add			= nft_arp_add,
 	.is_same		= nft_arp_is_same,
@@ -718,4 +807,8 @@ struct nft_family_ops nft_family_ops_arp = {
 	.init_cs		= nft_arp_init_cs,
 	.clear_cs		= nft_clear_iptables_command_state,
 	.parse_target		= nft_ipv46_parse_target,
+	.add_entry		= nft_arp_add_entry,
+	.delete_entry		= nft_arp_delete_entry,
+	.check_entry		= nft_arp_check_entry,
+	.replace_entry		= nft_arp_replace_entry,
 };
diff --git a/iptables/xtables-arp-standalone.c b/iptables/xtables-arp-standalone.c
deleted file mode 100644
index 82db3f3801c10..0000000000000
--- a/iptables/xtables-arp-standalone.c
+++ /dev/null
@@ -1,63 +0,0 @@
-/*
- * Author: Paul.Russell@rustcorp.com.au and mneuling@radlogic.com.au
- *
- * Based on the ipchains code by Paul Russell and Michael Neuling
- *
- * (C) 2000-2002 by the netfilter coreteam <coreteam@netfilter.org>:
- * 		    Paul 'Rusty' Russell <rusty@rustcorp.com.au>
- * 		    Marc Boucher <marc+nf@mbsi.ca>
- * 		    James Morris <jmorris@intercode.com.au>
- * 		    Harald Welte <laforge@gnumonks.org>
- * 		    Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
- *
- *	arptables -- IP firewall administration for kernels with
- *	firewall table (aimed for the 2.3 kernels)
- *
- *	See the accompanying manual page arptables(8) for information
- *	about proper usage of this program.
- *
- *	This program is free software; you can redistribute it and/or modify
- *	it under the terms of the GNU General Public License as published by
- *	the Free Software Foundation; either version 2 of the License, or
- *	(at your option) any later version.
- *
- *	This program is distributed in the hope that it will be useful,
- *	but WITHOUT ANY WARRANTY; without even the implied warranty of
- *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *	GNU General Public License for more details.
- *
- *	You should have received a copy of the GNU General Public License
- *	along with this program; if not, write to the Free Software
- *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <errno.h>
-#include <string.h>
-#include <xtables.h>
-#include "nft.h"
-#include <linux/netfilter_arp/arp_tables.h>
-
-#include "xtables-multi.h"
-
-int xtables_arp_main(int argc, char *argv[])
-{
-	int ret;
-	char *table = "filter";
-	struct nft_handle h;
-
-	nft_init_arp(&h, "arptables");
-
-	ret = do_commandarp(&h, argc, argv, &table, false);
-	if (ret)
-		ret = nft_commit(&h);
-
-	nft_fini(&h);
-	xtables_fini();
-
-	if (!ret)
-		fprintf(stderr, "arptables: %s\n", nft_strerror(errno));
-
-	exit(!ret);
-}
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index de7c381788a37..cca19438a877e 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -30,35 +30,23 @@
 #include "config.h"
 #include <getopt.h>
 #include <string.h>
-#include <netdb.h>
-#include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <inttypes.h>
-#include <dlfcn.h>
-#include <ctype.h>
-#include <stdarg.h>
-#include <limits.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <sys/wait.h>
-#include <net/if.h>
-#include <netinet/ether.h>
-#include <iptables.h>
 #include <xtables.h>
 
 #include "xshared.h"
 
 #include "nft.h"
 #include "nft-arp.h"
-#include <linux/netfilter_arp/arp_tables.h>
 
 static struct option original_opts[] = {
 	{ "append", 1, 0, 'A' },
 	{ "delete", 1, 0,  'D' },
+	{ "check", 1, 0,  'C'},
 	{ "insert", 1, 0,  'I' },
 	{ "replace", 1, 0,  'R' },
 	{ "list", 2, 0,  'L' },
+	{ "list-rules", 2, 0,  'S'},
 	{ "flush", 2, 0,  'F' },
 	{ "zero", 2, 0,  'Z' },
 	{ "new-chain", 1, 0,  'N' },
@@ -101,22 +89,13 @@ static void printhelp(const struct xtables_rule_match *m);
 struct xtables_globals arptables_globals = {
 	.option_offset		= 0,
 	.program_version	= PACKAGE_VERSION,
-	.optstring		= OPTSTRING_COMMON "R:S::" "h::l:nv" /* "m:" */,
+	.optstring		= OPTSTRING_COMMON "C:R:S::" "h::l:nv" /* "m:" */,
 	.orig_opts		= original_opts,
 	.exit_err		= xtables_exit_error,
 	.compat_rev		= nft_compatible_revision,
 	.print_help		= printhelp,
 };
 
-static void
-exit_tryhelp(int status)
-{
-	fprintf(stderr, "Try `%s -h' or '%s --help' for more information.\n",
-		arptables_globals.program_name,
-		arptables_globals.program_version);
-	exit(status);
-}
-
 static void
 printhelp(const struct xtables_rule_match *m)
 {
@@ -124,10 +103,12 @@ printhelp(const struct xtables_rule_match *m)
 	int i;
 
 	printf("%s v%s\n\n"
-"Usage: %s -[AD] chain rule-specification [options]\n"
-"       %s -[RI] chain rulenum rule-specification [options]\n"
+"Usage: %s -[ACD] chain rule-specification [options]\n"
+"       %s -I chain [rulenum] rule-specification [options]\n"
+"       %s -R chain rulenum rule-specification [options]\n"
 "       %s -D chain rulenum [options]\n"
-"       %s -[LFZ] [chain] [options]\n"
+"       %s -[LS] [chain [rulenum]] [options]\n"
+"       %s -[FZ] [chain] [options]\n"
 "       %s -[NX] chain\n"
 "       %s -E old-chain-name new-chain-name\n"
 "       %s -P chain target [options]\n"
@@ -141,11 +122,14 @@ printhelp(const struct xtables_rule_match *m)
 	       arptables_globals.program_name,
 	       arptables_globals.program_name,
 	       arptables_globals.program_name,
+	       arptables_globals.program_name,
+	       arptables_globals.program_name,
 	       arptables_globals.program_name);
 	printf(
 "Commands:\n"
 "Either long or short options are allowed.\n"
 "  --append  -A chain		Append to chain\n"
+"  --check   -C chain		Check for the existence of a rule\n"
 "  --delete  -D chain		Delete matching rule from chain\n"
 "  --delete  -D chain rulenum\n"
 "				Delete rule rulenum (1 = first) from chain\n"
@@ -153,9 +137,13 @@ printhelp(const struct xtables_rule_match *m)
 "				Insert in chain as rulenum (default 1=first)\n"
 "  --replace -R chain rulenum\n"
 "				Replace rule rulenum (1 = first) in chain\n"
-"  --list    -L [chain]		List the rules in a chain or all chains\n"
+"  --list    -L [chain [rulenum]]\n"
+"				List the rules in a chain or all chains\n"
+"  --list-rules -S [chain [rulenum]]\n"
+"				Print the rules in a chain or all chains\n"
 "  --flush   -F [chain]		Delete all rules in  chain or all chains\n"
-"  --zero    -Z [chain]		Zero counters in chain or all chains\n"
+"  --zero    -Z [chain [rulenum]]\n"
+"				Zero counters in chain or all chains\n"
 "  --new     -N chain		Create a new user-defined chain\n"
 "  --delete-chain\n"
 "            -X [chain]		Delete a user-defined chain\n"
@@ -210,134 +198,6 @@ printhelp(const struct xtables_rule_match *m)
 	}
 }
 
-static int
-check_inverse(const char option[], int *invert, int *optidx, int argc)
-{
-	if (option && strcmp(option, "!") == 0) {
-		if (*invert)
-			xtables_error(PARAMETER_PROBLEM,
-				      "Multiple `!' flags not allowed");
-		*invert = true;
-		if (optidx) {
-			*optidx = *optidx+1;
-			if (argc && *optidx > argc)
-				xtables_error(PARAMETER_PROBLEM,
-					      "no argument following `!'");
-		}
-
-		return true;
-	}
-	return false;
-}
-
-static int
-list_entries(struct nft_handle *h, const char *chain, const char *table,
-	     int rulenum, int verbose, int numeric, int expanded,
-	     int linenumbers)
-{
-	unsigned int format;
-
-	format = FMT_OPTIONS;
-	if (!verbose)
-		format |= FMT_NOCOUNTS;
-	else
-		format |= FMT_VIA;
-
-	if (numeric)
-		format |= FMT_NUMERIC;
-
-	if (!expanded)
-		format |= FMT_KILOMEGAGIGA;
-
-	if (linenumbers)
-		format |= FMT_LINENUMBERS;
-
-	return nft_cmd_rule_list(h, chain, table, rulenum, format);
-}
-
-static int
-append_entry(struct nft_handle *h,
-	     const char *chain,
-	     const char *table,
-	     struct iptables_command_state *cs,
-	     int rulenum,
-	     unsigned int nsaddrs,
-	     const struct in_addr saddrs[],
-	     const struct in_addr smasks[],
-	     unsigned int ndaddrs,
-	     const struct in_addr daddrs[],
-	     const struct in_addr dmasks[],
-	     bool verbose, bool append)
-{
-	unsigned int i, j;
-	int ret = 1;
-
-	for (i = 0; i < nsaddrs; i++) {
-		cs->arp.arp.src.s_addr = saddrs[i].s_addr;
-		cs->arp.arp.smsk.s_addr = smasks[i].s_addr;
-		for (j = 0; j < ndaddrs; j++) {
-			cs->arp.arp.tgt.s_addr = daddrs[j].s_addr;
-			cs->arp.arp.tmsk.s_addr = dmasks[j].s_addr;
-			if (append) {
-				ret = nft_cmd_rule_append(h, chain, table, cs, NULL,
-						      verbose);
-			} else {
-				ret = nft_cmd_rule_insert(h, chain, table, cs,
-						      rulenum, verbose);
-			}
-		}
-	}
-
-	return ret;
-}
-
-static int
-replace_entry(const char *chain,
-	      const char *table,
-	      struct iptables_command_state *cs,
-	      unsigned int rulenum,
-	      const struct in_addr *saddr,
-	      const struct in_addr *smask,
-	      const struct in_addr *daddr,
-	      const struct in_addr *dmask,
-	      bool verbose, struct nft_handle *h)
-{
-	cs->arp.arp.src.s_addr = saddr->s_addr;
-	cs->arp.arp.tgt.s_addr = daddr->s_addr;
-	cs->arp.arp.smsk.s_addr = smask->s_addr;
-	cs->arp.arp.tmsk.s_addr = dmask->s_addr;
-
-	return nft_cmd_rule_replace(h, chain, table, cs, rulenum, verbose);
-}
-
-static int
-delete_entry(const char *chain,
-	     const char *table,
-	     struct iptables_command_state *cs,
-	     unsigned int nsaddrs,
-	     const struct in_addr saddrs[],
-	     const struct in_addr smasks[],
-	     unsigned int ndaddrs,
-	     const struct in_addr daddrs[],
-	     const struct in_addr dmasks[],
-	     bool verbose, struct nft_handle *h)
-{
-	unsigned int i, j;
-	int ret = 1;
-
-	for (i = 0; i < nsaddrs; i++) {
-		cs->arp.arp.src.s_addr = saddrs[i].s_addr;
-		cs->arp.arp.smsk.s_addr = smasks[i].s_addr;
-		for (j = 0; j < ndaddrs; j++) {
-			cs->arp.arp.tgt.s_addr = daddrs[j].s_addr;
-			cs->arp.arp.tmsk.s_addr = dmasks[j].s_addr;
-			ret = nft_cmd_rule_delete(h, chain, table, cs, verbose);
-		}
-	}
-
-	return ret;
-}
-
 int nft_init_arp(struct nft_handle *h, const char *pname)
 {
 	arptables_globals.program_name = pname;
@@ -358,467 +218,3 @@ int nft_init_arp(struct nft_handle *h, const char *pname)
 
 	return 0;
 }
-
-int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
-		  bool restore)
-{
-	struct iptables_command_state cs = {
-		.jumpto = "",
-		.arp.arp = {
-			.arhln = 6,
-			.arhln_mask = 255,
-			.arhrd = htons(ARPHRD_ETHER),
-			.arhrd_mask = 65535,
-		},
-	};
-	struct nft_xt_cmd_parse p = {
-		.table = *table,
-	};
-	struct xtables_args args = {
-		.family = h->family,
-	};
-	int invert = 0;
-	int ret = 1;
-	struct xtables_target *t;
-
-	/* re-set optind to 0 in case do_command gets called
-	 * a second time */
-	optind = 0;
-
-	for (t = xtables_targets; t; t = t->next) {
-		t->tflags = 0;
-		t->used = 0;
-	}
-
-	/* Suppress error messages: we may add new options if we
-	    demand-load a protocol. */
-	opterr = 0;
-
-	opts = xt_params->orig_opts;
-	while ((cs.c = getopt_long(argc, argv, xt_params->optstring,
-					   opts, NULL)) != -1) {
-		switch (cs.c) {
-			/*
-			 * Command selection
-			 */
-		case 'A':
-			add_command(&p.command, CMD_APPEND, CMD_NONE,
-				    invert);
-			p.chain = optarg;
-			break;
-
-		case 'D':
-			add_command(&p.command, CMD_DELETE, CMD_NONE,
-				    invert);
-			p.chain = optarg;
-			if (xs_has_arg(argc, argv)) {
-				p.rulenum = parse_rulenumber(argv[optind++]);
-				p.command = CMD_DELETE_NUM;
-			}
-			break;
-
-		case 'R':
-			add_command(&p.command, CMD_REPLACE, CMD_NONE,
-				    invert);
-			p.chain = optarg;
-			if (xs_has_arg(argc, argv))
-				p.rulenum = parse_rulenumber(argv[optind++]);
-			else
-				xtables_error(PARAMETER_PROBLEM,
-					      "-%c requires a rule number",
-					      cmd2char(CMD_REPLACE));
-			break;
-
-		case 'I':
-			add_command(&p.command, CMD_INSERT, CMD_NONE,
-				    invert);
-			p.chain = optarg;
-			if (xs_has_arg(argc, argv))
-				p.rulenum = parse_rulenumber(argv[optind++]);
-			else p.rulenum = 1;
-			break;
-
-		case 'L':
-			add_command(&p.command, CMD_LIST, CMD_ZERO,
-				    invert);
-			if (optarg) p.chain = optarg;
-			else if (xs_has_arg(argc, argv))
-				p.chain = argv[optind++];
-			break;
-
-		case 'F':
-			add_command(&p.command, CMD_FLUSH, CMD_NONE,
-				    invert);
-			if (optarg) p.chain = optarg;
-			else if (xs_has_arg(argc, argv))
-				p.chain = argv[optind++];
-			break;
-
-		case 'Z':
-			add_command(&p.command, CMD_ZERO, CMD_LIST,
-				    invert);
-			if (optarg) p.chain = optarg;
-			else if (xs_has_arg(argc, argv))
-				p.chain = argv[optind++];
-			break;
-
-		case 'N':
-			if (optarg && *optarg == '-')
-				xtables_error(PARAMETER_PROBLEM,
-					      "chain name not allowed to start "
-					      "with `-'\n");
-			if (xtables_find_target(optarg, XTF_TRY_LOAD))
-				xtables_error(PARAMETER_PROBLEM,
-						"chain name may not clash "
-						"with target name\n");
-			add_command(&p.command, CMD_NEW_CHAIN, CMD_NONE,
-				    invert);
-			p.chain = optarg;
-			break;
-
-		case 'X':
-			add_command(&p.command, CMD_DELETE_CHAIN, CMD_NONE,
-				    invert);
-			if (optarg) p.chain = optarg;
-			else if (xs_has_arg(argc, argv))
-				p.chain = argv[optind++];
-			break;
-
-		case 'E':
-			add_command(&p.command, CMD_RENAME_CHAIN, CMD_NONE,
-				    invert);
-			p.chain = optarg;
-			if (xs_has_arg(argc, argv))
-				p.newname = argv[optind++];
-			else
-				xtables_error(PARAMETER_PROBLEM,
-					      "-%c requires old-chain-name and "
-					      "new-chain-name",
-					      cmd2char(CMD_RENAME_CHAIN));
-			break;
-
-		case 'P':
-			add_command(&p.command, CMD_SET_POLICY, CMD_NONE,
-				    invert);
-			p.chain = optarg;
-			if (xs_has_arg(argc, argv))
-				p.policy = argv[optind++];
-			else
-				xtables_error(PARAMETER_PROBLEM,
-					      "-%c requires a chain and a policy",
-					      cmd2char(CMD_SET_POLICY));
-			break;
-
-		case 'h':
-			if (!optarg)
-				optarg = argv[optind];
-
-			xt_params->print_help(NULL);
-			p.command = CMD_NONE;
-			break;
-		case 's':
-			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&cs.options, OPT_SOURCE, &args.invflags,
-				   invert);
-			args.shostnetworkmask = argv[optind-1];
-			break;
-
-		case 'd':
-			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&cs.options, OPT_DESTINATION, &args.invflags,
-				   invert);
-			args.dhostnetworkmask = argv[optind-1];
-			break;
-
-		case 2:/* src-mac */
-			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&cs.options, OPT_S_MAC, &args.invflags,
-				   invert);
-			args.src_mac = argv[optind - 1];
-			break;
-
-		case 3:/* dst-mac */
-			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&cs.options, OPT_D_MAC, &args.invflags,
-				   invert);
-			args.dst_mac = argv[optind - 1];
-			break;
-
-		case 'l':/* hardware length */
-			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&cs.options, OPT_H_LENGTH, &args.invflags,
-				   invert);
-			args.arp_hlen = argv[optind - 1];
-			break;
-
-		case 8: /* was never supported, not even in arptables-legacy */
-			xtables_error(PARAMETER_PROBLEM, "not supported");
-		case 4:/* opcode */
-			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&cs.options, OPT_OPCODE, &args.invflags,
-				   invert);
-			args.arp_opcode = argv[optind - 1];
-			break;
-
-		case 5:/* h-type */
-			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&cs.options, OPT_H_TYPE, &args.invflags,
-				   invert);
-			args.arp_htype = argv[optind - 1];
-			break;
-
-		case 6:/* proto-type */
-			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&cs.options, OPT_P_TYPE, &args.invflags,
-				   invert);
-			args.arp_ptype = argv[optind - 1];
-			break;
-
-		case 'j':
-			set_option(&cs.options, OPT_JUMP, &args.invflags,
-				   invert);
-			command_jump(&cs, optarg);
-			break;
-
-		case 'i':
-			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&cs.options, OPT_VIANAMEIN, &args.invflags,
-				   invert);
-			xtables_parse_interface(argv[optind-1],
-						args.iniface,
-						args.iniface_mask);
-			break;
-
-		case 'o':
-			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&cs.options, OPT_VIANAMEOUT, &args.invflags,
-				   invert);
-			xtables_parse_interface(argv[optind-1],
-						args.outiface,
-						args.outiface_mask);
-			break;
-
-		case 'v':
-			if (!p.verbose)
-				set_option(&cs.options, OPT_VERBOSE,
-					   &args.invflags, invert);
-			p.verbose++;
-			break;
-
-		case 'm': /* ignored by arptables-legacy */
-			break;
-		case 'n':
-			set_option(&cs.options, OPT_NUMERIC, &args.invflags,
-				   invert);
-			break;
-
-		case 't':
-			if (invert)
-				xtables_error(PARAMETER_PROBLEM,
-					      "unexpected ! flag before --table");
-			/* ignore this option.
-			 * arptables-legacy parses it, but libarptc doesn't use it.
-			 * arptables only has a 'filter' table anyway.
-			 */
-			break;
-
-		case 'V':
-			if (invert)
-				printf("Not %s ;-)\n", arptables_globals.program_version);
-			else
-				printf("%s v%s (nf_tables)\n",
-				       arptables_globals.program_name,
-				       arptables_globals.program_version);
-			exit(0);
-
-		case '0':
-			set_option(&cs.options, OPT_LINENUMBERS, &args.invflags,
-				   invert);
-			break;
-
-		case 'M':
-			//modprobe = optarg;
-			break;
-
-		case 'c':
-
-			set_option(&cs.options, OPT_COUNTERS, &args.invflags,
-				   invert);
-			args.pcnt = optarg;
-			if (xs_has_arg(argc, argv))
-				args.bcnt = argv[optind++];
-			else
-				xtables_error(PARAMETER_PROBLEM,
-					      "-%c requires packet and byte counter",
-					      opt2char(OPT_COUNTERS));
-
-			if (sscanf(args.pcnt, "%llu", &cs.arp.counters.pcnt) != 1)
-			xtables_error(PARAMETER_PROBLEM,
-				"-%c packet counter not numeric",
-				opt2char(OPT_COUNTERS));
-
-			if (sscanf(args.bcnt, "%llu", &cs.arp.counters.bcnt) != 1)
-				xtables_error(PARAMETER_PROBLEM,
-					      "-%c byte counter not numeric",
-					      opt2char(OPT_COUNTERS));
-
-			break;
-
-
-		case 1: /* non option */
-			if (optarg[0] == '!' && optarg[1] == '\0') {
-				if (invert)
-					xtables_error(PARAMETER_PROBLEM,
-						      "multiple consecutive ! not"
-						      " allowed");
-				invert = true;
-				optarg[0] = '\0';
-				continue;
-			}
-			printf("Bad argument `%s'\n", optarg);
-			exit_tryhelp(2);
-
-		default:
-			if (cs.target) {
-				xtables_option_tpcall(cs.c, argv,
-						      invert, cs.target, &cs.arp);
-			}
-			break;
-		}
-		invert = false;
-	}
-
-	if (cs.target)
-		xtables_option_tfcall(cs.target);
-
-	if (optind < argc)
-		xtables_error(PARAMETER_PROBLEM,
-			      "unknown arguments found on commandline");
-	if (invert)
-		xtables_error(PARAMETER_PROBLEM,
-			      "nothing appropriate following !");
-
-	h->ops->post_parse(p.command, &cs, &args);
-
-	if (p.command == CMD_REPLACE && (args.s.naddrs != 1 || args.d.naddrs != 1))
-		xtables_error(PARAMETER_PROBLEM, "Replacement rule does not "
-						 "specify a unique address");
-
-	if (p.chain && strlen(p.chain) > ARPT_FUNCTION_MAXNAMELEN)
-		xtables_error(PARAMETER_PROBLEM,
-				"chain name `%s' too long (must be under %i chars)",
-				p.chain, ARPT_FUNCTION_MAXNAMELEN);
-
-	if (p.command == CMD_APPEND
-	    || p.command == CMD_DELETE
-	    || p.command == CMD_INSERT
-	    || p.command == CMD_REPLACE) {
-		if (strcmp(p.chain, "PREROUTING") == 0
-		    || strcmp(p.chain, "INPUT") == 0) {
-			/* -o not valid with incoming packets. */
-			if (cs.options & OPT_VIANAMEOUT)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Can't use -%c with %s\n",
-					      opt2char(OPT_VIANAMEOUT),
-					      p.chain);
-		}
-
-		if (strcmp(p.chain, "POSTROUTING") == 0
-		    || strcmp(p.chain, "OUTPUT") == 0) {
-			/* -i not valid with outgoing packets */
-			if (cs.options & OPT_VIANAMEIN)
-				xtables_error(PARAMETER_PROBLEM,
-						"Can't use -%c with %s\n",
-						opt2char(OPT_VIANAMEIN),
-						p.chain);
-		}
-	}
-
-	switch (p.command) {
-	case CMD_APPEND:
-		ret = append_entry(h, p.chain, p.table, &cs, 0,
-				   args.s.naddrs, args.s.addr.v4, args.s.mask.v4,
-				   args.d.naddrs, args.d.addr.v4, args.d.mask.v4,
-				   cs.options&OPT_VERBOSE, true);
-		break;
-	case CMD_DELETE:
-		ret = delete_entry(p.chain, p.table, &cs,
-				   args.s.naddrs, args.s.addr.v4, args.s.mask.v4,
-				   args.d.naddrs, args.d.addr.v4, args.d.mask.v4,
-				   cs.options&OPT_VERBOSE, h);
-		break;
-	case CMD_DELETE_NUM:
-		ret = nft_cmd_rule_delete_num(h, p.chain, p.table, p.rulenum - 1, p.verbose);
-		break;
-	case CMD_REPLACE:
-		ret = replace_entry(p.chain, p.table, &cs, p.rulenum - 1,
-				    args.s.addr.v4, args.s.mask.v4, args.d.addr.v4, args.d.mask.v4,
-				    cs.options&OPT_VERBOSE, h);
-		break;
-	case CMD_INSERT:
-		ret = append_entry(h, p.chain, p.table, &cs, p.rulenum - 1,
-				   args.s.naddrs, args.s.addr.v4, args.s.mask.v4,
-				   args.d.naddrs, args.d.addr.v4, args.d.mask.v4,
-				   cs.options&OPT_VERBOSE, false);
-		break;
-	case CMD_LIST:
-		ret = list_entries(h, p.chain, p.table,
-				   p.rulenum,
-				   cs.options&OPT_VERBOSE,
-				   cs.options&OPT_NUMERIC,
-				   /*cs.options&OPT_EXPANDED*/0,
-				   cs.options&OPT_LINENUMBERS);
-		break;
-	case CMD_FLUSH:
-		ret = nft_cmd_rule_flush(h, p.chain, p.table, cs.options & OPT_VERBOSE);
-		break;
-	case CMD_ZERO:
-		ret = nft_cmd_chain_zero_counters(h, p.chain, p.table,
-					      cs.options & OPT_VERBOSE);
-		break;
-	case CMD_LIST|CMD_ZERO:
-		ret = list_entries(h, p.chain, p.table, p.rulenum,
-				   cs.options&OPT_VERBOSE,
-				   cs.options&OPT_NUMERIC,
-				   /*cs.options&OPT_EXPANDED*/0,
-				   cs.options&OPT_LINENUMBERS);
-		if (ret)
-			ret = nft_cmd_chain_zero_counters(h, p.chain, p.table,
-						      cs.options & OPT_VERBOSE);
-		break;
-	case CMD_NEW_CHAIN:
-		ret = nft_cmd_chain_user_add(h, p.chain, p.table);
-		break;
-	case CMD_DELETE_CHAIN:
-		ret = nft_cmd_chain_del(h, p.chain, p.table,
-					cs.options & OPT_VERBOSE);
-		break;
-	case CMD_RENAME_CHAIN:
-		ret = nft_cmd_chain_user_rename(h, p.chain, p.table, p.newname);
-		break;
-	case CMD_SET_POLICY:
-		ret = nft_cmd_chain_set(h, p.table, p.chain, p.policy, NULL);
-		if (ret < 0)
-			xtables_error(PARAMETER_PROBLEM, "Wrong policy `%s'\n",
-				      p.policy);
-		break;
-	case CMD_NONE:
-		break;
-	default:
-		/* We should never reach this... */
-		exit_tryhelp(2);
-	}
-
-	free(args.s.addr.v4);
-	free(args.s.mask.v4);
-	free(args.d.addr.v4);
-	free(args.d.mask.v4);
-
-	nft_clear_iptables_command_state(&cs);
-	xtables_free_opts(1);
-
-/*	if (p.verbose > 1)
-		dump_entries(*handle);*/
-
-	return ret;
-}
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 86dcede395e07..aa8b397f29ac7 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -451,7 +451,7 @@ int xtables_eb_restore_main(int argc, char *argv[])
 static const struct nft_xt_restore_cb arp_restore_cb = {
 	.commit		= nft_commit,
 	.table_flush	= nft_cmd_table_flush,
-	.do_command	= do_commandarp,
+	.do_command	= do_commandx,
 	.chain_set	= nft_cmd_chain_set,
 	.chain_restore  = nft_cmd_chain_restore,
 };
diff --git a/iptables/xtables-standalone.c b/iptables/xtables-standalone.c
index 19d663b02348c..5482a85689d79 100644
--- a/iptables/xtables-standalone.c
+++ b/iptables/xtables-standalone.c
@@ -68,9 +68,17 @@ xtables_main(int family, const char *progname, int argc, char *argv[])
 	}
 	xt_params->program_name = progname;
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
-	init_extensions();
-	init_extensions4();
-	init_extensions6();
+	switch (family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+		init_extensions();
+		init_extensions4();
+		init_extensions6();
+		break;
+	case NFPROTO_ARP:
+		init_extensionsa();
+		break;
+	}
 #endif
 
 	if (nft_init(&h, family) < 0) {
@@ -107,3 +115,8 @@ int xtables_ip6_main(int argc, char *argv[])
 {
 	return xtables_main(NFPROTO_IPV6, "ip6tables", argc, argv);
 }
+
+int xtables_arp_main(int argc, char *argv[])
+{
+	return xtables_main(NFPROTO_ARP, "arptables", argc, argv);
+}
diff --git a/iptables/xtables.c b/iptables/xtables.c
index dc67affc19dbe..23d7d29169ca0 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -36,11 +36,13 @@
 #include <stdarg.h>
 #include <limits.h>
 #include <unistd.h>
+#include <netinet/ether.h>
 #include <iptables.h>
 #include <xtables.h>
 #include <fcntl.h>
 #include "xshared.h"
 #include "nft-shared.h"
+#include "nft-arp.h"
 #include "nft.h"
 
 static struct option original_opts[] = {
@@ -461,7 +463,8 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 					   "rule would never match protocol");
 
 			/* This needs to happen here to parse extensions */
-			h->ops->proto_parse(cs, args);
+			if (h->ops->proto_parse)
+				h->ops->proto_parse(cs, args);
 			break;
 
 		case 's':
@@ -485,13 +488,50 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			break;
 #endif
 
+		case 2:/* src-mac */
+			set_option(&cs->options, OPT_S_MAC, &args->invflags,
+				   invert);
+			args->src_mac = optarg;
+			break;
+
+		case 3:/* dst-mac */
+			set_option(&cs->options, OPT_D_MAC, &args->invflags,
+				   invert);
+			args->dst_mac = optarg;
+			break;
+
+		case 'l':/* hardware length */
+			set_option(&cs->options, OPT_H_LENGTH, &args->invflags,
+				   invert);
+			args->arp_hlen = optarg;
+			break;
+
+		case 8: /* was never supported, not even in arptables-legacy */
+			xtables_error(PARAMETER_PROBLEM, "not supported");
+		case 4:/* opcode */
+			set_option(&cs->options, OPT_OPCODE, &args->invflags,
+				   invert);
+			args->arp_opcode = optarg;
+			break;
+
+		case 5:/* h-type */
+			set_option(&cs->options, OPT_H_TYPE, &args->invflags,
+				   invert);
+			args->arp_htype = optarg;
+			break;
+
+		case 6:/* proto-type */
+			set_option(&cs->options, OPT_P_TYPE, &args->invflags,
+				   invert);
+			args->arp_ptype = optarg;
+			break;
+
 		case 'j':
 			set_option(&cs->options, OPT_JUMP, &args->invflags,
 				   invert);
 			command_jump(cs, optarg);
 			break;
 
-
 		case 'i':
 			if (*optarg == '\0')
 				xtables_error(PARAMETER_PROBLEM,
-- 
2.33.0

