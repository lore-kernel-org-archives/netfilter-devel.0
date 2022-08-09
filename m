Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 828C1C19F2D
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Aug 2022 16:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245097AbiHIQfH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Aug 2022 12:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245101AbiHIQfD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Aug 2022 12:35:03 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F02020BC2
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2022 09:35:02 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oLSC4-0008MU-En; Tue, 09 Aug 2022 18:35:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     pablo@netfilter.org, Florian Westphal <fw@strlen.de>,
        mingi cho <mgcho.minic@gmail.com>
Subject: [PATCH nf] netfilter: nf_tables: fix null deref due to zeroed list head
Date:   Tue,  9 Aug 2022 18:34:02 +0200
Message-Id: <20220809163402.20227-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In nf_tables_updtable, if nf_tables_table_enable returns an error,
nft_trans_destroy is called to free the transaction object.

nft_trans_destroy() calls list_del(), but the transaction was never
placed on a list -- the list head is all zeroes, this results in
a null dereference:

BUG: KASAN: null-ptr-deref in nft_trans_destroy+0x26/0x59
Call Trace:
 nft_trans_destroy+0x26/0x59
 nf_tables_newtable+0x4bc/0x9bc
 [..]

Its sane to assume that nft_trans_destroy() can be called
on the transaction object returned by nft_trans_alloc(), so
make sure the list head is initialised.

Fixes: 55dd6f93076b ("netfilter: nf_tables: use new transaction infrastructure to handle table")
Reported-by: mingi cho <mgcho.minic@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9f976b11d896..6287e313a769 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -153,6 +153,7 @@ static struct nft_trans *nft_trans_alloc_gfp(const struct nft_ctx *ctx,
 	if (trans == NULL)
 		return NULL;
 
+	INIT_LIST_HEAD(&trans->list);
 	trans->msg_type = msg_type;
 	trans->ctx	= *ctx;
 
-- 
2.35.1

