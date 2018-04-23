From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/12] netfilter: xt_connmark: Add bit mapping for bit-shift operation.
Date: Mon, 23 Apr 2018 19:57:06 +0200
Message-ID: <20180423175714.9794-5-pablo@netfilter.org>
References: <20180423175714.9794-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180423175714.9794-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jack Ma <jack.ma@alliedtelesis.co.nz>

With the addition of bit-shift operations, we are able to shift
ct/skbmark based on user requirements. However, this change might also
cause the most left/right hand- side mark to be accidentially lost
during shift operations.

This patch adds the ability to 'grep' certain bits based on ctmask or
nfmask out of the original mark. Then, apply shift operations to achieve
a new mapping between ctmark and skb->mark.

For example: If someone would like save the fourth F bits of ctmark
0xFFF(F)000F into the seventh hexadecimal (0) skb->mark 0xABC000(0)E.

	new_targetmark = (ctmark & ctmask) >> 12;
	(new) skb->mark = (skb->mark &~nfmask) ^
        	           new_targetmark;

This will preserve the other bits that are not related to this
operation.

Fixes: 472a73e00757 ("netfilter: xt_conntrack: Support bit-shifting for CONNMARK & MARK targets.")
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Jack Ma <jack.ma@alliedtelesis.co.nz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_connmark.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 773da82190dc..4b424e6caf3e 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -41,6 +41,7 @@ connmark_tg_shift(struct sk_buff *skb,
 		u8 shift_bits, u8 shift_dir)
 {
 	enum ip_conntrack_info ctinfo;
+	u_int32_t new_targetmark;
 	struct nf_conn *ct;
 	u_int32_t newmark;
 
@@ -61,24 +62,26 @@ connmark_tg_shift(struct sk_buff *skb,
 		}
 		break;
 	case XT_CONNMARK_SAVE:
-		newmark = (ct->mark & ~info->ctmask) ^
-			  (skb->mark & info->nfmask);
+		new_targetmark = (skb->mark & info->nfmask);
 		if (shift_dir == D_SHIFT_RIGHT)
-			newmark >>= shift_bits;
+			new_targetmark >>= shift_bits;
 		else
-			newmark <<= shift_bits;
+			new_targetmark <<= shift_bits;
+		newmark = (ct->mark & ~info->ctmask) ^
+			  new_targetmark;
 		if (ct->mark != newmark) {
 			ct->mark = newmark;
 			nf_conntrack_event_cache(IPCT_MARK, ct);
 		}
 		break;
 	case XT_CONNMARK_RESTORE:
-		newmark = (skb->mark & ~info->nfmask) ^
-			  (ct->mark & info->ctmask);
+		new_targetmark = (ct->mark & info->ctmask);
 		if (shift_dir == D_SHIFT_RIGHT)
-			newmark >>= shift_bits;
+			new_targetmark >>= shift_bits;
 		else
-			newmark <<= shift_bits;
+			new_targetmark <<= shift_bits;
+		newmark = (skb->mark & ~info->nfmask) ^
+			  new_targetmark;
 		skb->mark = newmark;
 		break;
 	}
-- 
2.11.0
