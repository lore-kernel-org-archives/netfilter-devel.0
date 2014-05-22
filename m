From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/2] netfilter: ctnetlink: only export whitelisted flags to userspace
Date: Thu, 22 May 2014 11:43:07 +0200
Message-ID: <1400751788-7923-2-git-send-email-fw@strlen.de>
References: <1400751788-7923-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57108 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754324AbaEVJsy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2014 05:48:54 -0400
In-Reply-To: <1400751788-7923-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Flag bits are part of ABI as they're exposed to userspace.
Upcoming patch will introduce kernel-only flag that we might want to
remove again in the future, so only expose the whitelisted ones (i.e,
all the flags we currently have).

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_netlink.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ccc46fa..66d8e15 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -130,12 +130,14 @@ ctnetlink_dump_tuples(struct sk_buff *skb,
 static inline int
 ctnetlink_dump_status(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	if (nla_put_be32(skb, CTA_STATUS, htonl(ct->status)))
-		goto nla_put_failure;
-	return 0;
-
-nla_put_failure:
-	return -1;
+	static const u32 public_flag_mask = IPS_EXPECTED |
+			IPS_SEEN_REPLY | IPS_ASSURED | IPS_CONFIRMED |
+			IPS_NAT_MASK | IPS_SEQ_ADJUST | IPS_NAT_DONE_MASK |
+			IPS_DYING | IPS_FIXED_TIMEOUT | IPS_TEMPLATE |
+			IPS_UNTRACKED | IPS_HELPER;
+
+	return nla_put_be32(skb, CTA_STATUS,
+			    htonl(ct->status & public_flag_mask));
 }
 
 static inline int
-- 
1.8.1.5

