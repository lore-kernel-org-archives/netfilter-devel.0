Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C289C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Nov 2023 11:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbjKGLQM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Nov 2023 06:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234303AbjKGLQI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Nov 2023 06:16:08 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E2510C7
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2023 03:16:00 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1r0K3q-0002ES-RY; Tue, 07 Nov 2023 12:15:58 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 iptables 1/4] nft-arp: add missing mask support
Date:   Tue,  7 Nov 2023 12:15:37 +0100
Message-ID: <20231107111544.17166-2-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231107111544.17166-1-fw@strlen.de>
References: <20231107111544.17166-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

arptables-legacy supports masks for --h-type, --opcode
and --proto-type, but arptables-nft did not.

Add this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft-arp.c           | 21 +++++++++++++++++++--
 iptables/nft-ruleparse-arp.c |  8 ++++++++
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 535dd6b83237..b3c8dfa453d9 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -58,41 +58,56 @@ static int nft_arp_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	}
 
 	if (fw->arp.arhrd != 0 ||
+	    fw->arp.arhrd_mask != 0xffff ||
 	    fw->arp.invflags & IPT_INV_ARPHRD) {
 		uint8_t reg;
 
 		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_ARPHRD);
 		add_payload(h, r, offsetof(struct arphdr, ar_hrd), 2,
 			    NFT_PAYLOAD_NETWORK_HEADER, &reg);
+		if (fw->arp.arhrd_mask != 0xffff)
+			add_bitwise_u16(h, r, fw->arp.arhrd_mask, 0, reg, &reg);
 		add_cmp_u16(r, fw->arp.arhrd, op, reg);
 	}
 
 	if (fw->arp.arpro != 0 ||
+	    fw->arp.arpro_mask != 0xffff ||
 	    fw->arp.invflags & IPT_INV_PROTO) {
 		uint8_t reg;
 
 		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_PROTO);
 	        add_payload(h, r, offsetof(struct arphdr, ar_pro), 2,
 			    NFT_PAYLOAD_NETWORK_HEADER, &reg);
+		if (fw->arp.arpro_mask != 0xffff)
+			add_bitwise_u16(h, r, fw->arp.arpro_mask, 0, reg, &reg);
 		add_cmp_u16(r, fw->arp.arpro, op, reg);
 	}
 
 	if (fw->arp.arhln != 0 ||
+	    fw->arp.arhln_mask != 255 ||
 	    fw->arp.invflags & IPT_INV_ARPHLN) {
+		uint8_t reg;
+
 		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_ARPHLN);
-		add_proto(h, r, offsetof(struct arphdr, ar_hln), 1,
-			  fw->arp.arhln, op);
+		add_payload(h, r, offsetof(struct arphdr, ar_hln), 1,
+			    NFT_PAYLOAD_NETWORK_HEADER, &reg);
+		if (fw->arp.arhln_mask != 255)
+			add_bitwise(h, r, &fw->arp.arhln_mask, 1, reg, &reg);
+		add_cmp_u8(r, fw->arp.arhln, op, reg);
 	}
 
 	add_proto(h, r, offsetof(struct arphdr, ar_pln), 1, 4, NFT_CMP_EQ);
 
 	if (fw->arp.arpop != 0 ||
+	    fw->arp.arpop_mask != 0xffff ||
 	    fw->arp.invflags & IPT_INV_ARPOP) {
 		uint8_t reg;
 
 		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_ARPOP);
 		add_payload(h, r, offsetof(struct arphdr, ar_op), 2,
 			    NFT_PAYLOAD_NETWORK_HEADER, &reg);
+		if (fw->arp.arpop_mask != 0xffff)
+			add_bitwise_u16(h, r, fw->arp.arpop_mask, 0, reg, &reg);
 		add_cmp_u16(r, fw->arp.arpop, op, reg);
 	}
 
@@ -556,6 +571,8 @@ static void nft_arp_init_cs(struct iptables_command_state *cs)
 	cs->arp.arp.arhln_mask = 255;
 	cs->arp.arp.arhrd = htons(ARPHRD_ETHER);
 	cs->arp.arp.arhrd_mask = 65535;
+	cs->arp.arp.arpop_mask = 65535;
+	cs->arp.arp.arpro_mask = 65535;
 }
 
 static int
diff --git a/iptables/nft-ruleparse-arp.c b/iptables/nft-ruleparse-arp.c
index d80ca922955c..cd74747e9189 100644
--- a/iptables/nft-ruleparse-arp.c
+++ b/iptables/nft-ruleparse-arp.c
@@ -90,6 +90,8 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 		fw->arp.arhrd_mask = 0xffff;
 		if (inv)
 			fw->arp.invflags |= IPT_INV_ARPHRD;
+		if (reg->bitwise.set)
+			fw->arp.arhrd_mask = reg->bitwise.mask[0];
 		break;
 	case offsetof(struct arphdr, ar_pro):
 		get_cmp_data(e, &ar_pro, sizeof(ar_pro), &inv);
@@ -97,6 +99,8 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 		fw->arp.arpro_mask = 0xffff;
 		if (inv)
 			fw->arp.invflags |= IPT_INV_PROTO;
+		if (reg->bitwise.set)
+			fw->arp.arpro_mask = reg->bitwise.mask[0];
 		break;
 	case offsetof(struct arphdr, ar_op):
 		get_cmp_data(e, &ar_op, sizeof(ar_op), &inv);
@@ -104,6 +108,8 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 		fw->arp.arpop_mask = 0xffff;
 		if (inv)
 			fw->arp.invflags |= IPT_INV_ARPOP;
+		if (reg->bitwise.set)
+			fw->arp.arpop_mask = reg->bitwise.mask[0];
 		break;
 	case offsetof(struct arphdr, ar_hln):
 		get_cmp_data(e, &ar_hln, sizeof(ar_hln), &inv);
@@ -111,6 +117,8 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 		fw->arp.arhln_mask = 0xff;
 		if (inv)
 			fw->arp.invflags |= IPT_INV_ARPHLN;
+		if (reg->bitwise.set)
+			fw->arp.arhln_mask = reg->bitwise.mask[0];
 		break;
 	case offsetof(struct arphdr, ar_pln):
 		get_cmp_data(e, &ar_pln, sizeof(ar_pln), &inv);
-- 
2.41.0

