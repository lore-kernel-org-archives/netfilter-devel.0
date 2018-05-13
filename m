From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/15] netfilter: bridge: stp fix reference to uninitialized data
Date: Mon, 14 May 2018 00:36:45 +0200
Message-ID: <20180513223656.10077-5-pablo@netfilter.org>
References: <20180513223656.10077-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180513223656.10077-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>

The destination mac (destmac) is only valid if EBT_DESTMAC flag
is set. Fix by changing the order of the comparison to look for
the flag first.

Reported-by: syzbot+5c06e318fc558cc27823@syzkaller.appspotmail.com
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
2.11.0
