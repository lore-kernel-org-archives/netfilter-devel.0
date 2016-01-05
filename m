From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH nf-next 4/5] netfilter: nfnetlink_queue: autoload
 nf_conntrack_netlink module NFQA_CFG_F_CONNTRACK config flag
Date: Tue, 5 Jan 2016 09:32:59 +0900
Message-ID: <20160105003259.GE27154@gmail.com>
References: <20151006021001.GA30037@gmail.com>
 <20151006021246.GB30037@gmail.com>
 <20151006100728.GA2429@salvia>
 <20151007042016.GA23203@gmail.com>
 <20151007042550.GC23203@gmail.com>
 <20151016170532.GA18148@salvia>
 <20151106004640.GA11266@gmail.com>
 <20151106004947.GB11266@gmail.com>
 <20151108221454.GA21221@salvia>
 <20160105002456.GA27154@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35420 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbcAEAdE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 19:33:04 -0500
Received: by mail-pa0-f52.google.com with SMTP id do7so4494037pab.2
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Jan 2016 16:33:03 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20160105002456.GA27154@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch enables to load nf_conntrack_netlink module if
NFQA_CFG_F_CONNTRACK config flag is specified.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 net/netfilter/nfnetlink_queue.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index c5cd50c..6168984 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1147,6 +1147,17 @@ static int nfqnl_recv_config(struct net *net, struct sock *ctnl,
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

