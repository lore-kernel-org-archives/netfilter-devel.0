From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable-3.9 08/15] netfilter: nfnetlink_acct: fix incomplete dumping of objects
Date: Tue,  2 Jul 2013 16:50:58 +0200
Message-ID: <1372776665-6795-8-git-send-email-pablo@netfilter.org>
References: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Fix broken incomplete object dumping if the list of objects does not
fit into one single netlink message.

Reported-by: Gabriel Lazar <Gabriel.Lazar@com.utcluj.ro>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Cherry-pick: 991a6b735ff47710769545b11e481bb140b2e6f7

 net/netfilter/nfnetlink_acct.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index dc3fd5d..c7b6d46 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -149,9 +149,12 @@ nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(cur, &nfnl_acct_list, head) {
-		if (last && cur != last)
-			continue;
+		if (last) {
+			if (cur != last)
+				continue;
 
+			last = NULL;
+		}
 		if (nfnl_acct_fill_info(skb, NETLINK_CB(cb->skb).portid,
 				       cb->nlh->nlmsg_seq,
 				       NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
-- 
1.7.10.4
