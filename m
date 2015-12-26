From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libipt_DNAT: Add translation to nft
Date: Sat, 26 Dec 2015 23:31:13 +0530
Message-ID: <20151226180113.GA7278@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:34313 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbbLZSBV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Dec 2015 13:01:21 -0500
Received: by mail-pf0-f172.google.com with SMTP id e65so40202705pfe.1
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Dec 2015 10:01:21 -0800 (PST)
Received: from gmail.com ([223.176.174.151])
        by smtp.gmail.com with ESMTPSA id k76sm27571433pfb.37.2015.12.26.10.01.18
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sat, 26 Dec 2015 10:01:19 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for target DNAT to nftables.

Examples:

$ sudo iptables-translate -t nat -A prerouting -p tcp -o eth0 -j DNAT --to-destination 1.2.3.4
nft add rule ip nat prerouting oifname eth0 ip protocol tcp counter dnat 1.2.3.4

$ sudo iptables-translate -t nat -A prerouting -p tcp -d 15.45.23.67 --dport 80 -j DNAT --to-destination 192.168.1.1-192.168.1.10
nft add rule ip nat prerouting ip daddr 15.45.23.67 tcp dport 80 counter dnat 192.168.1.1-192.168.1.10

$ sudo iptables-translate -t nat -A prerouting -p tcp -o eth0 -j DNAT --to-destination 1.2.3.4:1-1023
nft add rule ip nat prerouting oifname eth0 ip protocol tcp counter dnat 1.2.3.4:1-1023

$ sudo iptables-translate -t nat -A prerouting -p tcp -o eth0 -j DNAT --to-destination 1.2.3.4 --random
nft add rule ip nat prerouting oifname eth0 ip protocol tcp counter dnat 1.2.3.4 random

$ sudo iptables-translate -t nat -A prerouting -p tcp -o eth0 -j DNAT --to-destination 1.2.3.4 --persistent
nft add rule ip nat prerouting oifname eth0 ip protocol tcp counter dnat 1.2.3.4 persistent

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libipt_DNAT.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index ff18799..ddc69f9 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -242,6 +242,44 @@ static void DNAT_save(const void *ip, const struct xt_entry_target *target)
 	}
 }
 
+static void print_range_xlate(const struct nf_nat_ipv4_range *r,
+			struct xt_buf *buf)
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
+		xt_buf_add(buf, ":%hu", ntohs(r->min.tcp.port));
+		if (r->max.tcp.port != r->min.tcp.port)
+			xt_buf_add(buf, "-%hu", ntohs(r->max.tcp.port));
+	}
+}
+
+static int DNAT_xlate(const struct xt_entry_target *target,
+		      struct xt_buf *buf, int numeric)
+{
+	const struct ipt_natinfo *info = (const void *)target;
+	unsigned int i = 0;
+
+	for (i = 0; i < info->mr.rangesize; i++) {
+		xt_buf_add(buf, "dnat ");
+		print_range_xlate(&info->mr.range[i], buf);
+		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM)
+			xt_buf_add(buf, " random");
+		if (info->mr.range[i].flags & NF_NAT_RANGE_PERSISTENT)
+			xt_buf_add(buf, " persistent");
+	}
+
+	return 1;
+}
+
 static struct xtables_target dnat_tg_reg = {
 	.name		= "DNAT",
 	.version	= XTABLES_VERSION,
@@ -254,6 +292,7 @@ static struct xtables_target dnat_tg_reg = {
 	.print		= DNAT_print,
 	.save		= DNAT_save,
 	.x6_options	= DNAT_opts,
+	.xlate		= DNAT_xlate,
 };
 
 void _init(void)
-- 
1.9.1

