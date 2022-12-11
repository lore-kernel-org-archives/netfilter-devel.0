Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD49C4332F
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Dec 2022 10:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiLKKMP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 11 Dec 2022 05:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLKKMN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Dec 2022 05:12:13 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4EE5CE08;
        Sun, 11 Dec 2022 02:12:09 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 01/12] netfilter: nft_inner: fix IS_ERR() vs NULL check
Date:   Sun, 11 Dec 2022 11:11:53 +0100
Message-Id: <20221211101204.1751-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221211101204.1751-1-pablo@netfilter.org>
References: <20221211101204.1751-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

The __nft_expr_type_get() function returns NULL on error.  It never
returns error pointers.

Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2fa52b8d5ce1..833850a4780f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2873,8 +2873,8 @@ int nft_expr_inner_parse(const struct nft_ctx *ctx, const struct nlattr *nla,
 		return -EINVAL;
 
 	type = __nft_expr_type_get(ctx->family, tb[NFTA_EXPR_NAME]);
-	if (IS_ERR(type))
-		return PTR_ERR(type);
+	if (!type)
+		return -ENOENT;
 
 	if (!type->inner_ops)
 		return -EOPNOTSUPP;
-- 
2.30.2

