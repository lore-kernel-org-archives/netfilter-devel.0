From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nfnetlink: remove static declaration from err_list
Date: Sat, 18 Feb 2017 10:35:47 +0800
Message-ID: <1487385347-25257-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:52331 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752446AbdBRCgi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Feb 2017 21:36:38 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Otherwise, different subsys will race to access the err_list, with holding
the different nfnl_lock(subsys_id).

But this will not happen now, since ->call_batch is only implemented by
nftables, so the err_list is protected by nfnl_lock(NFNL_SUBSYS_NFTABLES).

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nfnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index a2148d0..68eda920 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -279,7 +279,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net *net = sock_net(skb->sk);
 	const struct nfnetlink_subsystem *ss;
 	const struct nfnl_callback *nc;
-	static LIST_HEAD(err_list);
+	LIST_HEAD(err_list);
 	u32 status;
 	int err;
 
-- 
2.5.5


