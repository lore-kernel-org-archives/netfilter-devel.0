From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH nf-next 3/3] netfilter: nfnetlink_queue: autoload
 nf_conntrack_netlink module NFQA_CFG_F_CONNTRACK config flag
Date: Fri, 6 Nov 2015 09:58:27 +0900
Message-ID: <20151106005827.GD11266@gmail.com>
References: <20151005024454.GA14637@gmail.com>
 <20151005025046.GE14637@gmail.com>
 <20151005152315.GA11562@salvia>
 <20151006021001.GA30037@gmail.com>
 <20151006021246.GB30037@gmail.com>
 <20151006100728.GA2429@salvia>
 <20151007042016.GA23203@gmail.com>
 <20151007042550.GC23203@gmail.com>
 <20151016170532.GA18148@salvia>
 <20151106004640.GA11266@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34203 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030447AbbKFA6c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2015 19:58:32 -0500
Received: by padhx2 with SMTP id hx2so95489284pad.1
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Nov 2015 16:58:32 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20151106004640.GA11266@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch enables to load nf_conntrack_netlink module if
NFQA_CFG_F_CONNTRACK config flag is specified.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 net/netfilter/nfnetlink_queue.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 98c9edc..d990c81 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1140,6 +1140,17 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		if (flags & mask & NFQA_CFG_F_SECCTX)
 			return -EOPNOTSUPP;
 #endif
+		if ((flags & mask & NFQA_CFG_F_CONNTRACK) &&
+		    !rcu_access_pointer(nfnl_ct_hook)) {
+#ifdef CONFIG_MODULES
+			nfnl_unlock(NFNL_SUBSYS_QUEUE);
+			request_module("ip_conntrack_netlink");
+			nfnl_lock(NFNL_SUBSYS_QUEUE);
+			if (rcu_access_pointer(nfnl_ct_hook))
+				return -EAGAIN;
+#endif
+			return -EOPNOTSUPP;
+		}
 	}
 
 	rcu_read_lock();
-- 
1.7.10.4
