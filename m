Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C7AEC4167D
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Oct 2022 11:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbiJQLEG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Oct 2022 07:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbiJQLDo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2022 07:03:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F06F310C8
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2022 04:03:43 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v5 7/7] netfilter: nft_inner: set tunnel offset to GRE header offset
Date:   Mon, 17 Oct 2022 13:03:35 +0200
Message-Id: <20221017110335.742076-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221017110335.742076-1-pablo@netfilter.org>
References: <20221017110335.742076-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Set inner tunnel offset to the GRE header, this is redundant to existing
transport header offset, but this normalizes the handling of the tunnel
header regardless its location in the layering. GRE version 0 is overloaded
with RFCs, the type decorator in the inner expression might also be useful
to interpret matching fields from the netlink delinearize path in userspace.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v5: new in the series.

 net/netfilter/nft_inner.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index 19fdc8c70cd1..eae7caeff316 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -174,8 +174,13 @@ static int nft_inner_parse_tunhdr(const struct nft_inner *priv,
 				  const struct nft_pktinfo *pkt,
 				  struct nft_inner_tun_ctx *ctx, u32 *off)
 {
-	if (pkt->tprot != IPPROTO_UDP ||
-	    pkt->tprot != IPPROTO_GRE)
+	if (pkt->tprot == IPPROTO_GRE) {
+		ctx->inner_tunoff = pkt->thoff;
+		ctx->flags |= NFT_PAYLOAD_CTX_INNER_TUN;
+		return 0;
+	}
+
+	if (pkt->tprot != IPPROTO_UDP)
 		return -1;
 
 	ctx->inner_tunoff = *off;
-- 
2.30.2

