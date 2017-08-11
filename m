From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 4/7] netfilter: conntrack: reduce size of l4protocol trackers
Date: Sat, 12 Aug 2017 00:57:05 +0200
Message-ID: <20170811225708.22181-5-fw@strlen.de>
References: <20170811225708.22181-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54212 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753839AbdHKX1X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Aug 2017 19:27:23 -0400
In-Reply-To: <20170811225708.22181-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

can use u16 for both, shrinks size by another 8 bytes.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_l4proto.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 47c16bae5e00..15c58dd3f701 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -92,12 +92,12 @@ struct nf_conntrack_l4proto {
 
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
 	struct {
-		size_t obj_size;
 		int (*nlattr_to_obj)(struct nlattr *tb[],
 				     struct net *net, void *data);
 		int (*obj_to_nlattr)(struct sk_buff *skb, const void *data);
 
-		unsigned int nlattr_max;
+		u16 obj_size;
+		u16 nlattr_max;
 		const struct nla_policy *nla_policy;
 	} ctnl_timeout;
 #endif
-- 
2.13.0

