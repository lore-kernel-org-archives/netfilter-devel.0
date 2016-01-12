From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libipt_REDIRECT: Add translation to nft
Date: Tue, 12 Jan 2016 22:17:54 +0530
Message-ID: <20160112164754.GA3259@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35108 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759679AbcALQsD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jan 2016 11:48:03 -0500
Received: by mail-pa0-f49.google.com with SMTP id ho8so81608874pac.2
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2016 08:48:01 -0800 (PST)
Received: from gmail.com ([106.201.101.184])
        by smtp.gmail.com with ESMTPSA id l14sm31597671pfb.73.2016.01.12.08.47.59
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 12 Jan 2016 08:48:00 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for target REDIRECT to nftables.

Examples:

$ sudo iptables-translate -t nat -A prerouting -p tcp --dport 80 -j REDIRECT --to-ports 8080
nft add rule ip nat prerouting tcp dport 80 counter redirect to 8080

$ sudo iptables-translate -t nat -A prerouting -p tcp --dport 80 -j REDIRECT --to-ports 8080 --random
nft add rule ip nat prerouting tcp dport 80 counter redirect to 8080 random

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libipt_REDIRECT.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 610a949..2e5b33d 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -135,6 +135,24 @@ static void REDIRECT_save(const void *ip, const struct xt_entry_target *target)
 	}
 }
 
+static int REDIRECT_xlate(const struct xt_entry_target *target,
+			  struct xt_buf *buf, int numeric)
+{
+	const struct nf_nat_ipv4_multi_range_compat *mr =
+					(const void *)target->data;
+	const struct nf_nat_ipv4_range *r = &mr->range[0];
+
+	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
+		xt_buf_add(buf, "redirect to %hu", ntohs(r->min.tcp.port));
+		if (r->max.tcp.port != r->min.tcp.port)
+			xt_buf_add(buf, "-%hu ", ntohs(r->max.tcp.port));
+		if (mr->range[0].flags & NF_NAT_RANGE_PROTO_RANDOM)
+			xt_buf_add(buf, " random ");
+	}
+
+	return 1;
+}
+
 static struct xtables_target redirect_tg_reg = {
 	.name		= "REDIRECT",
 	.version	= XTABLES_VERSION,
@@ -147,6 +165,7 @@ static struct xtables_target redirect_tg_reg = {
 	.print		= REDIRECT_print,
 	.save		= REDIRECT_save,
 	.x6_options	= REDIRECT_opts,
+	.xlate		= REDIRECT_xlate,
 };
 
 void _init(void)
-- 
1.9.1

