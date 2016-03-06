From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCHv2] extensions: libip6t_icmp6: Add translation to nft
Date: Sun, 6 Mar 2016 23:23:10 +0100
Message-ID: <20160306222308.GA20846@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: shivanib134@gmail.com, pablo@netfilter.org,
	outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38182 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbcCFWXP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Mar 2016 17:23:15 -0500
Received: by mail-wm0-f46.google.com with SMTP id l68so50648759wml.1
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Mar 2016 14:23:15 -0800 (PST)
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

 extensions/libip6t_icmp6.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index e183ce6..70f9c21 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -222,6 +222,58 @@ static void icmp6_save(const void *ip, const struct xt_entry_match *match)
 		printf("/%u", icmpv6->code[0]);
 }
 
+static unsigned int type_xlate_print(struct xt_xlate *xl, unsigned int icmptype,
+			     unsigned int code_min, unsigned int code_max)
+{
+	unsigned int i;
+
+	if (code_min == code_max)
+		return 0;
+
+	switch (icmptype) {
+	case 133:
+		xt_xlate_add(xl, "nd-router-solicit");
+		break;
+	case 134:
+		xt_xlate_add(xl, "nd-router-advert");
+		break;
+	case 135:
+		xt_xlate_add(xl, "nd-neighbor-solicit");
+		break;
+	case 136:
+		xt_xlate_add(xl, "nd-neighbor-advert");
+		break;
+	case 137:
+		xt_xlate_add(xl, "nd-redirect");
+		break;
+	default:
+		for (i = 0; ARRAY_SIZE(icmpv6_codes); ++i)
+			if (icmpv6_codes[i].type == icmptype &&
+			    icmpv6_codes[i].code_min == code_min &&
+			    icmpv6_codes[i].code_max == code_max)
+				break;
+			xt_xlate_add(xl, icmpv6_codes[i].name);
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
@@ -234,6 +286,7 @@ static struct xtables_match icmp6_mt6_reg = {
 	.save		= icmp6_save,
 	.x6_parse	= icmp6_parse,
 	.x6_options	= icmp6_opts,
+	.xlate		= icmp6_xlate,
 };
 
 void _init(void)
-- 
2.7.0

