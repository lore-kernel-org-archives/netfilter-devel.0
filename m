Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89378482C9
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="oCvwXzJ+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dL1fm3QaBD6n6xte56rsz+FqYY6W0F6kEc/Glof3g7Y=; b=oCvwXzJ+SSQ3RSy7uWy1OY7xN1
	mdTVEImy0XSUjzetTUB3I15OvJdrlcWYMt4ornDxYzIB9FRRc46BAmuqQmYSXSubTHyDkt6ltH6+B
	lhTrQ7BGoupQNNFIiAcrxX99KEpfTaJzuM72d8xQ44GQqv5dn1oZ9BHkhftNhrmjRFeLIdEJ4xwW3
	/mdsioz6ME5kRXN1qoXw6FsxR3dQ86VvNWNOgopIvBrMuKCjByCliioy+EyPtgYraEuCykEPvUV9I
	Efaa7IfRNpJ8sYGgCEUpef/g9qbYjRSPAbMH67akOKmO7zPR/cdRMaQy1k+9xPfZwJlbqrxxhtGKi
	6suwSjDQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rFz5m-0004Kr-Si
	for netfilter-devel@vger.kernel.org; Wed, 20 Dec 2023 17:06:42 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 11/23] extensions: libebt_ip: Use guided option parser
Date: Wed, 20 Dec 2023 17:06:24 +0100
Message-ID: <20231220160636.11778-12-phil@nwl.cc>
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
 extensions/libebt_ip.c | 199 ++++++++++++++++-------------------------
 extensions/libebt_ip.t |   8 ++
 2 files changed, 84 insertions(+), 123 deletions(-)

diff --git a/extensions/libebt_ip.c b/extensions/libebt_ip.c
index 97ec4160942da..350dbcb6abb09 100644
--- a/extensions/libebt_ip.c
+++ b/extensions/libebt_ip.c
@@ -16,7 +16,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <getopt.h>
 #include <netdb.h>
 #include <inttypes.h>
 #include <xtables.h>
@@ -24,30 +23,56 @@
 
 #include "libxt_icmp.h"
 
-#define IP_SOURCE	'1'
-#define IP_DEST		'2'
-#define IP_EBT_TOS	'3' /* include/bits/in.h seems to already define IP_TOS */
-#define IP_PROTO	'4'
-#define IP_SPORT	'5'
-#define IP_DPORT	'6'
-#define IP_EBT_ICMP	'7'
-#define IP_EBT_IGMP	'8'
-
-static const struct option brip_opts[] = {
-	{ .name = "ip-source",		.has_arg = true, .val = IP_SOURCE },
-	{ .name = "ip-src",		.has_arg = true, .val = IP_SOURCE },
-	{ .name = "ip-destination",	.has_arg = true, .val = IP_DEST },
-	{ .name = "ip-dst",		.has_arg = true, .val = IP_DEST },
-	{ .name = "ip-tos",		.has_arg = true, .val = IP_EBT_TOS },
-	{ .name = "ip-protocol",	.has_arg = true, .val = IP_PROTO },
-	{ .name = "ip-proto",		.has_arg = true, .val = IP_PROTO },
-	{ .name = "ip-source-port",	.has_arg = true, .val = IP_SPORT },
-	{ .name = "ip-sport",		.has_arg = true, .val = IP_SPORT },
-	{ .name = "ip-destination-port",.has_arg = true, .val = IP_DPORT },
-	{ .name = "ip-dport",		.has_arg = true, .val = IP_DPORT },
-	{ .name = "ip-icmp-type",       .has_arg = true, .val = IP_EBT_ICMP },
-	{ .name = "ip-igmp-type",       .has_arg = true, .val = IP_EBT_IGMP },
-	XT_GETOPT_TABLEEND,
+/* must correspond to the bit position in EBT_IP6_* defines */
+enum {
+	O_SOURCE = 0,
+	O_DEST,
+	O_TOS,
+	O_PROTO,
+	O_SPORT,
+	O_DPORT,
+	O_ICMP,
+	O_IGMP,
+	F_PORT = 1 << O_ICMP | 1 << O_IGMP,
+	F_ICMP = 1 << O_SPORT | 1 << O_DPORT | 1 << O_IGMP,
+	F_IGMP = 1 << O_SPORT | 1 << O_DPORT | 1 << O_ICMP,
+};
+
+static const struct xt_option_entry brip_opts[] = {
+	{ .name = "ip-source",		.id = O_SOURCE, .type = XTTYPE_HOSTMASK,
+	  .flags = XTOPT_INVERT },
+	{ .name = "ip-src",		.id = O_SOURCE, .type = XTTYPE_HOSTMASK,
+	  .flags = XTOPT_INVERT },
+	{ .name = "ip-destination",	.id = O_DEST, .type = XTTYPE_HOSTMASK,
+	  .flags = XTOPT_INVERT },
+	{ .name = "ip-dst",		.id = O_DEST, .type = XTTYPE_HOSTMASK,
+	  .flags = XTOPT_INVERT },
+	{ .name = "ip-tos",		.id = O_TOS, .type = XTTYPE_UINT8,
+	  .flags = XTOPT_INVERT | XTOPT_PUT,
+	  XTOPT_POINTER(struct ebt_ip_info, tos) },
+	{ .name = "ip-protocol",	.id = O_PROTO, .type = XTTYPE_PROTOCOL,
+	  .flags = XTOPT_INVERT | XTOPT_PUT,
+	  XTOPT_POINTER(struct ebt_ip_info, protocol) },
+	{ .name = "ip-proto",		.id = O_PROTO, .type = XTTYPE_PROTOCOL,
+	  .flags = XTOPT_INVERT | XTOPT_PUT,
+	  XTOPT_POINTER(struct ebt_ip_info, protocol) },
+	{ .name = "ip-source-port",	.id = O_SPORT, .type = XTTYPE_PORTRC,
+	  .excl = F_PORT, .flags = XTOPT_INVERT | XTOPT_PUT,
+	  XTOPT_POINTER(struct ebt_ip_info, sport) },
+	{ .name = "ip-sport",		.id = O_SPORT, .type = XTTYPE_PORTRC,
+	  .excl = F_PORT, .flags = XTOPT_INVERT | XTOPT_PUT,
+	  XTOPT_POINTER(struct ebt_ip_info, sport) },
+	{ .name = "ip-destination-port",.id = O_DPORT, .type = XTTYPE_PORTRC,
+	  .excl = F_PORT, .flags = XTOPT_INVERT | XTOPT_PUT,
+	  XTOPT_POINTER(struct ebt_ip_info, dport) },
+	{ .name = "ip-dport",		.id = O_DPORT, .type = XTTYPE_PORTRC,
+	  .excl = F_PORT, .flags = XTOPT_INVERT | XTOPT_PUT,
+	  XTOPT_POINTER(struct ebt_ip_info, dport) },
+	{ .name = "ip-icmp-type",       .id = O_ICMP, .type = XTTYPE_STRING,
+	  .excl = F_ICMP, .flags = XTOPT_INVERT },
+	{ .name = "ip-igmp-type",       .id = O_IGMP, .type = XTTYPE_STRING,
+	  .excl = F_IGMP, .flags = XTOPT_INVERT },
+	XTOPT_TABLEEND,
 };
 
 static void brip_print_help(void)
@@ -69,30 +94,6 @@ static void brip_print_help(void)
 	xt_print_icmp_types(igmp_types, ARRAY_SIZE(igmp_types));
 }
 
-static void
-parse_port_range(const char *protocol, const char *portstring, uint16_t *ports)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = xtables_strdup(portstring);
-
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
-
 /* original code from ebtables: useful_functions.c */
 static void print_icmp_code(uint8_t *code)
 {
@@ -130,86 +131,38 @@ static void ebt_print_icmp_type(const struct xt_icmp_names *codes,
 	print_icmp_code(code);
 }
 
-static int
-brip_parse(int c, char **argv, int invert, unsigned int *flags,
-	   const void *entry, struct xt_entry_match **match)
+static void brip_parse(struct xt_option_call *cb)
 {
-	struct ebt_ip_info *info = (struct ebt_ip_info *)(*match)->data;
-	struct in_addr *ipaddr, ipmask;
-	unsigned int ipnr;
-
-	switch (c) {
-	case IP_SOURCE:
-		if (invert)
-			info->invflags |= EBT_IP_SOURCE;
-		xtables_ipparse_any(optarg, &ipaddr, &ipmask, &ipnr);
-		info->saddr = ipaddr->s_addr;
-		info->smsk = ipmask.s_addr;
-		free(ipaddr);
-		info->bitmask |= EBT_IP_SOURCE;
-		break;
-	case IP_DEST:
-		if (invert)
-			info->invflags |= EBT_IP_DEST;
-		xtables_ipparse_any(optarg, &ipaddr, &ipmask, &ipnr);
-		info->daddr = ipaddr->s_addr;
-		info->dmsk = ipmask.s_addr;
-		free(ipaddr);
-		info->bitmask |= EBT_IP_DEST;
-		break;
-	case IP_SPORT:
-		if (invert)
-			info->invflags |= EBT_IP_SPORT;
-		parse_port_range(NULL, optarg, info->sport);
-		info->bitmask |= EBT_IP_SPORT;
-		break;
-	case IP_DPORT:
-		if (invert)
-			info->invflags |= EBT_IP_DPORT;
-		parse_port_range(NULL, optarg, info->dport);
-		info->bitmask |= EBT_IP_DPORT;
-		break;
-	case IP_EBT_ICMP:
-		if (invert)
-			info->invflags |= EBT_IP_ICMP;
-		ebt_parse_icmp(optarg, info->icmp_type, info->icmp_code);
-		info->bitmask |= EBT_IP_ICMP;
+	struct ebt_ip_info *info = cb->data;
+
+	xtables_option_parse(cb);
+
+	info->bitmask |= 1 << cb->entry->id;
+	info->invflags |= cb->invert ? 1 << cb->entry->id : 0;
+
+	switch (cb->entry->id) {
+	case O_SOURCE:
+		cb->val.haddr.all[0] &= cb->val.hmask.all[0];
+		info->saddr = cb->val.haddr.ip;
+		info->smsk = cb->val.hmask.ip;
 		break;
-	case IP_EBT_IGMP:
-		if (invert)
-			info->invflags |= EBT_IP_IGMP;
-		ebt_parse_igmp(optarg, info->igmp_type);
-		info->bitmask |= EBT_IP_IGMP;
+	case O_DEST:
+		cb->val.haddr.all[0] &= cb->val.hmask.all[0];
+		info->daddr = cb->val.haddr.ip;
+		info->dmsk = cb->val.hmask.ip;
 		break;
-	case IP_EBT_TOS: {
-		uintmax_t tosvalue;
-
-		if (invert)
-			info->invflags |= EBT_IP_TOS;
-		if (!xtables_strtoul(optarg, NULL, &tosvalue, 0, 255))
-			xtables_error(PARAMETER_PROBLEM,
-				      "Problem with specified IP tos");
-		info->tos = tosvalue;
-		info->bitmask |= EBT_IP_TOS;
-	}
+	case O_ICMP:
+		ebt_parse_icmp(cb->arg, info->icmp_type, info->icmp_code);
 		break;
-	case IP_PROTO:
-		if (invert)
-			info->invflags |= EBT_IP_PROTO;
-		info->protocol = xtables_parse_protocol(optarg);
-		info->bitmask |= EBT_IP_PROTO;
+	case O_IGMP:
+		ebt_parse_igmp(cb->arg, info->igmp_type);
 		break;
-	default:
-		return 0;
 	}
-
-	*flags |= info->bitmask;
-	return 1;
 }
 
-static void brip_final_check(unsigned int flags)
+static void brip_final_check(struct xt_fcheck_call *fc)
 {
-	if (!flags)
+	if (!fc->xflags)
 		xtables_error(PARAMETER_PROBLEM,
 			      "You must specify proper arguments");
 }
@@ -496,11 +449,11 @@ static struct xtables_match brip_match = {
 	.size		= XT_ALIGN(sizeof(struct ebt_ip_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ebt_ip_info)),
 	.help		= brip_print_help,
-	.parse		= brip_parse,
-	.final_check	= brip_final_check,
+	.x6_parse	= brip_parse,
+	.x6_fcheck	= brip_final_check,
 	.print		= brip_print,
 	.xlate		= brip_xlate,
-	.extra_opts	= brip_opts,
+	.x6_options	= brip_opts,
 };
 
 void _init(void)
diff --git a/extensions/libebt_ip.t b/extensions/libebt_ip.t
index 8be5dfbb22309..f6012df4c264e 100644
--- a/extensions/libebt_ip.t
+++ b/extensions/libebt_ip.t
@@ -1,13 +1,21 @@
 :INPUT,FORWARD,OUTPUT
 -p ip --ip-src ! 192.168.0.0/24 -j ACCEPT;-p IPv4 --ip-src ! 192.168.0.0/24 -j ACCEPT;OK
 -p IPv4 --ip-dst 10.0.0.1;=;OK
+-p IPv4 --ip-dst ! 10.0.0.1;=;OK
 -p IPv4 --ip-tos 0xFF;=;OK
 -p IPv4 --ip-tos ! 0xFF;=;OK
 -p IPv4 --ip-proto tcp --ip-dport 22;=;OK
 -p IPv4 --ip-proto udp --ip-sport 1024:65535;=;OK
 -p IPv4 --ip-proto 253;=;OK
+-p IPv4 --ip-proto ! 253;=;OK
 -p IPv4 --ip-proto icmp --ip-icmp-type echo-request;=;OK
 -p IPv4 --ip-proto icmp --ip-icmp-type 1/1;=;OK
 -p ip --ip-protocol icmp --ip-icmp-type ! 1:10;-p IPv4 --ip-proto icmp --ip-icmp-type ! 1:10/0:255 -j CONTINUE;OK
 --ip-proto icmp --ip-icmp-type 1/1;=;FAIL
 ! -p ip --ip-proto icmp --ip-icmp-type 1/1;=;FAIL
+! -p ip --ip-proto tcp --ip-sport 22 --ip-icmp-type echo-reply;;FAIL
+! -p ip --ip-proto tcp --ip-sport 22 --ip-igmp-type membership-query;;FAIL
+! -p ip --ip-proto tcp --ip-dport 22 --ip-icmp-type echo-reply;;FAIL
+! -p ip --ip-proto tcp --ip-dport 22 --ip-igmp-type membership-query;;FAIL
+! -p ip --ip-proto icmp --ip-icmp-type echo-reply --ip-igmp-type membership-query;;FAIL
+-p IPv4 --ip-proto icmp --ip-icmp-type ! echo-reply;=;OK
-- 
2.43.0

