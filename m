From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCHv6] extensions: libipt_icmp: Add translation to nft
Date: Sat, 12 Mar 2016 17:54:34 +0100
Message-ID: <20160312165431.GA12984@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: shivanib134@gmail.com, pablo@netfilter.org,
	outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:33089 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbcCLQyj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Mar 2016 11:54:39 -0500
Received: by mail-wm0-f41.google.com with SMTP id l68so53410405wml.0
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2016 08:54:38 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for icmp to nftables. Not supported icmp codes in nftables
are: network-unreachable, host-unreachable, protocol-unreachable,
port-unreachable, fragmentation-needed, source-route-failed,
network-unknown, host-unknown, network-prohibited, host-prohibited,
TOS-network-unreachable, TOS-host-unreachable, communication-prohibited,
host-precedence-violation, precedence-cutoff, network-redirect,
host-redirect, TOS-network-redirect, TOS-host-redirect,
ttl-zero-during-transit, ttl-zero-during-reassembly, ip-header-bad and required-option-missing.

Examples:

$ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type echo-reply -j ACCEPT
nft add rule ip filter INPUT icmp type echo-reply counter accept

$ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type 3 -j ACCEPT
nft add rule ip filter INPUT icmp type destination-unreachable counter accept

$ sudo iptables-translate -t filter -A INPUT -m icmp ! --icmp-type 3 -j ACCEPT
nft add rule ip filter INPUT icmp type != destination-unreachable counter accept

In the case of '--icmp-type any' there is no type to translate, nft only
has to check the icmp header. This is currently not supported in nft.

$ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type any -j ACCEPT
nft add rule ip filter INPUT icmp counter accept


Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
v2:
	- Detection of not supported types in nftables, as Shivani suggested.
v3:
	- Fix array iteration protection.
v4:
	- icmp types router-advertisement and router-solicitation already supported in nft.
v5:
	- Update commit message with the correct not supported codes.
v6:
	- No type to translate with 'any'.

 extensions/libipt_icmp.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 666e7da..2238b19 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -249,6 +249,46 @@ static void icmp_save(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
+static unsigned int type_xlate_print(struct xt_xlate *xl, unsigned int icmptype,
+				     unsigned int code_min,
+				     unsigned int code_max)
+{
+	unsigned int i;
+
+	if (code_min != code_max) {
+		for (i = 0; i < ARRAY_SIZE(icmp_codes); ++i)
+			if (icmp_codes[i].type == icmptype &&
+			    icmp_codes[i].code_min == code_min &&
+			    icmp_codes[i].code_max == code_max) {
+				xt_xlate_add(xl, icmp_codes[i].name);
+				return 1;
+			}
+	}
+
+	return 0;
+}
+
+static int icmp_xlate(const void *ip, const struct xt_entry_match *match,
+		      struct xt_xlate *xl, int numeric)
+{
+	const struct ipt_icmp *info = (struct ipt_icmp *)match->data;
+
+	if (info->type == 0xFF) {
+		xt_xlate_add(xl, "icmp");
+	} else {
+		xt_xlate_add(xl, "icmp type%s ",
+			     (info->invflags & IPT_ICMP_INV) ? " !=" : "");
+
+		if (!type_xlate_print(xl, info->type, info->code[0],
+				      info->code[1]))
+			return 0;
+	}
+
+	xt_xlate_add(xl, " ");
+
+	return 1;
+}
+
 static struct xtables_match icmp_mt_reg = {
 	.name		= "icmp",
 	.version	= XTABLES_VERSION,
@@ -261,6 +301,7 @@ static struct xtables_match icmp_mt_reg = {
 	.save		= icmp_save,
 	.x6_parse	= icmp_parse,
 	.x6_options	= icmp_opts,
+	.xlate		= icmp_xlate,
 };
 
 void _init(void)
-- 
2.7.0

