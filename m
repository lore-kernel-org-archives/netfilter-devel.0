From: Zhang Chunyu <zhangcy@cn.fujitsu.com>
Subject: [PATCH] Add NFPROTO_ARP for mark
Date: Mon, 6 Apr 2015 22:45:16 -0400
Message-ID: <1428374716-15108-2-git-send-email-zhangcy@cn.fujitsu.com>
References: <1428374716-15108-1-git-send-email-zhangcy@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Zhang Chunyu <zhangcy@cn.fujitsu.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18459 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752986AbbDGC7a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Apr 2015 22:59:30 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t372wMq6029432
	for <netfilter-devel@vger.kernel.org>; Tue, 7 Apr 2015 10:58:22 +0800
In-Reply-To: <1428374716-15108-1-git-send-email-zhangcy@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

need add NFPROTO_ARP and MODULE_ALIAS for arptables -mark

Signed-off-by: Zhang Chunyu <zhangcy@cn.fujitsu.com>
---
 net/netfilter/xt_mark.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 2334523..5778062 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -23,6 +23,7 @@ MODULE_ALIAS("ipt_mark");
 MODULE_ALIAS("ip6t_mark");
 MODULE_ALIAS("ipt_MARK");
 MODULE_ALIAS("ip6t_MARK");
+MODULE_ALIAS("arpt_MARK");
 
 static unsigned int
 mark_tg(struct sk_buff *skb, const struct xt_action_param *par)
@@ -41,13 +42,23 @@ mark_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return ((skb->mark & info->mask) == info->mark) ^ info->invert;
 }
 
-static struct xt_target mark_tg_reg __read_mostly = {
-	.name           = "MARK",
-	.revision       = 2,
-	.family         = NFPROTO_UNSPEC,
-	.target         = mark_tg,
-	.targetsize     = sizeof(struct xt_mark_tginfo2),
-	.me             = THIS_MODULE,
+static struct xt_target mark_tg_reg[] __read_mostly = {
+	{
+		.name           = "MARK",
+		.revision       = 2,
+		.family         = NFPROTO_UNSPEC,
+		.target         = mark_tg,
+		.targetsize     = sizeof(struct xt_mark_tginfo2),
+		.me             = THIS_MODULE,
+	},
+	{
+		.name           = "MARK",
+		.revision       = 2,
+		.family         = NFPROTO_ARP,
+		.target         = mark_tg,
+		.targetsize     = sizeof(struct xt_mark_tginfo2),
+		.me             = THIS_MODULE,
+	}
 };
 
 static struct xt_match mark_mt_reg __read_mostly = {
@@ -63,12 +74,12 @@ static int __init mark_mt_init(void)
 {
 	int ret;
 
-	ret = xt_register_target(&mark_tg_reg);
+	ret = xt_register_targets(mark_tg_reg, ARRAY_SIZE(mark_tg_reg));
 	if (ret < 0)
 		return ret;
 	ret = xt_register_match(&mark_mt_reg);
 	if (ret < 0) {
-		xt_unregister_target(&mark_tg_reg);
+		xt_unregister_targets(mark_tg_reg, ARRAY_SIZE(mark_tg_reg));
 		return ret;
 	}
 	return 0;
@@ -77,7 +88,7 @@ static int __init mark_mt_init(void)
 static void __exit mark_mt_exit(void)
 {
 	xt_unregister_match(&mark_mt_reg);
-	xt_unregister_target(&mark_tg_reg);
+	xt_unregister_targets(mark_tg_reg, ARRAY_SIZE(mark_tg_reg));
 }
 
 module_init(mark_mt_init);
-- 
1.7.12.4

