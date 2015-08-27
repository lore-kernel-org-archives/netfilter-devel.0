From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next] netfilter: nfnetlink: work around wrong endianess with old nft userspace
Date: Fri, 28 Aug 2015 00:17:43 +0200
Message-ID: <1440713863-18469-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56699 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753892AbbH0XHs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Aug 2015 19:07:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The nfgenmsg res_id is __be16.  Unfortunately nftables batch support uses
host byte order.

This adds a compat workaround for old nft userspace.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 0c0e8ec..2e255ad 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -276,18 +276,24 @@ enum {
 };
 
 static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
-				u_int16_t subsys_id)
+				__be16 __subsys_id)
 {
 	struct sk_buff *oskb = skb;
 	struct net *net = sock_net(skb->sk);
 	const struct nfnetlink_subsystem *ss;
 	const struct nfnl_callback *nc;
 	static LIST_HEAD(err_list);
+	u16 subsys_id = ntohs(__subsys_id);
 	u32 status;
 	int err;
 
-	if (subsys_id >= NFNL_SUBSYS_COUNT)
-		return netlink_ack(skb, nlh, -EINVAL);
+	if (subsys_id >= NFNL_SUBSYS_COUNT) {
+		/* Work around old nft using host byte order */
+		if (NFNL_SUBSYS_NFTABLES != (__force __u16) __subsys_id)
+			return netlink_ack(skb, nlh, -EINVAL);
+
+		subsys_id = (__force __u16) __subsys_id;
+	}
 replay:
 	status = 0;
 
-- 
2.0.5

