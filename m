From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v2] netfilter: bridge: fix routing of bridge frames with call-iptables=1
Date: Mon, 14 Sep 2015 17:06:27 +0200
Message-ID: <1442243187-19855-1-git-send-email-fw@strlen.de>
Cc: linux@eikelenboom.it, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33514 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753642AbbINPGf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Sep 2015 11:06:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We can't re-use the physoutdev storage area.

1.  When using NFQUEUE in PREROUTING, we attempt to bump a bogus
refcnt since nf_bridge->physoutdev is garbage (ipv4/ipv6 address)

2. for same reason, we crash in physdev match in FORWARD or later if
skb is routed instead of bridged.

This increases nf_bridge_info to 40 bytes, but we have no other choice.

Fixes: 72b1e5e4cac7 ("netfilter: bridge: reduce nf_bridge_info to 32 bytes again")
Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
Either
- hard-reset nf.git to obliterate the v1 of the patch, then
apply this one instead, OR,
- revert v1 and apply this on top.

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 2738d35..9987af0 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -179,6 +179,9 @@ struct nf_bridge_info {
 	u8			bridged_dnat:1;
 	__u16			frag_max_size;
 	struct net_device	*physindev;
+
+	/* always valid & non-NULL from FORWARD on, for physdev match */
+	struct net_device	*physoutdev;
 	union {
 		/* prerouting: detect dnat in orig/reply direction */
 		__be32          ipv4_daddr;
@@ -189,9 +192,6 @@ struct nf_bridge_info {
 		 * skb is out in neigh layer.
 		 */
 		char neigh_header[8];
-
-		/* always valid & non-NULL from FORWARD on, for physdev match */
-		struct net_device *physoutdev;
 	};
 };
 #endif
-- 
2.0.5

