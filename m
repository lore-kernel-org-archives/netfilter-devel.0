From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH] extensions: libipt_icmp: Add translation to nft
Date: Sat, 5 Mar 2016 21:00:41 +0100
Message-ID: <20160305200039.GA14269@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: shivanib134@gmail.com, pablo@netfilter.org,
	outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38618 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbcCEUAq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Mar 2016 15:00:46 -0500
Received: by mail-wm0-f48.google.com with SMTP id l68so28418685wml.1
        for <netfilter-devel@vger.kernel.org>; Sat, 05 Mar 2016 12:00:45 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for icmp to nftables.

Examples:

$ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type any -j LOG
nft add rule ip filter INPUT icmp type any counter log level warn

$ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type 3/1 -j LOG
nft add rule ip filter INPUT icmp type host-unreachable counter log level warn

$ sudo iptables-translate -t filter -A INPUT -m icmp ! --icmp-type 3 -j LOG
nft add rule ip filter INPUT icmp type != destination-unreachable counter log level warn

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 extensions/libipt_icmp.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 666e7da..795172f 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -218,7 +218,7 @@ static void print_icmptype(uint8_t type,
 }
 
 static void icmp_print(const void *ip, const struct xt_entry_match *match,
-                       int numeric)
+		       int numeric)
 {
 	const struct ipt_icmp *icmp = (struct ipt_icmp *)match->data;
 
@@ -249,6 +249,36 @@ static void icmp_save(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
+static void type_xlate_print(struct xt_xlate *xl, unsigned int icmptype,
+			     unsigned int code_min, unsigned int code_max)
+{
+	unsigned int i;
+
+	for (i = 0; ARRAY_SIZE(icmp_codes); i++)
+		if (icmp_codes[i].type == icmptype &&
+		    icmp_codes[i].code_min == code_min &&
+		    icmp_codes[i].code_max == code_max)
+			break;
+
+	xt_xlate_add(xl, icmp_codes[i].name);
+}
+
+static int icmp_xlate(const struct xt_entry_match *match, struct xt_xlate *xl,
+		       int numeric)
+{
+	const struct ipt_icmp *info = (struct ipt_icmp *)match->data;
+
+	xt_xlate_add(xl, "icmp type%s ",
+		     (info->invflags & IPT_ICMP_INV) ? " !=" : "");
+
+	type_xlate_print(xl, info->type, info->code[0], info->code[1]);
+
+	xt_xlate_add(xl, " ");
+
+	return 1;
+}
+
+
 static struct xtables_match icmp_mt_reg = {
 	.name		= "icmp",
 	.version	= XTABLES_VERSION,
@@ -261,6 +291,7 @@ static struct xtables_match icmp_mt_reg = {
 	.save		= icmp_save,
 	.x6_parse	= icmp_parse,
 	.x6_options	= icmp_opts,
+	.xlate		= icmp_xlate,
 };
 
 void _init(void)
-- 
2.7.0

