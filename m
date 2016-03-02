From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v2] extensions: libxt_owner: Add translation to nft
Date: Thu, 3 Mar 2016 00:45:55 +0530
Message-ID: <20160302191555.GA32247@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34886 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbcCBTQD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 14:16:03 -0500
Received: by mail-pf0-f193.google.com with SMTP id w128so13235527pfb.2
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Mar 2016 11:16:02 -0800 (PST)
Received: from gmail.com ([223.176.182.21])
        by smtp.gmail.com with ESMTPSA id 16sm54785081pfk.28.2016.03.02.11.15.59
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 02 Mar 2016 11:16:00 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for module owner to nftables.
Full translation of this match awaits the support for --socket-exists
option.

Examples:

$ sudo iptables-translate -t nat -A OUTPUT -p tcp --dport 80 -m owner --uid-owner root -j ACCEPT
nft add rule ip nat OUTPUT tcp dport 80 skuid 0 counter accept

$ sudo iptables-translate -t nat -A OUTPUT -p tcp --dport 80 -m owner --gid-owner 0-10 -j ACCEPT
nft add rule ip nat OUTPUT tcp dport 80 skgid 0-10 counter accept

$ sudo iptables-translate -t nat -A OUTPUT -p tcp --dport 80 -m owner ! --uid-owner shivani -j ACCEPT
nft add rule ip nat OUTPUT tcp dport 80 skuid != 1000 counter accept

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
Changes in v2:
	Add different functions for skuid and skgid

 extensions/libxt_owner.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index d9adc12..2085de8 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -492,6 +492,56 @@ static void owner_mt_save(const void *ip, const struct xt_entry_match *match)
 	owner_mt_print_item(info, "--gid-owner",      XT_OWNER_GID,    true);
 }
 
+static int
+owner_mt_print_uid_xlate(const struct xt_owner_match_info *info,
+			 struct xt_xlate *xl)
+{
+	xt_xlate_add(xl, "skuid%s ", info->invert ? " !=" : "");
+
+	if (info->uid_min != info->uid_max)
+		xt_xlate_add(xl, "%u-%u ", (unsigned int)info->uid_min,
+			     (unsigned int)info->uid_max);
+	else
+		xt_xlate_add(xl, "%u ", (unsigned int)info->uid_min);
+
+	return 1;
+}
+
+static int
+owner_mt_print_gid_xlate(const struct xt_owner_match_info *info,
+			 struct xt_xlate *xl)
+{
+	xt_xlate_add(xl, "skgid%s ", info->invert ? " !=" : "");
+
+	if (info->gid_min != info->gid_max)
+		xt_xlate_add(xl, "%u-%u ", (unsigned int)info->gid_min,
+			     (unsigned int)info->gid_max);
+	else
+		xt_xlate_add(xl, "%u ", (unsigned int)info->gid_min);
+
+	return 1;
+}
+
+static int owner_mt_xlate(const struct xt_entry_match *match,
+			  struct xt_xlate *xl, int numeric)
+{
+	const struct xt_owner_match_info *info = (void *)match->data;
+	int ret;
+
+	switch (info->match) {
+	case XT_OWNER_UID:
+		ret = owner_mt_print_uid_xlate(info, xl);
+		break;
+	case XT_OWNER_GID:
+		ret = owner_mt_print_gid_xlate(info, xl);
+		break;
+	default:
+		ret = 0;
+	}
+
+	return ret;
+}
+
 static struct xtables_match owner_mt_reg[] = {
 	{
 		.version       = XTABLES_VERSION,
@@ -534,6 +584,7 @@ static struct xtables_match owner_mt_reg[] = {
 		.print         = owner_mt_print,
 		.save          = owner_mt_save,
 		.x6_options    = owner_mt_opts,
+		.xlate	       = owner_mt_xlate,
 	},
 };
 
-- 
1.9.1

