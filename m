From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/6] netfilter: nfnetlink: use original skbuff when acking batches
Date: Tue, 16 Feb 2016 18:02:33 +0100
Message-ID: <1455642157-6864-3-git-send-email-pablo@netfilter.org>
References: <1455642157-6864-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1455642157-6864-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Since bd678e09dc17 ("netfilter: nfnetlink: fix splat due to incorrect
socket memory accounting in skbuff clones"), we don't manually attach
the sk to the skbuff clone anymore, so we have to use the original
skbuff from netlink_ack() which needs to access the sk pointer.

Fixes: bd678e09dc17 ("netfilter: nfnetlink: fix splat due to incorrect socket memory accounting in skbuff clones")
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index a7ba233..62e92af 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -311,14 +311,14 @@ replay:
 #endif
 		{
 			nfnl_unlock(subsys_id);
-			netlink_ack(skb, nlh, -EOPNOTSUPP);
+			netlink_ack(oskb, nlh, -EOPNOTSUPP);
 			return kfree_skb(skb);
 		}
 	}
 
 	if (!ss->commit || !ss->abort) {
 		nfnl_unlock(subsys_id);
-		netlink_ack(skb, nlh, -EOPNOTSUPP);
+		netlink_ack(oskb, nlh, -EOPNOTSUPP);
 		return kfree_skb(skb);
 	}
 
@@ -406,7 +406,7 @@ ack:
 				 * pointing to the batch header.
 				 */
 				nfnl_err_reset(&err_list);
-				netlink_ack(skb, nlmsg_hdr(oskb), -ENOMEM);
+				netlink_ack(oskb, nlmsg_hdr(oskb), -ENOMEM);
 				status |= NFNL_BATCH_FAILURE;
 				goto done;
 			}
-- 
2.1.4
