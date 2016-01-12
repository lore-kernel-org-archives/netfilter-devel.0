From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v2] extensions: libip6t_hl: Add translation to nft
Date: Tue, 12 Jan 2016 19:58:29 +0530
Message-ID: <20160112142829.GA5879@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33528 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762521AbcALO2g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jan 2016 09:28:36 -0500
Received: by mail-pf0-f195.google.com with SMTP id e65so4923208pfe.0
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2016 06:28:36 -0800 (PST)
Received: from gmail.com ([106.204.22.198])
        by smtp.gmail.com with ESMTPSA id 11sm30942224pfq.87.2016.01.12.06.28.34
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 12 Jan 2016 06:28:35 -0800 (PST)
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
Changes in v2:
	Alter the contents of array op

 extensions/libip6t_hl.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index 3559db4..226b69c 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -83,6 +83,23 @@ static void hl_save(const void *ip, const struct xt_entry_match *match)
 	printf(" %s %u", op[info->mode], info->hop_limit);
 }
 
+static int hl_xlate(const struct xt_entry_match *match,
+		    struct xt_buf *buf, int numeric)
+{
+	static const char *const op[] = {
+		[IP6T_HL_EQ] = "",
+		[IP6T_HL_NE] = "!= ",
+		[IP6T_HL_LT] = "lt ",
+		[IP6T_HL_GT] = "gt " };
+
+	const struct ip6t_hl_info *info =
+		(struct ip6t_hl_info *) match->data;
+
+	xt_buf_add(buf, "ip6 hoplimit %s%u ", op[info->mode], info->hop_limit);
+
+	return 1;
+}
+
 #define s struct ip6t_hl_info
 static const struct xt_option_entry hl_opts[] = {
 	{.name = "hl-lt", .id = O_HL_LT, .excl = F_ANY, .type = XTTYPE_UINT8,
@@ -109,6 +126,7 @@ static struct xtables_match hl_mt6_reg = {
 	.x6_parse      = hl_parse,
 	.x6_fcheck     = hl_check,
 	.x6_options    = hl_opts,
+	.xlate	       = hl_xlate,
 };
 
 
-- 
1.9.1

