Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49794C3276B
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Aug 2022 22:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiHIWGM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Aug 2022 18:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiHIWFs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Aug 2022 18:05:48 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 96B2C13D02;
        Tue,  9 Aug 2022 15:05:46 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 8/8] netfilter: nf_tables: fix null deref due to zeroed list head
Date:   Wed, 10 Aug 2022 00:05:32 +0200
Message-Id: <20220809220532.130240-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220809220532.130240-1-pablo@netfilter.org>
References: <20220809220532.130240-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 460b0925ea60..3cc88998b879 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -153,6 +153,7 @@ static struct nft_trans *nft_trans_alloc_gfp(const struct nft_ctx *ctx,
 	if (trans == NULL)
 		return NULL;
 
+	INIT_LIST_HEAD(&trans->list);
 	trans->msg_type = msg_type;
 	trans->ctx	= *ctx;
 
-- 
2.30.2

