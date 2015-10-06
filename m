From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCHv2 nf-next 1/1] netfilter: nfnetlink_queue: check
 NFQA_CFG_F_CONNTRACK config flag
Date: Tue, 6 Oct 2015 11:12:46 +0900
Message-ID: <20151006021246.GB30037@gmail.com>
References: <1443724990-4014-1-git-send-email-pablo@netfilter.org>
 <1443724990-4014-2-git-send-email-pablo@netfilter.org>
 <20151005024454.GA14637@gmail.com>
 <20151005025046.GE14637@gmail.com>
 <20151005152315.GA11562@salvia>
 <20151006021001.GA30037@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33072 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbbJFCMv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2015 22:12:51 -0400
Received: by pacex6 with SMTP id ex6so194127601pac.0
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Oct 2015 19:12:50 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20151006021001.GA30037@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch enables to check GLUE_CT is enabled or not when
NFQA_CFG_F_CONNTRACK config flag is received. And try to load
nf_conntrack_netlink module, and l3proto module if family is
specified. Then returns error either case is failed.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 net/netfilter/nfnetlink_queue.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a659e57..99c9c8c 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -34,6 +34,7 @@
 #include <net/tcp_states.h>
 #include <net/netfilter/nf_queue.h>
 #include <net/netns/generic.h>
+#include <net/netfilter/nf_conntrack.h>
 
 #include <linux/atomic.h>
 
@@ -1225,6 +1226,24 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 			goto err_out_unlock;
 		}
 #endif
+		if (flags & mask & NFQA_CFG_F_CONNTRACK) {
+			if (!rcu_access_pointer(nfnl_ct_hook))
+#ifdef CONFIG_MODULES
+				if (request_module("ip_conntrack_netlink") ||
+				    !rcu_access_pointer(nfnl_ct_hook))
+#endif
+				{
+					ret = -EOPNOTSUPP;
+					goto err_out_unlock;
+				}
+
+			if (nfmsg->nfgen_family &&
+			    nf_ct_l3proto_try_module_get(nfmsg->nfgen_family)) {
+				ret = -EPROTONOSUPPORT;
+				goto err_out_unlock;
+			}
+		}
+
 		spin_lock_bh(&queue->lock);
 		queue->flags &= ~mask;
 		queue->flags |= flags & mask;
-- 
1.7.10.4

