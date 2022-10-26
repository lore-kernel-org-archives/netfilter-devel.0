Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A86E5C38A2D
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Oct 2022 13:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbiJZNXg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Oct 2022 09:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233986AbiJZNXB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Oct 2022 09:23:01 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 942AB371BA;
        Wed, 26 Oct 2022 06:23:00 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 10/10] netfilter: nft_inner: set tunnel offset to GRE header offset
Date:   Wed, 26 Oct 2022 15:22:27 +0200
Message-Id: <20221026132227.3287-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221026132227.3287-1-pablo@netfilter.org>
References: <20221026132227.3287-1-pablo@netfilter.org>
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

