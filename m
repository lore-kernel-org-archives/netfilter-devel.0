From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nf_tables: check if same extensions are set when adding elements
Date: Mon,  1 May 2017 12:58:50 +0200
Message-ID: <1493636330-25262-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52826 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S969003AbdEAK7B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 May 2017 06:59:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 490C7210568
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 12:58:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3B973ED32D
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 12:58:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E6E77DA870
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 12:58:52 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If no NLM_F_EXCL is set and the element already exists in the set, make
sure that both elements have the same extensions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6e7a5fabc0cb..d0578aede993 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3757,6 +3757,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	err = set->ops->insert(ctx->net, set, &elem, &ext2);
 	if (err) {
 		if (err == -EEXIST) {
+			if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA) ^
+			    nft_set_ext_exists(ext2, NFT_SET_EXT_DATA) ||
+			    nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) ^
+			    nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF))
+				return -EBUSY;
 			if ((nft_set_ext_exists(ext, NFT_SET_EXT_DATA) &&
 			     nft_set_ext_exists(ext2, NFT_SET_EXT_DATA) &&
 			     memcmp(nft_set_ext_data(ext),
-- 
2.1.4

