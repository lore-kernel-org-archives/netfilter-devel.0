From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCHv3 nf-next] netfilter: nfnetlink_queue: check
 NFQA_CFG_F_CONNTRACK config flag
Date: Wed, 7 Oct 2015 13:23:47 +0900
Message-ID: <20151007042347.GB23203@gmail.com>
References: <1443724990-4014-1-git-send-email-pablo@netfilter.org>
 <1443724990-4014-2-git-send-email-pablo@netfilter.org>
 <20151005024454.GA14637@gmail.com>
 <20151005025046.GE14637@gmail.com>
 <20151005152315.GA11562@salvia>
 <20151006021001.GA30037@gmail.com>
 <20151006021246.GB30037@gmail.com>
 <20151006100728.GA2429@salvia>
 <20151007042016.GA23203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34739 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbbJGEXx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Oct 2015 00:23:53 -0400
Received: by padhy16 with SMTP id hy16so8260657pad.1
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Oct 2015 21:23:52 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20151007042016.GA23203@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch enables to check if GLUE_CT is enabled and try to load
dependent, nf_conntrack_netlink module when NFQA_CFG_F_CONNTRACK
config flag is received. Then returns error either case is failed.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 net/netfilter/nfnetlink_queue.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a659e57..583a7a0 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1225,6 +1225,23 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 			goto err_out_unlock;
 		}
 #endif
+		if (flags & mask & NFQA_CFG_F_CONNTRACK &&
+		    !rcu_dereference(nfnl_ct_hook)) {
+#ifdef CONFIG_MODULES
+			rcu_read_unlock();
+			nfnl_unlock(NFNL_SUBSYS_QUEUE);
+			request_module("ip_conntrack_netlink");
+			nfnl_lock(NFNL_SUBSYS_QUEUE);
+			rcu_read_lock();
+			if (rcu_dereference(nfnl_ct_hook)) {
+				ret = -EAGAIN;
+				goto err_out_unlock;
+			}
+#endif
+			ret = -EOPNOTSUPP;
+			goto err_out_unlock;
+		}
+
 		spin_lock_bh(&queue->lock);
 		queue->flags &= ~mask;
 		queue->flags |= flags & mask;
-- 
1.7.10.4

