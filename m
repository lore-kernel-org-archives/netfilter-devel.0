Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE14C43217
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Mar 2022 17:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243274AbiCNRYj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Mar 2022 13:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243277AbiCNRYg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Mar 2022 13:24:36 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C7AD34BBD
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2022 10:23:26 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id DA3C863000
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2022 18:21:09 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 14/14] netfilter: nft_exthdr: add reduce support
Date:   Mon, 14 Mar 2022 18:23:13 +0100
Message-Id: <20220314172313.63348-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220314172313.63348-1-pablo@netfilter.org>
References: <20220314172313.63348-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Check if we can elide the load. Cancel if the new candidate
isn't identical to previous store.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: new in this series

 net/netfilter/nft_exthdr.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index d2b9378164bb..22c3e05b52db 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -603,12 +603,40 @@ static int nft_exthdr_dump_strip(struct sk_buff *skb, const struct nft_expr *exp
 	return nft_exthdr_dump_common(skb, priv);
 }
 
+static bool nft_exthdr_reduce(struct nft_regs_track *track,
+			       const struct nft_expr *expr)
+{
+	const struct nft_exthdr *priv = nft_expr_priv(expr);
+	const struct nft_exthdr *exthdr;
+
+	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		return false;
+	}
+
+	exthdr = nft_expr_priv(track->regs[priv->dreg].selector);
+	if (priv->type != exthdr->type ||
+	    priv->op != exthdr->op ||
+	    priv->flags != exthdr->flags ||
+	    priv->offset != exthdr->offset ||
+	    priv->len != exthdr->len) {
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		return false;
+	}
+
+	if (!track->regs[priv->dreg].bitwise)
+		return true;
+
+	return nft_expr_reduce_bitwise(track, expr);
+}
+
 static const struct nft_expr_ops nft_exthdr_ipv6_ops = {
 	.type		= &nft_exthdr_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_exthdr)),
 	.eval		= nft_exthdr_ipv6_eval,
 	.init		= nft_exthdr_init,
 	.dump		= nft_exthdr_dump,
+	.reduce		= nft_exthdr_reduce,
 };
 
 static const struct nft_expr_ops nft_exthdr_ipv4_ops = {
@@ -617,6 +645,7 @@ static const struct nft_expr_ops nft_exthdr_ipv4_ops = {
 	.eval		= nft_exthdr_ipv4_eval,
 	.init		= nft_exthdr_ipv4_init,
 	.dump		= nft_exthdr_dump,
+	.reduce		= nft_exthdr_reduce,
 };
 
 static const struct nft_expr_ops nft_exthdr_tcp_ops = {
@@ -625,6 +654,7 @@ static const struct nft_expr_ops nft_exthdr_tcp_ops = {
 	.eval		= nft_exthdr_tcp_eval,
 	.init		= nft_exthdr_init,
 	.dump		= nft_exthdr_dump,
+	.reduce		= nft_exthdr_reduce,
 };
 
 static const struct nft_expr_ops nft_exthdr_tcp_set_ops = {
@@ -633,6 +663,7 @@ static const struct nft_expr_ops nft_exthdr_tcp_set_ops = {
 	.eval		= nft_exthdr_tcp_set_eval,
 	.init		= nft_exthdr_tcp_set_init,
 	.dump		= nft_exthdr_dump_set,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static const struct nft_expr_ops nft_exthdr_tcp_strip_ops = {
@@ -641,6 +672,7 @@ static const struct nft_expr_ops nft_exthdr_tcp_strip_ops = {
 	.eval		= nft_exthdr_tcp_strip_eval,
 	.init		= nft_exthdr_tcp_strip_init,
 	.dump		= nft_exthdr_dump_strip,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static const struct nft_expr_ops nft_exthdr_sctp_ops = {
@@ -649,6 +681,7 @@ static const struct nft_expr_ops nft_exthdr_sctp_ops = {
 	.eval		= nft_exthdr_sctp_eval,
 	.init		= nft_exthdr_init,
 	.dump		= nft_exthdr_dump,
+	.reduce		= nft_exthdr_reduce,
 };
 
 static const struct nft_expr_ops *
-- 
2.30.2

