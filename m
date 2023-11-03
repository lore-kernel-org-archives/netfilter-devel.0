Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B168C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 10:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjKCK0S (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 06:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbjKCK0Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 06:26:16 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAD8D4B
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 03:26:11 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qyrNR-00055d-Nh; Fri, 03 Nov 2023 11:26:09 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables 1/4] arptables-nft: use ARPT_INV flags consistently
Date:   Fri,  3 Nov 2023 11:23:23 +0100
Message-ID: <20231103102330.27578-2-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231103102330.27578-1-fw@strlen.de>
References: <20231103102330.27578-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These values are not always interchangeable, e.g.:

define IPT_INV_SRCDEVADDR	0x0080
but:
define ARPT_INV_SRCDEVADDR	0x0010

as these flags can be tested by libarp_foo.so such
checks can yield incorrect results.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft-arp.c           | 56 ++++++++++++++++++------------------
 iptables/nft-ruleparse-arp.c | 16 +++++------
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index aed39ebdd516..a0f4e1547f4e 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -48,38 +48,38 @@ static int nft_arp_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	int ret = 0;
 
 	if (fw->arp.iniface[0] != '\0') {
-		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_VIA_IN);
+		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_VIA_IN);
 		add_iface(h, r, fw->arp.iniface, NFT_META_IIFNAME, op);
 	}
 
 	if (fw->arp.outiface[0] != '\0') {
-		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_VIA_OUT);
+		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_VIA_OUT);
 		add_iface(h, r, fw->arp.outiface, NFT_META_OIFNAME, op);
 	}
 
 	if (fw->arp.arhrd != 0 ||
-	    fw->arp.invflags & IPT_INV_ARPHRD) {
+	    fw->arp.invflags & ARPT_INV_ARPHRD) {
 		uint8_t reg;
 
-		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_ARPHRD);
+		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_ARPHRD);
 		add_payload(h, r, offsetof(struct arphdr, ar_hrd), 2,
 			    NFT_PAYLOAD_NETWORK_HEADER, &reg);
 		add_cmp_u16(r, fw->arp.arhrd, op, reg);
 	}
 
 	if (fw->arp.arpro != 0 ||
-	    fw->arp.invflags & IPT_INV_PROTO) {
+	    fw->arp.invflags & ARPT_INV_ARPPRO) {
 		uint8_t reg;
 
-		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_PROTO);
+		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_ARPPRO);
 	        add_payload(h, r, offsetof(struct arphdr, ar_pro), 2,
 			    NFT_PAYLOAD_NETWORK_HEADER, &reg);
 		add_cmp_u16(r, fw->arp.arpro, op, reg);
 	}
 
 	if (fw->arp.arhln != 0 ||
-	    fw->arp.invflags & IPT_INV_ARPHLN) {
-		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_ARPHLN);
+	    fw->arp.invflags & ARPT_INV_ARPHLN) {
+		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_ARPHLN);
 		add_proto(h, r, offsetof(struct arphdr, ar_hln), 1,
 			  fw->arp.arhln, op);
 	}
@@ -87,17 +87,17 @@ static int nft_arp_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	add_proto(h, r, offsetof(struct arphdr, ar_pln), 1, 4, NFT_CMP_EQ);
 
 	if (fw->arp.arpop != 0 ||
-	    fw->arp.invflags & IPT_INV_ARPOP) {
+	    fw->arp.invflags & ARPT_INV_ARPOP) {
 		uint8_t reg;
 
-		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_ARPOP);
+		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_ARPOP);
 		add_payload(h, r, offsetof(struct arphdr, ar_op), 2,
 			    NFT_PAYLOAD_NETWORK_HEADER, &reg);
 		add_cmp_u16(r, fw->arp.arpop, op, reg);
 	}
 
 	if (need_devaddr(&fw->arp.src_devaddr)) {
-		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_SRCDEVADDR);
+		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_SRCDEVADDR);
 		add_addr(h, r, NFT_PAYLOAD_NETWORK_HEADER,
 			 sizeof(struct arphdr),
 			 &fw->arp.src_devaddr.addr,
@@ -108,8 +108,8 @@ static int nft_arp_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 
 	if (fw->arp.src.s_addr != 0 ||
 	    fw->arp.smsk.s_addr != 0 ||
-	    fw->arp.invflags & IPT_INV_SRCIP) {
-		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_SRCIP);
+	    fw->arp.invflags & ARPT_INV_SRCIP) {
+		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_SRCIP);
 		add_addr(h, r, NFT_PAYLOAD_NETWORK_HEADER,
 			 sizeof(struct arphdr) + fw->arp.arhln,
 			 &fw->arp.src.s_addr, &fw->arp.smsk.s_addr,
@@ -118,7 +118,7 @@ static int nft_arp_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 
 
 	if (need_devaddr(&fw->arp.tgt_devaddr)) {
-		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_TGTDEVADDR);
+		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_TGTDEVADDR);
 		add_addr(h, r, NFT_PAYLOAD_NETWORK_HEADER,
 			 sizeof(struct arphdr) + fw->arp.arhln + sizeof(struct in_addr),
 			 &fw->arp.tgt_devaddr.addr,
@@ -128,8 +128,8 @@ static int nft_arp_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 
 	if (fw->arp.tgt.s_addr != 0 ||
 	    fw->arp.tmsk.s_addr != 0 ||
-	    fw->arp.invflags & IPT_INV_DSTIP) {
-		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_DSTIP);
+	    fw->arp.invflags & ARPT_INV_TGTIP) {
+		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_TGTIP);
 		add_addr(h, r, NFT_PAYLOAD_NETWORK_HEADER,
 			 sizeof(struct arphdr) + fw->arp.arhln + sizeof(struct in_addr) + fw->arp.arhln,
 			 &fw->arp.tgt.s_addr, &fw->arp.tmsk.s_addr,
@@ -207,7 +207,7 @@ static void nft_arp_print_rule_details(const struct iptables_command_state *cs,
 		else strcat(iface, "any");
 	}
 	if (print_iface) {
-		printf("%s%s-i %s", sep, fw->arp.invflags & IPT_INV_VIA_IN ?
+		printf("%s%s-i %s", sep, fw->arp.invflags & ARPT_INV_VIA_IN ?
 				   "! " : "", iface);
 		sep = " ";
 	}
@@ -225,14 +225,14 @@ static void nft_arp_print_rule_details(const struct iptables_command_state *cs,
 		else strcat(iface, "any");
 	}
 	if (print_iface) {
-		printf("%s%s-o %s", sep, fw->arp.invflags & IPT_INV_VIA_OUT ?
+		printf("%s%s-o %s", sep, fw->arp.invflags & ARPT_INV_VIA_OUT ?
 				   "! " : "", iface);
 		sep = " ";
 	}
 
 	if (fw->arp.smsk.s_addr != 0L) {
 		printf("%s%s-s %s", sep,
-		       fw->arp.invflags & IPT_INV_SRCIP ? "! " : "",
+		       fw->arp.invflags & ARPT_INV_SRCIP ? "! " : "",
 		       ipv4_addr_to_string(&fw->arp.src,
 					   &fw->arp.smsk, format));
 		sep = " ";
@@ -243,7 +243,7 @@ static void nft_arp_print_rule_details(const struct iptables_command_state *cs,
 			break;
 	if (i == ARPT_DEV_ADDR_LEN_MAX)
 		goto after_devsrc;
-	printf("%s%s", sep, fw->arp.invflags & IPT_INV_SRCDEVADDR
+	printf("%s%s", sep, fw->arp.invflags & ARPT_INV_SRCDEVADDR
 		? "! " : "");
 	printf("--src-mac ");
 	xtables_print_mac_and_mask((unsigned char *)fw->arp.src_devaddr.addr,
@@ -253,7 +253,7 @@ after_devsrc:
 
 	if (fw->arp.tmsk.s_addr != 0L) {
 		printf("%s%s-d %s", sep,
-		       fw->arp.invflags & IPT_INV_DSTIP ? "! " : "",
+		       fw->arp.invflags & ARPT_INV_TGTIP ? "! " : "",
 		       ipv4_addr_to_string(&fw->arp.tgt,
 					   &fw->arp.tmsk, format));
 		sep = " ";
@@ -264,7 +264,7 @@ after_devsrc:
 			break;
 	if (i == ARPT_DEV_ADDR_LEN_MAX)
 		goto after_devdst;
-	printf("%s%s", sep, fw->arp.invflags & IPT_INV_TGTDEVADDR
+	printf("%s%s", sep, fw->arp.invflags & ARPT_INV_TGTDEVADDR
 		? "! " : "");
 	printf("--dst-mac ");
 	xtables_print_mac_and_mask((unsigned char *)fw->arp.tgt_devaddr.addr,
@@ -274,8 +274,8 @@ after_devsrc:
 after_devdst:
 
 	if (fw->arp.arhln_mask != 255 || fw->arp.arhln != 6 ||
-	    fw->arp.invflags & IPT_INV_ARPHLN) {
-		printf("%s%s", sep, fw->arp.invflags & IPT_INV_ARPHLN
+	    fw->arp.invflags & ARPT_INV_ARPHLN) {
+		printf("%s%s", sep, fw->arp.invflags & ARPT_INV_ARPHLN
 			? "! " : "");
 		printf("--h-length %d", fw->arp.arhln);
 		if (fw->arp.arhln_mask != 255)
@@ -286,7 +286,7 @@ after_devdst:
 	if (fw->arp.arpop_mask != 0) {
 		int tmp = ntohs(fw->arp.arpop);
 
-		printf("%s%s", sep, fw->arp.invflags & IPT_INV_ARPOP
+		printf("%s%s", sep, fw->arp.invflags & ARPT_INV_ARPOP
 			? "! " : "");
 		if (tmp <= ARP_NUMOPCODES && !(format & FMT_NUMERIC))
 			printf("--opcode %s", arp_opcodes[tmp-1]);
@@ -299,10 +299,10 @@ after_devdst:
 	}
 
 	if (fw->arp.arhrd_mask != 65535 || fw->arp.arhrd != htons(1) ||
-	    fw->arp.invflags & IPT_INV_ARPHRD) {
+	    fw->arp.invflags & ARPT_INV_ARPHRD) {
 		uint16_t tmp = ntohs(fw->arp.arhrd);
 
-		printf("%s%s", sep, fw->arp.invflags & IPT_INV_ARPHRD
+		printf("%s%s", sep, fw->arp.invflags & ARPT_INV_ARPHRD
 			? "! " : "");
 		if (tmp == 1 && !(format & FMT_NUMERIC))
 			printf("--h-type %s", "Ethernet");
@@ -316,7 +316,7 @@ after_devdst:
 	if (fw->arp.arpro_mask != 0) {
 		int tmp = ntohs(fw->arp.arpro);
 
-		printf("%s%s", sep, fw->arp.invflags & IPT_INV_PROTO
+		printf("%s%s", sep, fw->arp.invflags & ARPT_INV_ARPPRO
 			? "! " : "");
 		if (tmp == 0x0800 && !(format & FMT_NUMERIC))
 			printf("--proto-type %s", "IPv4");
diff --git a/iptables/nft-ruleparse-arp.c b/iptables/nft-ruleparse-arp.c
index d80ca922955c..a9b92d8048f4 100644
--- a/iptables/nft-ruleparse-arp.c
+++ b/iptables/nft-ruleparse-arp.c
@@ -89,28 +89,28 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 		fw->arp.arhrd = ar_hrd;
 		fw->arp.arhrd_mask = 0xffff;
 		if (inv)
-			fw->arp.invflags |= IPT_INV_ARPHRD;
+			fw->arp.invflags |= ARPT_INV_ARPHRD;
 		break;
 	case offsetof(struct arphdr, ar_pro):
 		get_cmp_data(e, &ar_pro, sizeof(ar_pro), &inv);
 		fw->arp.arpro = ar_pro;
 		fw->arp.arpro_mask = 0xffff;
 		if (inv)
-			fw->arp.invflags |= IPT_INV_PROTO;
+			fw->arp.invflags |= ARPT_INV_ARPPRO;
 		break;
 	case offsetof(struct arphdr, ar_op):
 		get_cmp_data(e, &ar_op, sizeof(ar_op), &inv);
 		fw->arp.arpop = ar_op;
 		fw->arp.arpop_mask = 0xffff;
 		if (inv)
-			fw->arp.invflags |= IPT_INV_ARPOP;
+			fw->arp.invflags |= ARPT_INV_ARPOP;
 		break;
 	case offsetof(struct arphdr, ar_hln):
 		get_cmp_data(e, &ar_hln, sizeof(ar_hln), &inv);
 		fw->arp.arhln = ar_hln;
 		fw->arp.arhln_mask = 0xff;
 		if (inv)
-			fw->arp.invflags |= IPT_INV_ARPHLN;
+			fw->arp.invflags |= ARPT_INV_ARPHLN;
 		break;
 	case offsetof(struct arphdr, ar_pln):
 		get_cmp_data(e, &ar_pln, sizeof(ar_pln), &inv);
@@ -120,7 +120,7 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 	default:
 		if (reg->payload.offset == sizeof(struct arphdr)) {
 			if (nft_arp_parse_devaddr(reg, e, &fw->arp.src_devaddr))
-				fw->arp.invflags |= IPT_INV_SRCDEVADDR;
+				fw->arp.invflags |= ARPT_INV_SRCDEVADDR;
 		} else if (reg->payload.offset == sizeof(struct arphdr) +
 					   fw->arp.arhln) {
 			get_cmp_data(e, &addr, sizeof(addr), &inv);
@@ -133,12 +133,12 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 					   sizeof(struct in_addr)));
 
 			if (inv)
-				fw->arp.invflags |= IPT_INV_SRCIP;
+				fw->arp.invflags |= ARPT_INV_SRCIP;
 		} else if (reg->payload.offset == sizeof(struct arphdr) +
 						  fw->arp.arhln +
 						  sizeof(struct in_addr)) {
 			if (nft_arp_parse_devaddr(reg, e, &fw->arp.tgt_devaddr))
-				fw->arp.invflags |= IPT_INV_TGTDEVADDR;
+				fw->arp.invflags |= ARPT_INV_TGTDEVADDR;
 		} else if (reg->payload.offset == sizeof(struct arphdr) +
 						  fw->arp.arhln +
 						  sizeof(struct in_addr) +
@@ -153,7 +153,7 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 					   sizeof(struct in_addr)));
 
 			if (inv)
-				fw->arp.invflags |= IPT_INV_DSTIP;
+				fw->arp.invflags |= ARPT_INV_TGTIP;
 		} else {
 			ctx->errmsg = "unknown payload offset";
 		}
-- 
2.41.0

