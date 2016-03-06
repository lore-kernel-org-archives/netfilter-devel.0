From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCHv2] extensions: libipt_icmp: Add translation to nft
Date: Sun, 6 Mar 2016 23:24:44 +0100
Message-ID: <20160306222442.GA20945@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: shivanib134@gmail.com, pablo@netfilter.org,
	outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:38766 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbcCFWYs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Mar 2016 17:24:48 -0500
Received: by mail-wm0-f42.google.com with SMTP id l68so50671229wml.1
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Mar 2016 14:24:47 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for icmp to nftables. Not supported types in nftables
are: any, network-unreachable, host-unreachable, protocol-unreachable,
port-unreachable, fragmentation-needed, source-route-failed,
network-unknown, host-unknown, network-prohibited, host-prohibited,
TOS-network-unreachable, TOS-host-unreachable, communication-prohibited,
host-precedence-violation, precedence-cutoff, network-redirect,
host-redirect, TOS-network-redirect, TOS-host-redirect,
router-advertisement, router-solicitation, ttl-zero-during-transit,
ttl-zero-during-reassembly, ip-header-bad and required-option-missing.

Examples:

$ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type echo-reply -j LOG
nft add rule ip filter INPUT icmp type echo-reply counter log level warn

$ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type 3 -j LOG
nft add rule ip filter INPUT icmp type destination-unreachable counter log level warn

$ sudo iptables-translate -t filter -A INPUT -m icmp ! --icmp-type 3 -j LOG
nft add rule ip filter INPUT icmp type != destination-unreachable counter log level warn

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
v2:
	- Detection of not supported types in nftables, as Shivani suggested.

 extensions/libipt_icmp.c | 46 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 666e7da..89eb36e 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -218,7 +218,7 @@ static void print_icmptype(uint8_t type,
 }
 
 static void icmp_print(const void *ip, const struct xt_entry_match *match,
-                       int numeric)
+		       int numeric)
 {
 	const struct ipt_icmp *icmp = (struct ipt_icmp *)match->data;
 
@@ -249,6 +249,49 @@ static void icmp_save(const void *ip, const struct xt_entry_match *match)
 	}
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
+	case 0xFF:
+	case 9:
+	case 10:
+		return 0;
+	default:
+		for (i = 0; ARRAY_SIZE(icmp_codes); ++i)
+			if (icmp_codes[i].type == icmptype &&
+			    icmp_codes[i].code_min == code_min &&
+			    icmp_codes[i].code_max == code_max)
+				break;
+
+			xt_xlate_add(xl, icmp_codes[i].name);
+	}
+
+	return 1;
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
+	if (!type_xlate_print(xl, info->type, info->code[0], info->code[1]))
+		return 0;
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
@@ -261,6 +304,7 @@ static struct xtables_match icmp_mt_reg = {
 	.save		= icmp_save,
 	.x6_parse	= icmp_parse,
 	.x6_options	= icmp_opts,
+	.xlate		= icmp_xlate,
 };
 
 void _init(void)
-- 
2.7.0

