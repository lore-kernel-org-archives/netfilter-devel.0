From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v4] extensions: libxt_devgroup: Add translation to nft
Date: Wed, 23 Dec 2015 20:14:02 +0530
Message-ID: <20151223144402.GA17250@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:34046 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbbLWOoK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2015 09:44:10 -0500
Received: by mail-pf0-f169.google.com with SMTP id e65so1195967pfe.1
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 06:44:09 -0800 (PST)
Received: from gmail.com ([223.176.140.7])
        by smtp.gmail.com with ESMTPSA id tb8sm53264645pab.22.2015.12.23.06.44.07
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 23 Dec 2015 06:44:08 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for device group to nftables.

Examples:

$ sudo iptables-translate -A FORWARD -m devgroup --src-group 0x2 -j ACCEPT
nft add rule ip filter FORWARD iifgroup 0x2 counter accept

$ sudo iptables-translate -A FORWARD -m devgroup --dst-group 0xc/0xc -j ACCEPT
nft add rule ip filter FORWARD oifgroup and 0xc == 0xc counter accept

$ sudo iptables-translate -t mangle -A PREROUTING -p tcp --dport 46000 -m devgroup --src-group 23 -j ACCEPT
nft add rule ip mangle PREROUTING tcp dport 46000 iifgroup 0x17 counter accept

$ sudo iptables-translate -A FORWARD -m devgroup ! --dst-group 0xc/0xc -j ACCEPT
nft add rule ip filter FORWARD oifgroup and 0xc != 0xc counter accept

$ sudo iptables-translate -A FORWARD -m devgroup ! --src-group 0x2 -j ACCEPT
nft add rule ip filter FORWARD iifgroup != 0x2 counter accept

Signed-off-by : Shivani Bhardwaj <shivanib134@gmail.com>
---
Changes in v4:
	Add enum in place of string added in the previous version to
	make code look better

 extensions/libxt_devgroup.c | 58 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_devgroup.c b/extensions/libxt_devgroup.c
index 1a52627..93126bc 100644
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
 
@@ -151,6 +152,58 @@ static void devgroup_check(struct xt_fcheck_call *cb)
 			      "'--src-group' or '--dst-group'");
 }
 
+static void
+print_devgroup_xlate(unsigned int id, uint32_t op,  unsigned int mask,
+		     struct xt_buf *buf, int numeric)
+{
+	const char *name = NULL;
+
+	if (mask != 0xffffffff)
+		xt_buf_add(buf, "and 0x%x %s 0x%x ", id,
+			   op == XT_OP_EQ ? "==" : "!=", mask);
+	else {
+		if (numeric == 0)
+			name = xtables_lmap_id2name(devgroups, id);
+		if (name)
+			xt_buf_add(buf, "%s ", name);
+		else
+			xt_buf_add(buf, "%s0x%x ",
+				   op == XT_OP_EQ ? "" : "!= ", id);
+	}
+}
+
+static void devgroup_show_xlate(const struct xt_devgroup_info *info,
+				struct xt_buf *buf, int numeric)
+{
+	enum xt_op op = XT_OP_EQ;
+
+	if (info->flags & XT_DEVGROUP_MATCH_SRC) {
+		if (info->flags & XT_DEVGROUP_INVERT_SRC)
+			op = XT_OP_NEQ;
+		xt_buf_add(buf, "iifgroup ");
+		print_devgroup_xlate(info->src_group, op,
+				     info->src_mask, buf, numeric);
+	}
+
+	if (info->flags & XT_DEVGROUP_MATCH_DST) {
+		if (info->flags & XT_DEVGROUP_INVERT_DST)
+			op = XT_OP_NEQ;
+		xt_buf_add(buf, "oifgroup ");
+		print_devgroup_xlate(info->dst_group, op,
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
@@ -164,6 +217,7 @@ static struct xtables_match devgroup_mt_reg = {
 	.x6_parse	= devgroup_parse,
 	.x6_fcheck	= devgroup_check,
 	.x6_options	= devgroup_opts,
+	.xlate		= devgroup_xlate,
 };
 
 void _init(void)
-- 
1.9.1

