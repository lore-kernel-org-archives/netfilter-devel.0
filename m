From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 2/2] netfilter: remove nf_ct_l4proto_find_get/nf_ct_l4proto_put
Date: Wed, 18 Mar 2009 16:42:03 +0100
Message-ID: <1237390923-3122-3-git-send-email-fw@strlen.de>
References: <1237390923-3122-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53679 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751998AbZCRPmL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2009 11:42:11 -0400
In-Reply-To: <1237390923-3122-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

users have been moved to __nf_ct_l4proto_find.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_l4proto.h |    5 -----
 net/netfilter/nf_conntrack_proto.c           |   21 ---------------------
 2 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 16ab604..b01070b 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -98,11 +98,6 @@ extern struct nf_conntrack_l4proto nf_conntrack_l4proto_generic;
 extern struct nf_conntrack_l4proto *
 __nf_ct_l4proto_find(u_int16_t l3proto, u_int8_t l4proto);
 
-extern struct nf_conntrack_l4proto *
-nf_ct_l4proto_find_get(u_int16_t l3proto, u_int8_t protocol);
-
-extern void nf_ct_l4proto_put(struct nf_conntrack_l4proto *p);
-
 /* Protocol registration. */
 extern int nf_conntrack_l4proto_register(struct nf_conntrack_l4proto *proto);
 extern void nf_conntrack_l4proto_unregister(struct nf_conntrack_l4proto *proto);
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 592d733..9a62b4e 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -74,27 +74,6 @@ EXPORT_SYMBOL_GPL(__nf_ct_l4proto_find);
 
 /* this is guaranteed to always return a valid protocol helper, since
  * it falls back to generic_protocol */
-struct nf_conntrack_l4proto *
-nf_ct_l4proto_find_get(u_int16_t l3proto, u_int8_t l4proto)
-{
-	struct nf_conntrack_l4proto *p;
-
-	rcu_read_lock();
-	p = __nf_ct_l4proto_find(l3proto, l4proto);
-	if (!try_module_get(p->me))
-		p = &nf_conntrack_l4proto_generic;
-	rcu_read_unlock();
-
-	return p;
-}
-EXPORT_SYMBOL_GPL(nf_ct_l4proto_find_get);
-
-void nf_ct_l4proto_put(struct nf_conntrack_l4proto *p)
-{
-	module_put(p->me);
-}
-EXPORT_SYMBOL_GPL(nf_ct_l4proto_put);
-
 struct nf_conntrack_l3proto *
 nf_ct_l3proto_find_get(u_int16_t l3proto)
 {
-- 
1.5.6.5

