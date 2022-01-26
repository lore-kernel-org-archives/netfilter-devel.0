Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB2C2C5DF62
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jan 2022 00:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbiAZArE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jan 2022 19:47:04 -0500
Received: from mail.netfilter.org ([217.70.188.207]:45890 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbiAZArD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 19:47:03 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id A52E560254
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:44:00 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_byteorder: track register operations
Date:   Wed, 26 Jan 2022 01:46:58 +0100
Message-Id: <20220126004658.72987-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Cancel tracking for byteorder operation, otherwise selector + byteorder
operation is incorrectly reduced if source and destination registers are
the same.

Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Fixes selftests/netfilter/nft_meta.sh

 net/netfilter/nft_byteorder.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index 9d5947ab8d4e..e646e9ee4a98 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -167,12 +167,24 @@ static int nft_byteorder_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static bool nft_byteorder_reduce(struct nft_regs_track *track,
+				 const struct nft_expr *expr)
+{
+	struct nft_byteorder *priv = nft_expr_priv(expr);
+
+	track->regs[priv->dreg].selector = NULL;
+	track->regs[priv->dreg].bitwise = NULL;
+
+	return false;
+}
+
 static const struct nft_expr_ops nft_byteorder_ops = {
 	.type		= &nft_byteorder_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_byteorder)),
 	.eval		= nft_byteorder_eval,
 	.init		= nft_byteorder_init,
 	.dump		= nft_byteorder_dump,
+	.reduce		= nft_byteorder_reduce,
 };
 
 struct nft_expr_type nft_byteorder_type __read_mostly = {
-- 
2.30.2

