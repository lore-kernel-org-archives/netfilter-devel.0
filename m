From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCHv3] extensions: libip6t_icmp6: Add translation to nft
Date: Mon, 7 Mar 2016 22:22:55 +0100
Message-ID: <20160307212252.GA10639@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: shivanib134@gmail.com, pablo@netfilter.org,
	outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38118 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbcCGVW7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 16:22:59 -0500
Received: by mail-wm0-f43.google.com with SMTP id l68so2750893wml.1
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Mar 2016 13:22:58 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for icmpv6 to nftables. Not supported types in nftables
are: no-route, communication-prohibited, beyond-scope,
address-unreachable, port-unreachable, failed-policy, reject-route,
ttl-zero-during-transit, ttl-zero-during-reassembly, bad-header,
unknown-header-type and unknown-option.

Examples:

$ ip6tables-translate -t filter -A INPUT -m icmp6 --icmpv6-type 1 -j LOG
nft add rule ip6 filter INPUT icmpv6 type destination-unreachable counter log level warn

$ ip6tables-translate -t filter -A INPUT -m icmp6 --icmpv6-type neighbour-advertisement -j LOG
nft add rule ip6 filter INPUT icmpv6 type nd-neighbor-advert counter log level warn

$ ip6tables-translate -t filter -A INPUT -m icmp6 ! --icmpv6-type packet-too-big -j LOG
nft add rule ip6 filter INPUT icmpv6 type != packet-too-big counter log level warn

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
v2:
	- Detection of not supported types in nftables, as Shivani suggested.
v3:
	- Generalize the source code, as Pablo suggested.

 extensions/libip6t_icmp6.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index e183ce6..08eca99 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -4,6 +4,9 @@
 #include <xtables.h>
 #include <limits.h> /* INT_MAX in ip6_tables.h */
 #include <linux/netfilter_ipv6/ip6_tables.h>
+#include <netinet/icmp6.h>
+
+#define XT_ICMPV6_TYPE(type)	(type - ND_ROUTER_SOLICIT)
 
 enum {
 	O_ICMPV6_TYPE = 0,
@@ -15,6 +18,14 @@ struct icmpv6_names {
 	uint8_t code_min, code_max;
 };
 
+static const char *icmp6_type_xlate_array[] = {
+	[XT_ICMPV6_TYPE(ND_ROUTER_SOLICIT)]	= "nd-router-solicit",
+	[XT_ICMPV6_TYPE(ND_ROUTER_ADVERT)]	= "nd-router-advert",
+	[XT_ICMPV6_TYPE(ND_NEIGHBOR_SOLICIT)]	= "nd-neighbor-solicit",
+	[XT_ICMPV6_TYPE(ND_NEIGHBOR_ADVERT)]	= "nd-neighbor-advert",
+	[XT_ICMPV6_TYPE(ND_REDIRECT)]		= "nd-redirect",
+};
+
 static const struct icmpv6_names icmpv6_codes[] = {
 	{ "destination-unreachable", 1, 0, 0xFF },
 	{   "no-route", 1, 0, 0 },
@@ -222,6 +233,59 @@ static void icmp6_save(const void *ip, const struct xt_entry_match *match)
 		printf("/%u", icmpv6->code[0]);
 }
 
+static const char *icmp6_type_xlate(unsigned int type)
+{
+	if (type < ND_ROUTER_SOLICIT || type > ND_REDIRECT)
+		return NULL;
+
+	return icmp6_type_xlate_array[XT_ICMPV6_TYPE(type)];
+}
+
+static unsigned int type_xlate_print(struct xt_xlate *xl, unsigned int icmptype,
+			     unsigned int code_min, unsigned int code_max)
+{
+	unsigned int i;
+	const char *type_name;
+
+	if (code_min == code_max)
+		return 0;
+
+	type_name = icmp6_type_xlate(icmptype);
+
+	if (type_name) {
+		xt_xlate_add(xl, type_name);
+	} else {
+		for (i = 0; i < ARRAY_SIZE(icmpv6_codes); ++i)
+			if (icmpv6_codes[i].type == icmptype &&
+			    icmpv6_codes[i].code_min == code_min &&
+			    icmpv6_codes[i].code_max == code_max)
+				break;
+
+		if (i != ARRAY_SIZE(icmpv6_codes))
+			xt_xlate_add(xl, icmpv6_codes[i].name);
+		else
+			return 0;
+	}
+
+	return 1;
+}
+
+static int icmp6_xlate(const struct xt_entry_match *match, struct xt_xlate *xl,
+		       int numeric)
+{
+	const struct ip6t_icmp *info = (struct ip6t_icmp *)match->data;
+
+	xt_xlate_add(xl, "icmpv6 type%s ",
+		     (info->invflags & IP6T_ICMP_INV) ? " !=" : "");
+
+	if (!type_xlate_print(xl, info->type, info->code[0], info->code[1]))
+		return 0;
+
+	xt_xlate_add(xl, " ");
+
+	return 1;
+}
+
 static struct xtables_match icmp6_mt6_reg = {
 	.name 		= "icmp6",
 	.version 	= XTABLES_VERSION,
@@ -234,6 +298,7 @@ static struct xtables_match icmp6_mt6_reg = {
 	.save		= icmp6_save,
 	.x6_parse	= icmp6_parse,
 	.x6_options	= icmp6_opts,
+	.xlate		= icmp6_xlate,
 };
 
 void _init(void)
-- 
2.7.0

