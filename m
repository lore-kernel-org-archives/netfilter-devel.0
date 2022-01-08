Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA170C4321E
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 Jan 2022 22:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbiAHW0w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 Jan 2022 17:26:52 -0500
Received: from mail.netfilter.org ([217.70.188.207]:40120 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbiAHW0t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Jan 2022 17:26:49 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id D91E06428C
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Jan 2022 23:24:00 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 14/14] netfilter: nft_meta: cancel register tracking after meta update
Date:   Sat,  8 Jan 2022 23:26:38 +0100
Message-Id: <20220108222638.36037-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220108222638.36037-1-pablo@netfilter.org>
References: <20220108222638.36037-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The meta expression might mangle the packet metadata, cancel register
tracking since any metadata in the registers is stale.

Finer grain register tracking cancellation by inspecting the meta type
on the register is also possible.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/nft_meta_bridge.c | 20 ++++++++++++++++++++
 net/netfilter/nft_meta.c               | 20 ++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 97805ec424c1..c1ef9cc89b78 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -100,6 +100,25 @@ static const struct nft_expr_ops nft_meta_bridge_get_ops = {
 	.dump		= nft_meta_get_dump,
 };
 
+static bool nft_meta_bridge_set_reduce(struct nft_regs_track *track,
+				       const struct nft_expr *expr)
+{
+	int i;
+
+	for (i = 0; i < NFT_REG32_NUM; i++) {
+		if (!track->regs[i].selector)
+			continue;
+
+		if (track->regs[i].selector->ops != &nft_meta_bridge_get_ops)
+			continue;
+
+		track->regs[i].selector = NULL;
+		track->regs[i].bitwise = NULL;
+	}
+
+	return false;
+}
+
 static const struct nft_expr_ops nft_meta_bridge_set_ops = {
 	.type		= &nft_meta_bridge_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
@@ -107,6 +126,7 @@ static const struct nft_expr_ops nft_meta_bridge_set_ops = {
 	.init		= nft_meta_set_init,
 	.destroy	= nft_meta_set_destroy,
 	.dump		= nft_meta_set_dump,
+	.reduce		= nft_meta_bridge_set_reduce,
 	.validate	= nft_meta_set_validate,
 };
 
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 40fe48fcf9d0..5ab4df56c945 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -788,6 +788,25 @@ static const struct nft_expr_ops nft_meta_get_ops = {
 	.offload	= nft_meta_get_offload,
 };
 
+static bool nft_meta_set_reduce(struct nft_regs_track *track,
+				const struct nft_expr *expr)
+{
+	int i;
+
+	for (i = 0; i < NFT_REG32_NUM; i++) {
+		if (!track->regs[i].selector)
+			continue;
+
+		if (track->regs[i].selector->ops != &nft_meta_get_ops)
+			continue;
+
+		track->regs[i].selector = NULL;
+		track->regs[i].bitwise = NULL;
+	}
+
+	return false;
+}
+
 static const struct nft_expr_ops nft_meta_set_ops = {
 	.type		= &nft_meta_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
@@ -795,6 +814,7 @@ static const struct nft_expr_ops nft_meta_set_ops = {
 	.init		= nft_meta_set_init,
 	.destroy	= nft_meta_set_destroy,
 	.dump		= nft_meta_set_dump,
+	.reduce		= nft_meta_set_reduce,
 	.validate	= nft_meta_set_validate,
 };
 
-- 
2.30.2

