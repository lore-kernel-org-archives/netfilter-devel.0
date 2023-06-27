Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AC00EB64D9
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jun 2023 06:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjF0Gxw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jun 2023 02:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbjF0Gxd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jun 2023 02:53:33 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C1261701;
        Mon, 26 Jun 2023 23:53:28 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 6/6] netfilter: nf_tables: fix underflow in chain reference counter
Date:   Tue, 27 Jun 2023 08:53:04 +0200
Message-Id: <20230627065304.66394-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230627065304.66394-1-pablo@netfilter.org>
References: <20230627065304.66394-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Set element addition error path decrements reference counter on chains
twice: once on element release and again via nft_data_release().

Then, d6b478666ffa ("netfilter: nf_tables: fix underflow in object
reference counter") incorrectly fixed this by removing the stateful
object reference count decrement.

Restore the stateful object decrement as in b91d90368837 ("netfilter:
nf_tables: fix leaking object reference count") and let
nft_data_release() decrement the chain reference counter, so this is
done only once.

Fixes: d6b478666ffa ("netfilter: nf_tables: fix underflow in object reference counter")
Fixes: 628bd3e49cba ("netfilter: nf_tables: drop map element references from preparation phase")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1d64c163076a..c742918f22a4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6771,7 +6771,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 err_element_clash:
 	kfree(trans);
 err_elem_free:
-	nft_set_elem_destroy(set, elem.priv, true);
+	nf_tables_set_elem_destroy(ctx, set, elem.priv);
+	if (obj)
+		obj->use--;
 err_parse_data:
 	if (nla[NFTA_SET_ELEM_DATA] != NULL)
 		nft_data_release(&elem.data.val, desc.type);
-- 
2.30.2

