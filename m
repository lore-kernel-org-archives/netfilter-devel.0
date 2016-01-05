From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libip6t_REJECT: Add translation to nft
Date: Tue, 5 Jan 2016 12:25:04 +0530
Message-ID: <20160105065504.GA5780@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33411 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbcAEGzL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jan 2016 01:55:11 -0500
Received: by mail-pa0-f48.google.com with SMTP id cy9so210293185pac.0
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Jan 2016 22:55:10 -0800 (PST)
Received: from gmail.com ([106.218.187.195])
        by smtp.gmail.com with ESMTPSA id y84sm84532735pfi.93.2016.01.04.22.55.08
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 04 Jan 2016 22:55:09 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for target REJECT to nftables.

Examples:

$ sudo ip6tables-translate -A FORWARD -p TCP --dport 22 -j REJECT --reject-with icmp6-reject-route
nft add rule ip6 filter FORWARD tcp dport 22 counter reject with icmpv6 type reject-route

$ sudo ip6tables-translate -A FORWARD -p TCP --dport 22 -j REJECT --reject-with tcp-reset
nft add rule ip6 filter FORWARD tcp dport 22 counter reject with tcp reset

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libip6t_REJECT.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index d62f431..6d33ecd 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -17,6 +17,11 @@ struct reject_names {
 	const char *desc;
 };
 
+struct reject_names_xlate {
+	const char *name;
+	enum ip6t_reject_with with;
+};
+
 enum {
 	O_REJECT_WITH = 0,
 };
@@ -124,6 +129,38 @@ static void REJECT_save(const void *ip, const struct xt_entry_target *target)
 	printf(" --reject-with %s", reject_table[i].name);
 }
 
+static const struct reject_names_xlate reject_table_xlate[] = {
+	{"no-route",		IP6T_ICMP6_NO_ROUTE},
+	{"admin-prohibited",	IP6T_ICMP6_ADM_PROHIBITED},
+#if 0
+	{"not-neighbour",	IP6T_ICMP6_NOT_NEIGHBOR},
+#endif
+	{"addr-unreachable",	IP6T_ICMP6_ADDR_UNREACH},
+	{"port-unreachable",	IP6T_ICMP6_PORT_UNREACH},
+	{"tcp reset",		IP6T_TCP_RESET},
+	{"policy-fail",		IP6T_ICMP6_POLICY_FAIL},
+	{"reject-route",	IP6T_ICMP6_REJECT_ROUTE}
+};
+
+static int REJECT_xlate(const struct xt_entry_target *target,
+			struct xt_buf *buf, int numeric)
+{
+	const struct ip6t_reject_info *reject =
+				(const struct ip6t_reject_info *)target->data;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(reject_table_xlate); ++i)
+		if (reject_table_xlate[i].with == reject->with)
+			break;
+	if (reject->with == IP6T_TCP_RESET)
+		xt_buf_add(buf, "reject with %s", reject_table_xlate[i].name);
+	else
+		xt_buf_add(buf, "reject with icmpv6 type %s",
+			   reject_table_xlate[i].name);
+
+	return 1;
+}
+
 static struct xtables_target reject_tg6_reg = {
 	.name = "REJECT",
 	.version	= XTABLES_VERSION,
@@ -136,6 +173,7 @@ static struct xtables_target reject_tg6_reg = {
 	.save		= REJECT_save,
 	.x6_parse	= REJECT_parse,
 	.x6_options	= REJECT_opts,
+	.xlate		= REJECT_xlate,
 };
 
 void _init(void)
-- 
1.9.1

