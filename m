From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next 6/8] netfilter: nat: depend on conntrack module
Date: Fri,  2 Oct 2015 13:49:15 +0200
Message-ID: <1443786557-21315-7-git-send-email-fw@strlen.de>
References: <1443786557-21315-1-git-send-email-fw@strlen.de>
Cc: ebiederm@xmission.com, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50311 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517AbbJBLta (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Oct 2015 07:49:30 -0400
In-Reply-To: <1443786557-21315-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Technically this isn't needed, since MASQUERADE, S/DNAT, etc.  targets
call functions that in one way or another depend on the conntrack module.

However, since the conntrack hooks are now registered in a lazy fashion
(i.e., only when needed) a symbol reference is not enough anymore.

Thus, when something is added to a nat table, make sure that it will see
packets by calling nf_ct_netns_get() which will register the conntrack
hooks in the current netns.

Another -- more elaborate solution -- is to move this refcounting to all
nat targets instead, i.e. S/DNAT, MASQUERADE and NETMAP.

However, the nat table is more of a 'configuration database' -- its a
sane assumption that if a rule is added to it it does involve one of the
targets listed above.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/iptable_nat.c  | 4 ++++
 net/ipv6/netfilter/ip6table_nat.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index 4e0cc89..f82db1c 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -110,6 +110,9 @@ static int __net_init iptable_nat_table_init(struct net *net)
 	if (net->ipv4.nat_table)
 		return 0;
 
+	ret = nf_ct_netns_get(net, NFPROTO_IPV4);
+	if (ret)
+		return ret;
 	repl = ipt_alloc_initial_table(&nf_nat_ipv4_table);
 	if (repl == NULL)
 		return -ENOMEM;
@@ -138,6 +141,7 @@ static void __net_exit iptable_nat_net_exit(struct net *net)
 	nf_unregister_net_hooks(net, nf_nat_ipv4_ops,
 				ARRAY_SIZE(nf_nat_ipv4_ops));
 	ipt_unregister_table(net, net->ipv4.nat_table);
+	nf_ct_netns_put(net, NFPROTO_IPV6);
 	net->ipv4.nat_table = NULL;
 }
 
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index ee6a3fe..f40302a 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -112,6 +112,9 @@ static int __net_init ip6table_nat_table_init(struct net *net)
 	if (net->ipv6.ip6table_nat)
 		return 0;
 
+	ret = nf_ct_netns_get(net, NFPROTO_IPV6);
+	if (ret)
+		return ret;
 	repl = ip6t_alloc_initial_table(&nf_nat_ipv6_table);
 	if (repl == NULL)
 		return -ENOMEM;
@@ -141,6 +144,7 @@ static void __net_exit ip6table_nat_net_exit(struct net *net)
 				ARRAY_SIZE(nf_nat_ipv6_ops));
 	ip6t_unregister_table(net, net->ipv6.ip6table_nat);
 	net->ipv6.ip6table_nat = NULL;
+	nf_ct_netns_put(net, NFPROTO_IPV6);
 }
 
 static struct pernet_operations ip6table_nat_net_ops = {
-- 
2.0.5

