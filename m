Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F4CEC4321E
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Mar 2022 00:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235135AbiCNAzj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 13 Mar 2022 20:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235735AbiCNAzf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 13 Mar 2022 20:55:35 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18F2B35866
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Mar 2022 17:54:27 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8A1B763020
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2022 01:52:12 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 10/12,v2] netfilter: nft_socket: track register operations
Date:   Mon, 14 Mar 2022 01:54:15 +0100
Message-Id: <20220314005417.315832-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220314005417.315832-1-pablo@netfilter.org>
References: <20220314005417.315832-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Check if the destination register already contains the data that this
socket expression performs. This allows to skip this redundant
operation.  If the destination contains a different selector, update the
register tracking information.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: new in this series

 net/netfilter/nft_socket.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index d601974c9d2e..bd3792f080ed 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -10,6 +10,7 @@
 struct nft_socket {
 	enum nft_socket_keys		key:8;
 	u8				level;
+	u8				len;
 	union {
 		u8			dreg;
 	};
@@ -179,6 +180,7 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
+	priv->len = len;
 	return nft_parse_register_store(ctx, tb[NFTA_SOCKET_DREG], &priv->dreg,
 					NULL, NFT_DATA_VALUE, len);
 }
@@ -198,6 +200,31 @@ static int nft_socket_dump(struct sk_buff *skb,
 	return 0;
 }
 
+static bool nft_socket_reduce(struct nft_regs_track *track,
+			      const struct nft_expr *expr)
+{
+	const struct nft_socket *priv = nft_expr_priv(expr);
+	const struct nft_socket *socket;
+
+	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		return false;
+	}
+
+	socket = nft_expr_priv(track->regs[priv->dreg].selector);
+	if (priv->key != socket->key ||
+	    priv->dreg != socket->dreg ||
+	    priv->level != socket->level) {
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
 static struct nft_expr_type nft_socket_type;
 static const struct nft_expr_ops nft_socket_ops = {
 	.type		= &nft_socket_type,
@@ -205,6 +232,7 @@ static const struct nft_expr_ops nft_socket_ops = {
 	.eval		= nft_socket_eval,
 	.init		= nft_socket_init,
 	.dump		= nft_socket_dump,
+	.reduce		= nft_socket_reduce,
 };
 
 static struct nft_expr_type nft_socket_type __read_mostly = {
-- 
2.30.2

