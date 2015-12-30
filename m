From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libip6t_SNAT: Add translation to nft
Date: Wed, 30 Dec 2015 14:54:57 +0530
Message-ID: <20151230092457.GA7327@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33390 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbbL3JZE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Dec 2015 04:25:04 -0500
Received: by mail-pa0-f45.google.com with SMTP id cy9so136268380pac.0
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Dec 2015 01:25:03 -0800 (PST)
Received: from gmail.com ([106.215.166.113])
        by smtp.gmail.com with ESMTPSA id sy5sm93448652pac.5.2015.12.30.01.25.01
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 30 Dec 2015 01:25:02 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for SNAT target to nftables.

Examples:

$ sudo ip6tables-translate -t nat -A postrouting -o eth0 -p tcp -j SNAT --to [fec0::1234]:80
nft add rule ip6 nat postrouting oifname eth0 ip6 nexthdr tcp counter snat fec0::1234 :80

$ sudo ip6tables-translate -t nat -A postrouting -o eth0 -p tcp -j SNAT --to [fec0::1234]:1-20
nft add rule ip6 nat postrouting oifname eth0 ip6 nexthdr tcp counter snat fec0::1234 :1-20

$ sudo ip6tables-translate -t nat -A postrouting -o eth0 -p tcp -j SNAT --to [fec0::1234]:123 --random
nft add rule ip6 nat postrouting oifname eth0 ip6 nexthdr tcp counter snat fec0::1234 :123 random

$ sudo ip6tables-translate -t nat -A postrouting -o eth0 -p tcp -j SNAT --to [fec0::1234]:123 --random-fully --persistent
nft add rule ip6 nat postrouting oifname eth0 ip6 nexthdr tcp counter snat fec0::1234 :123 fully-random,persistent

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libip6t_SNAT.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/extensions/libip6t_SNAT.c b/extensions/libip6t_SNAT.c
index 8eb50b8..b85c86c 100644
--- a/extensions/libip6t_SNAT.c
+++ b/extensions/libip6t_SNAT.c
@@ -241,6 +241,55 @@ static void SNAT_save(const void *ip, const struct xt_entry_target *target)
 		printf(" --persistent");
 }
 
+static void print_range_xlate(const struct nf_nat_range *range,
+			      struct xt_buf *buf)
+{
+	if (range->flags & NF_NAT_RANGE_MAP_IPS) {
+		xt_buf_add(buf, "%s",
+			   xtables_ip6addr_to_numeric(&range->min_addr.in6));
+
+		if (memcmp(&range->min_addr, &range->max_addr,
+			   sizeof(range->min_addr)))
+			xt_buf_add(buf, "-%s",
+			     xtables_ip6addr_to_numeric(&range->max_addr.in6));
+	}
+	if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
+		xt_buf_add(buf, " :%hu", ntohs(range->min_proto.tcp.port));
+
+		if (range->max_proto.tcp.port != range->min_proto.tcp.port)
+			xt_buf_add(buf, "-%hu",
+				   ntohs(range->max_proto.tcp.port));
+	}
+}
+
+static int SNAT_xlate(const struct xt_entry_target *target,
+		      struct xt_buf *buf, int numeric)
+{
+	const struct nf_nat_range *range = (const void *)target->data;
+	bool sep_need = false;
+	const char *sep = " ";
+
+	xt_buf_add(buf, "snat ");
+	print_range_xlate(range, buf);
+	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM) {
+		xt_buf_add(buf, " random");
+		sep_need = true;
+	}
+	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM_FULLY) {
+		if (sep_need)
+			sep = ",";
+		xt_buf_add(buf, "%sfully-random", sep);
+		sep_need = true;
+	}
+	if (range->flags & NF_NAT_RANGE_PERSISTENT) {
+		if (sep_need)
+			sep = ",";
+		xt_buf_add(buf, "%spersistent", sep);
+	}
+
+	return 1;
+}
+
 static struct xtables_target snat_tg_reg = {
 	.name		= "SNAT",
 	.version	= XTABLES_VERSION,
@@ -254,6 +303,7 @@ static struct xtables_target snat_tg_reg = {
 	.print		= SNAT_print,
 	.save		= SNAT_save,
 	.x6_options	= SNAT_opts,
+	.xlate		= SNAT_xlate,
 };
 
 void _init(void)
-- 
1.9.1

