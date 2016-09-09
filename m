From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: nf_conntrack: simplify __nf_ct_try_assign_helper() return logic
Date: Fri,  9 Sep 2016 14:01:26 +0200
Message-ID: <1473422486-17125-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45400 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753017AbcIIMBs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Sep 2016 08:01:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3138C1022A4
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 14:01:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1D4111B3036
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 14:01:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 174701B2FEB
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 14:01:37 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of several goto's just to return the result, simply return it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_helper.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index b989b81..4ffe388 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -189,7 +189,6 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 	struct nf_conntrack_helper *helper = NULL;
 	struct nf_conn_help *help;
 	struct net *net = nf_ct_net(ct);
-	int ret = 0;
 
 	/* We already got a helper explicitly attached. The function
 	 * nf_conntrack_alter_reply - in case NAT is in use - asks for looking
@@ -223,15 +222,13 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 	if (helper == NULL) {
 		if (help)
 			RCU_INIT_POINTER(help->helper, NULL);
-		goto out;
+		return 0;
 	}
 
 	if (help == NULL) {
 		help = nf_ct_helper_ext_add(ct, helper, flags);
-		if (help == NULL) {
-			ret = -ENOMEM;
-			goto out;
-		}
+		if (help == NULL)
+			return -ENOMEM;
 	} else {
 		/* We only allow helper re-assignment of the same sort since
 		 * we cannot reallocate the helper extension area.
@@ -240,13 +237,13 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 
 		if (tmp && tmp->help != helper->help) {
 			RCU_INIT_POINTER(help->helper, NULL);
-			goto out;
+			return 0;
 		}
 	}
 
 	rcu_assign_pointer(help->helper, helper);
-out:
-	return ret;
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(__nf_ct_try_assign_helper);
 
-- 
2.1.4

