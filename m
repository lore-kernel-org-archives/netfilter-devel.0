From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 5/5] netfilter: nat: destroy nat mappings on module exit path only
Date: Sun, 21 May 2017 12:52:59 +0200
Message-ID: <20170521105259.10239-6-fw@strlen.de>
References: <20170521105259.10239-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37114 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753090AbdEUKxD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 May 2017 06:53:03 -0400
In-Reply-To: <20170521105259.10239-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We don't need pernetns cleanup anymore.  If the netns is being
destroyed, conntrack netns exit will kill all entries in this namespace,
and neither conntrack hash table nor bysource hash are per namespace.

For the rmmod case, we have to make sure we remove all entries from the
nat bysource table, so call the new nf_ct_iterate_destroy in module exit
path.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_core.c | 37 +++++--------------------------------
 1 file changed, 5 insertions(+), 32 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 46eac534f0d0..32b749ea2014 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -578,12 +578,8 @@ static void nf_nat_l4proto_clean(u8 l3proto, u8 l4proto)
 		.l3proto = l3proto,
 		.l4proto = l4proto,
 	};
-	struct net *net;
 
-	rtnl_lock();
-	for_each_net(net)
-		nf_ct_iterate_cleanup_net(net, nf_nat_proto_remove, &clean, 0, 0);
-	rtnl_unlock();
+	nf_ct_iterate_destroy(nf_nat_proto_remove, &clean);
 }
 
 static void nf_nat_l3proto_clean(u8 l3proto)
@@ -591,13 +587,8 @@ static void nf_nat_l3proto_clean(u8 l3proto)
 	struct nf_nat_proto_clean clean = {
 		.l3proto = l3proto,
 	};
-	struct net *net;
 
-	rtnl_lock();
-
-	for_each_net(net)
-		nf_ct_iterate_cleanup_net(net, nf_nat_proto_remove, &clean, 0, 0);
-	rtnl_unlock();
+	nf_ct_iterate_destroy(nf_nat_proto_remove, &clean);
 }
 
 /* Protocol registration. */
@@ -818,17 +809,6 @@ nfnetlink_parse_nat_setup(struct nf_conn *ct,
 }
 #endif
 
-static void __net_exit nf_nat_net_exit(struct net *net)
-{
-	struct nf_nat_proto_clean clean = {};
-
-	nf_ct_iterate_cleanup_net(net, nf_nat_proto_clean, &clean, 0, 0);
-}
-
-static struct pernet_operations nf_nat_net_ops = {
-	.exit = nf_nat_net_exit,
-};
-
 static struct nf_ct_helper_expectfn follow_master_nat = {
 	.name		= "nat-follow-master",
 	.expectfn	= nf_nat_follow_master,
@@ -849,10 +829,6 @@ static int __init nf_nat_init(void)
 		return ret;
 	}
 
-	ret = register_pernet_subsys(&nf_nat_net_ops);
-	if (ret < 0)
-		goto cleanup_extend;
-
 	nf_ct_helper_expectfn_register(&follow_master_nat);
 
 	BUG_ON(nfnetlink_parse_nat_setup_hook != NULL);
@@ -863,18 +839,15 @@ static int __init nf_nat_init(void)
 	RCU_INIT_POINTER(nf_nat_decode_session_hook, __nf_nat_decode_session);
 #endif
 	return 0;
-
- cleanup_extend:
-	rhltable_destroy(&nf_nat_bysource_table);
-	nf_ct_extend_unregister(&nat_extend);
-	return ret;
 }
 
 static void __exit nf_nat_cleanup(void)
 {
+	struct nf_nat_proto_clean clean = {};
 	unsigned int i;
 
-	unregister_pernet_subsys(&nf_nat_net_ops);
+	nf_ct_iterate_destroy(nf_nat_proto_clean, &clean);
+
 	nf_ct_extend_unregister(&nat_extend);
 	nf_ct_helper_expectfn_unregister(&follow_master_nat);
 	RCU_INIT_POINTER(nfnetlink_parse_nat_setup_hook, NULL);
-- 
2.13.0

