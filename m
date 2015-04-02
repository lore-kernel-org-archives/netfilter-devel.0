From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 3/6] netfilter: physdev: use helpers
Date: Thu,  2 Apr 2015 14:31:42 +0200
Message-ID: <1427977905-9927-4-git-send-email-fw@strlen.de>
References: <1427977905-9927-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44235 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753012AbbDBMb4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Apr 2015 08:31:56 -0400
In-Reply-To: <1427977905-9927-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Avoid skb->nf_bridge accesses where possible.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 no changes since v1.

 net/netfilter/xt_physdev.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 50a5204..1caaccb 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -25,16 +25,15 @@ MODULE_ALIAS("ip6t_physdev");
 static bool
 physdev_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
-	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	const struct xt_physdev_info *info = par->matchinfo;
+	const struct net_device *physdev;
 	unsigned long ret;
 	const char *indev, *outdev;
-	const struct nf_bridge_info *nf_bridge;
 
 	/* Not a bridged IP packet or no info available yet:
 	 * LOCAL_OUT/mangle and LOCAL_OUT/nat don't know if
 	 * the destination device will be a bridge. */
-	if (!(nf_bridge = skb->nf_bridge)) {
+	if (!skb->nf_bridge) {
 		/* Return MATCH if the invert flags of the used options are on */
 		if ((info->bitmask & XT_PHYSDEV_OP_BRIDGED) &&
 		    !(info->invert & XT_PHYSDEV_OP_BRIDGED))
@@ -54,30 +53,41 @@ physdev_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		return true;
 	}
 
+	physdev = nf_bridge_get_physoutdev(skb);
+	outdev = physdev ? physdev->name : NULL;
+
 	/* This only makes sense in the FORWARD and POSTROUTING chains */
 	if ((info->bitmask & XT_PHYSDEV_OP_BRIDGED) &&
-	    (!!nf_bridge->physoutdev ^ !(info->invert & XT_PHYSDEV_OP_BRIDGED)))
+	    (!!outdev ^ !(info->invert & XT_PHYSDEV_OP_BRIDGED)))
 		return false;
 
+	physdev = nf_bridge_get_physindev(skb);
+	indev = physdev ? physdev->name : NULL;
+
 	if ((info->bitmask & XT_PHYSDEV_OP_ISIN &&
-	    (!nf_bridge->physindev ^ !!(info->invert & XT_PHYSDEV_OP_ISIN))) ||
+	    (!indev ^ !!(info->invert & XT_PHYSDEV_OP_ISIN))) ||
 	    (info->bitmask & XT_PHYSDEV_OP_ISOUT &&
-	    (!nf_bridge->physoutdev ^ !!(info->invert & XT_PHYSDEV_OP_ISOUT))))
+	    (!outdev ^ !!(info->invert & XT_PHYSDEV_OP_ISOUT))))
 		return false;
 
 	if (!(info->bitmask & XT_PHYSDEV_OP_IN))
 		goto match_outdev;
-	indev = nf_bridge->physindev ? nf_bridge->physindev->name : nulldevname;
-	ret = ifname_compare_aligned(indev, info->physindev, info->in_mask);
 
-	if (!ret ^ !(info->invert & XT_PHYSDEV_OP_IN))
-		return false;
+	if (indev) {
+		ret = ifname_compare_aligned(indev, info->physindev,
+					     info->in_mask);
+
+		if (!ret ^ !(info->invert & XT_PHYSDEV_OP_IN))
+			return false;
+	}
 
 match_outdev:
 	if (!(info->bitmask & XT_PHYSDEV_OP_OUT))
 		return true;
-	outdev = nf_bridge->physoutdev ?
-		 nf_bridge->physoutdev->name : nulldevname;
+
+	if (!outdev)
+		return false;
+
 	ret = ifname_compare_aligned(outdev, info->physoutdev, info->out_mask);
 
 	return (!!ret ^ !(info->invert & XT_PHYSDEV_OP_OUT));
-- 
2.0.5

