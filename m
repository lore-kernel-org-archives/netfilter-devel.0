Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B98C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Mar 2022 10:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbiCaKOW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Mar 2022 06:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbiCaKOT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Mar 2022 06:14:19 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586671EECC
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2022 03:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=syc6lPh84YfVMdgOUVa81XgZlkGq4tdGWKb3ONUrQ2o=; b=EvO6FkSPwyZTyMDwVZrcDYyH4d
        F6njewpLq3WY6ql8sA1OaNgamWVjC6bJVQRFMQJS4B1jnkmt+GT5VMvFTLzjrikZ3jYvEJctxSV+o
        KzFZcXXUmPMAP0ShPMjYc5zzN35WoQ+6UJNUe+xYHjMOMaZc7gEdGQrc2Cs+VZMaf+15TtEnkcUy1
        CZSbl+EBF0NNxqk9C8PAAhumu3s6kDJYYHcDH/bkVIgdhszz/0TD07l0ZXLuDzWmpUmSmdOIANj5G
        Ata4E0oZvVlP0sWAJbmPAa9JC+C1fdY3LZNB4KyHfu0qNLJyTIpQkZwFzzoSKPL8ir5F6rhJaq6xE
        wLWsOiVw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nZrn3-00067B-Ll; Thu, 31 Mar 2022 12:12:29 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 7/9] extensions: Merge IPv4 and IPv6 DNAT targets
Date:   Thu, 31 Mar 2022 12:12:09 +0200
Message-Id: <20220331101211.10099-8-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220331101211.10099-1-phil@nwl.cc>
References: <20220331101211.10099-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Make parse_to() family-aware so it serves for both IPv4 and IPv6. Have a
core _DNAT_parse() function which parses into the most modern
(nf_nat_range2) data structure and a bunch of wrappers to copy into
legacy data structures if needed. Treat other callbacks analogous.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Fix for garbage in output when listing multiple rules.
---
 extensions/libip6t_DNAT.c      | 402 ---------------------------------
 extensions/libip6t_DNAT.txlate |  11 -
 extensions/libipt_DNAT.txlate  |  14 --
 extensions/libxt_DNAT.c        | 224 ++++++++++++++----
 extensions/libxt_DNAT.txlate   |  35 +++
 5 files changed, 218 insertions(+), 468 deletions(-)
 delete mode 100644 extensions/libip6t_DNAT.c
 delete mode 100644 extensions/libip6t_DNAT.txlate
 delete mode 100644 extensions/libipt_DNAT.txlate
 create mode 100644 extensions/libxt_DNAT.txlate

diff --git a/extensions/libip6t_DNAT.c b/extensions/libip6t_DNAT.c
deleted file mode 100644
index d51994c09e7f2..0000000000000
--- a/extensions/libip6t_DNAT.c
+++ /dev/null
@@ -1,402 +0,0 @@
-/*
- * Copyright (c) 2011 Patrick McHardy <kaber@trash.net>
- *
- * Based on Rusty Russell's IPv4 DNAT target. Development of IPv6 NAT
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
-	O_TO_DEST = 0,
-	O_RANDOM,
-	O_PERSISTENT,
-	F_TO_DEST   = 1 << O_TO_DEST,
-	F_RANDOM   = 1 << O_RANDOM,
-};
-
-static void DNAT_help(void)
-{
-	printf(
-"DNAT target options:\n"
-" --to-destination [<ipaddr>[-<ipaddr>]][:port[-port]]\n"
-"				Address to map destination to.\n"
-"[--random] [--persistent]\n");
-}
-
-static void DNAT_help_v2(void)
-{
-	printf(
-"DNAT target options:\n"
-" --to-destination [<ipaddr>[-<ipaddr>]][:port[-port[/port]]]\n"
-"				Address to map destination to.\n"
-"[--random] [--persistent]\n");
-}
-
-static const struct xt_option_entry DNAT_opts[] = {
-	{.name = "to-destination", .id = O_TO_DEST, .type = XTTYPE_STRING,
-	 .flags = XTOPT_MAND},
-	{.name = "random", .id = O_RANDOM, .type = XTTYPE_NONE},
-	{.name = "persistent", .id = O_PERSISTENT, .type = XTTYPE_NONE},
-	XTOPT_TABLEEND,
-};
-
-/* Ranges expected in network order. */
-static void
-parse_to(const char *orig_arg, int portok, struct nf_nat_range2 *range, int rev)
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
-
-			if (rev >= 2) {
-				char *slash = strchr(dash, '/');
-				if (slash) {
-					int baseport;
-
-					baseport = atoi(slash + 1);
-					if (baseport <= 0 || baseport > 65535)
-						xtables_error(PARAMETER_PROBLEM,
-								 "Port `%s' not valid\n", slash+1);
-					range->flags |= NF_NAT_RANGE_PROTO_OFFSET;
-					range->base_proto.tcp.port = htons(baseport);
-				}
-			}
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
-static void _DNAT_parse(struct xt_option_call *cb,
-		struct nf_nat_range2 *range, int rev)
-{
-	const struct ip6t_entry *entry = cb->xt_entry;
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
-	case O_TO_DEST:
-		parse_to(cb->arg, portok, range, rev);
-		break;
-	case O_PERSISTENT:
-		range->flags |= NF_NAT_RANGE_PERSISTENT;
-		break;
-	}
-}
-
-static void DNAT_parse(struct xt_option_call *cb)
-{
-	struct nf_nat_range *range_v1 = (void *)cb->data;
-	struct nf_nat_range2 range = {};
-
-	memcpy(&range, range_v1, sizeof(*range_v1));
-	_DNAT_parse(cb, &range, 1);
-	memcpy(range_v1, &range, sizeof(*range_v1));
-}
-
-static void DNAT_parse_v2(struct xt_option_call *cb)
-{
-	_DNAT_parse(cb, (struct nf_nat_range2 *)cb->data, 2);
-}
-
-static void _DNAT_fcheck(struct xt_fcheck_call *cb, unsigned int *flags)
-{
-	static const unsigned int f = F_TO_DEST | F_RANDOM;
-
-	if ((cb->xflags & f) == f)
-		*flags |= NF_NAT_RANGE_PROTO_RANDOM;
-}
-
-static void DNAT_fcheck(struct xt_fcheck_call *cb)
-{
-	_DNAT_fcheck(cb, &((struct nf_nat_range *)cb->data)->flags);
-}
-
-static void DNAT_fcheck_v2(struct xt_fcheck_call *cb)
-{
-	_DNAT_fcheck(cb, &((struct nf_nat_range2 *)cb->data)->flags);
-}
-
-static void print_range(const struct nf_nat_range2 *range, int rev)
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
-		if (rev >= 2 && (range->flags & NF_NAT_RANGE_PROTO_OFFSET))
-			printf("/%hu", ntohs(range->base_proto.tcp.port));
-	}
-}
-
-static void _DNAT_print(const struct nf_nat_range2 *range, int rev)
-{
-	printf(" to:");
-	print_range(range, rev);
-	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM)
-		printf(" random");
-	if (range->flags & NF_NAT_RANGE_PERSISTENT)
-		printf(" persistent");
-}
-
-static void DNAT_print(const void *ip, const struct xt_entry_target *target,
-                       int numeric)
-{
-	const struct nf_nat_range *range_v1 = (const void *)target->data;
-	struct nf_nat_range2 range = {};
-
-	memcpy(&range, range_v1, sizeof(*range_v1));
-	_DNAT_print(&range, 1);
-}
-
-static void DNAT_print_v2(const void *ip, const struct xt_entry_target *target,
-                          int numeric)
-{
-	_DNAT_print((const struct nf_nat_range2 *)target->data, 2);
-}
-
-static void _DNAT_save(const struct nf_nat_range2 *range, int rev)
-{
-	printf(" --to-destination ");
-	print_range(range, rev);
-	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM)
-		printf(" --random");
-	if (range->flags & NF_NAT_RANGE_PERSISTENT)
-		printf(" --persistent");
-}
-
-static void DNAT_save(const void *ip, const struct xt_entry_target *target)
-{
-	const struct nf_nat_range *range_v1 = (const void *)target->data;
-	struct nf_nat_range2 range = {};
-
-	memcpy(&range, range_v1, sizeof(*range_v1));
-	_DNAT_save(&range, 1);
-}
-
-static void DNAT_save_v2(const void *ip, const struct xt_entry_target *target)
-{
-	_DNAT_save((const struct nf_nat_range2 *)target->data, 2);
-}
-
-static void print_range_xlate(const struct nf_nat_range2 *range,
-			      struct xt_xlate *xl, int rev)
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
-static int _DNAT_xlate(struct xt_xlate *xl,
-		      const struct nf_nat_range2 *range, int rev)
-{
-	bool sep_need = false;
-	const char *sep = " ";
-
-	xt_xlate_add(xl, "dnat to ");
-	print_range_xlate(range, xl, rev);
-	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM) {
-		xt_xlate_add(xl, " random");
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
-static int DNAT_xlate(struct xt_xlate *xl,
-		      const struct xt_xlate_tg_params *params)
-{
-	const struct nf_nat_range *range_v1 = (const void *)params->target->data;
-	struct nf_nat_range2 range = {};
-
-	memcpy(&range, range_v1, sizeof(*range_v1));
-	_DNAT_xlate(xl, &range, 1);
-
-	return 1;
-}
-
-static int DNAT_xlate_v2(struct xt_xlate *xl,
-		      const struct xt_xlate_tg_params *params)
-{
-	_DNAT_xlate(xl, (const struct nf_nat_range2 *)params->target->data, 2);
-
-	return 1;
-}
-
-static struct xtables_target dnat_tg_reg[] = {
-	{
-		.name		= "DNAT",
-		.version	= XTABLES_VERSION,
-		.family		= NFPROTO_IPV6,
-		.revision	= 1,
-		.size		= XT_ALIGN(sizeof(struct nf_nat_range)),
-		.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_range)),
-		.help		= DNAT_help,
-		.print		= DNAT_print,
-		.save		= DNAT_save,
-		.x6_parse	= DNAT_parse,
-		.x6_fcheck	= DNAT_fcheck,
-		.x6_options	= DNAT_opts,
-		.xlate		= DNAT_xlate,
-	},
-	{
-		.name		= "DNAT",
-		.version	= XTABLES_VERSION,
-		.family		= NFPROTO_IPV6,
-		.revision	= 2,
-		.size		= XT_ALIGN(sizeof(struct nf_nat_range2)),
-		.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_range2)),
-		.help		= DNAT_help_v2,
-		.print		= DNAT_print_v2,
-		.save		= DNAT_save_v2,
-		.x6_parse	= DNAT_parse_v2,
-		.x6_fcheck	= DNAT_fcheck_v2,
-		.x6_options	= DNAT_opts,
-		.xlate		= DNAT_xlate_v2,
-	},
-};
-
-void _init(void)
-{
-	xtables_register_targets(dnat_tg_reg, ARRAY_SIZE(dnat_tg_reg));
-}
diff --git a/extensions/libip6t_DNAT.txlate b/extensions/libip6t_DNAT.txlate
deleted file mode 100644
index 03c4caf7e87c4..0000000000000
--- a/extensions/libip6t_DNAT.txlate
+++ /dev/null
@@ -1,11 +0,0 @@
-ip6tables-translate -t nat -A prerouting -i eth1 -p tcp --dport 8080 -j DNAT --to-destination [fec0::1234]:80
-nft add rule ip6 nat prerouting iifname "eth1" tcp dport 8080 counter dnat to [fec0::1234]:80
-
-ip6tables-translate -t nat -A prerouting -p tcp -j DNAT --to-destination [fec0::1234]:1-20
-nft add rule ip6 nat prerouting meta l4proto tcp counter dnat to [fec0::1234]:1-20
-
-ip6tables-translate -t nat -A prerouting -p tcp -j DNAT --to-destination [fec0::1234]:80 --persistent
-nft add rule ip6 nat prerouting meta l4proto tcp counter dnat to [fec0::1234]:80 persistent
-
-ip6tables-translate -t nat -A prerouting -p tcp -j DNAT --to-destination [fec0::1234]:80 --random --persistent
-nft add rule ip6 nat prerouting meta l4proto tcp counter dnat to [fec0::1234]:80 random,persistent
diff --git a/extensions/libipt_DNAT.txlate b/extensions/libipt_DNAT.txlate
deleted file mode 100644
index e88314d9dba59..0000000000000
--- a/extensions/libipt_DNAT.txlate
+++ /dev/null
@@ -1,14 +0,0 @@
-iptables-translate -t nat -A prerouting -p tcp -o eth0 -j DNAT --to-destination 1.2.3.4
-nft add rule ip nat prerouting oifname "eth0" ip protocol tcp counter dnat to 1.2.3.4
-
-iptables-translate -t nat -A prerouting -p tcp -d 15.45.23.67 --dport 80 -j DNAT --to-destination 192.168.1.1-192.168.1.10
-nft add rule ip nat prerouting ip daddr 15.45.23.67 tcp dport 80 counter dnat to 192.168.1.1-192.168.1.10
-
-iptables-translate -t nat -A prerouting -p tcp -o eth0 -j DNAT --to-destination 1.2.3.4:1-1023
-nft add rule ip nat prerouting oifname "eth0" ip protocol tcp counter dnat to 1.2.3.4:1-1023
-
-iptables-translate -t nat -A prerouting -p tcp -o eth0 -j DNAT --to-destination 1.2.3.4 --random
-nft add rule ip nat prerouting oifname "eth0" ip protocol tcp counter dnat to 1.2.3.4 random
-
-iptables-translate -t nat -A prerouting -p tcp -o eth0 -j DNAT --to-destination 1.2.3.4 --random --persistent
-nft add rule ip nat prerouting oifname "eth0" ip protocol tcp counter dnat to 1.2.3.4 random,persistent
diff --git a/extensions/libxt_DNAT.c b/extensions/libxt_DNAT.c
index 9a179919f522d..7f7c322cb2f9b 100644
--- a/extensions/libxt_DNAT.c
+++ b/extensions/libxt_DNAT.c
@@ -1,3 +1,10 @@
+/*
+ * Copyright (c) 2011 Patrick McHardy <kaber@trash.net>
+ *
+ * Based on Rusty Russell's IPv4 DNAT target. Development of IPv6 NAT
+ * funded by Astaro.
+ */
+
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -7,6 +14,7 @@
 #include <limits.h> /* INT_MAX in ip_tables.h */
 #include <arpa/inet.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter/nf_nat.h>
 
 #define TO_IPV4_MRC(ptr) ((const struct nf_nat_ipv4_multi_range_compat *)(ptr))
@@ -119,18 +127,36 @@ parse_ports(const char *arg, bool portok, struct nf_nat_range2 *range)
 
 /* Ranges expected in network order. */
 static void
-parse_to(const char *orig_arg, bool portok, struct nf_nat_range2 *range)
+parse_to(const char *orig_arg, bool portok,
+	 struct nf_nat_range2 *range, int family)
 {
-	char *arg, *colon, *dash;
+	char *arg, *start, *end, *colon, *dash;
 
 	arg = xtables_strdup(orig_arg);
-	colon = strchr(arg, ':');
+	start = strchr(arg, '[');
+	if (!start) {
+		start = arg;
+		/* Lets assume one colon is port information.
+		 * Otherwise its an IPv6 address */
+		colon = strchr(arg, ':');
+		if (colon && strchr(colon + 1, ':'))
+			colon = NULL;
+	} else {
+		start++;
+		end = strchr(start, ']');
+		if (end == NULL || family == AF_INET)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Invalid address format");
+
+		*end = '\0';
+		colon = strchr(end + 1, ':');
+	}
 
 	if (colon) {
 		parse_ports(colon + 1, portok, range);
 
-		/* Starts with a colon? No IP info...*/
-		if (colon == arg) {
+		/* Starts with colon or [] colon? No IP info...*/
+		if (colon == arg || colon == arg + 2) {
 			free(arg);
 			return;
 		}
@@ -138,20 +164,20 @@ parse_to(const char *orig_arg, bool portok, struct nf_nat_range2 *range)
 	}
 
 	range->flags |= NF_NAT_RANGE_MAP_IPS;
-	dash = strchr(arg, '-');
+	dash = strchr(start, '-');
 	if (colon && dash && dash > colon)
 		dash = NULL;
 
 	if (dash)
 		*dash = '\0';
 
-	if (!inet_pton(AF_INET, arg, &range->min_addr))
+	if (!inet_pton(family, start, &range->min_addr))
 		xtables_error(PARAMETER_PROBLEM,
-			      "Bad IP address \"%s\"\n", arg);
+			      "Bad IP address \"%s\"", arg);
 	if (dash) {
-		if (!inet_pton(AF_INET, dash + 1, &range->max_addr))
+		if (!inet_pton(family, dash + 1, &range->max_addr))
 			xtables_error(PARAMETER_PROBLEM,
-				      "Bad IP address \"%s\"\n", dash + 1);
+				      "Bad IP address \"%s\"", dash + 1);
 	} else {
 		range->max_addr = range->min_addr;
 	}
@@ -160,7 +186,7 @@ parse_to(const char *orig_arg, bool portok, struct nf_nat_range2 *range)
 }
 
 static void __DNAT_parse(struct xt_option_call *cb, __u16 proto,
-			 struct nf_nat_range2 *range)
+			 struct nf_nat_range2 *range, int family)
 {
 	bool portok = proto == IPPROTO_TCP ||
 		      proto == IPPROTO_UDP ||
@@ -171,7 +197,7 @@ static void __DNAT_parse(struct xt_option_call *cb, __u16 proto,
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
 	case O_TO_DEST:
-		parse_to(cb->arg, portok, range);
+		parse_to(cb->arg, portok, range, family);
 		break;
 	case O_PERSISTENT:
 		range->flags |= NF_NAT_RANGE_PERSISTENT;
@@ -185,7 +211,7 @@ static void DNAT_parse(struct xt_option_call *cb)
 	const struct ipt_entry *entry = cb->xt_entry;
 	struct nf_nat_range2 range = {};
 
-	__DNAT_parse(cb, entry->ip.proto, &range);
+	__DNAT_parse(cb, entry->ip.proto, &range, AF_INET);
 
 	switch (cb->entry->id) {
 	case O_TO_DEST:
@@ -200,32 +226,47 @@ static void DNAT_parse(struct xt_option_call *cb)
 	}
 }
 
-static void DNAT_fcheck(struct xt_fcheck_call *cb)
+static void __DNAT_fcheck(struct xt_fcheck_call *cb, unsigned int *flags)
 {
 	static const unsigned int f = F_TO_DEST | F_RANDOM;
-	struct nf_nat_ipv4_multi_range_compat *mr = cb->data;
 
 	if ((cb->xflags & f) == f)
-		mr->range[0].flags |= NF_NAT_RANGE_PROTO_RANDOM;
+		*flags |= NF_NAT_RANGE_PROTO_RANDOM;
+}
+
+static void DNAT_fcheck(struct xt_fcheck_call *cb)
+{
+	struct nf_nat_ipv4_multi_range_compat *mr = cb->data;
 
 	mr->rangesize = 1;
 
 	if (mr->range[0].flags & NF_NAT_RANGE_PROTO_OFFSET)
 		xtables_error(PARAMETER_PROBLEM,
 			      "Shifted portmap ranges not supported with this kernel");
+
+	__DNAT_fcheck(cb, &mr->range[0].flags);
 }
 
-static char *sprint_range(const struct nf_nat_range2 *r)
+static char *sprint_range(const struct nf_nat_range2 *r, int family)
 {
-	static char buf[INET_ADDRSTRLEN * 2 + 1 + 6 * 3];
+	bool brackets = family == AF_INET6 &&
+			r->flags & NF_NAT_RANGE_PROTO_SPECIFIED;
+	static char buf[INET6_ADDRSTRLEN * 2 + 3 + 6 * 3];
+
+	buf[0] = '\0';
 
 	if (r->flags & NF_NAT_RANGE_MAP_IPS) {
-		sprintf(buf, "%s", xtables_ipaddr_to_numeric(&r->min_addr.in));
-		if (memcmp(&r->min_addr, &r->max_addr, sizeof(r->min_addr)))
-			sprintf(buf + strlen(buf), "-%s",
-				xtables_ipaddr_to_numeric(&r->max_addr.in));
-	} else {
-		buf[0] = '\0';
+		if (brackets)
+			strcat(buf, "[");
+		inet_ntop(family, &r->min_addr,
+			  buf + strlen(buf), INET6_ADDRSTRLEN);
+		if (memcmp(&r->min_addr, &r->max_addr, sizeof(r->min_addr))) {
+			strcat(buf, "-");
+			inet_ntop(family, &r->max_addr,
+				  buf + strlen(buf), INET6_ADDRSTRLEN);
+		}
+		if (brackets)
+			strcat(buf, "]");
 	}
 	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
 		sprintf(buf + strlen(buf), ":%hu",
@@ -240,11 +281,12 @@ static char *sprint_range(const struct nf_nat_range2 *r)
 	return buf;
 }
 
-static void __DNAT_print(const struct nf_nat_range2 *r, bool save)
+static void __DNAT_print(const struct nf_nat_range2 *r, bool save, int family)
 {
 	const char *dashdash = save ? "--" : "";
 
-	printf(" %s%s", save ? "--to-destination " : "to:", sprint_range(r));
+	printf(" %s%s", save ? "--to-destination " : "to:",
+	       sprint_range(r, family));
 	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM)
 		printf(" %srandom", dashdash);
 	if (r->flags & NF_NAT_RANGE_PERSISTENT)
@@ -256,19 +298,20 @@ static void DNAT_print(const void *ip, const struct xt_entry_target *target,
 {
 	struct nf_nat_range2 range = RANGE2_INIT_FROM_IPV4_MRC(target->data);
 
-	__DNAT_print(&range, false);
+	__DNAT_print(&range, false, AF_INET);
 }
 
 static void DNAT_save(const void *ip, const struct xt_entry_target *target)
 {
 	struct nf_nat_range2 range = RANGE2_INIT_FROM_IPV4_MRC(target->data);
 
-	__DNAT_print(&range, true);
+	__DNAT_print(&range, true, AF_INET);
 }
 
-static int __DNAT_xlate(struct xt_xlate *xl, const struct nf_nat_range2 *r)
+static int
+__DNAT_xlate(struct xt_xlate *xl, const struct nf_nat_range2 *r, int family)
 {
-	char *range_str = sprint_range(r);
+	char *range_str = sprint_range(r, family);
 	const char *sep = " ";
 
 	/* shifted portmap ranges are not supported by nftables */
@@ -295,40 +338,109 @@ static int DNAT_xlate(struct xt_xlate *xl,
 	struct nf_nat_range2 range =
 		RANGE2_INIT_FROM_IPV4_MRC(params->target->data);
 
-	return __DNAT_xlate(xl, &range);
+	return __DNAT_xlate(xl, &range, AF_INET);
 }
 
 static void DNAT_parse_v2(struct xt_option_call *cb)
 {
 	const struct ipt_entry *entry = cb->xt_entry;
 
-	__DNAT_parse(cb, entry->ip.proto, cb->data);
+	__DNAT_parse(cb, entry->ip.proto, cb->data, AF_INET);
 }
 
 static void DNAT_fcheck_v2(struct xt_fcheck_call *cb)
 {
-	static const unsigned int f = F_TO_DEST | F_RANDOM;
-	struct nf_nat_range2 *range = cb->data;
-
-	if ((cb->xflags & f) == f)
-		range->flags |= NF_NAT_RANGE_PROTO_RANDOM;
+	__DNAT_fcheck(cb, &((struct nf_nat_range2 *)cb->data)->flags);
 }
 
 static void DNAT_print_v2(const void *ip, const struct xt_entry_target *target,
                        int numeric)
 {
-	__DNAT_print((const void *)target->data, false);
+	__DNAT_print((const void *)target->data, false, AF_INET);
 }
 
 static void DNAT_save_v2(const void *ip, const struct xt_entry_target *target)
 {
-	__DNAT_print((const void *)target->data, true);
+	__DNAT_print((const void *)target->data, true, AF_INET);
 }
 
 static int DNAT_xlate_v2(struct xt_xlate *xl,
-		      const struct xt_xlate_tg_params *params)
+			  const struct xt_xlate_tg_params *params)
+{
+	return __DNAT_xlate(xl, (const void *)params->target->data, AF_INET);
+}
+
+static void DNAT_parse6(struct xt_option_call *cb)
+{
+	const struct ip6t_entry *entry = cb->xt_entry;
+	struct nf_nat_range *range_v1 = (void *)cb->data;
+	struct nf_nat_range2 range = {};
+
+	memcpy(&range, range_v1, sizeof(*range_v1));
+	__DNAT_parse(cb, entry->ipv6.proto, &range, AF_INET6);
+	memcpy(range_v1, &range, sizeof(*range_v1));
+}
+
+static void DNAT_fcheck6(struct xt_fcheck_call *cb)
+{
+	struct nf_nat_range *range = (void *)cb->data;
+
+	if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
+		xtables_error(PARAMETER_PROBLEM,
+			      "Shifted portmap ranges not supported with this kernel");
+
+	__DNAT_fcheck(cb, &range->flags);
+}
+
+static void DNAT_print6(const void *ip, const struct xt_entry_target *target,
+			int numeric)
+{
+	struct nf_nat_range2 range = {};
+
+	memcpy(&range, (const void *)target->data, sizeof(struct nf_nat_range));
+	__DNAT_print(&range, true, AF_INET6);
+}
+
+static void DNAT_save6(const void *ip, const struct xt_entry_target *target)
+{
+	struct nf_nat_range2 range = {};
+
+	memcpy(&range, (const void *)target->data, sizeof(struct nf_nat_range));
+	__DNAT_print(&range, true, AF_INET6);
+}
+
+static int DNAT_xlate6(struct xt_xlate *xl,
+		       const struct xt_xlate_tg_params *params)
+{
+	struct nf_nat_range2 range = {};
+
+	memcpy(&range, (const void *)params->target->data,
+	       sizeof(struct nf_nat_range));
+	return __DNAT_xlate(xl, &range, AF_INET6);
+}
+
+static void DNAT_parse6_v2(struct xt_option_call *cb)
+{
+	const struct ip6t_entry *entry = cb->xt_entry;
+
+	__DNAT_parse(cb, entry->ipv6.proto, cb->data, AF_INET6);
+}
+
+static void DNAT_print6_v2(const void *ip, const struct xt_entry_target *target,
+			   int numeric)
+{
+	__DNAT_print((const void *)target->data, true, AF_INET6);
+}
+
+static void DNAT_save6_v2(const void *ip, const struct xt_entry_target *target)
 {
-	return __DNAT_xlate(xl, (const void *)params->target->data);
+	__DNAT_print((const void *)target->data, true, AF_INET6);
+}
+
+static int DNAT_xlate6_v2(struct xt_xlate *xl,
+			  const struct xt_xlate_tg_params *params)
+{
+	return __DNAT_xlate(xl, (const void *)params->target->data, AF_INET6);
 }
 
 static struct xtables_target dnat_tg_reg[] = {
@@ -347,6 +459,21 @@ static struct xtables_target dnat_tg_reg[] = {
 		.x6_options	= DNAT_opts,
 		.xlate		= DNAT_xlate,
 	},
+	{
+		.name		= "DNAT",
+		.version	= XTABLES_VERSION,
+		.family		= NFPROTO_IPV6,
+		.revision	= 1,
+		.size		= XT_ALIGN(sizeof(struct nf_nat_range)),
+		.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_range)),
+		.help		= DNAT_help,
+		.print		= DNAT_print6,
+		.save		= DNAT_save6,
+		.x6_parse	= DNAT_parse6,
+		.x6_fcheck	= DNAT_fcheck6,
+		.x6_options	= DNAT_opts,
+		.xlate		= DNAT_xlate6,
+	},
 	{
 		.name		= "DNAT",
 		.version	= XTABLES_VERSION,
@@ -362,6 +489,21 @@ static struct xtables_target dnat_tg_reg[] = {
 		.x6_options	= DNAT_opts,
 		.xlate		= DNAT_xlate_v2,
 	},
+	{
+		.name		= "DNAT",
+		.version	= XTABLES_VERSION,
+		.family		= NFPROTO_IPV6,
+		.revision	= 2,
+		.size		= XT_ALIGN(sizeof(struct nf_nat_range2)),
+		.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_range2)),
+		.help		= DNAT_help_v2,
+		.print		= DNAT_print6_v2,
+		.save		= DNAT_save6_v2,
+		.x6_parse	= DNAT_parse6_v2,
+		.x6_fcheck	= DNAT_fcheck_v2,
+		.x6_options	= DNAT_opts,
+		.xlate		= DNAT_xlate6_v2,
+	},
 };
 
 void _init(void)
diff --git a/extensions/libxt_DNAT.txlate b/extensions/libxt_DNAT.txlate
new file mode 100644
index 0000000000000..a65976562ef53
--- /dev/null
+++ b/extensions/libxt_DNAT.txlate
@@ -0,0 +1,35 @@
+iptables-translate -t nat -A prerouting -p tcp -o eth0 -j DNAT --to-destination 1.2.3.4
+nft add rule ip nat prerouting oifname "eth0" ip protocol tcp counter dnat to 1.2.3.4
+
+iptables-translate -t nat -A prerouting -p tcp -d 15.45.23.67 --dport 80 -j DNAT --to-destination 192.168.1.1-192.168.1.10
+nft add rule ip nat prerouting ip daddr 15.45.23.67 tcp dport 80 counter dnat to 192.168.1.1-192.168.1.10
+
+iptables-translate -t nat -A prerouting -p tcp -o eth0 -j DNAT --to-destination 1.2.3.4:1-1023
+nft add rule ip nat prerouting oifname "eth0" ip protocol tcp counter dnat to 1.2.3.4:1-1023
+
+iptables-translate -t nat -A prerouting -p tcp -o eth0 -j DNAT --to-destination 1.2.3.4 --random
+nft add rule ip nat prerouting oifname "eth0" ip protocol tcp counter dnat to 1.2.3.4 random
+
+iptables-translate -t nat -A prerouting -p tcp -o eth0 -j DNAT --to-destination 1.2.3.4 --random --persistent
+nft add rule ip nat prerouting oifname "eth0" ip protocol tcp counter dnat to 1.2.3.4 random,persistent
+
+ip6tables-translate -t nat -A prerouting -p tcp --dport 8080 -j DNAT --to-destination fec0::1234
+nft add rule ip6 nat prerouting tcp dport 8080 counter dnat to fec0::1234
+
+ip6tables-translate -t nat -A prerouting -p tcp --dport 8080 -j DNAT --to-destination fec0::1234-fec0::2000
+nft add rule ip6 nat prerouting tcp dport 8080 counter dnat to fec0::1234-fec0::2000
+
+ip6tables-translate -t nat -A prerouting -i eth1 -p tcp --dport 8080 -j DNAT --to-destination [fec0::1234]:80
+nft add rule ip6 nat prerouting iifname "eth1" tcp dport 8080 counter dnat to [fec0::1234]:80
+
+ip6tables-translate -t nat -A prerouting -p tcp -j DNAT --to-destination [fec0::1234]:1-20
+nft add rule ip6 nat prerouting meta l4proto tcp counter dnat to [fec0::1234]:1-20
+
+ip6tables-translate -t nat -A prerouting -p tcp -j DNAT --to-destination [fec0::1234-fec0::2000]:1-20
+nft add rule ip6 nat prerouting meta l4proto tcp counter dnat to [fec0::1234-fec0::2000]:1-20
+
+ip6tables-translate -t nat -A prerouting -p tcp -j DNAT --to-destination [fec0::1234]:80 --persistent
+nft add rule ip6 nat prerouting meta l4proto tcp counter dnat to [fec0::1234]:80 persistent
+
+ip6tables-translate -t nat -A prerouting -p tcp -j DNAT --to-destination [fec0::1234]:80 --random --persistent
+nft add rule ip6 nat prerouting meta l4proto tcp counter dnat to [fec0::1234]:80 random,persistent
-- 
2.34.1

