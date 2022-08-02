Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F21BC00140
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Aug 2022 12:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236023AbiHBM4B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Aug 2022 08:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbiHBM4B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Aug 2022 08:56:01 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB23B7DD
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Aug 2022 05:55:59 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oIrRF-0001Iv-Ka; Tue, 02 Aug 2022 14:55:57 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Yi Chen <yiche@redhat.com>
Subject: [PATCH iptables] nft: fix ebtables among match when mac+ip addresses are used
Date:   Tue,  2 Aug 2022 14:55:52 +0200
Message-Id: <20220802125552.25396-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When matching mac and ip addresses, the ip address needs to be placed
into then 2nd 32bit register, the switch to dynamic register allocation
instead re-uses reg1, this partially clobbers the mac address, so
set lookup comes up empty even though it should find a match.

Fixes: 7e38890c6b4fb ("nft: prepare for dynamic register allocation")
Reported-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index ec79f2bc5e98..ee003511ab7f 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1208,8 +1208,8 @@ static int __add_nft_among(struct nft_handle *h, const char *table,
 	nftnl_rule_add_expr(r, e);
 
 	if (ip) {
-		e = gen_payload(h, NFT_PAYLOAD_NETWORK_HEADER, ip_addr_off[dst],
-				sizeof(struct in_addr), &reg);
+		e = __gen_payload(NFT_PAYLOAD_NETWORK_HEADER, ip_addr_off[dst],
+				sizeof(struct in_addr), NFT_REG32_02);
 		if (!e)
 			return -ENOMEM;
 		nftnl_rule_add_expr(r, e);
-- 
2.35.1

