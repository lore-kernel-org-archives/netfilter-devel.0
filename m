From: Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] netfilter: ipv6: nf_defrag: reduce struct net memory waste
Date: Wed, 13 Jun 2018 10:11:56 -0700
Message-ID: <20180613171156.240889-1-edumazet@google.com>
Cc: netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

It is a waste of memory to use a full "struct netns_sysctl_ipv6"
while only one pointer is really used, considering netns_sysctl_ipv6
keeps growing.

Also, since "struct netns_frags" has cache line alignment,
it is better to move the frags_hdr pointer outside, otherwise
we spend a full cache line for this pointer.

This saves 192 bytes of memory per netns.

Fixes: c038a767cd69 ("ipv6: add a new namespace for nf_conntrack_reasm")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/net_namespace.h             | 1 +
 include/net/netns/ipv6.h                | 1 -
 net/ipv6/netfilter/nf_conntrack_reasm.c | 6 +++---
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 47e35cce3b648d696b127ed7bd643036128795f6..a71264d75d7f98d28f92dfd861ffe6e0d39c0198 100644
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
index c978a31b0f846210b4c2a369af960d5349b5395a..762ac9931b6251152b6ee0e5780df0f7b073f3e6 100644
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
index 5e0332014c1738999e680c1853829f384e880284..a452d99c9f5281b5e5d7e6f0162611deeb82212d 100644
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
2.18.0.rc1.242.g61856ae69a-goog
