From: Zhang Chunyu <zhangcy@cn.fujitsu.com>
Subject: [PATCH] Add arpt_MARK to xt_mark
Date: Fri, 17 Apr 2015 10:21:32 +0800
Message-ID: <1429237292-17701-1-git-send-email-zhangcy@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Zhang Chunyu <zhangcy@cn.fujitsu.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10420 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750810AbbDQCb1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Apr 2015 22:31:27 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3H2UEZV001455
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Apr 2015 10:30:14 +0800
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

for http://git.netfilter.org/arptables/commit/?h=next&id=4bb2f8340783fd3a3f70aa6f8807428a280f8474

Signed-off-by: Zhang Chunyu <zhangcy@cn.fujitsu.com>
---
 net/netfilter/xt_mark.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 2334523..ebd41dc 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -23,6 +23,7 @@ MODULE_ALIAS("ipt_mark");
 MODULE_ALIAS("ip6t_mark");
 MODULE_ALIAS("ipt_MARK");
 MODULE_ALIAS("ip6t_MARK");
+MODULE_ALIAS("arpt_MARK");
 
 static unsigned int
 mark_tg(struct sk_buff *skb, const struct xt_action_param *par)
-- 
2.3.5

