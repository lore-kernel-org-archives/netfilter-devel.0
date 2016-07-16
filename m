From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH V2 iptables] extensions: libxt_connlabel: Add translation to nft
Date: Sat, 16 Jul 2016 18:42:24 +0800
Message-ID: <1468665744-21839-1-git-send-email-zlpnobody@163.com>
Cc: fw@strlen.de, Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:38314 "EHLO m12-11.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbcGPKn2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Jul 2016 06:43:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Add translation for connlabel to nftables.
For examples:

  # iptables-translate -A INPUT -m connlabel --label bit40
  nft add rule ip filter INPUT ct label bit40 counter

  # iptables-translate -A INPUT -m connlabel ! --label bit40 --set
  nft add rule ip filter INPUT ct label set bit40 ct label and bit40 != bit40 counter

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 V2: fix wrong translation when "!" is set, pointed by Florian Westphal.
 extensions/libxt_connlabel.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/extensions/libxt_connlabel.c b/extensions/libxt_connlabel.c
index 1f83095..96b9aec 100644
--- a/extensions/libxt_connlabel.c
+++ b/extensions/libxt_connlabel.c
@@ -118,6 +118,27 @@ connlabel_mt_save(const void *ip, const struct xt_entry_match *match)
 	connlabel_mt_print_op(info, "--");
 }
 
+static int
+connlabel_mt_xlate(const void *ip, const struct xt_entry_match *match,
+		   struct xt_xlate *xl, int numeric)
+{
+	const struct xt_connlabel_mtinfo *info = (const void *)match->data;
+	const char *name = connlabel_get_name(info->bit);
+
+	if (name == NULL)
+		return 0;
+
+	if (info->options & XT_CONNLABEL_OP_SET)
+		xt_xlate_add(xl, "ct label set %s ", name);
+
+	xt_xlate_add(xl, "ct label ");
+	if (info->options & XT_CONNLABEL_OP_INVERT)
+		xt_xlate_add(xl, "and %s != ", name);
+	xt_xlate_add(xl, "%s", name);
+
+	return 1;
+}
+
 static struct xtables_match connlabel_mt_reg = {
 	.family        = NFPROTO_UNSPEC,
 	.name          = "connlabel",
@@ -129,6 +150,7 @@ static struct xtables_match connlabel_mt_reg = {
 	.save          = connlabel_mt_save,
 	.x6_parse      = connlabel_mt_parse,
 	.x6_options    = connlabel_mt_opts,
+	.xlate	       = connlabel_mt_xlate,
 };
 
 void _init(void)
-- 
2.5.5


