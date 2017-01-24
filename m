From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf,v2 1/3] netfilter: nf_tables: fix set->nelems counting with no NLM_F_EXCL
Date: Tue, 24 Jan 2017 19:42:57 +0100
Message-ID: <1485283379-9281-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49638 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750966AbdAXSnM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Jan 2017 13:43:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5E5D81EC2C0
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 19:43:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 49A87A7E7D
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 19:43:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AFEB5A7BE8
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Jan 2017 19:43:03 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the element exists and no NLM_F_EXCL is specified, do not bump
set->nelems, otherwise we leak one set element slot. This problem
amplifies if the set is full since the abort path always decrements the
counter for the -ENFILE case too, giving one spare extra slot.

Fix this by moving set->nelems update to nft_add_set_elem() after
successful element insertion. Moreover, remove the element if the set is
full so there is no need to rely on the abort path to undo things
anymore.

Fixes: c016c7e45ddf ("netfilter: nf_tables: honor NLM_F_EXCL flag in set element insertion")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: http://patchwork.ozlabs.org/patch/716751/ attacks the problem from the
    wrong angle since this doesn't catch more corner cases that trigger bugs.
    This patch obsoletes this previous try.

 net/netfilter/nf_tables_api.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b84c7b25219b..831a9a16f563 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3745,10 +3745,18 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err5;
 	}
 
+	if (set->size &&
+	    !atomic_add_unless(&set->nelems, 1, set->size + set->ndeact)) {
+		err = -ENFILE;
+		goto err6;
+	}
+
 	nft_trans_elem(trans) = elem;
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 	return 0;
 
+err6:
+	set->ops->remove(set, &elem);
 err5:
 	kfree(trans);
 err4:
@@ -3795,15 +3803,9 @@ static int nf_tables_newsetelem(struct net *net, struct sock *nlsk,
 		return -EBUSY;
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		if (set->size &&
-		    !atomic_add_unless(&set->nelems, 1, set->size + set->ndeact))
-			return -ENFILE;
-
 		err = nft_add_set_elem(&ctx, set, attr, nlh->nlmsg_flags);
-		if (err < 0) {
-			atomic_dec(&set->nelems);
+		if (err < 0)
 			break;
-		}
 	}
 	return err;
 }
-- 
2.1.4

