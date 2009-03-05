From: Florian Westphal <fwestphal@astaro.com>
Subject: [PATCH xt-addons] TEE: do not use ipv6 if CONFIG_IPV6=n
Date: Thu,  5 Mar 2009 11:01:50 +0100
Message-ID: <1236247310-7895-1-git-send-email-fwestphal@astaro.com>
Cc: Florian Westphal <fwestphal@astaro.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-89.dex002.intermedia.net ([64.78.20.227]:4480 "EHLO
	dhost002-89.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692AbZCEKRK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:17:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

WARNING: xt_TEE.ko needs unknown symbol ip6_route_output

Signed-off-by: Florian Westphal <fwestphal@astaro.com>
---
 extensions/xt_TEE.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/extensions/xt_TEE.c b/extensions/xt_TEE.c
index 265fc90..c605e49 100644
--- a/extensions/xt_TEE.c
+++ b/extensions/xt_TEE.c
@@ -210,6 +210,7 @@ tee_tg4(struct sk_buff **pskb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 static bool
 tee_tg_route6(struct sk_buff *skb, const struct xt_tee_tginfo *info)
 {
@@ -263,6 +264,7 @@ tee_tg6(struct sk_buff **pskb, const struct xt_target_param *par)
 
 	return XT_CONTINUE;
 }
+#endif
 
 static bool tee_tg_check(const struct xt_tgchk_param *par)
 {
@@ -284,6 +286,7 @@ static struct xt_target tee_tg_reg[] __read_mostly = {
 		.checkentry = tee_tg_check,
 		.me         = THIS_MODULE,
 	},
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 	{
 		.name       = "TEE",
 		.revision   = 0,
@@ -294,6 +297,7 @@ static struct xt_target tee_tg_reg[] __read_mostly = {
 		.checkentry = tee_tg_check,
 		.me         = THIS_MODULE,
 	},
+#endif
 };
 
 static int __init tee_tg_init(void)
-- 
1.5.6.5

