From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libipt_REJECT: Add translation to nft
Date: Sun, 27 Dec 2015 10:12:48 +0530
Message-ID: <20151227044248.GA5043@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34326 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbbL0Emz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Dec 2015 23:42:55 -0500
Received: by mail-pa0-f44.google.com with SMTP id uo6so71753210pac.1
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Dec 2015 20:42:55 -0800 (PST)
Received: from gmail.com ([106.196.170.223])
        by smtp.gmail.com with ESMTPSA id r83sm6609054pfa.13.2015.12.26.20.42.52
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sat, 26 Dec 2015 20:42:54 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for target REJECT to nftables.

Examples:

$ sudo iptables-translate -A FORWARD -p TCP --dport 22 -j REJECT
nft add rule ip filter FORWARD tcp dport 22 counter reject with icmp type port-unreachable

$ sudo iptables-translate -A FORWARD -p TCP --dport 22 -j REJECT --reject-with icmp-net-unreachable
nft add rule ip filter FORWARD tcp dport 22 counter reject with icmp type net-unreachable

$ sudo iptables-translate -A FORWARD -p TCP --dport 22 -j REJECT --reject-with tcp-reset
nft add rule ip filter FORWARD tcp dport 22 counter reject with tcp reset

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libipt_REJECT.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index 362c65e..28dd6b6 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -24,6 +24,11 @@ struct reject_names {
 	const char *desc;
 };
 
+struct reject_names_xlate {
+	const char *name;
+	enum ipt_reject_with with;
+};
+
 enum {
 	O_REJECT_WITH = 0,
 };
@@ -140,6 +145,42 @@ static void REJECT_save(const void *ip, const struct xt_entry_target *target)
 	printf(" --reject-with %s", reject_table[i].name);
 }
 
+static const struct reject_names_xlate reject_table_xlate[] = {
+	{"net-unreachable",	IPT_ICMP_NET_UNREACHABLE},
+	{"host-unreachable",	IPT_ICMP_HOST_UNREACHABLE},
+	{"prot-unreachable",	IPT_ICMP_PROT_UNREACHABLE},
+	{"port-unreachable",	IPT_ICMP_PORT_UNREACHABLE},
+#if 0
+	{"echo-reply",		IPT_ICMP_ECHOREPLY},
+#endif
+	{"net-prohibited",	IPT_ICMP_NET_PROHIBITED},
+	{"host-prohibited",	IPT_ICMP_HOST_PROHIBITED},
+	{"tcp reset",		IPT_TCP_RESET},
+	{"admin-prohibited",	IPT_ICMP_ADMIN_PROHIBITED}
+};
+
+static int REJECT_xlate(const struct xt_entry_target *target,
+			struct xt_buf *buf, int numeric)
+{
+	const struct ipt_reject_info *reject
+				= (const struct ipt_reject_info *)target->data;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(reject_table_xlate); ++i)
+		if (reject_table_xlate[i].with == reject->with)
+			break;
+
+	if (reject->with == IPT_TCP_RESET)
+		xt_buf_add(buf, "reject with %s",
+			   reject_table_xlate[i].name);
+	else
+		xt_buf_add(buf, "reject with icmp type %s",
+			   reject_table_xlate[i].name);
+
+	return 1;
+}
+
+
 static struct xtables_target reject_tg_reg = {
 	.name		= "REJECT",
 	.version	= XTABLES_VERSION,
@@ -152,6 +193,7 @@ static struct xtables_target reject_tg_reg = {
 	.save		= REJECT_save,
 	.x6_parse	= REJECT_parse,
 	.x6_options	= REJECT_opts,
+	.xlate		= REJECT_xlate,
 };
 
 void _init(void)
-- 
1.9.1

