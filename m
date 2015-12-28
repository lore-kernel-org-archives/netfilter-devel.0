From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v2] extensions: libipt_DNAT: Add translation to nft
Date: Tue, 29 Dec 2015 00:21:45 +0530
Message-ID: <20151228185145.GA3153@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:35543 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbbL1Svw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Dec 2015 13:51:52 -0500
Received: by mail-pf0-f181.google.com with SMTP id 78so115561119pfw.2
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 10:51:51 -0800 (PST)
Received: from gmail.com ([171.50.51.80])
        by smtp.gmail.com with ESMTPSA id w85sm34575724pfi.36.2015.12.28.10.51.49
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 28 Dec 2015 10:51:50 -0800 (PST)
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

$ sudo iptables-translate -t nat -A prerouting -p tcp -o eth0 -j DNAT --to-destination 1.2.3.4 --random --persistent
nft add rule ip nat prerouting oifname eth0 ip protocol tcp counter dnat 1.2.3.4 random,persistent

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
Changes in v2:
	Fix the code for using comma separator for multiple options

 extensions/libipt_DNAT.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index ff18799..e529141 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -242,6 +242,51 @@ static void DNAT_save(const void *ip, const struct xt_entry_target *target)
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
+	bool sep_need = false;
+	const char *sep = " ";
+
+	for (i = 0; i < info->mr.rangesize; i++) {
+		xt_buf_add(buf, "dnat ");
+		print_range_xlate(&info->mr.range[i], buf);
+		if (info->mr.range[i].flags & NF_NAT_RANGE_PROTO_RANDOM) {
+			xt_buf_add(buf, " random");
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
 static struct xtables_target dnat_tg_reg = {
 	.name		= "DNAT",
 	.version	= XTABLES_VERSION,
@@ -254,6 +299,7 @@ static struct xtables_target dnat_tg_reg = {
 	.print		= DNAT_print,
 	.save		= DNAT_save,
 	.x6_options	= DNAT_opts,
+	.xlate		= DNAT_xlate,
 };
 
 void _init(void)
-- 
1.9.1

