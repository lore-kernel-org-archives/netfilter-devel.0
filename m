From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/18] netfilter: xtables: allow table definitions not backed by hook_ops
Date: Wed, 23 May 2018 20:42:42 +0200
Message-ID: <20180523184254.22599-7-pablo@netfilter.org>
References: <20180523184254.22599-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180523184254.22599-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The ip(6)tables nat table is currently receiving skbs from the netfilter
core, after a followup patch skbs will be coming from the netfilter nat
core instead, so the table is no longer backed by normal hook_ops.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/ip_tables.c  | 5 ++++-
 net/ipv6/netfilter/ip6_tables.c | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 444f125f3974..ddcc56c37d4d 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1782,6 +1782,8 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 
 	/* set res now, will see skbs right after nf_register_net_hooks */
 	WRITE_ONCE(*res, new_table);
+	if (!ops)
+		return 0;
 
 	ret = nf_register_net_hooks(net, ops, hweight32(table->valid_hooks));
 	if (ret != 0) {
@@ -1799,7 +1801,8 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 void ipt_unregister_table(struct net *net, struct xt_table *table,
 			  const struct nf_hook_ops *ops)
 {
-	nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+	if (ops)
+		nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
 	__ipt_unregister_table(net, table);
 }
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 7097bbf95843..e18b14b2e019 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1792,6 +1792,8 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 
 	/* set res now, will see skbs right after nf_register_net_hooks */
 	WRITE_ONCE(*res, new_table);
+	if (!ops)
+		return 0;
 
 	ret = nf_register_net_hooks(net, ops, hweight32(table->valid_hooks));
 	if (ret != 0) {
@@ -1809,7 +1811,8 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 void ip6t_unregister_table(struct net *net, struct xt_table *table,
 			   const struct nf_hook_ops *ops)
 {
-	nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
+	if (ops)
+		nf_unregister_net_hooks(net, ops, hweight32(table->valid_hooks));
 	__ip6t_unregister_table(net, table);
 }
 
-- 
2.11.0
