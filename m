Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4146EC433FE
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Oct 2022 21:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiJGVCH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Oct 2022 17:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiJGVCG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Oct 2022 17:02:06 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C176889B
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Oct 2022 14:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rl/qbL4NNnj3XDhoLlhHNNQlqOzonLWcWpJtWSOzdPo=; b=D2x81u/DzvjHpNjdW3jzLFAC3A
        7wP/0vMc3/zopsvJIuJp+i+qIcRBpkgo4ifouVC7wJyjwJiXB+kdatoIRvW/x9NPGY/pJKFb655j7
        qU2n/KLg++qVqaZvN2CNwx2I5xihHlmYddg+NoLvWWFnXU1zX6NRt/qTQN2oJKcLwKeV8VOJbRed4
        CIifkjNWAIKqfQ/Bh4xFB2M1ofIvXgGRKrIhfW+sCuA3JG5seJa8MDmGG2RK1xbS+GuVkfoDiwJWU
        Cs9/BfY1pWnhTfZOXCY44vndrBT78Gd4aczgURZ/o4eJyfA9EPqxDvkK2JAcYp7dcK9cRuL4PWBgO
        tZ7fyXVA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oguTr-0004AB-5F
        for netfilter-devel@vger.kernel.org; Fri, 07 Oct 2022 23:02:03 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] nft: Fix compile with -DDEBUG
Date:   Fri,  7 Oct 2022 23:01:54 +0200
Message-Id: <20221007210154.9974-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Conversion from 'ctx' to 'reg' missed some of the DEBUGP() calls.

Fixes: f315af1cf8871 ("nft: track each register individually")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-bridge.c | 8 ++++----
 iptables/nft-ipv6.c   | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index d1385cc3593b9..749cbc6fbbaf1 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -365,8 +365,8 @@ static int lookup_analyze_payloads(struct nft_xt_ctx *ctx,
 						  reg->payload.len);
 		if (val2 < 0) {
 			DEBUGP("unknown payload base/offset/len %d/%d/%d\n",
-			       ctx->payload.base, ctx->payload.offset,
-			       ctx->payload.len);
+			       reg->payload.base, reg->payload.offset,
+			       reg->payload.len);
 			return -1;
 		} else if (val != val2) {
 			DEBUGP("mismatching payload match offsets\n");
@@ -379,8 +379,8 @@ static int lookup_analyze_payloads(struct nft_xt_ctx *ctx,
 						 reg->payload.len);
 		if (val < 0) {
 			DEBUGP("unknown payload base/offset/len %d/%d/%d\n",
-			       ctx->payload.base, ctx->payload.offset,
-			       ctx->payload.len);
+			       reg->payload.base, reg->payload.offset,
+			       reg->payload.len);
 			return -1;
 		}
 		break;
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 05d65fbb46247..7ca9d842f2b1a 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -173,7 +173,7 @@ static void nft_ipv6_parse_payload(struct nft_xt_ctx *ctx,
 		nft_parse_hl(ctx, e, cs);
 		break;
 	default:
-		DEBUGP("unknown payload offset %d\n", ctx->payload.offset);
+		DEBUGP("unknown payload offset %d\n", reg->payload.offset);
 		break;
 	}
 }
-- 
2.34.1

