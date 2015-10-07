From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH nf-next] netfilter: nfnetlink_log: autoload
 nf_conntrack_netlink module NFQA_CFG_F_CONNTRACK config flag
Date: Wed, 7 Oct 2015 13:25:50 +0900
Message-ID: <20151007042550.GC23203@gmail.com>
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
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33136 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbbJGEZz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Oct 2015 00:25:55 -0400
Received: by pacex6 with SMTP id ex6so8342394pac.0
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Oct 2015 21:25:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20151007042016.GA23203@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch enables to load nf_conntrack_netlink module if
NFULNL_CFG_F_CONNTRACK config flag is specified.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 net/netfilter/nfnetlink_log.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index e1d1187..f8d9bd8 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -927,7 +927,16 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		}
 
 		if (flags & NFULNL_CFG_F_CONNTRACK &&
-		    rcu_access_pointer(nfnl_ct_hook) == NULL) {
+		    !rcu_access_pointer(nfnl_ct_hook)) {
+#ifdef CONFIG_MODULES
+			nfnl_unlock(NFNL_SUBSYS_ULOG);
+			request_module("ip_conntrack_netlink");
+			nfnl_lock(NFNL_SUBSYS_ULOG);
+			if (rcu_access_pointer(nfnl_ct_hook)) {
+				ret = -EAGAIN;
+				goto out;
+			}
+#endif
 			ret = -EOPNOTSUPP;
 			goto out;
 		}
-- 
1.7.10.4

