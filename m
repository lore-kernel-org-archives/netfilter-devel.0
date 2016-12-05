From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 1/3] netfilter: nf_tables: constify struct nft_ctx * parameter in nft_trans_alloc()
Date: Mon,  5 Dec 2016 23:35:48 +0100
Message-ID: <1480977350-14873-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53812 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752126AbcLEWgJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Dec 2016 17:36:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 027D21DF5BB
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Dec 2016 23:35:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E51A8DA841
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Dec 2016 23:35:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A15BBDA841
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Dec 2016 23:35:54 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Context is not modified by nft_trans_alloc(), so constify it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e5194f6f906c..b8fa54ec6bbb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -110,8 +110,8 @@ static void nft_ctx_init(struct nft_ctx *ctx,
 	ctx->seq	= nlh->nlmsg_seq;
 }
 
-static struct nft_trans *nft_trans_alloc(struct nft_ctx *ctx, int msg_type,
-					 u32 size)
+static struct nft_trans *nft_trans_alloc(const struct nft_ctx *ctx,
+					 int msg_type, u32 size)
 {
 	struct nft_trans *trans;
 
-- 
2.1.4

