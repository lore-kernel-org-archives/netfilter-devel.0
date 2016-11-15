From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/7] conntrack: remove unused init_net hook
Date: Tue, 15 Nov 2016 21:36:39 +0100
Message-ID: <1479242205-21675-2-git-send-email-fw@strlen.de>
References: <1479242205-21675-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45076 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753205AbcKOUgb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Nov 2016 15:36:31 -0500
In-Reply-To: <1479242205-21675-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

since adf0516845bcd0 ("netfilter: remove ip_conntrack* sysctl compat code")
the only user (ipv4 tracker) sets this to an empty stub function.

After this change nf_ct_l3proto_pernet_register() is also empty,
but this will change in a followup patch to add conditional register
of the hooks.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_l3proto.h   | 3 ---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c | 6 ------
 net/netfilter/nf_conntrack_proto.c             | 8 --------
 3 files changed, 17 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index 8992e4229da9..cf8f3dfd810d 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -63,9 +63,6 @@ struct nf_conntrack_l3proto {
 
 	size_t nla_size;
 
-	/* Init l3proto pernet data */
-	int (*init_net)(struct net *net);
-
 	/* Module (if any) which this is connected to. */
 	struct module *me;
 };
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 7130ed5dc1fa..823cf3331b9d 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -307,11 +307,6 @@ static struct nf_sockopt_ops so_getorigdst = {
 	.owner		= THIS_MODULE,
 };
 
-static int ipv4_init_net(struct net *net)
-{
-	return 0;
-}
-
 struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 __read_mostly = {
 	.l3proto	 = PF_INET,
 	.name		 = "ipv4",
@@ -325,7 +320,6 @@ struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 __read_mostly = {
 	.nlattr_to_tuple = ipv4_nlattr_to_tuple,
 	.nla_policy	 = ipv4_nla_policy,
 #endif
-	.init_net	 = ipv4_init_net,
 	.me		 = THIS_MODULE,
 };
 
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 9bd34647225a..b218e70b2f74 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -193,14 +193,6 @@ EXPORT_SYMBOL_GPL(nf_ct_l3proto_register);
 int nf_ct_l3proto_pernet_register(struct net *net,
 				  struct nf_conntrack_l3proto *proto)
 {
-	int ret;
-
-	if (proto->init_net) {
-		ret = proto->init_net(net);
-		if (ret < 0)
-			return ret;
-	}
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_ct_l3proto_pernet_register);
-- 
2.7.3

