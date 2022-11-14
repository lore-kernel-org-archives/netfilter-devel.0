Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCF6FC433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Nov 2022 16:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238082AbiKNQ6l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 11:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238086AbiKNQ61 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 11:58:27 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8341DF03E
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2022 08:57:19 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables] nft-shared: replace nftnl_expr_get_data() by nftnl_expr_get()
Date:   Mon, 14 Nov 2022 17:57:15 +0100
Message-Id: <20221114165715.72843-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Replace nftnl_expr_get_data() alias by real function call.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-shared.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 996cff996c15..2c1d317802fd 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -1081,7 +1081,7 @@ static void nft_parse_immediate(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		const void *imm_data;
 		uint32_t len;
 
-		imm_data = nftnl_expr_get_data(e, NFTNL_EXPR_IMM_DATA, &len);
+		imm_data = nftnl_expr_get(e, NFTNL_EXPR_IMM_DATA, &len);
 		dreg = nft_xt_ctx_get_dreg(ctx, nftnl_expr_get_u32(e, NFTNL_EXPR_IMM_DREG));
 		if (!dreg)
 			return;
-- 
2.30.2

