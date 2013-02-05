From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH] ulog: add protection when remove ipt_ULOG
Date: Tue, 5 Feb 2013 09:57:30 +0800
Message-ID: <1360029450-6673-1-git-send-email-gaofeng@cn.fujitsu.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:40444 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab3BEB5P (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Feb 2013 20:57:15 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r151v4St000615
	for <netfilter-devel@vger.kernel.org>; Tue, 5 Feb 2013 09:57:05 +0800
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We should add a lock protection when we free the skb,
because it maybe used by ipt_ulog_packet right now.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/ipv4/netfilter/ipt_ULOG.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index b5ef3cb..b390002 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -430,11 +430,12 @@ static void __exit ulog_tg_exit(void)
 			pr_debug("timer was pending, deleting\n");
 			del_timer(&ub->timer);
 		}
-
+		spin_lock_bh(&ulog_lock);
 		if (ub->skb) {
 			kfree_skb(ub->skb);
 			ub->skb = NULL;
 		}
+		spin_unlock_bh(&ulog_lock);
 	}
 }
 
-- 
1.7.11.7

