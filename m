From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: cthelper: no need for rcu read side on helper creation
Date: Fri, 17 Mar 2017 13:22:10 +0100
Message-ID: <1489753330-7907-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50036 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751224AbdCQMWW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 08:22:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 839BDE04BA
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 13:22:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 750CEDA725
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 13:22:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45956DA725
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 13:22:17 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This code is already protected by the nfnl_lock mutex.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_cthelper.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index f0241a1e1083..3166406d68d3 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -306,9 +306,8 @@ static int nfnl_cthelper_new(struct net *net, struct sock *nfnl,
 	if (ret < 0)
 		return ret;
 
-	rcu_read_lock();
 	for (i = 0; i < nf_ct_helper_hsize && !helper; i++) {
-		hlist_for_each_entry_rcu(cur, &nf_ct_helper_hash[i], hnode) {
+		hlist_for_each_entry(cur, &nf_ct_helper_hash[i], hnode) {
 
 			/* skip non-userspace conntrack helpers. */
 			if (!(cur->flags & NF_CT_HELPER_F_USERSPACE))
@@ -330,16 +329,12 @@ static int nfnl_cthelper_new(struct net *net, struct sock *nfnl,
 			break;
 		}
 	}
-	rcu_read_unlock();
 
 	if (helper == NULL)
 		ret = nfnl_cthelper_create(tb, &tuple);
 	else
 		ret = nfnl_cthelper_update(tb, helper);
-
-	return ret;
 err:
-	rcu_read_unlock();
 	return ret;
 }
 
-- 
2.1.4

