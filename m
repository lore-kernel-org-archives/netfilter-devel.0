From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/6] netfilter: ipv6: nf_defrag: reduce struct net memory waste
Date: Wed, 27 Jun 2018 17:22:19 +0200
Message-ID: <20180627152223.3633-3-pablo@netfilter.org>
References: <20180627152223.3633-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180627152223.3633-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

It is a waste of memory to use a full "struct netns_sysctl_ipv6"
while only one pointer is really used, considering netns_sysctl_ipv6
keeps growing.

Also, since "struct netns_frags" has cache line alignment,
it is better to move the frags_hdr pointer outside, otherwise
we spend a full cache line for this pointer.

This saves 192 bytes of memory per netns.

Fixes: c038a767cd69 ("ipv6: add a new namespace for nf_conntrack_reasm")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/net_namespace.h             | 1 +
 include/net/netns/ipv6.h                | 1 -
 net/ipv6/netfilter/nf_conntrack_reasm.c | 6 +++---
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 47e35cce3b64..a71264d75d7f 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -128,6 +128,7 @@ struct net {
 #endif
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 	struct netns_nf_frag	nf_frag;
+	struct ctl_table_header *nf_frag_frags_hdr;
 #endif
 	struct sock		*nfnl;
 	struct sock		*nfnl_stash;
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index c978a31b0f84..762ac9931b62 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -109,7 +109,6 @@ struct netns_ipv6 {
 
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 struct netns_nf_frag {
-	struct netns_sysctl_ipv6 sysctl;
 	struct netns_frags	frags;
 };
 #endif
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 5e0332014c17..a452d99c9f52 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -107,7 +107,7 @@ static int nf_ct_frag6_sysctl_register(struct net *net)
 	if (hdr == NULL)
 		goto err_reg;
 
-	net->nf_frag.sysctl.frags_hdr = hdr;
+	net->nf_frag_frags_hdr = hdr;
 	return 0;
 
 err_reg:
@@ -121,8 +121,8 @@ static void __net_exit nf_ct_frags6_sysctl_unregister(struct net *net)
 {
 	struct ctl_table *table;
 
-	table = net->nf_frag.sysctl.frags_hdr->ctl_table_arg;
-	unregister_net_sysctl_table(net->nf_frag.sysctl.frags_hdr);
+	table = net->nf_frag_frags_hdr->ctl_table_arg;
+	unregister_net_sysctl_table(net->nf_frag_frags_hdr);
 	if (!net_eq(net, &init_net))
 		kfree(table);
 }
-- 
2.11.0
