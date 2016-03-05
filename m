From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH] extensions: libip6t_icmp6: Add translation to nft
Date: Sat, 5 Mar 2016 20:13:58 +0100
Message-ID: <20160305191355.GA11228@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: shivanib134@gmail.com, pablo@netfilter.org,
	outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36639 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbcCETOD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Mar 2016 14:14:03 -0500
Received: by mail-wm0-f46.google.com with SMTP id n186so33419698wmn.1
        for <netfilter-devel@vger.kernel.org>; Sat, 05 Mar 2016 11:14:02 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for icmpv6 to nftables.

Examples:

$ ip6tables-translate -t filter -A INPUT -m icmp6 --icmpv6-type 1 -j LOG
nft add rule ip6 filter INPUT icmpv6 type destination-unreachable counter log level warn

$ ip6tables-translate -t filter -A INPUT -m icmp6 --icmpv6-type 1/3 -j LOG
nft add rule ip6 filter INPUT icmpv6 type address-unreachable counter log level warn

$ ip6tables-translate -t filter -A INPUT -m icmp6 ! --icmpv6-type 2 -j LOG
nft add rule ip6 filter INPUT icmpv6 type != packet-too-big counter log level warn

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 extensions/libip6t_icmp6.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index e183ce6..a6a76c3 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -222,6 +222,35 @@ static void icmp6_save(const void *ip, const struct xt_entry_match *match)
 		printf("/%u", icmpv6->code[0]);
 }
 
+static void type_xlate_print(struct xt_xlate *xl, unsigned int icmptype,
+			     unsigned int code_min, unsigned int code_max)
+{
+	unsigned int i;
+
+	for (i = 0; ARRAY_SIZE(icmpv6_codes); i++)
+		if (icmpv6_codes[i].type == icmptype &&
+		    icmpv6_codes[i].code_min == code_min &&
+		    icmpv6_codes[i].code_max == code_max)
+			break;
+
+	xt_xlate_add(xl, icmpv6_codes[i].name);
+}
+
+static int icmp6_xlate(const struct xt_entry_match *match, struct xt_xlate *xl,
+		       int numeric)
+{
+	const struct ip6t_icmp *info = (struct ip6t_icmp *)match->data;
+
+	xt_xlate_add(xl, "icmpv6 type%s ",
+		     (info->invflags & IP6T_ICMP_INV)? " !=" : "");
+
+	type_xlate_print(xl, info->type, info->code[0], info->code[1]);
+
+	xt_xlate_add(xl, " ");
+
+	return 1;
+}
+
 static struct xtables_match icmp6_mt6_reg = {
 	.name 		= "icmp6",
 	.version 	= XTABLES_VERSION,
@@ -234,6 +263,7 @@ static struct xtables_match icmp6_mt6_reg = {
 	.save		= icmp6_save,
 	.x6_parse	= icmp6_parse,
 	.x6_options	= icmp6_opts,
+	.xlate		= icmp6_xlate,
 };
 
 void _init(void)
-- 
2.7.0

