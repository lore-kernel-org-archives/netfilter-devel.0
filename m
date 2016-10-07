From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables 6/8] extensions: libxt_quota: add translation to nft
Date: Fri,  7 Oct 2016 19:08:54 +0800
Message-ID: <1475838536-28816-7-git-send-email-zlpnobody@163.com>
References: <1475838536-28816-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:59367 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752298AbcJGLKC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Oct 2016 07:10:02 -0400
In-Reply-To: <1475838536-28816-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

For example:
  # iptables-translate -A OUTPUT -m quota --quota 111
  nft add rule ip filter OUTPUT quota 111 bytes counter

  # iptables-translate -A OUTPUT -m quota ! --quota 111
  nft add rule ip filter OUTPUT quota over 111 bytes counter

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libxt_quota.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index ff7dd2a..bad77d2 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -50,6 +50,17 @@ static void quota_parse(struct xt_option_call *cb)
 		info->flags |= XT_QUOTA_INVERT;
 }
 
+static int quota_xlate(struct xt_xlate *xl,
+		       const struct xt_xlate_mt_params *params)
+{
+	const struct xt_quota_info *q = (void *)params->match->data;
+
+	xt_xlate_add(xl, "quota %s%llu bytes",
+		     q->flags & XT_QUOTA_INVERT ? "over " : "",
+		     (unsigned long long) q->quota);
+	return 1;
+}
+
 static struct xtables_match quota_match = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "quota",
@@ -61,6 +72,7 @@ static struct xtables_match quota_match = {
 	.save		= quota_save,
 	.x6_parse	= quota_parse,
 	.x6_options	= quota_opts,
+	.xlate		= quota_xlate,
 };
 
 void
-- 
2.5.5


