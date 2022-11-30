Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0011CC352A1
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 10:38:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbiK3KiW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 05:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbiK3KiV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 05:38:21 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F012027160
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 02:38:19 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1p0KTp-0003NB-6W; Wed, 30 Nov 2022 11:38:17 +0100
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH ebtables-nft] nft-bridge: work around recent "among" decode breakage
Date:   Wed, 30 Nov 2022 11:38:12 +0100
Message-Id: <20221130103812.67033-1-fw@strlen.de>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

ebtables-nft-save will fail with
"unknown meta key" when decoding "among" emulation with ipv4 or ipv6
addresses included.

This is because "meta protocol ip" is used as a dependency, but
its never decoded anywhere.

Skip this for now to restore the "ebtables/0006-flush_0"
test case.

Fixes: 25883ce88bfb ("nft: check for unknown meta keys")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft-bridge.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 3180091364fa..50e90b22cf2f 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -197,6 +197,11 @@ static void nft_bridge_parse_meta(struct nft_xt_ctx *ctx,
 	uint8_t invflags = 0;
 	char iifname[IFNAMSIZ] = {}, oifname[IFNAMSIZ] = {};
 
+	switch (reg->meta_dreg.key) {
+	case NFT_META_PROTOCOL:
+		return;
+	}
+
 	if (parse_meta(ctx, e, reg->meta_dreg.key, iifname, NULL, oifname, NULL, &invflags) < 0) {
 		ctx->errmsg = "unknown meta key";
 		return;
-- 
2.38.1

