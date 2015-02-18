From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2] netfilter: nf_tables: don't uninitialize element from core
Date: Wed, 18 Feb 2015 04:52:26 +0100
Message-ID: <1424231546-4886-2-git-send-email-pablo@netfilter.org>
References: <1424231546-4886-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37972 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507AbbBRDtO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2015 22:49:14 -0500
In-Reply-To: <1424231546-4886-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The corresponding set implementation is responsible for this when
destroying the element. This prevents a table refcount underflow
when deleting elements.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 199fd0f..d49aa91 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3613,11 +3613,6 @@ static int nf_tables_commit(struct sk_buff *skb)
 						 NFT_MSG_DELSETELEM, 0);
 			te->set->ops->get(te->set, &te->elem);
 			te->set->ops->remove(te->set, &te->elem);
-			nft_data_uninit(&te->elem.key, NFT_DATA_VALUE);
-			if (te->elem.flags & NFT_SET_MAP) {
-				nft_data_uninit(&te->elem.data,
-						te->set->dtype);
-			}
 			nft_trans_destroy(trans);
 			break;
 		}
-- 
1.7.10.4

