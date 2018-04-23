From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 12/12] netfilter: xt_connmark: do not cast xt_connmark_tginfo1 to xt_connmark_tginfo2
Date: Mon, 23 Apr 2018 19:57:14 +0200
Message-ID: <20180423175714.9794-13-pablo@netfilter.org>
References: <20180423175714.9794-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180423175714.9794-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

These structures have different layout, fill xt_connmark_tginfo2 with
old fields in xt_connmark_tginfo1. Based on patch from Jack Ma.

Fixes: 472a73e00757 ("netfilter: xt_conntrack: Support bit-shifting for CONNMARK & MARK targets.")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_connmark.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 4b424e6caf3e..94df000abb92 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -36,9 +36,7 @@ MODULE_ALIAS("ipt_connmark");
 MODULE_ALIAS("ip6t_connmark");
 
 static unsigned int
-connmark_tg_shift(struct sk_buff *skb,
-		const struct xt_connmark_tginfo1 *info,
-		u8 shift_bits, u8 shift_dir)
+connmark_tg_shift(struct sk_buff *skb, const struct xt_connmark_tginfo2 *info)
 {
 	enum ip_conntrack_info ctinfo;
 	u_int32_t new_targetmark;
@@ -52,10 +50,11 @@ connmark_tg_shift(struct sk_buff *skb,
 	switch (info->mode) {
 	case XT_CONNMARK_SET:
 		newmark = (ct->mark & ~info->ctmask) ^ info->ctmark;
-		if (shift_dir == D_SHIFT_RIGHT)
-			newmark >>= shift_bits;
+		if (info->shift_dir == D_SHIFT_RIGHT)
+			newmark >>= info->shift_bits;
 		else
-			newmark <<= shift_bits;
+			newmark <<= info->shift_bits;
+
 		if (ct->mark != newmark) {
 			ct->mark = newmark;
 			nf_conntrack_event_cache(IPCT_MARK, ct);
@@ -63,10 +62,11 @@ connmark_tg_shift(struct sk_buff *skb,
 		break;
 	case XT_CONNMARK_SAVE:
 		new_targetmark = (skb->mark & info->nfmask);
-		if (shift_dir == D_SHIFT_RIGHT)
-			new_targetmark >>= shift_bits;
+		if (info->shift_dir == D_SHIFT_RIGHT)
+			new_targetmark >>= info->shift_bits;
 		else
-			new_targetmark <<= shift_bits;
+			new_targetmark <<= info->shift_bits;
+
 		newmark = (ct->mark & ~info->ctmask) ^
 			  new_targetmark;
 		if (ct->mark != newmark) {
@@ -76,10 +76,11 @@ connmark_tg_shift(struct sk_buff *skb,
 		break;
 	case XT_CONNMARK_RESTORE:
 		new_targetmark = (ct->mark & info->ctmask);
-		if (shift_dir == D_SHIFT_RIGHT)
-			new_targetmark >>= shift_bits;
+		if (info->shift_dir == D_SHIFT_RIGHT)
+			new_targetmark >>= info->shift_bits;
 		else
-			new_targetmark <<= shift_bits;
+			new_targetmark <<= info->shift_bits;
+
 		newmark = (skb->mark & ~info->nfmask) ^
 			  new_targetmark;
 		skb->mark = newmark;
@@ -92,8 +93,14 @@ static unsigned int
 connmark_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_connmark_tginfo1 *info = par->targinfo;
-
-	return connmark_tg_shift(skb, info, 0, 0);
+	const struct xt_connmark_tginfo2 info2 = {
+		.ctmark	= info->ctmark,
+		.ctmask	= info->ctmask,
+		.nfmask	= info->nfmask,
+		.mode	= info->mode,
+	};
+
+	return connmark_tg_shift(skb, &info2);
 }
 
 static unsigned int
@@ -101,8 +108,7 @@ connmark_tg_v2(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_connmark_tginfo2 *info = par->targinfo;
 
-	return connmark_tg_shift(skb, (const struct xt_connmark_tginfo1 *)info,
-				 info->shift_bits, info->shift_dir);
+	return connmark_tg_shift(skb, info);
 }
 
 static int connmark_tg_check(const struct xt_tgchk_param *par)
-- 
2.11.0
