From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_connlabel: Add translation to nft
Date: Sun, 6 Mar 2016 03:17:46 +0530
Message-ID: <20160305214746.GA16464@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:32883 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbcCEVrw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Mar 2016 16:47:52 -0500
Received: by mail-pf0-f182.google.com with SMTP id 124so56531412pfg.0
        for <netfilter-devel@vger.kernel.org>; Sat, 05 Mar 2016 13:47:52 -0800 (PST)
Received: from gmail.com ([223.176.189.146])
        by smtp.gmail.com with ESMTPSA id v4sm14384731pfa.21.2016.03.05.13.47.50
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sat, 05 Mar 2016 13:47:51 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for connlabel to nftables.
Full translation for this match awaits the support for --set option.

Examples:

$ sudo iptables-translate -A INPUT -m connlabel --label eth0-in
nft add rule ip filter INPUT ct label eth0-in counter

$ sudo iptables-translate -A INPUT -m connlabel ! --label eth0-out
nft add rule ip filter INPUT ct label != eth0-out counter

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_connlabel.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/extensions/libxt_connlabel.c b/extensions/libxt_connlabel.c
index 1f83095..c3a96a6 100644
--- a/extensions/libxt_connlabel.c
+++ b/extensions/libxt_connlabel.c
@@ -118,6 +118,28 @@ connlabel_mt_save(const void *ip, const struct xt_entry_match *match)
 	connlabel_mt_print_op(info, "--");
 }
 
+static int
+connlabel_mt_xlate(const struct xt_entry_match *match,
+		   struct xt_xlate *xl, int numeric)
+{
+	const struct xt_connlabel_mtinfo *info = (const void *)match->data;
+	const char *name = connlabel_get_name(info->bit);
+
+	if (name)
+		xt_xlate_add(xl, "ct label %s%s ",
+			     info->options & XT_CONNLABEL_OP_INVERT ? "!= " : "",
+			     name);
+	else
+		xt_xlate_add(xl, "ct label %s%u ",
+			     info->options & XT_CONNLABEL_OP_INVERT ? "!= " : "",
+			     info->bit);
+
+	if (info->options & XT_CONNLABEL_OP_SET)
+		return 0;
+
+	return 1;
+}
+
 static struct xtables_match connlabel_mt_reg = {
 	.family        = NFPROTO_UNSPEC,
 	.name          = "connlabel",
@@ -129,6 +151,7 @@ static struct xtables_match connlabel_mt_reg = {
 	.save          = connlabel_mt_save,
 	.x6_parse      = connlabel_mt_parse,
 	.x6_options    = connlabel_mt_opts,
+	.xlate	       = connlabel_mt_xlate,
 };
 
 void _init(void)
-- 
1.9.1

