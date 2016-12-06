From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 1/2] netfilter: nf_tables: restore check for NFTA_SET_ELEM_LIST_ELEMENTS
Date: Tue,  6 Dec 2016 14:45:46 +0100
Message-ID: <1481031947-8805-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44468 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752436AbcLFNqc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 08:46:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3897A96ECD
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 14:45:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 28DCFA7E92
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 14:45:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6D30ADA729
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 14:45:51 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It seems git rebase and branch rmerge resulted patching the wrong spot,
restore check when adding elements, remove it from the deletion path so
flushing sets still works. The original patch applying this chunk in the
right spot: http://patchwork.ozlabs.org/patch/702919/.

Fixes: 34d360415a92 ("netfilter: nf_tables: support for set flushing")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9ead6a7514c3..a019a87e58ee 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3767,6 +3767,9 @@ static int nf_tables_newsetelem(struct net *net, struct sock *nlsk,
 	struct nft_ctx ctx;
 	int rem, err = 0;
 
+	if (nla[NFTA_SET_ELEM_LIST_ELEMENTS] == NULL)
+		return -EINVAL;
+
 	err = nft_ctx_init_from_elemattr(&ctx, net, skb, nlh, nla, genmask);
 	if (err < 0)
 		return err;
@@ -3917,9 +3920,6 @@ static int nf_tables_delsetelem(struct net *net, struct sock *nlsk,
 	struct nft_ctx ctx;
 	int rem, err = 0;
 
-	if (nla[NFTA_SET_ELEM_LIST_ELEMENTS] == NULL)
-		return -EINVAL;
-
 	err = nft_ctx_init_from_elemattr(&ctx, net, skb, nlh, nla, genmask);
 	if (err < 0)
 		return err;
-- 
2.1.4

