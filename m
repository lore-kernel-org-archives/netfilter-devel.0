Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2710C61DF4
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 12:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343909AbjKVMyx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 07:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343893AbjKVMys (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 07:54:48 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FE2D6F
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 04:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=twUzJXjqeQmDhj9u1JpIXnNj/yB3+crEtpLkp81Y19U=; b=QoGi25jQtCMvNp5AU8wySEeY+1
        mMLjQgps7+l5Uk+YP3DNPt+7XNhLttwafZ98Dlns0+ZJZ8vcUS98okV8Ra4anQSS/Nrf02YN46yf3
        kGf+z5d9TKgcfzXm/M/zCfaiV+D11+mh3GqLRcRFlW+TVtmJqXSrdFCKf4FfvgldqJnf+12II77Ml
        yEcYbFbNmlfdjSBaOHGpllJEP79ThmDTD9tlMjRGJPuM5z+Si1IoeV7hsLMFKxd96L4vtWwQk3dNT
        VYkIkXO0bAL6TO8WXAuoB/Ogoa1c/EXwCuSjpJ0+FGHFswA5y9bxcITz1FxJZYJrgAkc/ZWD+DJ1W
        5yxRT9gw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r5mkW-0005SZ-L9
        for netfilter-devel@vger.kernel.org; Wed, 22 Nov 2023 13:54:36 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 02/12] nft-bridge: nft_bridge_add() uses wrong flags
Date:   Wed, 22 Nov 2023 14:02:12 +0100
Message-ID: <20231122130222.29453-3-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231122130222.29453-1-phil@nwl.cc>
References: <20231122130222.29453-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When checking whether -s or -d was given, invflags were used by
accident. This change has no functional effect since the values remain
the same, but this way it's clear where the previously assigned flags
are used.

Fixes: 07f4ca9681688 ("xtables-compat: ebtables: allow checking for zero-mac")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-bridge.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index d9a8ad2b0f373..772525e1b45a9 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -134,14 +134,14 @@ static int nft_bridge_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	struct ebt_entry *fw = &cs->eb;
 	uint32_t op;
 
-	if (fw->bitmask & EBT_ISOURCE) {
+	if (fw->bitmask & EBT_SOURCEMAC) {
 		op = nft_invflags2cmp(fw->invflags, EBT_ISOURCE);
 		add_addr(h, r, NFT_PAYLOAD_LL_HEADER,
 			 offsetof(struct ethhdr, h_source),
 			 fw->sourcemac, fw->sourcemsk, ETH_ALEN, op);
 	}
 
-	if (fw->bitmask & EBT_IDEST) {
+	if (fw->bitmask & EBT_DESTMAC) {
 		op = nft_invflags2cmp(fw->invflags, EBT_IDEST);
 		add_addr(h, r, NFT_PAYLOAD_LL_HEADER,
 			 offsetof(struct ethhdr, h_dest),
-- 
2.41.0

