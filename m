From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 41/53] netfilter: Only allow sane values in nf_register_net_hook
Date: Mon, 26 Sep 2016 01:06:51 +0200
Message-ID: <1474844823-2026-42-git-send-email-pablo@netfilter.org>
References: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Aaron Conole <aconole@bytheb.org>

This commit adds an upfront check for sane values to be passed when
registering a netfilter hook.  This will be used in a future patch for a
simplified hook list traversal.

Signed-off-by: Aaron Conole <aconole@bytheb.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index c8faf8102394..67b74287535d 100644
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
2.1.4
