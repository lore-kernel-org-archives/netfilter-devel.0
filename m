From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 2/2] netfilter: ipt_ULOG: make spinlock per nlgroup
Date: Tue, 5 Feb 2013 10:48:37 +0800
Message-ID: <1360032517-3785-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1360029450-6673-1-git-send-email-gaofeng@cn.fujitsu.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:10177 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753641Ab3BECsI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Feb 2013 21:48:08 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r152m6MC004148
	for <netfilter-devel@vger.kernel.org>; Tue, 5 Feb 2013 10:48:06 +0800
In-Reply-To: <1360029450-6673-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch uses the spin lock per group instead of
global spin lock,just like ebt_ulog.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/ipv4/netfilter/ipt_ULOG.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index b390002..09a03e4 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -76,12 +76,12 @@ typedef struct {
 	struct nlmsghdr *lastnlh;	/* netlink header of last msg in skb */
 	struct sk_buff *skb;		/* the pre-allocated skb */
 	struct timer_list timer;	/* the timer function */
+	spinlock_t lock;		/* the pre-queue lock */
 } ulog_buff_t;
 
 static ulog_buff_t ulog_buffers[ULOG_MAXNLGROUPS];	/* array of buffers */
 
 static struct sock *nflognl;		/* our socket */
-static DEFINE_SPINLOCK(ulog_lock);	/* spinlock */
 
 /* send one ulog_buff_t to userspace */
 static void ulog_send(unsigned int nlgroupnum)
@@ -120,9 +120,9 @@ static void ulog_timer(unsigned long data)
 
 	/* lock to protect against somebody modifying our structure
 	 * from ipt_ulog_target at the same time */
-	spin_lock_bh(&ulog_lock);
+	spin_lock_bh(&ulog_buffers[data].lock);
 	ulog_send(data);
-	spin_unlock_bh(&ulog_lock);
+	spin_unlock_bh(&ulog_buffers[data].lock);
 }
 
 static struct sk_buff *ulog_alloc_skb(unsigned int size)
@@ -178,7 +178,7 @@ static void ipt_ulog_packet(unsigned int hooknum,
 
 	ub = &ulog_buffers[groupnum];
 
-	spin_lock_bh(&ulog_lock);
+	spin_lock_bh(&ub->lock);
 
 	if (!ub->skb) {
 		if (!(ub->skb = ulog_alloc_skb(size)))
@@ -265,13 +265,13 @@ static void ipt_ulog_packet(unsigned int hooknum,
 		ulog_send(groupnum);
 	}
 out_unlock:
-	spin_unlock_bh(&ulog_lock);
+	spin_unlock_bh(&ub->lock);
 
 	return;
 
 alloc_failure:
 	pr_debug("Error building netlink message\n");
-	spin_unlock_bh(&ulog_lock);
+	spin_unlock_bh(&ub->lock);
 }
 
 static unsigned int
@@ -393,8 +393,10 @@ static int __init ulog_tg_init(void)
 	}
 
 	/* initialize ulog_buffers */
-	for (i = 0; i < ULOG_MAXNLGROUPS; i++)
+	for (i = 0; i < ULOG_MAXNLGROUPS; i++) {
 		setup_timer(&ulog_buffers[i].timer, ulog_timer, i);
+		spin_lock_init(&ulog_buffers[i].lock);
+	}
 
 	nflognl = netlink_kernel_create(&init_net, NETLINK_NFLOG, &cfg);
 	if (!nflognl)
@@ -430,12 +432,12 @@ static void __exit ulog_tg_exit(void)
 			pr_debug("timer was pending, deleting\n");
 			del_timer(&ub->timer);
 		}
-		spin_lock_bh(&ulog_lock);
+		spin_lock_bh(&ub->lock);
 		if (ub->skb) {
 			kfree_skb(ub->skb);
 			ub->skb = NULL;
 		}
-		spin_unlock_bh(&ulog_lock);
+		spin_unlock_bh(&ub->lock);
 	}
 }
 
-- 
1.7.11.7

