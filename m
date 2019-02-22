Return-Path: <SRS0=yr9h=Q5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D01C4360F
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Feb 2019 12:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 982172075A
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Feb 2019 12:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbfBVM16 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 07:27:58 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54516 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725944AbfBVM16 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 07:27:58 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1gx9vo-0007w5-7J; Fri, 22 Feb 2019 13:27:56 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables] arptables-nft: fix decoding of hlen on bigendian platforms
Date:   Fri, 22 Feb 2019 13:26:05 +0100
Message-Id: <20190222122605.9860-1-fw@strlen.de>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The existing test fail with:
extensions/libarpt_standard.t: ERROR: line 2 (cannot find: arptables -I INPUT -s 192.168.0.1)

... because hlen is 0 instead of expected "6".
The rule is correct, i.e. this is a decode/display bug: arp_hlen is
specified as 'unsigned short' instead of uint8_t.

On LSB systems, this doesn't matter but on MSB the value then is '0x600'
instead of '0x006' which becomes 0 when assignment to the u8 header field.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft-arp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 637da4274ded..c786abb82ed2 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -338,7 +338,8 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 	struct iptables_command_state *cs = data;
 	struct arpt_entry *fw = &cs->arp;
 	struct in_addr addr;
-	unsigned short int ar_hrd, ar_pro, ar_op, ar_hln;
+	uint16_t ar_hrd, ar_pro, ar_op;
+	uint8_t ar_hln;
 	bool inv;
 
 	switch (ctx->payload.offset) {
@@ -364,7 +365,7 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 			fw->arp.invflags |= ARPT_INV_ARPOP;
 		break;
 	case offsetof(struct arphdr, ar_hln):
-		get_cmp_data(e, &ar_hln, sizeof(ar_op), &inv);
+		get_cmp_data(e, &ar_hln, sizeof(ar_hln), &inv);
 		fw->arp.arhln = ar_hln;
 		fw->arp.arhln_mask = 0xff;
 		if (inv)
-- 
2.19.2

