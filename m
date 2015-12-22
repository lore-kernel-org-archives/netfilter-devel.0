From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_iprange: Add translation to nft
Date: Tue, 22 Dec 2015 12:35:20 +0530
Message-ID: <20151222070520.GA20511@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:33218 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbbLVHF1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 02:05:27 -0500
Received: by mail-pf0-f173.google.com with SMTP id n128so85119883pfn.0
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Dec 2015 23:05:27 -0800 (PST)
Received: from gmail.com ([171.50.109.40])
        by smtp.gmail.com with ESMTPSA id e67sm38820978pfj.53.2015.12.21.23.05.24
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 21 Dec 2015 23:05:26 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for iprange to nftables.

Examples:

$ sudo iptables-translate -A INPUT -m iprange --src-range 192.168.25.149-192.168.25.151 -j ACCEPT
nft add rule ip filter INPUT  ip saddr 192.168.25.149-192.168.25.151 counter accept

$ sudo iptables-translate -A INPUT -m iprange --dst-range 192.168.25.149-192.168.25.151 -j ACCEPT
nft add rule ip filter INPUT  ip daddr 192.168.25.149-192.168.25.151 counter accept

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_iprange.c | 111 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 102 insertions(+), 9 deletions(-)

diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 2c9ea99..9cf6225 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -104,7 +104,8 @@ static void iprange_parse(struct xt_option_call *cb)
 		info->flags |= IPRANGE_SRC;
 		if (cb->invert)
 			info->flags |= IPRANGE_SRC_INV;
-		iprange_parse_range(cb->arg, range, NFPROTO_IPV4, "--src-range");
+		iprange_parse_range(cb->arg, range,
+				    NFPROTO_IPV4, "--src-range");
 		info->src.min_ip = range[0].ip;
 		info->src.max_ip = range[1].ip;
 		break;
@@ -112,7 +113,8 @@ static void iprange_parse(struct xt_option_call *cb)
 		info->flags |= IPRANGE_DST;
 		if (cb->invert)
 			info->flags |= IPRANGE_DST_INV;
-		iprange_parse_range(cb->arg, range, NFPROTO_IPV4, "--dst-range");
+		iprange_parse_range(cb->arg, range,
+				    NFPROTO_IPV4, "--dst-range");
 		info->dst.min_ip = range[0].ip;
 		info->dst.max_ip = range[1].ip;
 		break;
@@ -172,7 +174,7 @@ print_iprange(const struct ipt_iprange *range)
 }
 
 static void iprange_print(const void *ip, const struct xt_entry_match *match,
-                          int numeric)
+			  int numeric)
 {
 	const struct ipt_iprange_info *info = (const void *)match->data;
 
@@ -192,7 +194,7 @@ static void iprange_print(const void *ip, const struct xt_entry_match *match,
 
 static void
 iprange_mt4_print(const void *ip, const struct xt_entry_match *match,
-                  int numeric)
+		  int numeric)
 {
 	const struct xt_iprange_mtinfo *info = (const void *)match->data;
 
@@ -218,7 +220,7 @@ iprange_mt4_print(const void *ip, const struct xt_entry_match *match,
 
 static void
 iprange_mt6_print(const void *ip, const struct xt_entry_match *match,
-                  int numeric)
+		  int numeric)
 {
 	const struct xt_iprange_mtinfo *info = (const void *)match->data;
 
@@ -267,13 +269,15 @@ static void iprange_mt4_save(const void *ip, const struct xt_entry_match *match)
 	if (info->flags & IPRANGE_SRC) {
 		if (info->flags & IPRANGE_SRC_INV)
 			printf(" !");
-		printf(" --src-range %s", xtables_ipaddr_to_numeric(&info->src_min.in));
+		printf(" --src-range %s",
+		       xtables_ipaddr_to_numeric(&info->src_min.in));
 		printf("-%s", xtables_ipaddr_to_numeric(&info->src_max.in));
 	}
 	if (info->flags & IPRANGE_DST) {
 		if (info->flags & IPRANGE_DST_INV)
 			printf(" !");
-		printf(" --dst-range %s", xtables_ipaddr_to_numeric(&info->dst_min.in));
+		printf(" --dst-range %s",
+		       xtables_ipaddr_to_numeric(&info->dst_min.in));
 		printf("-%s", xtables_ipaddr_to_numeric(&info->dst_max.in));
 	}
 }
@@ -285,17 +289,103 @@ static void iprange_mt6_save(const void *ip, const struct xt_entry_match *match)
 	if (info->flags & IPRANGE_SRC) {
 		if (info->flags & IPRANGE_SRC_INV)
 			printf(" !");
-		printf(" --src-range %s", xtables_ip6addr_to_numeric(&info->src_min.in6));
+		printf(" --src-range %s",
+		       xtables_ip6addr_to_numeric(&info->src_min.in6));
 		printf("-%s", xtables_ip6addr_to_numeric(&info->src_max.in6));
 	}
 	if (info->flags & IPRANGE_DST) {
 		if (info->flags & IPRANGE_DST_INV)
 			printf(" !");
-		printf(" --dst-range %s", xtables_ip6addr_to_numeric(&info->dst_min.in6));
+		printf(" --dst-range %s",
+		       xtables_ip6addr_to_numeric(&info->dst_min.in6));
 		printf("-%s", xtables_ip6addr_to_numeric(&info->dst_max.in6));
 	}
 }
 
+static void
+print_iprange_xlate(const struct ipt_iprange *range,
+		    struct xt_buf *buf)
+{
+	const unsigned char *byte_min, *byte_max;
+
+	byte_min = (const unsigned char *)&range->min_ip;
+	byte_max = (const unsigned char *)&range->max_ip;
+	xt_buf_add(buf, " %u.%u.%u.%u-%u.%u.%u.%u ",
+		   byte_min[0], byte_min[1], byte_min[2], byte_min[3],
+		   byte_max[0], byte_max[1], byte_max[2], byte_max[3]);
+}
+
+static int iprange_xlate(const struct xt_entry_match *match,
+			 struct xt_buf *buf, int numeric)
+{
+	const struct ipt_iprange_info *info = (const void *)match->data;
+
+	if (info->flags & IPRANGE_SRC) {
+		if (info->flags & IPRANGE_SRC_INV)
+			xt_buf_add(buf, " !=");
+		xt_buf_add(buf, " ip saddr");
+		print_iprange_xlate(&info->src, buf);
+	}
+	if (info->flags & IPRANGE_DST) {
+		if (info->flags & IPRANGE_DST_INV)
+			xt_buf_add(buf, " !=");
+		xt_buf_add(buf, " ip daddr");
+		print_iprange_xlate(&info->dst, buf);
+	}
+
+	return 1;
+}
+
+static int iprange_mt4_xlate(const struct xt_entry_match *match,
+			     struct xt_buf *buf, int numeric)
+{
+	const struct xt_iprange_mtinfo *info = (const void *)match->data;
+
+	if (info->flags & IPRANGE_SRC) {
+		if (info->flags & IPRANGE_SRC_INV)
+			xt_buf_add(buf, " !=");
+		xt_buf_add(buf, " ip saddr %s",
+			   xtables_ipaddr_to_numeric(&info->src_min.in));
+		xt_buf_add(buf, "-%s ",
+			   xtables_ipaddr_to_numeric(&info->src_max.in));
+	}
+	if (info->flags & IPRANGE_DST) {
+		if (info->flags & IPRANGE_DST_INV)
+			xt_buf_add(buf, " !=");
+		xt_buf_add(buf, " ip daddr %s",
+			   xtables_ipaddr_to_numeric(&info->dst_min.in));
+		xt_buf_add(buf, "-%s ",
+			   xtables_ipaddr_to_numeric(&info->dst_max.in));
+	}
+
+	return 1;
+}
+
+static int iprange_mt6_xlate(const struct xt_entry_match *match,
+			     struct xt_buf *buf, int numeric)
+{
+	const struct xt_iprange_mtinfo *info = (const void *)match->data;
+
+	if (info->flags & IPRANGE_SRC) {
+		if (info->flags & IPRANGE_SRC_INV)
+			xt_buf_add(buf, " !=");
+		xt_buf_add(buf, " ip saddr %s",
+			   xtables_ip6addr_to_numeric(&info->src_min.in6));
+		xt_buf_add(buf, "-%s ",
+			   xtables_ip6addr_to_numeric(&info->src_max.in6));
+	}
+	if (info->flags & IPRANGE_DST) {
+		if (info->flags & IPRANGE_DST_INV)
+			xt_buf_add(buf, " !=");
+		xt_buf_add(buf, " ip daddr %s",
+			   xtables_ip6addr_to_numeric(&info->dst_min.in6));
+		xt_buf_add(buf, "-%s ",
+			   xtables_ip6addr_to_numeric(&info->dst_max.in6));
+	}
+
+	return 1;
+}
+
 static struct xtables_match iprange_mt_reg[] = {
 	{
 		.version       = XTABLES_VERSION,
@@ -310,6 +400,7 @@ static struct xtables_match iprange_mt_reg[] = {
 		.print         = iprange_print,
 		.save          = iprange_save,
 		.x6_options    = iprange_mt_opts,
+		.xlate	       = iprange_xlate,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -324,6 +415,7 @@ static struct xtables_match iprange_mt_reg[] = {
 		.print         = iprange_mt4_print,
 		.save          = iprange_mt4_save,
 		.x6_options    = iprange_mt_opts,
+		.xlate	       = iprange_mt4_xlate,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -338,6 +430,7 @@ static struct xtables_match iprange_mt_reg[] = {
 		.print         = iprange_mt6_print,
 		.save          = iprange_mt6_save,
 		.x6_options    = iprange_mt_opts,
+		.xlate	       = iprange_mt6_xlate,
 	},
 };
 
-- 
1.9.1

