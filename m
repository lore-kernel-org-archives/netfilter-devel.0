Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E71FC5519F
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 14:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5CEF22245
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 14:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729722AbgKPOCu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Nov 2020 09:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729572AbgKPOCu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Nov 2020 09:02:50 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CAFC0613CF
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2020 06:02:50 -0800 (PST)
Received: from localhost ([::1]:51028 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kef5i-0001RY-Ok; Mon, 16 Nov 2020 15:02:46 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/3] xtables-arp: Don't use ARPT_INV_*
Date:   Mon, 16 Nov 2020 15:02:37 +0100
Message-Id: <20201116140238.25955-3-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201116140238.25955-1-phil@nwl.cc>
References: <20201116140238.25955-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Arptables invflags are partly identical to IPT_INV_* ones but the bits
are differently assigned. Eliminate this incompatibility by definition
of the unique invflags in nft-arp.h on bits that don't collide with
IPT_INV_* ones, then use those in combination with IPT_INV_* ones in
arptables-specific code.

Note that ARPT_INV_ARPPRO is replaced by IPT_INV_PROTO although these
are in fact different options - yet since '-p' option is not supported
by arptables, this does not lead to a collision.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c     | 92 ++++++++++++++++--------------------------
 iptables/nft-arp.h     |  7 ++++
 iptables/xtables-arp.c | 22 +++++-----
 3 files changed, 53 insertions(+), 68 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 5dc38da831aa0..c82ffdc95e300 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -134,34 +134,34 @@ static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
 	int ret = 0;
 
 	if (fw->arp.iniface[0] != '\0') {
-		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_VIA_IN);
+		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_VIA_IN);
 		add_iniface(r, fw->arp.iniface, op);
 	}
 
 	if (fw->arp.outiface[0] != '\0') {
-		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_VIA_OUT);
+		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_VIA_OUT);
 		add_outiface(r, fw->arp.outiface, op);
 	}
 
 	if (fw->arp.arhrd != 0 ||
-	    fw->arp.invflags & ARPT_INV_ARPHRD) {
-		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_ARPHRD);
+	    fw->arp.invflags & IPT_INV_ARPHRD) {
+		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_ARPHRD);
 		add_payload(r, offsetof(struct arphdr, ar_hrd), 2,
 			    NFT_PAYLOAD_NETWORK_HEADER);
 		add_cmp_u16(r, fw->arp.arhrd, op);
 	}
 
 	if (fw->arp.arpro != 0 ||
-	    fw->arp.invflags & ARPT_INV_ARPPRO) {
-		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_ARPPRO);
+	    fw->arp.invflags & IPT_INV_PROTO) {
+		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_PROTO);
 	        add_payload(r, offsetof(struct arphdr, ar_pro), 2,
 			    NFT_PAYLOAD_NETWORK_HEADER);
 		add_cmp_u16(r, fw->arp.arpro, op);
 	}
 
 	if (fw->arp.arhln != 0 ||
-	    fw->arp.invflags & ARPT_INV_ARPHLN) {
-		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_ARPHLN);
+	    fw->arp.invflags & IPT_INV_ARPHLN) {
+		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_ARPHLN);
 		add_proto(r, offsetof(struct arphdr, ar_hln), 1,
 			  fw->arp.arhln, op);
 	}
@@ -169,15 +169,15 @@ static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
 	add_proto(r, offsetof(struct arphdr, ar_pln), 1, 4, NFT_CMP_EQ);
 
 	if (fw->arp.arpop != 0 ||
-	    fw->arp.invflags & ARPT_INV_ARPOP) {
-		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_ARPOP);
+	    fw->arp.invflags & IPT_INV_ARPOP) {
+		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_ARPOP);
 		add_payload(r, offsetof(struct arphdr, ar_op), 2,
 			    NFT_PAYLOAD_NETWORK_HEADER);
 		add_cmp_u16(r, fw->arp.arpop, op);
 	}
 
 	if (need_devaddr(&fw->arp.src_devaddr)) {
-		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_SRCDEVADDR);
+		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_SRCDEVADDR);
 		add_addr(r, NFT_PAYLOAD_NETWORK_HEADER,
 			 sizeof(struct arphdr),
 			 &fw->arp.src_devaddr.addr,
@@ -188,8 +188,8 @@ static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
 
 	if (fw->arp.src.s_addr != 0 ||
 	    fw->arp.smsk.s_addr != 0 ||
-	    fw->arp.invflags & ARPT_INV_SRCIP) {
-		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_SRCIP);
+	    fw->arp.invflags & IPT_INV_SRCIP) {
+		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_SRCIP);
 		add_addr(r, NFT_PAYLOAD_NETWORK_HEADER,
 			 sizeof(struct arphdr) + fw->arp.arhln,
 			 &fw->arp.src.s_addr, &fw->arp.smsk.s_addr,
@@ -198,7 +198,7 @@ static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
 
 
 	if (need_devaddr(&fw->arp.tgt_devaddr)) {
-		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_TGTDEVADDR);
+		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_TGTDEVADDR);
 		add_addr(r, NFT_PAYLOAD_NETWORK_HEADER,
 			 sizeof(struct arphdr) + fw->arp.arhln + sizeof(struct in_addr),
 			 &fw->arp.tgt_devaddr.addr,
@@ -208,8 +208,8 @@ static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
 
 	if (fw->arp.tgt.s_addr != 0 ||
 	    fw->arp.tmsk.s_addr != 0 ||
-	    fw->arp.invflags & ARPT_INV_TGTIP) {
-		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_TGTIP);
+	    fw->arp.invflags & IPT_INV_DSTIP) {
+		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_DSTIP);
 		add_addr(r, NFT_PAYLOAD_NETWORK_HEADER,
 			 sizeof(struct arphdr) + fw->arp.arhln + sizeof(struct in_addr) + fw->arp.arhln,
 			 &fw->arp.tgt.s_addr, &fw->arp.tmsk.s_addr,
@@ -240,28 +240,6 @@ static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
 	return ret;
 }
 
-static uint16_t ipt_to_arpt_flags(uint8_t invflags)
-{
-	uint16_t result = 0;
-
-	if (invflags & IPT_INV_VIA_IN)
-		result |= ARPT_INV_VIA_IN;
-
-	if (invflags & IPT_INV_VIA_OUT)
-		result |= ARPT_INV_VIA_OUT;
-
-	if (invflags & IPT_INV_SRCIP)
-		result |= ARPT_INV_SRCIP;
-
-	if (invflags & IPT_INV_DSTIP)
-		result |= ARPT_INV_TGTIP;
-
-	if (invflags & IPT_INV_PROTO)
-		result |= ARPT_INV_ARPPRO;
-
-	return result;
-}
-
 static void nft_arp_parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
 			       void *data)
 {
@@ -273,7 +251,7 @@ static void nft_arp_parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
 		   fw->arp.outiface, fw->arp.outiface_mask,
 		   &flags);
 
-	fw->arp.invflags |= ipt_to_arpt_flags(flags);
+	fw->arp.invflags |= flags;
 }
 
 static void nft_arp_parse_immediate(const char *jumpto, bool nft_goto,
@@ -330,33 +308,33 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 		fw->arp.arhrd = ar_hrd;
 		fw->arp.arhrd_mask = 0xffff;
 		if (inv)
-			fw->arp.invflags |= ARPT_INV_ARPHRD;
+			fw->arp.invflags |= IPT_INV_ARPHRD;
 		break;
 	case offsetof(struct arphdr, ar_pro):
 		get_cmp_data(e, &ar_pro, sizeof(ar_pro), &inv);
 		fw->arp.arpro = ar_pro;
 		fw->arp.arpro_mask = 0xffff;
 		if (inv)
-			fw->arp.invflags |= ARPT_INV_ARPPRO;
+			fw->arp.invflags |= IPT_INV_PROTO;
 		break;
 	case offsetof(struct arphdr, ar_op):
 		get_cmp_data(e, &ar_op, sizeof(ar_op), &inv);
 		fw->arp.arpop = ar_op;
 		fw->arp.arpop_mask = 0xffff;
 		if (inv)
-			fw->arp.invflags |= ARPT_INV_ARPOP;
+			fw->arp.invflags |= IPT_INV_ARPOP;
 		break;
 	case offsetof(struct arphdr, ar_hln):
 		get_cmp_data(e, &ar_hln, sizeof(ar_hln), &inv);
 		fw->arp.arhln = ar_hln;
 		fw->arp.arhln_mask = 0xff;
 		if (inv)
-			fw->arp.invflags |= ARPT_INV_ARPOP;
+			fw->arp.invflags |= IPT_INV_ARPOP;
 		break;
 	default:
 		if (ctx->payload.offset == sizeof(struct arphdr)) {
 			if (nft_arp_parse_devaddr(ctx, e, &fw->arp.src_devaddr))
-				fw->arp.invflags |= ARPT_INV_SRCDEVADDR;
+				fw->arp.invflags |= IPT_INV_SRCDEVADDR;
 		} else if (ctx->payload.offset == sizeof(struct arphdr) +
 					   fw->arp.arhln) {
 			get_cmp_data(e, &addr, sizeof(addr), &inv);
@@ -371,12 +349,12 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 			}
 
 			if (inv)
-				fw->arp.invflags |= ARPT_INV_SRCIP;
+				fw->arp.invflags |= IPT_INV_SRCIP;
 		} else if (ctx->payload.offset == sizeof(struct arphdr) +
 						  fw->arp.arhln +
 						  sizeof(struct in_addr)) {
 			if (nft_arp_parse_devaddr(ctx, e, &fw->arp.tgt_devaddr))
-				fw->arp.invflags |= ARPT_INV_TGTDEVADDR;
+				fw->arp.invflags |= IPT_INV_TGTDEVADDR;
 		} else if (ctx->payload.offset == sizeof(struct arphdr) +
 						  fw->arp.arhln +
 						  sizeof(struct in_addr) +
@@ -393,7 +371,7 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 			}
 
 			if (inv)
-				fw->arp.invflags |= ARPT_INV_TGTIP;
+				fw->arp.invflags |= IPT_INV_DSTIP;
 		}
 		break;
 	}
@@ -448,7 +426,7 @@ static void nft_arp_print_rule_details(const struct iptables_command_state *cs,
 		else strcat(iface, "any");
 	}
 	if (print_iface) {
-		printf("%s%s-i %s", sep, fw->arp.invflags & ARPT_INV_VIA_IN ?
+		printf("%s%s-i %s", sep, fw->arp.invflags & IPT_INV_VIA_IN ?
 				   "! " : "", iface);
 		sep = " ";
 	}
@@ -466,13 +444,13 @@ static void nft_arp_print_rule_details(const struct iptables_command_state *cs,
 		else strcat(iface, "any");
 	}
 	if (print_iface) {
-		printf("%s%s-o %s", sep, fw->arp.invflags & ARPT_INV_VIA_OUT ?
+		printf("%s%s-o %s", sep, fw->arp.invflags & IPT_INV_VIA_OUT ?
 				   "! " : "", iface);
 		sep = " ";
 	}
 
 	if (fw->arp.smsk.s_addr != 0L) {
-		printf("%s%s", sep, fw->arp.invflags & ARPT_INV_SRCIP
+		printf("%s%s", sep, fw->arp.invflags & IPT_INV_SRCIP
 			? "! " : "");
 		if (format & FMT_NUMERIC)
 			sprintf(buf, "%s", addr_to_dotted(&(fw->arp.src)));
@@ -489,7 +467,7 @@ static void nft_arp_print_rule_details(const struct iptables_command_state *cs,
 			break;
 	if (i == ARPT_DEV_ADDR_LEN_MAX)
 		goto after_devsrc;
-	printf("%s%s", sep, fw->arp.invflags & ARPT_INV_SRCDEVADDR
+	printf("%s%s", sep, fw->arp.invflags & IPT_INV_SRCDEVADDR
 		? "! " : "");
 	printf("--src-mac ");
 	xtables_print_mac_and_mask((unsigned char *)fw->arp.src_devaddr.addr,
@@ -498,7 +476,7 @@ static void nft_arp_print_rule_details(const struct iptables_command_state *cs,
 after_devsrc:
 
 	if (fw->arp.tmsk.s_addr != 0L) {
-		printf("%s%s", sep, fw->arp.invflags & ARPT_INV_TGTIP
+		printf("%s%s", sep, fw->arp.invflags & IPT_INV_DSTIP
 			? "! " : "");
 		if (format & FMT_NUMERIC)
 			sprintf(buf, "%s", addr_to_dotted(&(fw->arp.tgt)));
@@ -515,7 +493,7 @@ after_devsrc:
 			break;
 	if (i == ARPT_DEV_ADDR_LEN_MAX)
 		goto after_devdst;
-	printf("%s%s", sep, fw->arp.invflags & ARPT_INV_TGTDEVADDR
+	printf("%s%s", sep, fw->arp.invflags & IPT_INV_TGTDEVADDR
 		? "! " : "");
 	printf("--dst-mac ");
 	xtables_print_mac_and_mask((unsigned char *)fw->arp.tgt_devaddr.addr,
@@ -525,7 +503,7 @@ after_devsrc:
 after_devdst:
 
 	if (fw->arp.arhln_mask != 255 || fw->arp.arhln != 6) {
-		printf("%s%s", sep, fw->arp.invflags & ARPT_INV_ARPHLN
+		printf("%s%s", sep, fw->arp.invflags & IPT_INV_ARPHLN
 			? "! " : "");
 		printf("--h-length %d", fw->arp.arhln);
 		if (fw->arp.arhln_mask != 255)
@@ -536,7 +514,7 @@ after_devdst:
 	if (fw->arp.arpop_mask != 0) {
 		int tmp = ntohs(fw->arp.arpop);
 
-		printf("%s%s", sep, fw->arp.invflags & ARPT_INV_ARPOP
+		printf("%s%s", sep, fw->arp.invflags & IPT_INV_ARPOP
 			? "! " : "");
 		if (tmp <= NUMOPCODES && !(format & FMT_NUMERIC))
 			printf("--opcode %s", arp_opcodes[tmp-1]);
@@ -551,7 +529,7 @@ after_devdst:
 	if (fw->arp.arhrd_mask != 65535 || fw->arp.arhrd != htons(1)) {
 		uint16_t tmp = ntohs(fw->arp.arhrd);
 
-		printf("%s%s", sep, fw->arp.invflags & ARPT_INV_ARPHRD
+		printf("%s%s", sep, fw->arp.invflags & IPT_INV_ARPHRD
 			? "! " : "");
 		if (tmp == 1 && !(format & FMT_NUMERIC))
 			printf("--h-type %s", "Ethernet");
@@ -565,7 +543,7 @@ after_devdst:
 	if (fw->arp.arpro_mask != 0) {
 		int tmp = ntohs(fw->arp.arpro);
 
-		printf("%s%s", sep, fw->arp.invflags & ARPT_INV_ARPPRO
+		printf("%s%s", sep, fw->arp.invflags & IPT_INV_PROTO
 			? "! " : "");
 		if (tmp == 0x0800 && !(format & FMT_NUMERIC))
 			printf("--proto-type %s", "IPv4");
diff --git a/iptables/nft-arp.h b/iptables/nft-arp.h
index 3411fc3d7c7b3..0d93a31f563b1 100644
--- a/iptables/nft-arp.h
+++ b/iptables/nft-arp.h
@@ -4,4 +4,11 @@
 extern char *arp_opcodes[];
 #define NUMOPCODES 9
 
+/* define invflags which won't collide with IPT ones */
+#define IPT_INV_SRCDEVADDR	0x0080
+#define IPT_INV_TGTDEVADDR	0x0100
+#define IPT_INV_ARPHLN		0x0200
+#define IPT_INV_ARPOP		0x0400
+#define IPT_INV_ARPHRD		0x0800
+
 #endif
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index e56bbb4dd0363..a557f258b437a 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -113,22 +113,22 @@ struct xtables_globals arptables_globals = {
 static int inverse_for_options[] =
 {
 /* -n */ 0,
-/* -s */ ARPT_INV_SRCIP,
-/* -d */ ARPT_INV_TGTIP,
+/* -s */ IPT_INV_SRCIP,
+/* -d */ IPT_INV_DSTIP,
 /* -p */ 0,
 /* -j */ 0,
 /* -v */ 0,
 /* -x */ 0,
-/* -i */ ARPT_INV_VIA_IN,
-/* -o */ ARPT_INV_VIA_OUT,
+/* -i */ IPT_INV_VIA_IN,
+/* -o */ IPT_INV_VIA_OUT,
 /*--line*/ 0,
 /* -c */ 0,
-/* 2 */ ARPT_INV_SRCDEVADDR,
-/* 3 */ ARPT_INV_TGTDEVADDR,
-/* -l */ ARPT_INV_ARPHLN,
-/* 4 */ ARPT_INV_ARPOP,
-/* 5 */ ARPT_INV_ARPHRD,
-/* 6 */ ARPT_INV_ARPPRO,
+/* 2 */ IPT_INV_SRCDEVADDR,
+/* 3 */ IPT_INV_TGTDEVADDR,
+/* -l */ IPT_INV_ARPHLN,
+/* 4 */ IPT_INV_ARPOP,
+/* 5 */ IPT_INV_ARPHRD,
+/* 6 */ IPT_INV_PROTO,
 };
 
 /***********************************************/
@@ -855,7 +855,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 					 &dmasks, &ndaddrs);
 
 	if ((nsaddrs > 1 || ndaddrs > 1) &&
-	    (cs.arp.arp.invflags & (ARPT_INV_SRCIP | ARPT_INV_TGTIP)))
+	    (cs.arp.arp.invflags & (IPT_INV_SRCIP | IPT_INV_DSTIP)))
 		xtables_error(PARAMETER_PROBLEM, "! not allowed with multiple"
 				" source or destination IP addresses");
 
-- 
2.28.0

