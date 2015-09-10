From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH nf-next 1/1] netfilter: nfnetlink_queue: return -EOPNOTSUPP
 if QUEUE_CT is disabled
Date: Thu, 10 Sep 2015 18:24:57 +0900
Message-ID: <20150910092457.GB28436@gmail.com>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <1441731291-21342-4-git-send-email-pablo@netfilter.org>
 <20150909095516.GC11843@gmail.com>
 <20150910000958.GC5734@salvia>
 <20150910092058.GA28436@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33017 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbbIJJZC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Sep 2015 05:25:02 -0400
Received: by pacex6 with SMTP id ex6so38232426pac.0
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2015 02:25:02 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150910092058.GA28436@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Current kernel ignores NFQA_CFG_F_CONNTRACK config flag request even
if NETFILTER_NETLINK_QUEUE_CT is disabled. This patch enables to tell
it user by returning error nlmsg.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 net/netfilter/nfnetlink_queue.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 801af4e..40982c7 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1224,6 +1224,11 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 			goto err_out_unlock;
 		}
 #endif
+		if (flags & mask & NFQA_CFG_F_CONNTRACK &&
+		    rcu_dereference(nfq_ct_hook) == NULL) {
+			ret = -EOPNOTSUPP;
+			goto err_out_unlock;
+		}
 		spin_lock_bh(&queue->lock);
 		queue->flags &= ~mask;
 		queue->flags |= flags & mask;
-- 
1.7.10.4

