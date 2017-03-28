From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nat: avoid use of nf_conn_nat extension
Date: Tue, 28 Mar 2017 10:31:03 +0200
Message-ID: <20170328083103.2217-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:52112 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754756AbdC1IbD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Mar 2017 04:31:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

successful insert into the bysource hash sets IPS_SRC_NAT_DONE status bit
so we can check that instead of presence of nat extension which requires
extra deref.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 The idea is to get rid of nat extension for most cases, we don't
 need it added by default anymore because the rhlist bysrc hash head
 is now in nf_conn itself.
 This will also allow to get rid of PREALLOC.

 net/netfilter/nf_conntrack_core.c |  2 +-
 net/netfilter/nf_nat_core.c       | 18 ++++--------------
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index b0f2e8e65084..522a8857797e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -702,7 +702,7 @@ static int nf_ct_resolve_clash(struct net *net, struct sk_buff *skb,
 
 	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
 	if (l4proto->allow_clash &&
-	    !nfct_nat(ct) &&
+	    ((ct->status & IPS_NAT_DONE_MASK) == 0) &&
 	    !nf_ct_is_dying(ct) &&
 	    atomic_inc_not_zero(&ct->ct_general.use)) {
 		enum ip_conntrack_info oldinfo;
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 94b14c5a8b17..d47395ff4455 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -549,10 +549,6 @@ struct nf_nat_proto_clean {
 static int nf_nat_proto_remove(struct nf_conn *i, void *data)
 {
 	const struct nf_nat_proto_clean *clean = data;
-	struct nf_conn_nat *nat = nfct_nat(i);
-
-	if (!nat)
-		return 0;
 
 	if ((clean->l3proto && nf_ct_l3num(i) != clean->l3proto) ||
 	    (clean->l4proto && nf_ct_protonum(i) != clean->l4proto))
@@ -563,12 +559,10 @@ static int nf_nat_proto_remove(struct nf_conn *i, void *data)
 
 static int nf_nat_proto_clean(struct nf_conn *ct, void *data)
 {
-	struct nf_conn_nat *nat = nfct_nat(ct);
-
 	if (nf_nat_proto_remove(ct, data))
 		return 1;
 
-	if (!nat)
+	if ((ct->status & IPS_SRC_NAT_DONE) == 0)
 		return 0;
 
 	/* This netns is being destroyed, and conntrack has nat null binding.
@@ -716,13 +710,9 @@ EXPORT_SYMBOL_GPL(nf_nat_l3proto_unregister);
 /* No one using conntrack by the time this called. */
 static void nf_nat_cleanup_conntrack(struct nf_conn *ct)
 {
-	struct nf_conn_nat *nat = nf_ct_ext_find(ct, NF_CT_EXT_NAT);
-
-	if (!nat)
-		return;
-
-	rhltable_remove(&nf_nat_bysource_table, &ct->nat_bysource,
-			nf_nat_bysource_params);
+	if (ct->status & IPS_SRC_NAT_DONE)
+		rhltable_remove(&nf_nat_bysource_table, &ct->nat_bysource,
+				nf_nat_bysource_params);
 }
 
 static struct nf_ct_ext_type nat_extend __read_mostly = {
-- 
2.10.2

