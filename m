From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 37/47] netfilter: ebt_stp: Use generic functions for comparisons
Date: Fri, 30 Mar 2018 13:44:59 +0200
Message-ID: <20180330114509.18738-8-pablo@netfilter.org>
References: <20180330114509.18738-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330114509.18738-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Joe Perches <joe@perches.com>

Instead of unnecessary const declarations, use the generic functions to
save a little object space.

$ size net/bridge/netfilter/ebt_stp.o*
   text	   data	    bss	    dec	    hex	filename
   1250	    144	      0	   1394	    572	net/bridge/netfilter/ebt_stp.o.new
   1344	    144	      0	   1488	    5d0	net/bridge/netfilter/ebt_stp.o.old

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebt_stp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index 3140eb912d7e..47ba98db145d 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -153,8 +153,6 @@ ebt_stp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 static int ebt_stp_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ebt_stp_info *info = par->matchinfo;
-	const u8 bridge_ula[6] = {0x01, 0x80, 0xc2, 0x00, 0x00, 0x00};
-	const u8 msk[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	const struct ebt_entry *e = par->entryinfo;
 
 	if (info->bitmask & ~EBT_STP_MASK || info->invflags & ~EBT_STP_MASK ||
@@ -162,8 +160,8 @@ static int ebt_stp_mt_check(const struct xt_mtchk_param *par)
 		return -EINVAL;
 	/* Make sure the match only receives stp frames */
 	if (!par->nft_compat &&
-	    (!ether_addr_equal(e->destmac, bridge_ula) ||
-	     !ether_addr_equal(e->destmsk, msk) ||
+	    (!ether_addr_equal(e->destmac, eth_stp_addr) ||
+	     !is_broadcast_ether_addr(e->destmsk) ||
 	     !(e->bitmask & EBT_DESTMAC)))
 		return -EINVAL;
 
-- 
2.11.0
