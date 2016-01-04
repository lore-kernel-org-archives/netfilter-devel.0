From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v2] extensions: libipt_ttl: Add translation to nft
Date: Mon, 4 Jan 2016 23:30:02 +0530
Message-ID: <20160104180002.GA10529@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:35670 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbcADSAK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 13:00:10 -0500
Received: by mail-pf0-f173.google.com with SMTP id 78so207564009pfw.2
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Jan 2016 10:00:09 -0800 (PST)
Received: from gmail.com ([106.201.42.190])
        by smtp.gmail.com with ESMTPSA id 204sm107044242pfc.67.2016.01.04.10.00.07
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 04 Jan 2016 10:00:08 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for module ttl to nftables.

Examples:

$ sudo iptables-translate -A INPUT -m ttl --ttl-eq 3 -j ACCEPT
nft add rule ip filter INPUT ip ttl 3 counter accept

$ sudo iptables-translate -A INPUT -m ttl --ttl-gt 5 -j ACCEPT
nft add rule ip filter INPUT ip ttl \> 5 counter accept

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
Changes in v2:
	Remove the changes done in nft-ipv4

 extensions/libipt_ttl.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index 5fe08cc..5d897a7 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -100,6 +100,35 @@ static void ttl_save(const void *ip, const struct xt_entry_match *match)
 	printf(" %u", info->ttl);
 }
 
+static int ttl_xlate(const struct xt_entry_match *match,
+		     struct xt_buf *buf, int numeric)
+{
+	const struct ipt_ttl_info *info =
+			(struct ipt_ttl_info *) match->data;
+
+		switch (info->mode) {
+		case IPT_TTL_EQ:
+			xt_buf_add(buf, "ip ttl");
+			break;
+		case IPT_TTL_NE:
+			xt_buf_add(buf, "ip ttl !=");
+			break;
+		case IPT_TTL_LT:
+			xt_buf_add(buf, "ip ttl \\<");
+			break;
+		case IPT_TTL_GT:
+			xt_buf_add(buf, "ip ttl \\>");
+			break;
+		default:
+			/* error */
+			break;
+	}
+
+	xt_buf_add(buf, " %u ", info->ttl);
+
+	return 1;
+}
+
 #define s struct ipt_ttl_info
 static const struct xt_option_entry ttl_opts[] = {
 	{.name = "ttl-lt", .id = O_TTL_LT, .excl = F_ANY, .type = XTTYPE_UINT8,
@@ -126,6 +155,7 @@ static struct xtables_match ttl_mt_reg = {
 	.x6_parse	= ttl_parse,
 	.x6_fcheck	= ttl_check,
 	.x6_options	= ttl_opts,
+	.xlate		= ttl_xlate,
 };
 
 
-- 
1.9.1

