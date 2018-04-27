From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net] bridge: netfilter stp fix reference to uninitialized data
Date: Fri, 27 Apr 2018 11:16:09 -0700
Message-ID: <20180427181609.3103-1-sthemmin@microsoft.com>
Cc: netfilter-devel@vger.kernel.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Hemminger <stephen@networkplumber.org>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The destination mac (destmac) is only valid if EBT_DESTMAC flag
is set. Fix by changing the order of the comparison to look for
the flag first.

Reported-by: syzbot+5c06e318fc558cc27823@syzkaller.appspotmail.com
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
Note: no fixes since this bug goes back to pre-git days.
Should go to stable as well.

 net/bridge/netfilter/ebt_stp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index 47ba98db145d..46c1fe7637ea 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -161,8 +161,8 @@ static int ebt_stp_mt_check(const struct xt_mtchk_param *par)
 	/* Make sure the match only receives stp frames */
 	if (!par->nft_compat &&
 	    (!ether_addr_equal(e->destmac, eth_stp_addr) ||
-	     !is_broadcast_ether_addr(e->destmsk) ||
-	     !(e->bitmask & EBT_DESTMAC)))
+	     !(e->bitmask & EBT_DESTMAC) ||
+	     !is_broadcast_ether_addr(e->destmsk)))
 		return -EINVAL;
 
 	return 0;
-- 
2.17.0
