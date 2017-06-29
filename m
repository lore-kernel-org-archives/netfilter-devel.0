From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/29] netfilter: nat: destroy nat mappings on module exit path only
Date: Fri, 30 Jun 2017 00:53:07 +0200
Message-ID: <1498776807-11124-10-git-send-email-pablo@netfilter.org>
References: <1498776807-11124-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57632 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752438AbdF2WyK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Jun 2017 18:54:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BD877BDF58
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jun 2017 00:53:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A885DDA57F
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jun 2017 00:53:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F79AD1D8D
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jun 2017 00:53:30 +0200 (CEST)
In-Reply-To: <1498776807-11124-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>

We don't need pernetns cleanup anymore.  If the netns is being
destroyed, conntrack netns exit will kill all entries in this namespace,
and neither conntrack hash table nor bysource hash are per namespace.

For the rmmod case, we have to make sure we remove all entries from the
nat bysource table, so call the new nf_ct_iterate_destroy in module exit
path.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_core.c | 37 +++++--------------------------------
 1 file changed, 5 insertions(+), 32 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index daf5b22c07f8..d26cc2f864e6 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -582,12 +582,8 @@ static void nf_nat_l4proto_clean(u8 l3proto, u8 l4proto)
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
@@ -595,13 +591,8 @@ static void nf_nat_l3proto_clean(u8 l3proto)
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
@@ -822,17 +813,6 @@ nfnetlink_parse_nat_setup(struct nf_conn *ct,
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
@@ -853,10 +833,6 @@ static int __init nf_nat_init(void)
 		return ret;
 	}
 
-	ret = register_pernet_subsys(&nf_nat_net_ops);
-	if (ret < 0)
-		goto cleanup_extend;
-
 	nf_ct_helper_expectfn_register(&follow_master_nat);
 
 	BUG_ON(nfnetlink_parse_nat_setup_hook != NULL);
@@ -867,18 +843,15 @@ static int __init nf_nat_init(void)
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
2.1.4

