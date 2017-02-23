From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 8/8] netfilter: nfnetlink: remove static declaration from err_list
Date: Thu, 23 Feb 2017 12:14:09 +0100
Message-ID: <1487848449-2731-9-git-send-email-pablo@netfilter.org>
References: <1487848449-2731-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1487848449-2731-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Liping Zhang <zlpnobody@gmail.com>

Otherwise, different subsys will race to access the err_list, with holding
the different nfnl_lock(subsys_id).

But this will not happen now, since ->call_batch is only implemented by
nftables, so the err_list is protected by nfnl_lock(NFNL_SUBSYS_NFTABLES).

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index a09fa9fd8f3d..6fa448478cba 100644
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
2.1.4
