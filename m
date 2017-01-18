From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nf_tables: fix set->nelem leak
Date: Wed, 18 Jan 2017 17:53:16 +0100
Message-ID: <1484758396-11684-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50144 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751750AbdARQx3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 11:53:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B31AEDA722
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 17:53:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A3842A7E98
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 17:53:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2E7E6FEFB3
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 17:53:24 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If no NLM_F_EXCL is specified and the element already exists, no error
is reported to userspace. However, no new element is added so decrement
set->nelem to restore it the early increment that nf_tables_newsetelem()
performs.

Fixes: c016c7e45ddf ("netfilter: nf_tables: honor NLM_F_EXCL flag in set element insertion")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 091d2dcc63b2..a4619cbf2fe2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3734,8 +3734,10 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			     nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF) &&
 			     *nft_set_ext_obj(ext) != *nft_set_ext_obj(ext2)))
 				err = -EBUSY;
-			else if (!(nlmsg_flags & NLM_F_EXCL))
+			else if (!(nlmsg_flags & NLM_F_EXCL)) {
+				atomic_dec(&set->nelems);
 				err = 0;
+			}
 		}
 		goto err5;
 	}
-- 
2.1.4

