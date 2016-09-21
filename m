From: Aaron Conole <aconole@bytheb.org>
Subject: [PATCH nf-next v3 5/7] nf_register_net_hook: Only allow sane values
Date: Wed, 21 Sep 2016 11:35:05 -0400
Message-ID: <1474472107-12992-6-git-send-email-aconole@bytheb.org>
References: <1474472107-12992-1-git-send-email-aconole@bytheb.org>
Cc: Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1474472107-12992-1-git-send-email-aconole@bytheb.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This commit adds an upfront check for sane values to be passed when
registering a netfilter hook.  This will be used in a future patch for a
simplified hook list traversal.

Signed-off-by: Aaron Conole <aconole@bytheb.org>
---
 net/netfilter/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index c8faf81..67b7428 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -89,6 +89,11 @@ int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
 	struct nf_hook_entry *entry;
 	struct nf_hook_ops *elem;
 
+	if (reg->pf == NFPROTO_NETDEV &&
+	    (reg->hooknum != NF_NETDEV_INGRESS ||
+	     !reg->dev || dev_net(reg->dev) != net))
+		return -EINVAL;
+
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
 		return -ENOMEM;
-- 
2.7.4
