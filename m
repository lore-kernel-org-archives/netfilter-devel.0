From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 07/14] netfilter: ipt_CLUSTERIP: fix build error without procfs
Date: Thu, 26 Jan 2017 17:38:00 +0100
Message-ID: <1485448687-6072-8-git-send-email-pablo@netfilter.org>
References: <1485448687-6072-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1485448687-6072-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

We can't access c->pde if CONFIG_PROC_FS is disabled:

net/ipv4/netfilter/ipt_CLUSTERIP.c: In function 'clusterip_config_find_get':
net/ipv4/netfilter/ipt_CLUSTERIP.c:147:9: error: 'struct clusterip_config' has no member named 'pde'

This moves the check inside of another #ifdef.

Fixes: 6c5d5cfbe3c5 ("netfilter: ipt_CLUSTERIP: check duplicate config when initializing")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index a6b8c1a4102b..0a783cd73faf 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -144,7 +144,12 @@ clusterip_config_find_get(struct net *net, __be32 clusterip, int entry)
 	rcu_read_lock_bh();
 	c = __clusterip_config_find(net, clusterip);
 	if (c) {
-		if (!c->pde || unlikely(!atomic_inc_not_zero(&c->refcount)))
+#ifdef CONFIG_PROC_FS
+		if (!c->pde)
+			c = NULL;
+		else
+#endif
+		if (unlikely(!atomic_inc_not_zero(&c->refcount)))
 			c = NULL;
 		else if (entry)
 			atomic_inc(&c->entries);
-- 
2.1.4
