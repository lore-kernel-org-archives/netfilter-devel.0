Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72D9482CA
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="XafCEzyn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=y5vCnFaH1EMKHd2o1EbHjDy9s+ECKlhGAvVHZemACFA=; b=XafCEzynV+yKHj63MWnUff+BRe
	sPesAHZw/yjjl4CGOiGYAuupv0u9B6qbqdCFS41nzlE3/Ri3OiNfLmQd+1TxvpAsS1Xoiau01ud98
	FgGQXQHcgGwC5O31SqC1DxJGojeQZ8taJAESM3J+SEWwTiXkkyDP57PySu7H1uScvTthLhccBorAU
	Qni30ohN+fX2GwpqdMrxdJlj/kFtaiQMf989pqvZDfEMLDcChBQeXX9Ax27JE4zLundu3QVV8ufSZ
	k1jxEwizWimIfxRbkAihBVAYV2V2tUfLXLPDuvkGDPpDVFB6SHzERu9lWk+r3QJo9CywYSqo2KqJw
	IcOsHqzg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5m-0004Kj-5q
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:42 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 10/23] extensions: libebt_ip6: Use guided option parser
Date: Wed, 20 Dec 2023 17:06:23 +0100
Message-ID: <20231220160636.11778-11-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160636.11778-1-phil@nwl.cc>
References: <20231220160636.11778-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_ip6.c | 199 +++++++++++++++-------------------------
 extensions/libebt_ip6.t |   8 ++
 2 files changed, 83 insertions(+), 124 deletions(-)

diff --git a/extensions/libebt_ip6.c b/extensions/libebt_ip6.c
index d926e86a585f4..0d7403e72589a 100644
--- a/extensions/libebt_ip6.c
+++ b/extensions/libebt_ip6.c
@@ -18,59 +18,59 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <getopt.h>
 #include <netdb.h>
 #include <xtables.h>
 #include <linux/netfilter_bridge/ebt_ip6.h>
 
 #include "libxt_icmp.h"
 
-#define IP_SOURCE '1'
-#define IP_DEST   '2'
-#define IP_TCLASS '3'
-#define IP_PROTO  '4'
-#define IP_SPORT  '5'
-#define IP_DPORT  '6'
-#define IP_ICMP6  '7'
-
-static const struct option brip6_opts[] = {
-	{ .name = "ip6-source",		.has_arg = true, .val = IP_SOURCE },
-	{ .name = "ip6-src",		.has_arg = true, .val = IP_SOURCE },
-	{ .name = "ip6-destination",	.has_arg = true, .val = IP_DEST },
-	{ .name = "ip6-dst",		.has_arg = true, .val = IP_DEST },
-	{ .name = "ip6-tclass",		.has_arg = true, .val = IP_TCLASS },
-	{ .name = "ip6-protocol",	.has_arg = true, .val = IP_PROTO },
-	{ .name = "ip6-proto",		.has_arg = true, .val = IP_PROTO },
-	{ .name = "ip6-source-port",	.has_arg = true, .val = IP_SPORT },
-	{ .name = "ip6-sport",		.has_arg = true, .val = IP_SPORT },
-	{ .name = "ip6-destination-port",.has_arg = true,.val = IP_DPORT },
-	{ .name = "ip6-dport",		.has_arg = true, .val = IP_DPORT },
-	{ .name = "ip6-icmp-type",	.has_arg = true, .val = IP_ICMP6 },
-	XT_GETOPT_TABLEEND,
+/* must correspond to the bit position in EBT_IP6_* defines */
+enum {
+	O_SOURCE = 0,
+	O_DEST,
+	O_TCLASS,
+	O_PROTO,
+	O_SPORT,
+	O_DPORT,
+	O_ICMP6,
+	F_PORT = 1 << O_ICMP6,
+	F_ICMP6 = 1 << O_SPORT | 1 << O_DPORT,
 };
 
-static void
-parse_port_range(const char *protocol, const char *portstring, uint16_t *ports)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = xtables_strdup(portstring);
-	if ((cp = strchr(buffer, ':')) == NULL)
-		ports[0] = ports[1] = xtables_parse_port(buffer, NULL);
-	else {
-		*cp = '\0';
-		cp++;
-
-		ports[0] = buffer[0] ? xtables_parse_port(buffer, NULL) : 0;
-		ports[1] = cp[0] ? xtables_parse_port(cp, NULL) : 0xFFFF;
-
-		if (ports[0] > ports[1])
-			xtables_error(PARAMETER_PROBLEM,
-				      "invalid portrange (min > max)");
-	}
-	free(buffer);
-}
+static const struct xt_option_entry brip6_opts[] = {
+	{ .name = "ip6-source",		.id = O_SOURCE, .type = XTTYPE_HOSTMASK,
+	  .flags = XTOPT_INVERT },
+	{ .name = "ip6-src",		.id = O_SOURCE, .type = XTTYPE_HOSTMASK,
+	  .flags = XTOPT_INVERT },
+	{ .name = "ip6-destination",	.id = O_DEST, .type = XTTYPE_HOSTMASK,
+	  .flags = XTOPT_INVERT },
+	{ .name = "ip6-dst",		.id = O_DEST, .type = XTTYPE_HOSTMASK,
+	  .flags = XTOPT_INVERT },
+	{ .name = "ip6-tclass",		.id = O_TCLASS, .type = XTTYPE_UINT8,
+	  .flags = XTOPT_INVERT | XTOPT_PUT,
+	  XTOPT_POINTER(struct ebt_ip6_info, tclass) },
+	{ .name = "ip6-protocol",	.id = O_PROTO, .type = XTTYPE_PROTOCOL,
+	  .flags = XTOPT_INVERT | XTOPT_PUT,
+	  XTOPT_POINTER(struct ebt_ip6_info, protocol) },
+	{ .name = "ip6-proto",		.id = O_PROTO, .type = XTTYPE_PROTOCOL,
+	  .flags = XTOPT_INVERT | XTOPT_PUT,
+	  XTOPT_POINTER(struct ebt_ip6_info, protocol) },
+	{ .name = "ip6-source-port",	.id = O_SPORT, .type = XTTYPE_PORTRC,
+	  .excl = F_PORT, .flags = XTOPT_INVERT | XTOPT_PUT,
+	  XTOPT_POINTER(struct ebt_ip6_info, sport) },
+	{ .name = "ip6-sport",		.id = O_SPORT, .type = XTTYPE_PORTRC,
+	  .excl = F_PORT, .flags = XTOPT_INVERT | XTOPT_PUT,
+	  XTOPT_POINTER(struct ebt_ip6_info, sport) },
+	{ .name = "ip6-destination-port",.id = O_DPORT, .type = XTTYPE_PORTRC,
+	  .excl = F_PORT, .flags = XTOPT_INVERT | XTOPT_PUT,
+	  XTOPT_POINTER(struct ebt_ip6_info, dport) },
+	{ .name = "ip6-dport",		.id = O_DPORT, .type = XTTYPE_PORTRC,
+	  .excl = F_PORT, .flags = XTOPT_INVERT | XTOPT_PUT,
+	  XTOPT_POINTER(struct ebt_ip6_info, dport) },
+	{ .name = "ip6-icmp-type",	.id = O_ICMP6, .type = XTTYPE_STRING,
+	  .excl = F_ICMP6, .flags = XTOPT_INVERT },
+	XTOPT_TABLEEND,
+};
 
 static void print_port_range(uint16_t *ports)
 {
@@ -127,91 +127,42 @@ static void brip6_print_help(void)
 	xt_print_icmp_types(icmpv6_codes, ARRAY_SIZE(icmpv6_codes));
 }
 
-/* wrap xtables_ip6parse_any(), ignoring any but the first returned address */
-static void ebt_parse_ip6_address(char *address,
-				  struct in6_addr *addr, struct in6_addr *msk)
-{
-	struct in6_addr *addrp;
-	unsigned int naddrs;
-
-	xtables_ip6parse_any(address, &addrp, msk, &naddrs);
-	if (naddrs != 1)
-		xtables_error(PARAMETER_PROBLEM,
-			      "Invalid IPv6 Address '%s' specified", address);
-	memcpy(addr, addrp, sizeof(*addr));
-	free(addrp);
-}
-
-#define OPT_SOURCE 0x01
-#define OPT_DEST   0x02
-#define OPT_TCLASS 0x04
-#define OPT_PROTO  0x08
-#define OPT_SPORT  0x10
-#define OPT_DPORT  0x20
-static int
-brip6_parse(int c, char **argv, int invert, unsigned int *flags,
-	   const void *entry, struct xt_entry_match **match)
+static void brip6_parse(struct xt_option_call *cb)
 {
-	struct ebt_ip6_info *info = (struct ebt_ip6_info *)(*match)->data;
+	struct ebt_ip6_info *info = cb->data;
 	unsigned int i;
-	char *end;
-
-	switch (c) {
-	case IP_SOURCE:
-		if (invert)
-			info->invflags |= EBT_IP6_SOURCE;
-		ebt_parse_ip6_address(optarg, &info->saddr, &info->smsk);
-		info->bitmask |= EBT_IP6_SOURCE;
-		break;
-	case IP_DEST:
-		if (invert)
-			info->invflags |= EBT_IP6_DEST;
-		ebt_parse_ip6_address(optarg, &info->daddr, &info->dmsk);
-		info->bitmask |= EBT_IP6_DEST;
-		break;
-	case IP_SPORT:
-		if (invert)
-			info->invflags |= EBT_IP6_SPORT;
-		parse_port_range(NULL, optarg, info->sport);
-		info->bitmask |= EBT_IP6_SPORT;
-		break;
-	case IP_DPORT:
-		if (invert)
-			info->invflags |= EBT_IP6_DPORT;
-		parse_port_range(NULL, optarg, info->dport);
-		info->bitmask |= EBT_IP6_DPORT;
-		break;
-	case IP_ICMP6:
-		if (invert)
-			info->invflags |= EBT_IP6_ICMP6;
-		ebt_parse_icmpv6(optarg, info->icmpv6_type, info->icmpv6_code);
-		info->bitmask |= EBT_IP6_ICMP6;
+
+	/* XXX: overriding afinfo family is dangerous, but
+	 *      required for XTTYPE_HOSTMASK parsing */
+	xtables_set_nfproto(NFPROTO_IPV6);
+	xtables_option_parse(cb);
+	xtables_set_nfproto(NFPROTO_BRIDGE);
+
+	info->bitmask |= 1 << cb->entry->id;
+	info->invflags |= cb->invert ? 1 << cb->entry->id : 0;
+
+	switch (cb->entry->id) {
+	case O_SOURCE:
+		for (i = 0; i < ARRAY_SIZE(cb->val.haddr.all); i++)
+			cb->val.haddr.all[i] &= cb->val.hmask.all[i];
+		info->saddr = cb->val.haddr.in6;
+		info->smsk = cb->val.hmask.in6;
 		break;
-	case IP_TCLASS:
-		if (invert)
-			info->invflags |= EBT_IP6_TCLASS;
-		if (!xtables_strtoui(optarg, &end, &i, 0, 255))
-			xtables_error(PARAMETER_PROBLEM, "Problem with specified IPv6 traffic class '%s'", optarg);
-		info->tclass = i;
-		info->bitmask |= EBT_IP6_TCLASS;
+	case O_DEST:
+		for (i = 0; i < ARRAY_SIZE(cb->val.haddr.all); i++)
+			cb->val.haddr.all[i] &= cb->val.hmask.all[i];
+		info->daddr = cb->val.haddr.in6;
+		info->dmsk = cb->val.hmask.in6;
 		break;
-	case IP_PROTO:
-		if (invert)
-			info->invflags |= EBT_IP6_PROTO;
-		info->protocol = xtables_parse_protocol(optarg);
-		info->bitmask |= EBT_IP6_PROTO;
+	case O_ICMP6:
+		ebt_parse_icmpv6(cb->arg, info->icmpv6_type, info->icmpv6_code);
 		break;
-	default:
-		return 0;
 	}
-
-	*flags |= info->bitmask;
-	return 1;
 }
 
-static void brip6_final_check(unsigned int flags)
+static void brip6_final_check(struct xt_fcheck_call *fc)
 {
-	if (!flags)
+	if (!fc->xflags)
 		xtables_error(PARAMETER_PROBLEM,
 			      "You must specify proper arguments");
 }
@@ -441,11 +392,11 @@ static struct xtables_match brip6_match = {
 	.size		= XT_ALIGN(sizeof(struct ebt_ip6_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ebt_ip6_info)),
 	.help		= brip6_print_help,
-	.parse		= brip6_parse,
-	.final_check	= brip6_final_check,
+	.x6_parse	= brip6_parse,
+	.x6_fcheck	= brip6_final_check,
 	.print		= brip6_print,
 	.xlate		= brip6_xlate,
-	.extra_opts	= brip6_opts,
+	.x6_options	= brip6_opts,
 };
 
 void _init(void)
diff --git a/extensions/libebt_ip6.t b/extensions/libebt_ip6.t
index fa1038af25649..19358431d7ca0 100644
--- a/extensions/libebt_ip6.t
+++ b/extensions/libebt_ip6.t
@@ -2,14 +2,22 @@
 -p ip6 --ip6-src ! dead::beef/64 -j ACCEPT;-p IPv6 --ip6-src ! dead::/64 -j ACCEPT;OK
 -p IPv6 --ip6-dst dead:beef::/64 -j ACCEPT;=;OK
 -p IPv6 --ip6-dst f00:ba::;=;OK
+-p IPv6 --ip6-dst ! f00:ba::;=;OK
+-p IPv6 --ip6-src 10.0.0.1;;FAIL
 -p IPv6 --ip6-tclass 0xFF;=;OK
+-p IPv6 --ip6-tclass ! 0xFF;=;OK
 -p IPv6 --ip6-proto tcp --ip6-dport 22;=;OK
 -p IPv6 --ip6-proto tcp --ip6-dport ! 22;=;OK
+-p IPv6 --ip6-proto tcp --ip6-sport ! 22 --ip6-dport 22;=;OK
 -p IPv6 --ip6-proto udp --ip6-sport 1024:65535;=;OK
 -p IPv6 --ip6-proto 253;=;OK
+-p IPv6 --ip6-proto ! 253;=;OK
 -p IPv6 --ip6-proto ipv6-icmp --ip6-icmp-type echo-request -j CONTINUE;=;OK
 -p IPv6 --ip6-proto ipv6-icmp --ip6-icmp-type echo-request;=;OK
+-p IPv6 --ip6-proto ipv6-icmp --ip6-icmp-type ! echo-request;=;OK
 -p ip6 --ip6-protocol icmpv6 --ip6-icmp-type 1/1;-p IPv6 --ip6-proto ipv6-icmp --ip6-icmp-type communication-prohibited -j CONTINUE;OK
 -p IPv6 --ip6-proto ipv6-icmp --ip6-icmp-type ! 1:10/0:255;=;OK
 --ip6-proto ipv6-icmp ! --ip6-icmp-type 1:10/0:255;=;FAIL
 ! -p IPv6 --ip6-proto ipv6-icmp ! --ip6-icmp-type 1:10/0:255;=;FAIL
+-p IPv6 --ip6-proto tcp --ip6-sport 22 --ip6-icmp-type echo-request;;FAIL
+-p IPv6 --ip6-proto tcp --ip6-dport 22 --ip6-icmp-type echo-request;;FAIL
-- 
2.43.0

