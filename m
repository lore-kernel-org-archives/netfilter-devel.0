From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libipt_SNAT: Add translation to nft
Date: Mon, 28 Dec 2015 21:05:02 +0530
Message-ID: <20151228153502.GA4417@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35641 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbbL1PfJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Dec 2015 10:35:09 -0500
Received: by mail-pa0-f66.google.com with SMTP id gi1so13849274pac.2
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 07:35:09 -0800 (PST)
Received: from gmail.com ([223.176.129.56])
        by smtp.gmail.com with ESMTPSA id f12sm15251950pat.20.2015.12.28.07.35.06
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 28 Dec 2015 07:35:07 -0800 (PST)
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

$ sudo iptables-translate -t nat -A postrouting -o eth0 -j SNAT --to 1.2.3.4 --random --persistent
nft add rule ip nat postrouting oifname eth0 counter snat 1.2.3.4 random,persistent

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libipt_SNAT.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 78d2c2b..42fe92d 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -252,6 +252,58 @@ static void SNAT_save(const void *ip, const struct xt_entry_target *target)
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
+	bool sep_need = false;
+	const char *sep = " ";
+
+	for (i = 0; i < info->mr.rangesize; i++) {
+		xt_buf_add(buf, "snat ");
+		print_range_xlate(&info->mr.range[i], buf);
+		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM) {
+			xt_buf_add(buf, " random");
+			sep_need = true;
+		}
+		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY) {
+			if (sep_need)
+				sep = ",";
+			xt_buf_add(buf, "%sfully-random", sep);
+			sep_need = true;
+		}
+		if (info->mr.range[i].flags & NF_NAT_RANGE_PERSISTENT) {
+			if (sep_need)
+				sep = ",";
+			xt_buf_add(buf, "%spersistent", sep);
+		}
+	}
+
+	return 1;
+}
+
 static struct xtables_target snat_tg_reg = {
 	.name		= "SNAT",
 	.version	= XTABLES_VERSION,
@@ -264,6 +316,7 @@ static struct xtables_target snat_tg_reg = {
 	.print		= SNAT_print,
 	.save		= SNAT_save,
 	.x6_options	= SNAT_opts,
+	.xlate		= SNAT_xlate,
 };
 
 void _init(void)
-- 
1.9.1

