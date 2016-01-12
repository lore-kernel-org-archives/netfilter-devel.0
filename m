From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libip6t_REDIRECT: Add translation to nft
Date: Wed, 13 Jan 2016 00:56:44 +0530
Message-ID: <20160112192644.GA5574@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:36270 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbcALT0v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jan 2016 14:26:51 -0500
Received: by mail-pf0-f172.google.com with SMTP id n128so67444014pfn.3
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2016 11:26:51 -0800 (PST)
Received: from gmail.com ([106.201.101.184])
        by smtp.gmail.com with ESMTPSA id q27sm32138071pfi.80.2016.01.12.11.26.48
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 12 Jan 2016 11:26:50 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for REDIRECT target to nftables.

Examples:

$ sudo ip6tables-translate -t nat -A prerouting -p tcp --dport 80 -j REDIRECT --to-ports 8080
nft add rule ip6 nat prerouting tcp dport 80 counter redirect to 8080

$ sudo ip6tables-translate -t nat -A prerouting -p tcp --dport 80 -j REDIRECT --to-ports 8080 --random
nft add rule ip6 nat prerouting tcp dport 80 counter redirect to 8080 random

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libip6t_REDIRECT.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/extensions/libip6t_REDIRECT.c b/extensions/libip6t_REDIRECT.c
index 1724aa6..d907d94 100644
--- a/extensions/libip6t_REDIRECT.c
+++ b/extensions/libip6t_REDIRECT.c
@@ -132,6 +132,24 @@ static void REDIRECT_save(const void *ip, const struct xt_entry_target *target)
 	}
 }
 
+static int REDIRECT_xlate(const struct xt_entry_target *target,
+			  struct xt_buf *buf, int numeric)
+{
+	const struct nf_nat_range *range = (const void *)target->data;
+
+	if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
+		xt_buf_add(buf, "redirect to %hu",
+			   ntohs(range->min_proto.tcp.port));
+		if (range->max_proto.tcp.port != range->min_proto.tcp.port)
+			xt_buf_add(buf, "-%hu ",
+				   ntohs(range->max_proto.tcp.port));
+		if (range->flags & NF_NAT_RANGE_PROTO_RANDOM)
+			xt_buf_add(buf, " random ");
+	}
+
+	return 1;
+}
+
 static struct xtables_target redirect_tg_reg = {
 	.name		= "REDIRECT",
 	.version	= XTABLES_VERSION,
@@ -143,6 +161,7 @@ static struct xtables_target redirect_tg_reg = {
 	.print		= REDIRECT_print,
 	.save		= REDIRECT_save,
 	.x6_options	= REDIRECT_opts,
+	.xlate		= REDIRECT_xlate,
 };
 
 void _init(void)
-- 
1.9.1

