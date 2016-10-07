From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables 8/8] extensions: libxt_statistic: add translation to nft
Date: Fri,  7 Oct 2016 19:08:56 +0800
Message-ID: <1475838536-28816-9-git-send-email-zlpnobody@163.com>
References: <1475838536-28816-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:59461 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752430AbcJGLKC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Oct 2016 07:10:02 -0400
In-Reply-To: <1475838536-28816-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

For example:
  # iptables-translate -A OUTPUT -m statistic --mode nth --every 10 \
  --packet 1
  nft add rule ip filter OUTPUT numgen inc mod 10 1 counter

  # iptables-translate -A OUTPUT -m statistic --mode nth ! --every 10 \
  --packet 5
  nft add rule ip filter OUTPUT numgen inc mod 10 != 5 counter

Note, mode random is not completely supported in nft, so:
  # iptables-translate -A OUTPUT -m statistic --mode random \
  --probability 0.1
  nft # -A OUTPUT -m statistic --mode random --probability 0.1

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libxt_statistic.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index b6ae5f5..4f3341a 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -133,6 +133,26 @@ static void statistic_save(const void *ip, const struct xt_entry_match *match)
 	print_match(info, "--");
 }
 
+static int statistic_xlate(struct xt_xlate *xl,
+			   const struct xt_xlate_mt_params *params)
+{
+	const struct xt_statistic_info *info =
+		(struct xt_statistic_info *)params->match->data;
+
+	switch (info->mode) {
+	case XT_STATISTIC_MODE_RANDOM:
+		return 0;
+	case XT_STATISTIC_MODE_NTH:
+		xt_xlate_add(xl, "numgen inc mod %u %s%u",
+			     info->u.nth.every + 1,
+			     info->flags & XT_STATISTIC_INVERT ? "!= " : "",
+			     info->u.nth.packet);
+		break;
+	}
+
+	return 1;
+}
+
 static struct xtables_match statistic_match = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "statistic",
@@ -145,6 +165,7 @@ static struct xtables_match statistic_match = {
 	.print		= statistic_print,
 	.save		= statistic_save,
 	.x6_options	= statistic_opts,
+	.xlate		= statistic_xlate,
 };
 
 void _init(void)
-- 
2.5.5


