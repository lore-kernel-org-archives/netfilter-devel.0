From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libipt_SNAT: Add translation to nft
Date: Fri, 25 Dec 2015 22:46:59 +0530
Message-ID: <20151225171659.GA11250@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34352 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbbLYRRH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Dec 2015 12:17:07 -0500
Received: by mail-pa0-f49.google.com with SMTP id uo6so57404231pac.1
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 09:17:06 -0800 (PST)
Received: from gmail.com ([106.215.183.206])
        by smtp.gmail.com with ESMTPSA id s65sm4779388pfi.77.2015.12.25.09.17.03
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Fri, 25 Dec 2015 09:17:04 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for target SNAT to nftables.

Examples:

$ sudo iptables-translate -t nat -A postrouting -o eth0 -j SNAT --to 1.2.3.4
nft add rule ip nat postrouting oifname eth0 counter snat 1.2.3.4

$ sudo iptables-translate -t nat -A postrouting -o eth0 -j SNAT --to 1.2.3.4-1.2.3.6
nft add rule ip nat postrouting oifname eth0 counter snat 1.2.3.4-1.2.3.6

$ sudo iptables-translate -t nat -A postrouting -p tcp -o eth0 -j SNAT --to 1.2.3.4:1-1023
nft add rule ip nat postrouting oifname eth0 ip protocol tcp counter snat 1.2.3.4:1-1023

$ sudo iptables-translate -t nat -A postrouting -o eth0 -j SNAT --to 1.2.3.4 --random
nft add rule ip nat postrouting oifname eth0 counter snat 1.2.3.4 random

$ sudo iptables-translate -t nat -A postrouting -o eth0 -j SNAT --to 1.2.3.4 --random-fully
nft add rule ip nat postrouting oifname eth0 counter snat 1.2.3.4 fully-random

$ sudo iptables-translate -t nat -A postrouting -p tcp -o eth0 -j SNAT --to 1.2.3.4 --persistent
nft add rule ip nat postrouting oifname eth0 ip protocol tcp counter snat 1.2.3.4 persistent

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libipt_SNAT.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 78d2c2b..f1b8d9a 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -252,6 +252,47 @@ static void SNAT_save(const void *ip, const struct xt_entry_target *target)
 	}
 }
 
+static void print_range_xlate(const struct nf_nat_ipv4_range *r,
+			      struct xt_buf *buf)
+{
+	if (r->flags & NF_NAT_RANGE_MAP_IPS) {
+		struct in_addr a;
+
+		a.s_addr = r->min_ip;
+		xt_buf_add(buf, "%s", xtables_ipaddr_to_numeric(&a));
+		if (r->max_ip != r->min_ip) {
+			a.s_addr = r->max_ip;
+			xt_buf_add(buf, "-%s", xtables_ipaddr_to_numeric(&a));
+		}
+	}
+	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
+		xt_buf_add(buf, ":");
+		xt_buf_add(buf, "%hu", ntohs(r->min.tcp.port));
+		if (r->max.tcp.port != r->min.tcp.port)
+			xt_buf_add(buf, "-%hu", ntohs(r->max.tcp.port));
+	}
+}
+
+static int SNAT_xlate(const struct xt_entry_target *target,
+		      struct xt_buf *buf, int numeric)
+{
+	const struct ipt_natinfo *info = (const void *)target;
+	unsigned int i = 0;
+
+	for (i = 0; i < info->mr.rangesize; i++) {
+		xt_buf_add(buf, "snat ");
+		print_range_xlate(&info->mr.range[i], buf);
+		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM)
+			xt_buf_add(buf, " random");
+		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY)
+			xt_buf_add(buf, " fully-random");
+		if (info->mr.range[i].flags & NF_NAT_RANGE_PERSISTENT)
+			xt_buf_add(buf, " persistent");
+	}
+
+	return 1;
+}
+
 static struct xtables_target snat_tg_reg = {
 	.name		= "SNAT",
 	.version	= XTABLES_VERSION,
@@ -264,6 +305,7 @@ static struct xtables_target snat_tg_reg = {
 	.print		= SNAT_print,
 	.save		= SNAT_save,
 	.x6_options	= SNAT_opts,
+	.xlate		= SNAT_xlate,
 };
 
 void _init(void)
-- 
1.9.1

