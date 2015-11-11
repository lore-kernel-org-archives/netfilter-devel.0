From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables] iptables-compat: Keep xtables-config and xtables-events out from tree
Date: Wed, 11 Nov 2015 16:48:23 +0100
Message-ID: <1447256903-20128-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56769 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbbKKPse (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Nov 2015 10:48:34 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E337213A372
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2015 16:48:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D31B95DC
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2015 16:48:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0FBA55CC
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2015 16:48:28 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These binaries are part of the compat layer, however they provide more
features than actually available in the existing native iptables
binaries. So let's keep them out from the tree before the 1.6.0 release
as we only want to provide compatibility utils at this stage.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/Makefile.am            |   3 +-
 iptables/xtables-compat-multi.c |   2 -
 iptables/xtables-config.c       |  46 ---------
 iptables/xtables-events.c       | 213 ----------------------------------------
 4 files changed, 1 insertion(+), 263 deletions(-)
 delete mode 100644 iptables/xtables-config.c
 delete mode 100644 iptables/xtables-events.c

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index c66e533..132fe5f 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -38,7 +38,6 @@ xtables_compat_multi_SOURCES += xtables-config-parser.y xtables-config-syntax.l
 xtables_compat_multi_SOURCES += xtables-save.c xtables-restore.c \
 				xtables-standalone.c xtables.c nft.c \
 				nft-shared.c nft-ipv4.c nft-ipv6.c nft-arp.c \
-				xtables-config.c xtables-events.c \
 				xtables-arp-standalone.c xtables-arp.c \
 				getethertype.c nft-bridge.c \
 				xtables-eb-standalone.c xtables-eb.c
@@ -69,7 +68,7 @@ endif
 if ENABLE_NFTABLES
 x_sbin_links  = iptables-compat iptables-compat-restore iptables-compat-save \
 		ip6tables-compat ip6tables-compat-restore ip6tables-compat-save \
-		arptables-compat ebtables-compat xtables-config xtables-events
+		arptables-compat ebtables-compat
 endif
 
 iptables-extensions.8: iptables-extensions.8.tmpl ../extensions/matches.man ../extensions/targets.man
diff --git a/iptables/xtables-compat-multi.c b/iptables/xtables-compat-multi.c
index ed8ad07..902da52 100644
--- a/iptables/xtables-compat-multi.c
+++ b/iptables/xtables-compat-multi.c
@@ -29,8 +29,6 @@ static const struct subcommand multi_subcommands[] = {
 	{"arptables",			xtables_arp_main},
 	{"arptables-compat",		xtables_arp_main},
 	{"ebtables-compat",		xtables_eb_main},
-	{"xtables-config",		xtables_config_main},
-	{"xtables-events",		xtables_events_main},
 	{NULL},
 };
 
diff --git a/iptables/xtables-config.c b/iptables/xtables-config.c
deleted file mode 100644
index b7cf609..0000000
--- a/iptables/xtables-config.c
+++ /dev/null
@@ -1,46 +0,0 @@
-/*
- * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
- */
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <stdint.h>
-#include <stdbool.h>
-#include <string.h>
-#include <errno.h>
-
-#include "xtables-multi.h"
-#include "nft.h"
-
-int xtables_config_main(int argc, char *argv[])
-{
-	struct nft_handle h = {
-		.family = AF_INET,
-	};
-	const char *filename = NULL;
-
-	if (argc > 2) {
-		fprintf(stderr, "Usage: %s [<config_file>]\n", argv[0]);
-		return EXIT_SUCCESS;
-	}
-	if (argc == 1)
-		filename = XTABLES_CONFIG_DEFAULT;
-	else
-		filename = argv[1];
-
-	if (nft_init(&h, xtables_ipv4) < 0) {
-                fprintf(stderr, "Failed to initialize nft: %s\n",
-			strerror(errno));
-		return EXIT_FAILURE;
-	}
-
-	return nft_xtables_config_load(&h, filename, NFT_LOAD_VERBOSE) == 0 ?
-						    EXIT_SUCCESS : EXIT_FAILURE;
-}
diff --git a/iptables/xtables-events.c b/iptables/xtables-events.c
deleted file mode 100644
index df9a7b8..0000000
--- a/iptables/xtables-events.c
+++ /dev/null
@@ -1,213 +0,0 @@
-/*
- * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
- */
-
-#include <stdlib.h>
-#include <time.h>
-#include <string.h>
-#include <netinet/in.h>
-#include <getopt.h>
-
-#include <linux/netfilter/nfnetlink.h>
-#include <linux/netfilter/nf_tables.h>
-
-#include <libmnl/libmnl.h>
-#include <libnftnl/table.h>
-#include <libnftnl/chain.h>
-#include <libnftnl/rule.h>
-
-#include <include/xtables.h>
-#include "iptables.h" /* for xtables_globals */
-#include "xtables-multi.h"
-#include "nft.h"
-#include "nft-arp.h"
-
-static int table_cb(const struct nlmsghdr *nlh, int type)
-{
-	struct nftnl_table *t;
-	char buf[4096];
-
-	t = nftnl_table_alloc();
-	if (t == NULL)
-		goto err;
-
-	if (nftnl_table_nlmsg_parse(nlh, t) < 0)
-		goto err_free;
-
-	nftnl_table_snprintf(buf, sizeof(buf), t, NFTNL_OUTPUT_DEFAULT, 0);
-	/* FIXME: define syntax to represent table events */
-	printf("# [table: %s]\t%s\n", type == NFT_MSG_NEWTABLE ? "NEW" : "DEL", buf);
-
-err_free:
-	nftnl_table_free(t);
-err:
-	return MNL_CB_OK;
-}
-
-static bool counters;
-
-static int rule_cb(const struct nlmsghdr *nlh, int type)
-{
-	struct iptables_command_state cs = {};
-	struct arptables_command_state cs_arp = {};
-	struct nftnl_rule *r;
-	void *fw = NULL;
-	uint8_t family;
-
-	r = nftnl_rule_alloc();
-	if (r == NULL)
-		goto err;
-
-	if (nftnl_rule_nlmsg_parse(nlh, r) < 0)
-		goto err_free;
-
-	family = nftnl_rule_get_u32(r, NFTNL_RULE_FAMILY);
-	switch (family) {
-	case AF_INET:
-	case AF_INET6:
-		printf("-%c ", family == AF_INET ? '4' : '6');
-		nft_rule_to_iptables_command_state(r, &cs);
-		fw = &cs;
-		break;
-	case NFPROTO_ARP:
-		printf("-0 ");
-		nft_rule_to_arptables_command_state(r, &cs_arp);
-		fw = &cs_arp;
-		break;
-	default:
-		goto err_free;
-	}
-
-
-	nft_rule_print_save(fw, r,
-			    type == NFT_MSG_NEWRULE ? NFT_RULE_APPEND :
-						      NFT_RULE_DEL,
-			    counters ? 0 : FMT_NOCOUNTS);
-err_free:
-	nftnl_rule_free(r);
-err:
-	return MNL_CB_OK;
-}
-
-static int chain_cb(const struct nlmsghdr *nlh, int type)
-{
-	struct nftnl_chain *t;
-	char buf[4096];
-
-	t = nftnl_chain_alloc();
-	if (t == NULL)
-		goto err;
-
-	if (nftnl_chain_nlmsg_parse(nlh, t) < 0)
-		goto err_free;
-
-	nftnl_chain_snprintf(buf, sizeof(buf), t, NFTNL_OUTPUT_DEFAULT, 0);
-	/* FIXME: define syntax to represent chain events */
-	printf("# [chain: %s]\t%s\n", type == NFT_MSG_NEWCHAIN ? "NEW" : "DEL", buf);
-
-err_free:
-	nftnl_chain_free(t);
-err:
-	return MNL_CB_OK;
-}
-
-static int events_cb(const struct nlmsghdr *nlh, void *data)
-{
-	int ret = MNL_CB_OK;
-	int type = nlh->nlmsg_type & 0xFF;
-
-	switch(type) {
-	case NFT_MSG_NEWTABLE:
-	case NFT_MSG_DELTABLE:
-		ret = table_cb(nlh, type);
-		break;
-	case NFT_MSG_NEWCHAIN:
-	case NFT_MSG_DELCHAIN:
-		ret = chain_cb(nlh, type);
-		break;
-	case NFT_MSG_NEWRULE:
-	case NFT_MSG_DELRULE:
-		ret = rule_cb(nlh, type);
-		break;
-	}
-
-	return ret;
-}
-
-static const struct option options[] = {
-	{.name = "counters", .has_arg = false, .val = 'c'},
-	{NULL},
-};
-
-static void print_usage(const char *name, const char *version)
-{
-	fprintf(stderr, "Usage: %s [-c]\n"
-			"	   [ --counters ]\n", name);
-	exit(EXIT_FAILURE);
-}
-
-int xtables_events_main(int argc, char *argv[])
-{
-	struct mnl_socket *nl;
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	int ret, c;
-
-	xtables_globals.program_name = "xtables-events";
-	/* XXX xtables_init_all does several things we don't want */
-	c = xtables_init_all(&xtables_globals, NFPROTO_IPV4);
-	if (c < 0) {
-		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
-				xtables_globals.program_name,
-				xtables_globals.program_version);
-		exit(1);
-	}
-#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
-	init_extensions();
-	init_extensions4();
-#endif
-
-	opterr = 0;
-	while ((c = getopt_long(argc, argv, "c", options, NULL)) != -1) {
-		switch (c) {
-	        case 'c':
-			counters = true;
-			break;
-		default:
-			print_usage(argv[0], XTABLES_VERSION);
-			exit(EXIT_FAILURE);
-		}
-	}
-
-	nl = mnl_socket_open(NETLINK_NETFILTER);
-	if (nl == NULL) {
-		perror("cannot open nfnetlink socket");
-		exit(EXIT_FAILURE);
-	}
-
-	if (mnl_socket_bind(nl, (1 << (NFNLGRP_NFTABLES-1)), MNL_SOCKET_AUTOPID) < 0) {
-		perror("cannot bind to nfnetlink socket");
-		exit(EXIT_FAILURE);
-	}
-
-	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	while (ret > 0) {
-		ret = mnl_cb_run(buf, ret, 0, 0, events_cb, NULL);
-		if (ret <= 0)
-			break;
-		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	}
-	if (ret == -1) {
-		perror("cannot receive from nfnetlink socket");
-		exit(EXIT_FAILURE);
-	}
-	mnl_socket_close(nl);
-
-	return EXIT_SUCCESS;
-}
-- 
2.1.4

