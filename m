From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/12] netfilter: nfnetlink_log: Use GFP_NOWARN for skb allocation
Date: Tue,  1 Nov 2016 22:26:23 +0100
Message-ID: <1478035593-1362-3-git-send-email-pablo@netfilter.org>
References: <1478035593-1362-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1478035593-1362-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Calvin Owens <calvinowens@fb.com>

Since the code explicilty falls back to a smaller allocation when the
large one fails, we shouldn't complain when that happens.

Signed-off-by: Calvin Owens <calvinowens@fb.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index eb086a192c5a..7435505037b7 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -330,7 +330,7 @@ nfulnl_alloc_skb(struct net *net, u32 peer_portid, unsigned int inst_size,
 	 * message.  WARNING: has to be <= 128k due to slab restrictions */
 
 	n = max(inst_size, pkt_size);
-	skb = alloc_skb(n, GFP_ATOMIC);
+	skb = alloc_skb(n, GFP_ATOMIC | __GFP_NOWARN);
 	if (!skb) {
 		if (n > pkt_size) {
 			/* try to allocate only as much as we need for current
-- 
2.1.4
