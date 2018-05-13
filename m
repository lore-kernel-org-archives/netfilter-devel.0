From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/15] netfilter: core: add missing __rcu annotation
Date: Mon, 14 May 2018 00:36:49 +0200
Message-ID: <20180513223656.10077-9-pablo@netfilter.org>
References: <20180513223656.10077-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180513223656.10077-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

removes following sparse error:
net/netfilter/core.c:598:30: warning: incorrect type in argument 1 (different address spaces)
net/netfilter/core.c:598:30:    expected struct nf_hook_entries **e
net/netfilter/core.c:598:30:    got struct nf_hook_entries [noderef] <asn:4>**<noident>

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 0f6b8172fb9a..206fb2c4c319 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -585,7 +585,8 @@ void (*nf_nat_decode_session_hook)(struct sk_buff *, struct flowi *);
 EXPORT_SYMBOL(nf_nat_decode_session_hook);
 #endif
 
-static void __net_init __netfilter_net_init(struct nf_hook_entries **e, int max)
+static void __net_init
+__netfilter_net_init(struct nf_hook_entries __rcu **e, int max)
 {
 	int h;
 
-- 
2.11.0
