From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_devgroup: Add translation to nft
Date: Wed, 23 Dec 2015 00:40:35 +0530
Message-ID: <20151222191035.GA9805@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:34538 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbbLVTKn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 14:10:43 -0500
Received: by mail-pa0-f66.google.com with SMTP id yy13so644826pab.1
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 11:10:42 -0800 (PST)
Received: from gmail.com ([223.176.190.114])
        by smtp.gmail.com with ESMTPSA id 15sm42874518pfo.43.2015.12.22.11.10.40
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 22 Dec 2015 11:10:41 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for device group to nftables.

Examples:

$ sudo iptables-translate -A FORWARD -m devgroup --dst-group 0xc/0xc -j ACCEPT
nft add rule ip filter FORWARD oifgroup and 0xc == 0xc counter accept

$ sudo iptables-translate -t mangle -A PREROUTING -p tcp --dport 46000 -m devgroup --src-group 23 -j ACCEPT
nft add rule ip mangle PREROUTING tcp dport 46000 iifgroup 0x17 counter accept

$ sudo iptables-translate -A FORWARD -m devgroup ! --dst-group 0xc/0xc -j ACCEPT
nft add rule ip filter FORWARD oifgroup and 0xc != 0xc counter accept

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_devgroup.c | 56 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_devgroup.c b/extensions/libxt_devgroup.c
index 1a52627..207f106 100644
--- a/extensions/libxt_devgroup.c
+++ b/extensions/libxt_devgroup.c
@@ -37,6 +37,7 @@ static struct xtables_lmap *devgroups;
 static void devgroup_init(struct xt_entry_match *match)
 {
 	const char file[] = "/etc/iproute2/group";
+
 	devgroups = xtables_lmap_init(file);
 	if (devgroups == NULL && errno != ENOENT)
 		fprintf(stderr, "Warning: %s: %s\n", file, strerror(errno));
@@ -52,7 +53,7 @@ static void devgroup_parse_groupspec(const char *arg, unsigned int *group,
 	if (ok && (*end == '/' || *end == '\0')) {
 		if (*end == '/')
 			ok = xtables_strtoui(end + 1, NULL, mask,
-			                     0, UINT32_MAX);
+					     0, UINT32_MAX);
 		else
 			*mask = ~0U;
 		if (!ok)
@@ -129,7 +130,7 @@ static void devgroup_show(const char *pfx, const struct xt_devgroup_info *info,
 }
 
 static void devgroup_print(const void *ip, const struct xt_entry_match *match,
-                        int numeric)
+			   int numeric)
 {
 	const struct xt_devgroup_info *info = (const void *)match->data;
 
@@ -151,6 +152,56 @@ static void devgroup_check(struct xt_fcheck_call *cb)
 			      "'--src-group' or '--dst-group'");
 }
 
+static void
+print_devgroup_xlate(unsigned int id, const char *str,  unsigned int mask,
+		     struct xt_buf *buf, int numeric)
+{
+	const char *name = NULL;
+
+	if (mask != 0xffffffff)
+		xt_buf_add(buf, "and 0x%x %s 0x%x ", id, str, mask);
+	else {
+		if (numeric == 0)
+			name = xtables_lmap_id2name(devgroups, id);
+		if (name)
+			xt_buf_add(buf, "%s ", name);
+		else
+			xt_buf_add(buf, "0x%x ", id);
+	}
+}
+
+static void devgroup_show_xlate(const struct xt_devgroup_info *info,
+				struct xt_buf *buf, int numeric)
+{
+	const char *str = "==";
+
+	if (info->flags & XT_DEVGROUP_MATCH_SRC) {
+		if (info->flags & XT_DEVGROUP_INVERT_SRC)
+			str = "!=";
+		xt_buf_add(buf, "iifgroup ");
+		print_devgroup_xlate(info->src_group, str,
+				     info->src_mask, buf, numeric);
+	}
+
+	if (info->flags & XT_DEVGROUP_MATCH_DST) {
+		if (info->flags & XT_DEVGROUP_INVERT_DST)
+			str = "!=";
+		xt_buf_add(buf, "oifgroup ");
+		print_devgroup_xlate(info->dst_group, str,
+				     info->dst_mask, buf, numeric);
+	}
+}
+
+static int devgroup_xlate(const struct xt_entry_match *match,
+			  struct xt_buf *buf, int numeric)
+{
+	const struct xt_devgroup_info *info = (const void *)match->data;
+
+	devgroup_show_xlate(info, buf, 0);
+
+	return 1;
+}
+
 static struct xtables_match devgroup_mt_reg = {
 	.name		= "devgroup",
 	.version	= XTABLES_VERSION,
@@ -164,6 +215,7 @@ static struct xtables_match devgroup_mt_reg = {
 	.x6_parse	= devgroup_parse,
 	.x6_fcheck	= devgroup_check,
 	.x6_options	= devgroup_opts,
+	.xlate		= devgroup_xlate,
 };
 
 void _init(void)
-- 
1.9.1

