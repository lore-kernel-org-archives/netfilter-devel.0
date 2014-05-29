From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nftables 1/4] netfilter: nf_tables: release objects in reverse order in the abort path
Date: Thu, 29 May 2014 11:48:24 +0200
Message-ID: <1401356907-6840-2-git-send-email-pablo@netfilter.org>
References: <1401356907-6840-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45812 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119AbaE2Jsi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 May 2014 05:48:38 -0400
In-Reply-To: <1401356907-6840-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The patch c7c32e7 ("netfilter: nf_tables: defer all object release via
rcu") indicates that we always release deleted objects in the reverse
order, but that is only needed in the abort path. These are the two
possible scenarios when releasing objects:

1) Deletion scenario in the commit path: no need to release objects in
the reverse order since userspace already ensures that dependencies are
fulfilled), ie. userspace tells us to delete rule -> ... -> rule ->
chain -> table. In this case, we have to release the objects in the
*same order* as userspace provided.

2) Deletion scenario in the abort path: we have to iterate in the reverse
order to undo what it cannot be added, ie. userspace sent us a batch
that includes: table -> chain -> rule -> ... -> rule, and that needs to
be partially undone. In this case, we have to release objects in the
reverse order to ensure that the set and chain objects point to valid
rule and table objects.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9365531..4fffa36 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3527,7 +3527,8 @@ static int nf_tables_abort(struct sk_buff *skb)
 		}
 	}
 
-	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
+	list_for_each_entry_safe_reverse(trans, next,
+					 &net->nft.commit_list, list) {
 		list_del(&trans->list);
 		trans->ctx.nla = NULL;
 		call_rcu(&trans->rcu_head, nf_tables_abort_release_rcu);
-- 
1.7.10.4

