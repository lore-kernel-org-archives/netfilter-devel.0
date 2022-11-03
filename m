Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B97DC433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Nov 2022 01:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiKCBly (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Nov 2022 21:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKCBlw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Nov 2022 21:41:52 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFCD11465
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Nov 2022 18:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=l5hqImi1/NZNO4ZsXzJ2KA1cROrGo6nFRnouGIuQLm4=; b=HrvnzAI8SzlRsg08FkRY99H6WV
        9l6XU6FiyM165tOIys5YCVr4UAR0W8qXfGPLoccFKmVtYjXQR5lJh2ayqUW9kxqZmcRMTVtLkQuPt
        uMd8/nnwXuDjulZqSfRuil6qUVkks0x3BmPFET9kHPO8VCzg9cXbHW/IYpMzT6ZeOAMIT6oyQD5f+
        2WmoNeGsLRpBRiONmilepfqavIUbaf56d4ynm9tZIlBD9UWCRWhno+Yb5My8V5IaoqI5dveLDulSW
        NtlEkeRcLcupziGTtbE37sCfdeNE16SWgpHOOc70zXZDPgSLkkCbWkeGfkda3sdmeal3SP9SHoprb
        p/Qj5S2w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oqPEq-0005HB-BQ
        for netfilter-devel@vger.kernel.org; Thu, 03 Nov 2022 02:41:48 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 6/6] extensions: Merge SNAT, DNAT, REDIRECT and MASQUERADE
Date:   Thu,  3 Nov 2022 02:41:13 +0100
Message-Id: <20221103014113.10851-7-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221103014113.10851-1-phil@nwl.cc>
References: <20221103014113.10851-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

REDIRECT was already merged into DNAT. Given the callback generator and
generalized inner parsing routines, merging the other "flavors" is
relatively simple. Rename the extension into "libxt_NAT.so" while doing
so and turn the old DSOs into symlinks.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/GNUmakefile.in                |  10 +-
 extensions/libip6t_MASQUERADE.c          | 188 --------------
 extensions/libip6t_MASQUERADE.txlate     |   9 +
 extensions/libip6t_SNAT.c                | 298 -----------------------
 extensions/libip6t_SNAT.t                |   6 +
 extensions/libipt_MASQUERADE.c           | 190 ---------------
 extensions/libipt_MASQUERADE.txlate      |   9 +
 extensions/libipt_SNAT.c                 | 276 ---------------------
 extensions/libipt_SNAT.t                 |   6 +
 extensions/{libxt_DNAT.c => libxt_NAT.c} | 125 ++++++++++
 10 files changed, 163 insertions(+), 954 deletions(-)
 delete mode 100644 extensions/libip6t_MASQUERADE.c
 delete mode 100644 extensions/libip6t_SNAT.c
 delete mode 100644 extensions/libipt_MASQUERADE.c
 delete mode 100644 extensions/libipt_SNAT.c
 rename extensions/{libxt_DNAT.c => libxt_NAT.c} (80%)

diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 3c68f8decd13f..0239a06a90cd1 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -42,7 +42,7 @@ endif
 pfx_build_mod := $(patsubst ${srcdir}/libxt_%.c,%,$(sort $(wildcard ${srcdir}/libxt_*.c)))
 @ENABLE_NFTABLES_TRUE@ pfb_build_mod := $(patsubst ${srcdir}/libebt_%.c,%,$(sort $(wildcard ${srcdir}/libebt_*.c)))
 @ENABLE_NFTABLES_TRUE@ pfa_build_mod := $(patsubst ${srcdir}/libarpt_%.c,%,$(sort $(wildcard ${srcdir}/libarpt_*.c)))
-pfx_symlinks  := NOTRACK state REDIRECT
+pfx_symlinks  := NOTRACK state REDIRECT MASQUERADE SNAT DNAT
 @ENABLE_IPV4_TRUE@ pf4_build_mod := $(patsubst ${srcdir}/libipt_%.c,%,$(sort $(wildcard ${srcdir}/libipt_*.c)))
 @ENABLE_IPV6_TRUE@ pf6_build_mod := $(patsubst ${srcdir}/libip6t_%.c,%,$(sort $(wildcard ${srcdir}/libip6t_*.c)))
 pfx_build_mod := $(filter-out @blacklist_modules@ @blacklist_x_modules@,${pfx_build_mod})
@@ -130,7 +130,13 @@ libxt_NOTRACK.so: libxt_CT.so
 	ln -fs $< $@
 libxt_state.so: libxt_conntrack.so
 	ln -fs $< $@
-libxt_REDIRECT.so: libxt_DNAT.so
+libxt_REDIRECT.so: libxt_NAT.so
+	ln -fs $< $@
+libxt_MASQUERADE.so: libxt_NAT.so
+	ln -fs $< $@
+libxt_SNAT.so: libxt_NAT.so
+	ln -fs $< $@
+libxt_DNAT.so: libxt_NAT.so
 	ln -fs $< $@
 
 # Need the LIBADDs in iptables/Makefile.am too for libxtables_la_LIBADD
diff --git a/extensions/libip6t_MASQUERADE.c b/extensions/libip6t_MASQUERADE.c
deleted file mode 100644
index f28f071b047e1..0000000000000
--- a/extensions/libip6t_MASQUERADE.c
+++ /dev/null
@@ -1,188 +0,0 @@
-/*
- * Copyright (c) 2011 Patrick McHardy <kaber@trash.net>
- *
- * Based on Rusty Russell's IPv4 MASQUERADE target. Development of IPv6 NAT
- * funded by Astaro.
- */
-
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <xtables.h>
-#include <limits.h> /* INT_MAX in ip_tables.h */
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#include <linux/netfilter/nf_nat.h>
-
-enum {
-	O_TO_PORTS = 0,
-	O_RANDOM,
-	O_RANDOM_FULLY,
-};
-
-static void MASQUERADE_help(void)
-{
-	printf(
-"MASQUERADE target options:\n"
-" --to-ports <port>[-<port>]\n"
-"				Port (range) to map to.\n"
-" --random\n"
-"				Randomize source port.\n"
-" --random-fully\n"
-"				Fully randomize source port.\n");
-}
-
-static const struct xt_option_entry MASQUERADE_opts[] = {
-	{.name = "to-ports", .id = O_TO_PORTS, .type = XTTYPE_STRING},
-	{.name = "random", .id = O_RANDOM, .type = XTTYPE_NONE},
-	{.name = "random-fully", .id = O_RANDOM_FULLY, .type = XTTYPE_NONE},
-	XTOPT_TABLEEND,
-};
-
-/* Parses ports */
-static void
-parse_ports(const char *arg, struct nf_nat_range *r)
-{
-	char *end;
-	unsigned int port, maxport;
-
-	r->flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
-
-	if (!xtables_strtoui(arg, &end, &port, 0, UINT16_MAX))
-		xtables_param_act(XTF_BAD_VALUE, "MASQUERADE", "--to-ports", arg);
-
-	switch (*end) {
-	case '\0':
-		r->min_proto.tcp.port
-			= r->max_proto.tcp.port
-			= htons(port);
-		return;
-	case '-':
-		if (!xtables_strtoui(end + 1, NULL, &maxport, 0, UINT16_MAX))
-			break;
-
-		if (maxport < port)
-			break;
-
-		r->min_proto.tcp.port = htons(port);
-		r->max_proto.tcp.port = htons(maxport);
-		return;
-	default:
-		break;
-	}
-	xtables_param_act(XTF_BAD_VALUE, "MASQUERADE", "--to-ports", arg);
-}
-
-static void MASQUERADE_parse(struct xt_option_call *cb)
-{
-	const struct ip6t_entry *entry = cb->xt_entry;
-	struct nf_nat_range *r = cb->data;
-	int portok;
-
-	if (entry->ipv6.proto == IPPROTO_TCP ||
-	    entry->ipv6.proto == IPPROTO_UDP ||
-	    entry->ipv6.proto == IPPROTO_SCTP ||
-	    entry->ipv6.proto == IPPROTO_DCCP ||
-	    entry->ipv6.proto == IPPROTO_ICMP)
-		portok = 1;
-	else
-		portok = 0;
-
-	xtables_option_parse(cb);
-	switch (cb->entry->id) {
-	case O_TO_PORTS:
-		if (!portok)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Need TCP, UDP, SCTP or DCCP with port specification");
-		parse_ports(cb->arg, r);
-		break;
-	case O_RANDOM:
-		r->flags |=  NF_NAT_RANGE_PROTO_RANDOM;
-		break;
-	case O_RANDOM_FULLY:
-		r->flags |=  NF_NAT_RANGE_PROTO_RANDOM_FULLY;
-		break;
-	}
-}
-
-static void
-MASQUERADE_print(const void *ip, const struct xt_entry_target *target,
-                 int numeric)
-{
-	const struct nf_nat_range *r = (const void *)target->data;
-
-	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		printf(" masq ports: ");
-		printf("%hu", ntohs(r->min_proto.tcp.port));
-		if (r->max_proto.tcp.port != r->min_proto.tcp.port)
-			printf("-%hu", ntohs(r->max_proto.tcp.port));
-	}
-
-	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
-		printf(" random");
-
-	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY)
-		printf(" random-fully");
-}
-
-static void
-MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
-{
-	const struct nf_nat_range *r = (const void *)target->data;
-
-	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		printf(" --to-ports %hu", ntohs(r->min_proto.tcp.port));
-		if (r->max_proto.tcp.port != r->min_proto.tcp.port)
-			printf("-%hu", ntohs(r->max_proto.tcp.port));
-	}
-
-	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
-		printf(" --random");
-
-	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY)
-		printf(" --random-fully");
-}
-
-static int MASQUERADE_xlate(struct xt_xlate *xl,
-			    const struct xt_xlate_tg_params *params)
-{
-	const struct nf_nat_range *r = (const void *)params->target->data;
-
-	xt_xlate_add(xl, "masquerade");
-
-	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		xt_xlate_add(xl, " to :%hu", ntohs(r->min_proto.tcp.port));
-		if (r->max_proto.tcp.port != r->min_proto.tcp.port)
-			xt_xlate_add(xl, "-%hu", ntohs(r->max_proto.tcp.port));
-	}
-
-	xt_xlate_add(xl, " ");
-	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
-		xt_xlate_add(xl, "random ");
-
-	xt_xlate_add(xl, " ");
-	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY)
-		xt_xlate_add(xl, "fully-random ");
-
-	return 1;
-}
-
-static struct xtables_target masquerade_tg_reg = {
-	.name		= "MASQUERADE",
-	.version	= XTABLES_VERSION,
-	.family		= NFPROTO_IPV6,
-	.size		= XT_ALIGN(sizeof(struct nf_nat_range)),
-	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_range)),
-	.help		= MASQUERADE_help,
-	.x6_parse	= MASQUERADE_parse,
-	.print		= MASQUERADE_print,
-	.save		= MASQUERADE_save,
-	.x6_options	= MASQUERADE_opts,
-	.xlate		= MASQUERADE_xlate,
-};
-
-void _init(void)
-{
-	xtables_register_target(&masquerade_tg_reg);
-}
diff --git a/extensions/libip6t_MASQUERADE.txlate b/extensions/libip6t_MASQUERADE.txlate
index 6c289c2bdaee3..a2f9808036ebf 100644
--- a/extensions/libip6t_MASQUERADE.txlate
+++ b/extensions/libip6t_MASQUERADE.txlate
@@ -6,3 +6,12 @@ nft add rule ip6 nat POSTROUTING meta l4proto tcp counter masquerade to :10
 
 ip6tables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --to-ports 10-20 --random
 nft add rule ip6 nat POSTROUTING meta l4proto tcp counter masquerade to :10-20 random
+
+ip6tables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --random
+nft add rule ip6 nat POSTROUTING meta l4proto tcp counter masquerade random
+
+ip6tables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --random-fully
+nft add rule ip6 nat POSTROUTING meta l4proto tcp counter masquerade fully-random
+
+ip6tables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --random --random-fully
+nft add rule ip6 nat POSTROUTING meta l4proto tcp counter masquerade random,fully-random
diff --git a/extensions/libip6t_SNAT.c b/extensions/libip6t_SNAT.c
deleted file mode 100644
index 8bf7b035f84b6..0000000000000
--- a/extensions/libip6t_SNAT.c
+++ /dev/null
@@ -1,298 +0,0 @@
-/*
- * Copyright (c) 2011 Patrick McHardy <kaber@trash.net>
- *
- * Based on Rusty Russell's IPv4 SNAT target. Development of IPv6 NAT
- * funded by Astaro.
- */
-
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <xtables.h>
-#include <iptables.h>
-#include <limits.h> /* INT_MAX in ip_tables.h */
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#include <linux/netfilter/nf_nat.h>
-
-enum {
-	O_TO_SRC = 0,
-	O_RANDOM,
-	O_RANDOM_FULLY,
-	O_PERSISTENT,
-};
-
-static void SNAT_help(void)
-{
-	printf(
-"SNAT target options:\n"
-" --to-source [<ipaddr>[-<ipaddr>]][:port[-port]]\n"
-"				Address to map source to.\n"
-"[--random] [--random-fully] [--persistent]\n");
-}
-
-static const struct xt_option_entry SNAT_opts[] = {
-	{.name = "to-source", .id = O_TO_SRC, .type = XTTYPE_STRING,
-	 .flags = XTOPT_MAND},
-	{.name = "random", .id = O_RANDOM, .type = XTTYPE_NONE},
-	{.name = "random-fully", .id = O_RANDOM_FULLY, .type = XTTYPE_NONE},
-	{.name = "persistent", .id = O_PERSISTENT, .type = XTTYPE_NONE},
-	XTOPT_TABLEEND,
-};
-
-/* Ranges expected in network order. */
-static void
-parse_to(const char *orig_arg, int portok, struct nf_nat_range *range)
-{
-	char *arg, *start, *end = NULL, *colon = NULL, *dash, *error;
-	const struct in6_addr *ip;
-
-	arg = xtables_strdup(orig_arg);
-
-	start = strchr(arg, '[');
-	if (start == NULL) {
-		start = arg;
-		/* Lets assume one colon is port information. Otherwise its an IPv6 address */
-		colon = strchr(arg, ':');
-		if (colon && strchr(colon+1, ':'))
-			colon = NULL;
-	}
-	else {
-		start++;
-		end = strchr(start, ']');
-		if (end == NULL)
-			xtables_error(PARAMETER_PROBLEM,
-				      "Invalid address format");
-
-		*end = '\0';
-		colon = strchr(end + 1, ':');
-	}
-
-	if (colon) {
-		int port;
-
-		if (!portok)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Need TCP, UDP, SCTP or DCCP with port specification");
-
-		range->flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
-
-		port = atoi(colon+1);
-		if (port <= 0 || port > 65535)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Port `%s' not valid\n", colon+1);
-
-		error = strchr(colon+1, ':');
-		if (error)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Invalid port:port syntax - use dash\n");
-
-		dash = strchr(colon, '-');
-		if (!dash) {
-			range->min_proto.tcp.port
-				= range->max_proto.tcp.port
-				= htons(port);
-		} else {
-			int maxport;
-
-			maxport = atoi(dash + 1);
-			if (maxport <= 0 || maxport > 65535)
-				xtables_error(PARAMETER_PROBLEM,
-					   "Port `%s' not valid\n", dash+1);
-			if (maxport < port)
-				/* People are stupid. */
-				xtables_error(PARAMETER_PROBLEM,
-					   "Port range `%s' funky\n", colon+1);
-			range->min_proto.tcp.port = htons(port);
-			range->max_proto.tcp.port = htons(maxport);
-		}
-		/* Starts with colon or [] colon? No IP info...*/
-		if (colon == arg || colon == arg+2) {
-			free(arg);
-			return;
-		}
-		*colon = '\0';
-	}
-
-	range->flags |= NF_NAT_RANGE_MAP_IPS;
-	dash = strchr(start, '-');
-	if (colon && dash && dash > colon)
-		dash = NULL;
-
-	if (dash)
-		*dash = '\0';
-
-	ip = xtables_numeric_to_ip6addr(start);
-	if (!ip)
-		xtables_error(PARAMETER_PROBLEM, "Bad IP address \"%s\"\n",
-			      start);
-	range->min_addr.in6 = *ip;
-	if (dash) {
-		ip = xtables_numeric_to_ip6addr(dash + 1);
-		if (!ip)
-			xtables_error(PARAMETER_PROBLEM, "Bad IP address \"%s\"\n",
-				      dash+1);
-		range->max_addr.in6 = *ip;
-	} else
-		range->max_addr = range->min_addr;
-
-	free(arg);
-	return;
-}
-
-static void SNAT_parse(struct xt_option_call *cb)
-{
-	const struct ip6t_entry *entry = cb->xt_entry;
-	struct nf_nat_range *range = cb->data;
-	int portok;
-
-	if (entry->ipv6.proto == IPPROTO_TCP ||
-	    entry->ipv6.proto == IPPROTO_UDP ||
-	    entry->ipv6.proto == IPPROTO_SCTP ||
-	    entry->ipv6.proto == IPPROTO_DCCP ||
-	    entry->ipv6.proto == IPPROTO_ICMP)
-		portok = 1;
-	else
-		portok = 0;
-
-	xtables_option_parse(cb);
-	switch (cb->entry->id) {
-	case O_TO_SRC:
-		parse_to(cb->arg, portok, range);
-		break;
-	case O_PERSISTENT:
-		range->flags |= NF_NAT_RANGE_PERSISTENT;
-		break;
-	case O_RANDOM:
-		range->flags |= NF_NAT_RANGE_PROTO_RANDOM;
-		break;
-	case O_RANDOM_FULLY:
-		range->flags |= NF_NAT_RANGE_PROTO_RANDOM_FULLY;
-		break;
-	}
-}
-
-static void print_range(const struct nf_nat_range *range)
-{
-	if (range->flags & NF_NAT_RANGE_MAP_IPS) {
-		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)
-			printf("[");
-		printf("%s", xtables_ip6addr_to_numeric(&range->min_addr.in6));
-		if (memcmp(&range->min_addr, &range->max_addr,
-			   sizeof(range->min_addr)))
-			printf("-%s", xtables_ip6addr_to_numeric(&range->max_addr.in6));
-		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)
-			printf("]");
-	}
-	if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		printf(":");
-		printf("%hu", ntohs(range->min_proto.tcp.port));
-		if (range->max_proto.tcp.port != range->min_proto.tcp.port)
-			printf("-%hu", ntohs(range->max_proto.tcp.port));
-	}
-}
-
-static void SNAT_print(const void *ip, const struct xt_entry_target *target,
-                       int numeric)
-{
-	const struct nf_nat_range *range = (const void *)target->data;
-
-	printf(" to:");
-	print_range(range);
-	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM)
-		printf(" random");
-	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY)
-		printf(" random-fully");
-	if (range->flags & NF_NAT_RANGE_PERSISTENT)
-		printf(" persistent");
-}
-
-static void SNAT_save(const void *ip, const struct xt_entry_target *target)
-{
-	const struct nf_nat_range *range = (const void *)target->data;
-
-	printf(" --to-source ");
-	print_range(range);
-	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM)
-		printf(" --random");
-	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY)
-		printf(" --random-fully");
-	if (range->flags & NF_NAT_RANGE_PERSISTENT)
-		printf(" --persistent");
-}
-
-static void print_range_xlate(const struct nf_nat_range *range,
-			      struct xt_xlate *xl)
-{
-	bool proto_specified = range->flags & NF_NAT_RANGE_PROTO_SPECIFIED;
-
-	if (range->flags & NF_NAT_RANGE_MAP_IPS) {
-		xt_xlate_add(xl, "%s%s%s",
-			     proto_specified ? "[" : "",
-			     xtables_ip6addr_to_numeric(&range->min_addr.in6),
-			     proto_specified ? "]" : "");
-
-		if (memcmp(&range->min_addr, &range->max_addr,
-			   sizeof(range->min_addr))) {
-			xt_xlate_add(xl, "-%s%s%s",
-				     proto_specified ? "[" : "",
-				     xtables_ip6addr_to_numeric(&range->max_addr.in6),
-				     proto_specified ? "]" : "");
-		}
-	}
-	if (proto_specified) {
-		xt_xlate_add(xl, ":%hu", ntohs(range->min_proto.tcp.port));
-
-		if (range->max_proto.tcp.port != range->min_proto.tcp.port)
-			xt_xlate_add(xl, "-%hu",
-				   ntohs(range->max_proto.tcp.port));
-	}
-}
-
-static int SNAT_xlate(struct xt_xlate *xl,
-		      const struct xt_xlate_tg_params *params)
-{
-	const struct nf_nat_range *range = (const void *)params->target->data;
-	bool sep_need = false;
-	const char *sep = " ";
-
-	xt_xlate_add(xl, "snat to ");
-	print_range_xlate(range, xl);
-	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM) {
-		xt_xlate_add(xl, " random");
-		sep_need = true;
-	}
-	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY) {
-		if (sep_need)
-			sep = ",";
-		xt_xlate_add(xl, "%sfully-random", sep);
-		sep_need = true;
-	}
-	if (range->flags & NF_NAT_RANGE_PERSISTENT) {
-		if (sep_need)
-			sep = ",";
-		xt_xlate_add(xl, "%spersistent", sep);
-	}
-
-	return 1;
-}
-
-static struct xtables_target snat_tg_reg = {
-	.name		= "SNAT",
-	.version	= XTABLES_VERSION,
-	.family		= NFPROTO_IPV6,
-	.revision	= 1,
-	.size		= XT_ALIGN(sizeof(struct nf_nat_range)),
-	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_range)),
-	.help		= SNAT_help,
-	.x6_parse	= SNAT_parse,
-	.print		= SNAT_print,
-	.save		= SNAT_save,
-	.x6_options	= SNAT_opts,
-	.xlate		= SNAT_xlate,
-};
-
-void _init(void)
-{
-	xtables_register_target(&snat_tg_reg);
-}
diff --git a/extensions/libip6t_SNAT.t b/extensions/libip6t_SNAT.t
index d188a6bb3d559..98aa7602e784f 100644
--- a/extensions/libip6t_SNAT.t
+++ b/extensions/libip6t_SNAT.t
@@ -4,6 +4,12 @@
 -j SNAT --to-source dead::beef-dead::fee7;=;OK
 -j SNAT --to-source [dead::beef]:1025-65535;;FAIL
 -j SNAT --to-source [dead::beef] --to-source [dead::fee7];;FAIL
+-j SNAT --to-source dead::beef --random;=;OK
+-j SNAT --to-source dead::beef --random-fully;=;OK
+-j SNAT --to-source dead::beef --persistent;=;OK
+-j SNAT --to-source dead::beef --random --persistent;=;OK
+-j SNAT --to-source dead::beef --random --random-fully;=;OK
+-j SNAT --to-source dead::beef --random --random-fully --persistent;=;OK
 -p tcp -j SNAT --to-source [dead::beef]:1025-65535;=;OK
 -p tcp -j SNAT --to-source [dead::beef-dead::fee7]:1025-65535;=;OK
 -p tcp -j SNAT --to-source [dead::beef-dead::fee7]:1025-65536;;FAIL
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
deleted file mode 100644
index 90bf60659c4f4..0000000000000
--- a/extensions/libipt_MASQUERADE.c
+++ /dev/null
@@ -1,190 +0,0 @@
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <xtables.h>
-#include <limits.h> /* INT_MAX in ip_tables.h */
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter/nf_nat.h>
-
-enum {
-	O_TO_PORTS = 0,
-	O_RANDOM,
-	O_RANDOM_FULLY,
-};
-
-static void MASQUERADE_help(void)
-{
-	printf(
-"MASQUERADE target options:\n"
-" --to-ports <port>[-<port>]\n"
-"				Port (range) to map to.\n"
-" --random\n"
-"				Randomize source port.\n"
-" --random-fully\n"
-"				Fully randomize source port.\n");
-}
-
-static const struct xt_option_entry MASQUERADE_opts[] = {
-	{.name = "to-ports", .id = O_TO_PORTS, .type = XTTYPE_STRING},
-	{.name = "random", .id = O_RANDOM, .type = XTTYPE_NONE},
-	{.name = "random-fully", .id = O_RANDOM_FULLY, .type = XTTYPE_NONE},
-	XTOPT_TABLEEND,
-};
-
-static void MASQUERADE_init(struct xt_entry_target *t)
-{
-	struct nf_nat_ipv4_multi_range_compat *mr = (struct nf_nat_ipv4_multi_range_compat *)t->data;
-
-	/* Actually, it's 0, but it's ignored at the moment. */
-	mr->rangesize = 1;
-}
-
-/* Parses ports */
-static void
-parse_ports(const char *arg, struct nf_nat_ipv4_multi_range_compat *mr)
-{
-	char *end;
-	unsigned int port, maxport;
-
-	mr->range[0].flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
-
-	if (!xtables_strtoui(arg, &end, &port, 0, UINT16_MAX))
-		xtables_param_act(XTF_BAD_VALUE, "MASQUERADE", "--to-ports", arg);
-
-	switch (*end) {
-	case '\0':
-		mr->range[0].min.tcp.port
-			= mr->range[0].max.tcp.port
-			= htons(port);
-		return;
-	case '-':
-		if (!xtables_strtoui(end + 1, NULL, &maxport, 0, UINT16_MAX))
-			break;
-
-		if (maxport < port)
-			break;
-
-		mr->range[0].min.tcp.port = htons(port);
-		mr->range[0].max.tcp.port = htons(maxport);
-		return;
-	default:
-		break;
-	}
-	xtables_param_act(XTF_BAD_VALUE, "MASQUERADE", "--to-ports", arg);
-}
-
-static void MASQUERADE_parse(struct xt_option_call *cb)
-{
-	const struct ipt_entry *entry = cb->xt_entry;
-	int portok;
-	struct nf_nat_ipv4_multi_range_compat *mr = cb->data;
-
-	if (entry->ip.proto == IPPROTO_TCP
-	    || entry->ip.proto == IPPROTO_UDP
-	    || entry->ip.proto == IPPROTO_SCTP
-	    || entry->ip.proto == IPPROTO_DCCP
-	    || entry->ip.proto == IPPROTO_ICMP)
-		portok = 1;
-	else
-		portok = 0;
-
-	xtables_option_parse(cb);
-	switch (cb->entry->id) {
-	case O_TO_PORTS:
-		if (!portok)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Need TCP, UDP, SCTP or DCCP with port specification");
-		parse_ports(cb->arg, mr);
-		break;
-	case O_RANDOM:
-		mr->range[0].flags |=  NF_NAT_RANGE_PROTO_RANDOM;
-		break;
-	case O_RANDOM_FULLY:
-		mr->range[0].flags |=  NF_NAT_RANGE_PROTO_RANDOM_FULLY;
-		break;
-	}
-}
-
-static void
-MASQUERADE_print(const void *ip, const struct xt_entry_target *target,
-                 int numeric)
-{
-	const struct nf_nat_ipv4_multi_range_compat *mr = (const void *)target->data;
-	const struct nf_nat_ipv4_range *r = &mr->range[0];
-
-	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		printf(" masq ports: ");
-		printf("%hu", ntohs(r->min.tcp.port));
-		if (r->max.tcp.port != r->min.tcp.port)
-			printf("-%hu", ntohs(r->max.tcp.port));
-	}
-
-	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
-		printf(" random");
-
-	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY)
-		printf(" random-fully");
-}
-
-static void
-MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
-{
-	const struct nf_nat_ipv4_multi_range_compat *mr = (const void *)target->data;
-	const struct nf_nat_ipv4_range *r = &mr->range[0];
-
-	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		printf(" --to-ports %hu", ntohs(r->min.tcp.port));
-		if (r->max.tcp.port != r->min.tcp.port)
-			printf("-%hu", ntohs(r->max.tcp.port));
-	}
-
-	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
-		printf(" --random");
-
-	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY)
-		printf(" --random-fully");
-}
-
-static int MASQUERADE_xlate(struct xt_xlate *xl,
-			    const struct xt_xlate_tg_params *params)
-{
-	const struct nf_nat_ipv4_multi_range_compat *mr =
-		(const void *)params->target->data;
-	const struct nf_nat_ipv4_range *r = &mr->range[0];
-
-	xt_xlate_add(xl, "masquerade");
-
-	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		xt_xlate_add(xl, " to :%hu", ntohs(r->min.tcp.port));
-		if (r->max.tcp.port != r->min.tcp.port)
-			xt_xlate_add(xl, "-%hu", ntohs(r->max.tcp.port));
-        }
-
-	xt_xlate_add(xl, " ");
-	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
-		xt_xlate_add(xl, "random ");
-
-	return 1;
-}
-
-static struct xtables_target masquerade_tg_reg = {
-	.name		= "MASQUERADE",
-	.version	= XTABLES_VERSION,
-	.family		= NFPROTO_IPV4,
-	.size		= XT_ALIGN(sizeof(struct nf_nat_ipv4_multi_range_compat)),
-	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_ipv4_multi_range_compat)),
-	.help		= MASQUERADE_help,
-	.init		= MASQUERADE_init,
-	.x6_parse	= MASQUERADE_parse,
-	.print		= MASQUERADE_print,
-	.save		= MASQUERADE_save,
-	.x6_options	= MASQUERADE_opts,
-	.xlate		= MASQUERADE_xlate,
-};
-
-void _init(void)
-{
-	xtables_register_target(&masquerade_tg_reg);
-}
diff --git a/extensions/libipt_MASQUERADE.txlate b/extensions/libipt_MASQUERADE.txlate
index 40b6958a55cad..49f79d33dcfa8 100644
--- a/extensions/libipt_MASQUERADE.txlate
+++ b/extensions/libipt_MASQUERADE.txlate
@@ -6,3 +6,12 @@ nft add rule ip nat POSTROUTING ip protocol tcp counter masquerade to :10
 
 iptables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --to-ports 10-20 --random
 nft add rule ip nat POSTROUTING ip protocol tcp counter masquerade to :10-20 random
+
+iptables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --random
+nft add rule ip nat POSTROUTING ip protocol tcp counter masquerade random
+
+iptables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --random-fully
+nft add rule ip nat POSTROUTING ip protocol tcp counter masquerade fully-random
+
+iptables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --random --random-fully
+nft add rule ip nat POSTROUTING ip protocol tcp counter masquerade random,fully-random
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
deleted file mode 100644
index 9c8cdb46a1585..0000000000000
--- a/extensions/libipt_SNAT.c
+++ /dev/null
@@ -1,276 +0,0 @@
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <xtables.h>
-#include <iptables.h>
-#include <limits.h> /* INT_MAX in ip_tables.h */
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter/nf_nat.h>
-
-enum {
-	O_TO_SRC = 0,
-	O_RANDOM,
-	O_RANDOM_FULLY,
-	O_PERSISTENT,
-};
-
-static void SNAT_help(void)
-{
-	printf(
-"SNAT target options:\n"
-" --to-source [<ipaddr>[-<ipaddr>]][:port[-port]]\n"
-"				Address to map source to.\n"
-"[--random] [--random-fully] [--persistent]\n");
-}
-
-static const struct xt_option_entry SNAT_opts[] = {
-	{.name = "to-source", .id = O_TO_SRC, .type = XTTYPE_STRING,
-	 .flags = XTOPT_MAND},
-	{.name = "random", .id = O_RANDOM, .type = XTTYPE_NONE},
-	{.name = "random-fully", .id = O_RANDOM_FULLY, .type = XTTYPE_NONE},
-	{.name = "persistent", .id = O_PERSISTENT, .type = XTTYPE_NONE},
-	XTOPT_TABLEEND,
-};
-
-/* Ranges expected in network order. */
-static void
-parse_to(const char *orig_arg, int portok, struct nf_nat_ipv4_range *range)
-{
-	char *arg, *colon, *dash, *error;
-	const struct in_addr *ip;
-
-	arg = xtables_strdup(orig_arg);
-	colon = strchr(arg, ':');
-
-	if (colon) {
-		int port;
-
-		if (!portok)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Need TCP, UDP, SCTP or DCCP with port specification");
-
-		range->flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
-
-		port = atoi(colon+1);
-		if (port <= 0 || port > 65535)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Port `%s' not valid\n", colon+1);
-
-		error = strchr(colon+1, ':');
-		if (error)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Invalid port:port syntax - use dash\n");
-
-		dash = strchr(colon, '-');
-		if (!dash) {
-			range->min.tcp.port
-				= range->max.tcp.port
-				= htons(port);
-		} else {
-			int maxport;
-
-			maxport = atoi(dash + 1);
-			if (maxport <= 0 || maxport > 65535)
-				xtables_error(PARAMETER_PROBLEM,
-					   "Port `%s' not valid\n", dash+1);
-			if (maxport < port)
-				/* People are stupid. */
-				xtables_error(PARAMETER_PROBLEM,
-					   "Port range `%s' funky\n", colon+1);
-			range->min.tcp.port = htons(port);
-			range->max.tcp.port = htons(maxport);
-		}
-		/* Starts with a colon? No IP info...*/
-		if (colon == arg) {
-			free(arg);
-			return;
-		}
-		*colon = '\0';
-	}
-
-	range->flags |= NF_NAT_RANGE_MAP_IPS;
-	dash = strchr(arg, '-');
-	if (colon && dash && dash > colon)
-		dash = NULL;
-
-	if (dash)
-		*dash = '\0';
-
-	ip = xtables_numeric_to_ipaddr(arg);
-	if (!ip)
-		xtables_error(PARAMETER_PROBLEM, "Bad IP address \"%s\"\n",
-			   arg);
-	range->min_ip = ip->s_addr;
-	if (dash) {
-		ip = xtables_numeric_to_ipaddr(dash+1);
-		if (!ip)
-			xtables_error(PARAMETER_PROBLEM, "Bad IP address \"%s\"\n",
-				   dash+1);
-		range->max_ip = ip->s_addr;
-	} else
-		range->max_ip = range->min_ip;
-
-	free(arg);
-	return;
-}
-
-static void SNAT_parse(struct xt_option_call *cb)
-{
-	struct nf_nat_ipv4_multi_range_compat *mr = cb->data;
-	const struct ipt_entry *entry = cb->xt_entry;
-	int portok;
-
-	if (entry->ip.proto == IPPROTO_TCP
-	    || entry->ip.proto == IPPROTO_UDP
-	    || entry->ip.proto == IPPROTO_SCTP
-	    || entry->ip.proto == IPPROTO_DCCP
-	    || entry->ip.proto == IPPROTO_ICMP)
-		portok = 1;
-	else
-		portok = 0;
-
-	xtables_option_parse(cb);
-	switch (cb->entry->id) {
-	case O_TO_SRC:
-		parse_to(cb->arg, portok, mr->range);
-		break;
-	case O_PERSISTENT:
-		mr->range->flags |= NF_NAT_RANGE_PERSISTENT;
-		break;
-	case O_RANDOM:
-		mr->range->flags |= NF_NAT_RANGE_PROTO_RANDOM;
-		break;
-	case O_RANDOM_FULLY:
-		mr->range->flags |= NF_NAT_RANGE_PROTO_RANDOM_FULLY;
-		break;
-	}
-}
-
-static void SNAT_fcheck(struct xt_fcheck_call *cb)
-{
-	struct nf_nat_ipv4_multi_range_compat *mr = cb->data;
-
-	mr->rangesize = 1;
-}
-
-static void print_range(const struct nf_nat_ipv4_range *r)
-{
-	if (r->flags & NF_NAT_RANGE_MAP_IPS) {
-		struct in_addr a;
-
-		a.s_addr = r->min_ip;
-		printf("%s", xtables_ipaddr_to_numeric(&a));
-		if (r->max_ip != r->min_ip) {
-			a.s_addr = r->max_ip;
-			printf("-%s", xtables_ipaddr_to_numeric(&a));
-		}
-	}
-	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		printf(":");
-		printf("%hu", ntohs(r->min.tcp.port));
-		if (r->max.tcp.port != r->min.tcp.port)
-			printf("-%hu", ntohs(r->max.tcp.port));
-	}
-}
-
-static void SNAT_print(const void *ip, const struct xt_entry_target *target,
-                       int numeric)
-{
-	const struct nf_nat_ipv4_multi_range_compat *mr =
-				(const void *)target->data;
-
-	printf(" to:");
-	print_range(mr->range);
-	if (mr->range->flags & NF_NAT_RANGE_PROTO_RANDOM)
-		printf(" random");
-	if (mr->range->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY)
-		printf(" random-fully");
-	if (mr->range->flags & NF_NAT_RANGE_PERSISTENT)
-		printf(" persistent");
-}
-
-static void SNAT_save(const void *ip, const struct xt_entry_target *target)
-{
-	const struct nf_nat_ipv4_multi_range_compat *mr =
-				(const void *)target->data;
-
-	printf(" --to-source ");
-	print_range(mr->range);
-	if (mr->range->flags & NF_NAT_RANGE_PROTO_RANDOM)
-		printf(" --random");
-	if (mr->range->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY)
-		printf(" --random-fully");
-	if (mr->range->flags & NF_NAT_RANGE_PERSISTENT)
-		printf(" --persistent");
-}
-
-static void print_range_xlate(const struct nf_nat_ipv4_range *r,
-			      struct xt_xlate *xl)
-{
-	if (r->flags & NF_NAT_RANGE_MAP_IPS) {
-		struct in_addr a;
-
-		a.s_addr = r->min_ip;
-		xt_xlate_add(xl, "%s", xtables_ipaddr_to_numeric(&a));
-		if (r->max_ip != r->min_ip) {
-			a.s_addr = r->max_ip;
-			xt_xlate_add(xl, "-%s", xtables_ipaddr_to_numeric(&a));
-		}
-	}
-	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
-		xt_xlate_add(xl, ":");
-		xt_xlate_add(xl, "%hu", ntohs(r->min.tcp.port));
-		if (r->max.tcp.port != r->min.tcp.port)
-			xt_xlate_add(xl, "-%hu", ntohs(r->max.tcp.port));
-	}
-}
-
-static int SNAT_xlate(struct xt_xlate *xl,
-		      const struct xt_xlate_tg_params *params)
-{
-	const struct nf_nat_ipv4_multi_range_compat *mr =
-				(const void *)params->target->data;
-	bool sep_need = false;
-	const char *sep = " ";
-
-	xt_xlate_add(xl, "snat to ");
-	print_range_xlate(mr->range, xl);
-	if (mr->range->flags & NF_NAT_RANGE_PROTO_RANDOM) {
-		xt_xlate_add(xl, " random");
-		sep_need = true;
-	}
-	if (mr->range->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY) {
-		if (sep_need)
-			sep = ",";
-		xt_xlate_add(xl, "%sfully-random", sep);
-		sep_need = true;
-	}
-	if (mr->range->flags & NF_NAT_RANGE_PERSISTENT) {
-		if (sep_need)
-			sep = ",";
-		xt_xlate_add(xl, "%spersistent", sep);
-	}
-
-	return 1;
-}
-
-static struct xtables_target snat_tg_reg = {
-	.name		= "SNAT",
-	.version	= XTABLES_VERSION,
-	.family		= NFPROTO_IPV4,
-	.size		= XT_ALIGN(sizeof(struct nf_nat_ipv4_multi_range_compat)),
-	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_ipv4_multi_range_compat)),
-	.help		= SNAT_help,
-	.x6_parse	= SNAT_parse,
-	.x6_fcheck	= SNAT_fcheck,
-	.print		= SNAT_print,
-	.save		= SNAT_save,
-	.x6_options	= SNAT_opts,
-	.xlate		= SNAT_xlate,
-};
-
-void _init(void)
-{
-	xtables_register_target(&snat_tg_reg);
-}
diff --git a/extensions/libipt_SNAT.t b/extensions/libipt_SNAT.t
index 186e1cb82c3f3..c31d6e7c2cce8 100644
--- a/extensions/libipt_SNAT.t
+++ b/extensions/libipt_SNAT.t
@@ -4,6 +4,12 @@
 -j SNAT --to-source 1.1.1.1-1.1.1.10;=;OK
 -j SNAT --to-source 1.1.1.1:1025-65535;;FAIL
 -j SNAT --to-source 1.1.1.1 --to-source 2.2.2.2;;FAIL
+-j SNAT --to-source 1.1.1.1 --random;=;OK
+-j SNAT --to-source 1.1.1.1 --random-fully;=;OK
+-j SNAT --to-source 1.1.1.1 --persistent;=;OK
+-j SNAT --to-source 1.1.1.1 --random --persistent;=;OK
+-j SNAT --to-source 1.1.1.1 --random --random-fully;=;OK
+-j SNAT --to-source 1.1.1.1 --random --random-fully --persistent;=;OK
 -p tcp -j SNAT --to-source 1.1.1.1:1025-65535;=;OK
 -p tcp -j SNAT --to-source 1.1.1.1-1.1.1.10:1025-65535;=;OK
 -p tcp -j SNAT --to-source 1.1.1.1-1.1.1.10:1025-65536;;FAIL
diff --git a/extensions/libxt_DNAT.c b/extensions/libxt_NAT.c
similarity index 80%
rename from extensions/libxt_DNAT.c
rename to extensions/libxt_NAT.c
index fbb10e410a221..da9f22012c5d6 100644
--- a/extensions/libxt_DNAT.c
+++ b/extensions/libxt_NAT.c
@@ -36,11 +36,34 @@
 
 enum {
 	O_TO_DEST = 0,
+	O_TO_SRC,
 	O_TO_PORTS,
 	O_RANDOM,
+	O_RANDOM_FULLY,
 	O_PERSISTENT,
 };
 
+static void SNAT_help(void)
+{
+	printf(
+"SNAT target options:\n"
+" --to-source [<ipaddr>[-<ipaddr>]][:port[-port]]\n"
+"				Address to map source to.\n"
+"[--random] [--random-fully] [--persistent]\n");
+}
+
+static void MASQUERADE_help(void)
+{
+	printf(
+"MASQUERADE target options:\n"
+" --to-ports <port>[-<port>]\n"
+"				Port (range) to map to.\n"
+" --random\n"
+"				Randomize source port.\n"
+" --random-fully\n"
+"				Fully randomize source port.\n");
+}
+
 static void DNAT_help(void)
 {
 	printf(
@@ -68,6 +91,22 @@ static void REDIRECT_help(void)
 " [--random]\n");
 }
 
+static const struct xt_option_entry SNAT_opts[] = {
+	{.name = "to-source", .id = O_TO_SRC, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND},
+	{.name = "random", .id = O_RANDOM, .type = XTTYPE_NONE},
+	{.name = "random-fully", .id = O_RANDOM_FULLY, .type = XTTYPE_NONE},
+	{.name = "persistent", .id = O_PERSISTENT, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
+};
+
+static const struct xt_option_entry MASQUERADE_opts[] = {
+	{.name = "to-ports", .id = O_TO_PORTS, .type = XTTYPE_STRING},
+	{.name = "random", .id = O_RANDOM, .type = XTTYPE_NONE},
+	{.name = "random-fully", .id = O_RANDOM_FULLY, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
+};
+
 static const struct xt_option_entry DNAT_opts[] = {
 	{.name = "to-destination", .id = O_TO_DEST, .type = XTTYPE_STRING,
 	 .flags = XTOPT_MAND},
@@ -226,6 +265,7 @@ static void __NAT_parse(struct xt_option_call *cb, __u16 proto,
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
 	case O_TO_DEST:
+	case O_TO_SRC:
 		parse_to(cb->arg, portok, range, family);
 		break;
 	case O_TO_PORTS:
@@ -237,6 +277,9 @@ static void __NAT_parse(struct xt_option_call *cb, __u16 proto,
 	case O_RANDOM:
 		range->flags |= NF_NAT_RANGE_PROTO_RANDOM;
 		break;
+	case O_RANDOM_FULLY:
+		range->flags |= NF_NAT_RANGE_PROTO_RANDOM_FULLY;
+		break;
 	}
 }
 
@@ -250,6 +293,7 @@ static void NAT_parse(struct xt_option_call *cb)
 
 	switch (cb->entry->id) {
 	case O_TO_DEST:
+	case O_TO_SRC:
 		mr->range->min_ip = range.min_addr.ip;
 		mr->range->max_ip = range.max_addr.ip;
 		/* fall through */
@@ -259,6 +303,7 @@ static void NAT_parse(struct xt_option_call *cb)
 		/* fall through */
 	case O_PERSISTENT:
 	case O_RANDOM:
+	case O_RANDOM_FULLY:
 		mr->range->flags |= range.flags;
 		break;
 	}
@@ -288,6 +333,13 @@ static void DNAT_parse6_v2(struct xt_option_call *cb)
 	__NAT_parse(cb, entry->ipv6.proto, cb->data, AF_INET6);
 }
 
+static void SNAT_fcheck(struct xt_fcheck_call *cb)
+{
+	struct nf_nat_ipv4_multi_range_compat *mr = cb->data;
+
+	mr->rangesize = 1;
+}
+
 static void DNAT_fcheck(struct xt_fcheck_call *cb)
 {
 	struct nf_nat_ipv4_multi_range_compat *mr = cb->data;
@@ -355,6 +407,8 @@ static void __NAT_print(const struct nf_nat_range2 *r, int family,
 	}
 	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
 		printf(" %srandom", flag_pfx);
+	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY)
+		printf(" %srandom-fully", flag_pfx);
 	if (r->flags & NF_NAT_RANGE_PERSISTENT)
 		printf(" %spersistent", flag_pfx);
 }
@@ -377,6 +431,10 @@ __NAT_xlate(struct xt_xlate *xl, const struct nf_nat_range2 *r,
 		xt_xlate_add(xl, "%srandom", sep);
 		sep = ",";
 	}
+	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY) {
+		xt_xlate_add(xl, "%sfully-random", sep);
+		sep = ",";
+	}
 	if (r->flags & NF_NAT_RANGE_PERSISTENT) {
 		xt_xlate_add(xl, "%spersistent", sep);
 		sep = ",";
@@ -425,7 +483,33 @@ PSX_GEN(REDIRECT, RANGE2_INIT_FROM_IPV4_MRC, \
 PSX_GEN(REDIRECT6, RANGE2_INIT_FROM_RANGE, \
 	AF_INET6, "redir ports ", "--to-ports ", true, "redirect")
 
+PSX_GEN(SNAT, RANGE2_INIT_FROM_IPV4_MRC, \
+	AF_INET, "to:", "--to-source ", false, "snat")
+
+PSX_GEN(SNAT6, RANGE2_INIT_FROM_RANGE, \
+	AF_INET6, "to:", "--to-source ", false, "snat")
+
+PSX_GEN(MASQUERADE, RANGE2_INIT_FROM_IPV4_MRC, \
+	AF_INET, "masq ports: ", "--to-ports ", true, "masquerade")
+
+PSX_GEN(MASQUERADE6, RANGE2_INIT_FROM_RANGE, \
+	AF_INET6, "masq ports: ", "--to-ports ", true, "masquerade")
+
 static struct xtables_target nat_tg_reg[] = {
+	{
+		.name		= "SNAT",
+		.version	= XTABLES_VERSION,
+		.family		= NFPROTO_IPV4,
+		.size		= XT_ALIGN(sizeof(struct nf_nat_ipv4_multi_range_compat)),
+		.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_ipv4_multi_range_compat)),
+		.help		= SNAT_help,
+		.x6_parse	= NAT_parse,
+		.x6_fcheck	= SNAT_fcheck,
+		.print		= SNAT_print,
+		.save		= SNAT_save,
+		.x6_options	= SNAT_opts,
+		.xlate		= SNAT_xlate,
+	},
 	{
 		.name		= "DNAT",
 		.version	= XTABLES_VERSION,
@@ -441,6 +525,33 @@ static struct xtables_target nat_tg_reg[] = {
 		.x6_options	= DNAT_opts,
 		.xlate		= DNAT_xlate,
 	},
+	{
+		.name		= "MASQUERADE",
+		.version	= XTABLES_VERSION,
+		.family		= NFPROTO_IPV4,
+		.size		= XT_ALIGN(sizeof(struct nf_nat_ipv4_multi_range_compat)),
+		.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_ipv4_multi_range_compat)),
+		.help		= MASQUERADE_help,
+		.x6_parse	= NAT_parse,
+		.x6_fcheck	= SNAT_fcheck,
+		.print		= MASQUERADE_print,
+		.save		= MASQUERADE_save,
+		.x6_options	= MASQUERADE_opts,
+		.xlate		= MASQUERADE_xlate,
+	},
+	{
+		.name		= "MASQUERADE",
+		.version	= XTABLES_VERSION,
+		.family		= NFPROTO_IPV6,
+		.size		= XT_ALIGN(sizeof(struct nf_nat_range)),
+		.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_range)),
+		.help		= MASQUERADE_help,
+		.x6_parse	= NAT_parse6,
+		.print		= MASQUERADE6_print,
+		.save		= MASQUERADE6_save,
+		.x6_options	= MASQUERADE_opts,
+		.xlate		= MASQUERADE6_xlate,
+	},
 	{
 		.name		= "REDIRECT",
 		.version	= XTABLES_VERSION,
@@ -456,6 +567,20 @@ static struct xtables_target nat_tg_reg[] = {
 		.x6_options	= REDIRECT_opts,
 		.xlate		= REDIRECT_xlate,
 	},
+	{
+		.name		= "SNAT",
+		.version	= XTABLES_VERSION,
+		.family		= NFPROTO_IPV6,
+		.revision	= 1,
+		.size		= XT_ALIGN(sizeof(struct nf_nat_range)),
+		.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_range)),
+		.help		= SNAT_help,
+		.x6_parse	= NAT_parse6,
+		.print		= SNAT6_print,
+		.save		= SNAT6_save,
+		.x6_options	= SNAT_opts,
+		.xlate		= SNAT6_xlate,
+	},
 	{
 		.name		= "DNAT",
 		.version	= XTABLES_VERSION,
-- 
2.38.0

