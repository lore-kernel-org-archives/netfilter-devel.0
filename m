From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: xt_cpu: no need to check the validity of invert flag
Date: Wed,  8 Jun 2016 20:23:27 +0800
Message-ID: <1465388607-26771-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:55613 "EHLO m12-18.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbcFHMX7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2016 08:23:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Instead, we can convert invert flag and ensure it is 1 or 0.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/xt_cpu.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/net/netfilter/xt_cpu.c b/net/netfilter/xt_cpu.c
index c7a2e54..ca1eaaf 100644
--- a/net/netfilter/xt_cpu.c
+++ b/net/netfilter/xt_cpu.c
@@ -25,27 +25,17 @@ MODULE_DESCRIPTION("Xtables: CPU match");
 MODULE_ALIAS("ipt_cpu");
 MODULE_ALIAS("ip6t_cpu");
 
-static int cpu_mt_check(const struct xt_mtchk_param *par)
-{
-	const struct xt_cpu_info *info = par->matchinfo;
-
-	if (info->invert & ~1)
-		return -EINVAL;
-	return 0;
-}
-
 static bool cpu_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_cpu_info *info = par->matchinfo;
 
-	return (info->cpu == smp_processor_id()) ^ info->invert;
+	return (info->cpu == smp_processor_id()) ^ !!info->invert;
 }
 
 static struct xt_match cpu_mt_reg __read_mostly = {
 	.name       = "cpu",
 	.revision   = 0,
 	.family     = NFPROTO_UNSPEC,
-	.checkentry = cpu_mt_check,
 	.match      = cpu_mt,
 	.matchsize  = sizeof(struct xt_cpu_info),
 	.me         = THIS_MODULE,
-- 
2.5.5


