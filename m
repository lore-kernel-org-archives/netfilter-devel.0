From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH nf-next 2/2] netfilter: ipt_ULOG: make spinlock per nlgroup
Date: Tue, 19 Feb 2013 10:59:11 +0800
Message-ID: <1361242751-20827-2-git-send-email-gaofeng@cn.fujitsu.com>
References: <1361242751-20827-1-git-send-email-gaofeng@cn.fujitsu.com>
Cc: netfilter-devel@vger.kernel.org, Gao feng <gaofeng@cn.fujitsu.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:37253 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757878Ab3BSC6j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:58:39 -0500
In-Reply-To: <1361242751-20827-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch makes the spin lock per group instead of
global spin lock,just like ebt_ulog.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/ipv4/netfilter/ipt_ULOG.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 7d168dc..3f9f810 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -76,12 +76,12 @@ typedef struct {
 	struct nlmsghdr *lastnlh;	/* netlink header of last msg in skb */
 	struct sk_buff *skb;		/* the pre-allocated skb */
 	struct timer_list timer;	/* the timer function */
+	spinlock_t lock;		/* the per-queue lock */
 } ulog_buff_t;
 
 static ulog_buff_t ulog_buffers[ULOG_MAXNLGROUPS];	/* array of buffers */
 
 static struct sock *nflognl;		/* our socket */
-static DEFINE_SPINLOCK(ulog_lock);	/* spinlock */
 
 /* send one ulog_buff_t to userspace */
 static void ulog_send(unsigned int nlgroupnum)
@@ -118,9 +118,9 @@ static void ulog_timer(unsigned long data)
 
 	/* lock to protect against somebody modifying our structure
 	 * from ipt_ulog_target at the same time */
-	spin_lock_bh(&ulog_lock);
+	spin_lock_bh(&ulog_buffers[data].lock);
 	ulog_send(data);
-	spin_unlock_bh(&ulog_lock);
+	spin_unlock_bh(&ulog_buffers[data].lock);
 }
 
 static struct sk_buff *ulog_alloc_skb(unsigned int size)
@@ -176,7 +176,7 @@ static void ipt_ulog_packet(unsigned int hooknum,
 
 	ub = &ulog_buffers[groupnum];
 
-	spin_lock_bh(&ulog_lock);
+	spin_lock_bh(&ub->lock);
 
 	if (!ub->skb) {
 		if (!(ub->skb = ulog_alloc_skb(size)))
@@ -263,13 +263,13 @@ static void ipt_ulog_packet(unsigned int hooknum,
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
@@ -391,8 +391,10 @@ static int __init ulog_tg_init(void)
 	}
 
 	/* initialize ulog_buffers */
-	for (i = 0; i < ULOG_MAXNLGROUPS; i++)
+	for (i = 0; i < ULOG_MAXNLGROUPS; i++) {
 		setup_timer(&ulog_buffers[i].timer, ulog_timer, i);
+		spin_lock_init(&ulog_buffers[i].lock);
+	}
 
 	nflognl = netlink_kernel_create(&init_net, NETLINK_NFLOG, &cfg);
 	if (!nflognl)
-- 
1.7.11.7

