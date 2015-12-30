From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libip6t_DNAT: Add translation to nft
Date: Wed, 30 Dec 2015 14:11:26 +0530
Message-ID: <20151230084126.GA5676@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:32791 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbbL3Ild (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Dec 2015 03:41:33 -0500
Received: by mail-pa0-f45.google.com with SMTP id cy9so135802723pac.0
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Dec 2015 00:41:33 -0800 (PST)
Received: from gmail.com ([106.215.166.113])
        by smtp.gmail.com with ESMTPSA id w66sm51467268pfi.48.2015.12.30.00.41.30
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 30 Dec 2015 00:41:31 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for target DNAT to nftables.

Examples:

$ sudo ip6tables-translate -t nat -A prerouting -i eth1 -p tcp --dport 8080 -j DNAT --to-destination [fec0::1234]:80
nft add rule ip6 nat prerouting iifname eth1 tcp dport 8080 counter dnat fec0::1234 :80

$ sudo ip6tables-translate -t nat -A prerouting -p tcp -j DNAT --to-destination [fec0::1234]:1-20
nft add rule ip6 nat prerouting ip6 nexthdr tcp counter dnat fec0::1234 :1-20

$ sudo ip6tables-translate -t nat -A prerouting -p tcp -j DNAT --to-destination [fec0::1234]:80 --persistent
nft add rule ip6 nat prerouting ip6 nexthdr tcp counter dnat fec0::1234 :80 persistent

$ sudo ip6tables-translate -t nat -A prerouting -p tcp -j DNAT --to-destination [fec0::1234]:80 --random --persistent
nft add rule ip6 nat prerouting ip6 nexthdr tcp counter dnat fec0::1234 :80 random,persistent

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libip6t_DNAT.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/extensions/libip6t_DNAT.c b/extensions/libip6t_DNAT.c
index eaa6bf1..3959755 100644
--- a/extensions/libip6t_DNAT.c
+++ b/extensions/libip6t_DNAT.c
@@ -231,6 +231,49 @@ static void DNAT_save(const void *ip, const struct xt_entry_target *target)
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
+static int DNAT_xlate(const struct xt_entry_target *target,
+		       struct xt_buf *buf, int numeric)
+{
+	const struct nf_nat_range *range = (const void *)target->data;
+	bool sep_need = false;
+	const char *sep = " ";
+
+	xt_buf_add(buf, "dnat ");
+	print_range_xlate(range, buf);
+	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM) {
+		xt_buf_add(buf, " random");
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
 	.name		= "DNAT",
 	.version	= XTABLES_VERSION,
@@ -244,6 +287,7 @@ static struct xtables_target snat_tg_reg = {
 	.print		= DNAT_print,
 	.save		= DNAT_save,
 	.x6_options	= DNAT_opts,
+	.xlate		= DNAT_xlate,
 };
 
 void _init(void)
-- 
1.9.1

