From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 35/47] netfilter: conntrack: reduce size of l4protocol trackers
Date: Mon,  4 Sep 2017 00:41:44 +0200
Message-ID: <1504478516-13224-3-git-send-email-pablo@netfilter.org>
References: <1504478516-13224-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1504478516-13224-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

can use u16 for both, shrinks size by another 8 bytes.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.1.4
