Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C801AC43217
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Mar 2022 15:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbiCLPt3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 12 Mar 2022 10:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbiCLPt0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 12 Mar 2022 10:49:26 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9100B8AE65
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2022 07:48:20 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id F1FD462FF8
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2022 16:46:11 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 7/9] netfilter: nft_osf: track register operations
Date:   Sat, 12 Mar 2022 16:48:09 +0100
Message-Id: <20220312154811.68611-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220312154811.68611-1-pablo@netfilter.org>
References: <20220312154811.68611-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allow to recycle the previous output of the OS fingerprint expression
if flags and ttl are the same.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_osf.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index d82677e83400..c1d94ad6f466 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -120,6 +120,31 @@ static int nft_osf_validate(const struct nft_ctx *ctx,
 						    (1 << NF_INET_FORWARD));
 }
 
+static bool nft_osf_reduce(struct nft_regs_track *track,
+			   const struct nft_expr *expr)
+{
+	struct nft_osf *priv = nft_expr_priv(expr);
+	struct nft_osf *osf;
+
+	if (!track->regs[priv->dreg].selector ||
+	    track->regs[priv->dreg].selector->ops != expr->ops) {
+		nft_reg_track_update(track, expr, priv->dreg, NFT_OSF_MAXGENRELEN);
+		return false;
+	}
+
+	osf = nft_expr_priv(track->regs[priv->dreg].selector);
+	if (priv->flags != osf->flags ||
+	    priv->ttl != osf->ttl) {
+		nft_reg_track_update(track, expr, priv->dreg, NFT_OSF_MAXGENRELEN);
+		return false;
+	}
+
+	if (!track->regs[priv->dreg].bitwise)
+		return true;
+
+	return false;
+}
+
 static struct nft_expr_type nft_osf_type;
 static const struct nft_expr_ops nft_osf_op = {
 	.eval		= nft_osf_eval,
@@ -128,6 +153,7 @@ static const struct nft_expr_ops nft_osf_op = {
 	.dump		= nft_osf_dump,
 	.type		= &nft_osf_type,
 	.validate	= nft_osf_validate,
+	.reduce		= nft_osf_reduce,
 };
 
 static struct nft_expr_type nft_osf_type __read_mostly = {
-- 
2.30.2

