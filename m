From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libip6t_hl: Add translation to nft
Date: Thu, 7 Jan 2016 15:09:24 +0530
Message-ID: <20160107093924.GA6686@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34807 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbcAGJjc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Jan 2016 04:39:32 -0500
Received: by mail-pa0-f48.google.com with SMTP id uo6so236245783pac.1
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Jan 2016 01:39:32 -0800 (PST)
Received: from gmail.com ([223.176.149.78])
        by smtp.gmail.com with ESMTPSA id yn8sm152492927pac.32.2016.01.07.01.39.29
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 07 Jan 2016 01:39:30 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for hop limit to nftables.

Examples:

$ sudo ip6tables-translate -t nat -A postrouting -m hl --hl-gt 3
nft add rule ip6 nat postrouting ip6 hoplimit gt 3 counter

$ sudo ip6tables-translate -t nat -A postrouting -m hl ! --hl-eq 3
nft add rule ip6 nat postrouting ip6 hoplimit != 3 counter

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libip6t_hl.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index 3559db4..0e13df1 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -97,6 +97,23 @@ static const struct xt_option_entry hl_opts[] = {
 };
 #undef s
 
+static int hl_xlate(const struct xt_entry_match *match,
+		    struct xt_buf *buf, int numeric)
+{
+	static const char *const op[] = {
+		[IP6T_HL_EQ] = "ip6 hoplimit",
+		[IP6T_HL_NE] = "ip6 hoplimit !=",
+		[IP6T_HL_LT] = "ip6 hoplimit lt",
+		[IP6T_HL_GT] = "ip6 hoplimit gt" };
+
+	const struct ip6t_hl_info *info =
+			(struct ip6t_hl_info *) match->data;
+
+	xt_buf_add(buf, "%s %u ", op[info->mode], info->hop_limit);
+
+	return 1;
+}
+
 static struct xtables_match hl_mt6_reg = {
 	.name          = "hl",
 	.version       = XTABLES_VERSION,
@@ -109,6 +126,7 @@ static struct xtables_match hl_mt6_reg = {
 	.x6_parse      = hl_parse,
 	.x6_fcheck     = hl_check,
 	.x6_options    = hl_opts,
+	.xlate	       = hl_xlate,
 };
 
 
-- 
1.9.1

