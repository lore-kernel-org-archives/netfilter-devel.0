From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH nf-next 1/2] netfilter: ebt_ulog: remove useless spin lock protection
Date: Tue, 19 Feb 2013 10:59:10 +0800
Message-ID: <1361242751-20827-1-git-send-email-gaofeng@cn.fujitsu.com>
Cc: netfilter-devel@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:37253 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757367Ab3BSC6i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:58:38 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

when removing the module ebt_ulog,expect ebt_ulog_fini,
there are no other codes to operate ebt_ulog_buffer's
skb. So it is no need to add spin lock protection in
ebt_ulog_fini.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/bridge/netfilter/ebt_ulog.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 3bf43f7..442b032 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -319,12 +319,11 @@ static void __exit ebt_ulog_fini(void)
 	for (i = 0; i < EBT_ULOG_MAXNLGROUPS; i++) {
 		ub = &ulog_buffers[i];
 		del_timer(&ub->timer);
-		spin_lock_bh(&ub->lock);
+
 		if (ub->skb) {
 			kfree_skb(ub->skb);
 			ub->skb = NULL;
 		}
-		spin_unlock_bh(&ub->lock);
 	}
 	netlink_kernel_release(ebtulognl);
 }
-- 
1.7.11.7

