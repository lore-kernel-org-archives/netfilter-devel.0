From: Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 6/6] netfilter: xt_u32: fix length checks in u32_match_it
Date: Thu, 16 Aug 2007 14:19:12 +0100
Message-ID: <3a5bf48d1567d7136baaac80dfa4c94f@pinky>
References: <exportbomb.1187270320@pinky>
Cc: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
	netfilter-devel@lists.netfilter.org, Andy Whitcroft <apw@shadowen.org>
To: linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


It seems an extraneous trailing ';' has slipped into the skb length
checks in u32_match_it() triggering an unconditional missmatch.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: netfilter-devel@lists.netfilter.org
---
 net/netfilter/xt_u32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index 74f9b14..bec4279 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -36,7 +36,7 @@ static bool u32_match_it(const struct xt_u32 *data,
 		at  = 0;
 		pos = ct->location[0].number;
 
-		if (skb->len < 4 || pos > skb->len - 4);
+		if (skb->len < 4 || pos > skb->len - 4)
 			return false;
 
 		ret   = skb_copy_bits(skb, pos, &n, sizeof(n));
