Return-Path: <SRS0=8Ikc=EF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E7FC4363A
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Oct 2020 13:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3FA82075E
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Oct 2020 13:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgJ3NZC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Oct 2020 09:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgJ3NZC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Oct 2020 09:25:02 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD14C0613CF
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2020 06:25:01 -0700 (PDT)
Received: from localhost ([::1]:37584 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kYUOn-0004nB-T7; Fri, 30 Oct 2020 14:24:57 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] ebtables: Optimize masked MAC address matches
Date:   Fri, 30 Oct 2020 14:24:49 +0100
Message-Id: <20201030132449.5576-2-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030132449.5576-1-phil@nwl.cc>
References: <20201030132449.5576-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Just like with class-based prefix matches in iptables-nft, optimize
masked MAC address matches if the mask is on a byte-boundary.

To reuse the logic in add_addr(), extend it to accept the payload base
value via parameter.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c    | 12 ++++++++----
 iptables/nft-bridge.c | 22 ++++++++++------------
 iptables/nft-ipv4.c   |  6 ++++--
 iptables/nft-ipv6.c   |  6 ++++--
 iptables/nft-shared.c |  5 ++---
 iptables/nft-shared.h |  3 ++-
 6 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 952f0c6916e59..5dc38da831aa0 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -178,7 +178,8 @@ static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
 
 	if (need_devaddr(&fw->arp.src_devaddr)) {
 		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_SRCDEVADDR);
-		add_addr(r, sizeof(struct arphdr),
+		add_addr(r, NFT_PAYLOAD_NETWORK_HEADER,
+			 sizeof(struct arphdr),
 			 &fw->arp.src_devaddr.addr,
 			 &fw->arp.src_devaddr.mask,
 			 fw->arp.arhln, op);
@@ -189,7 +190,8 @@ static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
 	    fw->arp.smsk.s_addr != 0 ||
 	    fw->arp.invflags & ARPT_INV_SRCIP) {
 		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_SRCIP);
-		add_addr(r, sizeof(struct arphdr) + fw->arp.arhln,
+		add_addr(r, NFT_PAYLOAD_NETWORK_HEADER,
+			 sizeof(struct arphdr) + fw->arp.arhln,
 			 &fw->arp.src.s_addr, &fw->arp.smsk.s_addr,
 			 sizeof(struct in_addr), op);
 	}
@@ -197,7 +199,8 @@ static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
 
 	if (need_devaddr(&fw->arp.tgt_devaddr)) {
 		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_TGTDEVADDR);
-		add_addr(r, sizeof(struct arphdr) + fw->arp.arhln + sizeof(struct in_addr),
+		add_addr(r, NFT_PAYLOAD_NETWORK_HEADER,
+			 sizeof(struct arphdr) + fw->arp.arhln + sizeof(struct in_addr),
 			 &fw->arp.tgt_devaddr.addr,
 			 &fw->arp.tgt_devaddr.mask,
 			 fw->arp.arhln, op);
@@ -207,7 +210,8 @@ static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
 	    fw->arp.tmsk.s_addr != 0 ||
 	    fw->arp.invflags & ARPT_INV_TGTIP) {
 		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_TGTIP);
-		add_addr(r, sizeof(struct arphdr) + fw->arp.arhln + sizeof(struct in_addr) + fw->arp.arhln,
+		add_addr(r, NFT_PAYLOAD_NETWORK_HEADER,
+			 sizeof(struct arphdr) + fw->arp.arhln + sizeof(struct in_addr) + fw->arp.arhln,
 			 &fw->arp.tgt.s_addr, &fw->arp.tmsk.s_addr,
 			 sizeof(struct in_addr), op);
 	}
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index dbf11eb5e1fa8..c1a2c209cc1aa 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -159,20 +159,16 @@ static int nft_bridge_add(struct nft_handle *h,
 
 	if (fw->bitmask & EBT_ISOURCE) {
 		op = nft_invflags2cmp(fw->invflags, EBT_ISOURCE);
-		add_payload(r, offsetof(struct ethhdr, h_source), 6,
-			    NFT_PAYLOAD_LL_HEADER);
-		if (!mac_all_ones(fw->sourcemsk))
-			add_bitwise(r, fw->sourcemsk, 6);
-		add_cmp_ptr(r, op, fw->sourcemac, 6);
+		add_addr(r, NFT_PAYLOAD_LL_HEADER,
+			 offsetof(struct ethhdr, h_source),
+			 fw->sourcemac, fw->sourcemsk, ETH_ALEN, op);
 	}
 
 	if (fw->bitmask & EBT_IDEST) {
 		op = nft_invflags2cmp(fw->invflags, EBT_IDEST);
-		add_payload(r, offsetof(struct ethhdr, h_dest), 6,
-			    NFT_PAYLOAD_LL_HEADER);
-		if (!mac_all_ones(fw->destmsk))
-			add_bitwise(r, fw->destmsk, 6);
-		add_cmp_ptr(r, op, fw->destmac, 6);
+		add_addr(r, NFT_PAYLOAD_LL_HEADER,
+			 offsetof(struct ethhdr, h_dest),
+			 fw->destmac, fw->destmsk, ETH_ALEN, op);
 	}
 
 	if ((fw->bitmask & EBT_NOPROTO) == 0) {
@@ -258,7 +254,8 @@ static void nft_bridge_parse_payload(struct nft_xt_ctx *ctx,
                         memcpy(fw->destmsk, ctx->bitwise.mask, ETH_ALEN);
                         ctx->flags &= ~NFT_XT_CTX_BITWISE;
                 } else {
-                        memset(&fw->destmsk, 0xff, ETH_ALEN);
+			memset(&fw->destmsk, 0xff,
+			       min(ctx->payload.len, ETH_ALEN));
                 }
 		fw->bitmask |= EBT_IDEST;
 		break;
@@ -272,7 +269,8 @@ static void nft_bridge_parse_payload(struct nft_xt_ctx *ctx,
                         memcpy(fw->sourcemsk, ctx->bitwise.mask, ETH_ALEN);
                         ctx->flags &= ~NFT_XT_CTX_BITWISE;
                 } else {
-                        memset(&fw->sourcemsk, 0xff, ETH_ALEN);
+			memset(&fw->sourcemsk, 0xff,
+			       min(ctx->payload.len, ETH_ALEN));
                 }
 		fw->bitmask |= EBT_ISOURCE;
 		break;
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index ce702041af0f4..fdc15c6f04066 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -50,13 +50,15 @@ static int nft_ipv4_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
 
 	if (cs->fw.ip.src.s_addr || cs->fw.ip.smsk.s_addr || cs->fw.ip.invflags & IPT_INV_SRCIP) {
 		op = nft_invflags2cmp(cs->fw.ip.invflags, IPT_INV_SRCIP);
-		add_addr(r, offsetof(struct iphdr, saddr),
+		add_addr(r, NFT_PAYLOAD_NETWORK_HEADER,
+			 offsetof(struct iphdr, saddr),
 			 &cs->fw.ip.src.s_addr, &cs->fw.ip.smsk.s_addr,
 			 sizeof(struct in_addr), op);
 	}
 	if (cs->fw.ip.dst.s_addr || cs->fw.ip.dmsk.s_addr || cs->fw.ip.invflags & IPT_INV_DSTIP) {
 		op = nft_invflags2cmp(cs->fw.ip.invflags, IPT_INV_DSTIP);
-		add_addr(r, offsetof(struct iphdr, daddr),
+		add_addr(r, NFT_PAYLOAD_NETWORK_HEADER,
+			 offsetof(struct iphdr, daddr),
 			 &cs->fw.ip.dst.s_addr, &cs->fw.ip.dmsk.s_addr,
 			 sizeof(struct in_addr), op);
 	}
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index c877ec6d10887..130ad3e6e7c44 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -51,7 +51,8 @@ static int nft_ipv6_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
 	    !IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.smsk) ||
 	    (cs->fw6.ipv6.invflags & IPT_INV_SRCIP)) {
 		op = nft_invflags2cmp(cs->fw6.ipv6.invflags, IPT_INV_SRCIP);
-		add_addr(r, offsetof(struct ip6_hdr, ip6_src),
+		add_addr(r, NFT_PAYLOAD_NETWORK_HEADER,
+			 offsetof(struct ip6_hdr, ip6_src),
 			 &cs->fw6.ipv6.src, &cs->fw6.ipv6.smsk,
 			 sizeof(struct in6_addr), op);
 	}
@@ -59,7 +60,8 @@ static int nft_ipv6_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
 	    !IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.dmsk) ||
 	    (cs->fw6.ipv6.invflags & IPT_INV_DSTIP)) {
 		op = nft_invflags2cmp(cs->fw6.ipv6.invflags, IPT_INV_DSTIP);
-		add_addr(r, offsetof(struct ip6_hdr, ip6_dst),
+		add_addr(r, NFT_PAYLOAD_NETWORK_HEADER,
+			 offsetof(struct ip6_hdr, ip6_dst),
 			 &cs->fw6.ipv6.dst, &cs->fw6.ipv6.dmsk,
 			 sizeof(struct in6_addr), op);
 	}
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 545e9c60fa015..10553ab26823b 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -20,7 +20,6 @@
 
 #include <xtables.h>
 
-#include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/xt_comment.h>
 #include <linux/netfilter/xt_limit.h>
 
@@ -162,7 +161,7 @@ void add_outiface(struct nftnl_rule *r, char *iface, uint32_t op)
 		add_cmp_ptr(r, op, iface, iface_len + 1);
 }
 
-void add_addr(struct nftnl_rule *r, int offset,
+void add_addr(struct nftnl_rule *r, enum nft_payload_bases base, int offset,
 	      void *data, void *mask, size_t len, uint32_t op)
 {
 	const unsigned char *m = mask;
@@ -179,7 +178,7 @@ void add_addr(struct nftnl_rule *r, int offset,
 	if (!bitwise)
 		len = i;
 
-	add_payload(r, offset, len, NFT_PAYLOAD_NETWORK_HEADER);
+	add_payload(r, offset, len, base);
 
 	if (bitwise)
 		add_bitwise(r, mask, len);
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index a52463342b30a..da4ba9d2ba8de 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -8,6 +8,7 @@
 #include <libnftnl/chain.h>
 
 #include <linux/netfilter_arp/arp_tables.h>
+#include <linux/netfilter/nf_tables.h>
 
 #include "xshared.h"
 
@@ -121,7 +122,7 @@ void add_cmp_u16(struct nftnl_rule *r, uint16_t val, uint32_t op);
 void add_cmp_u32(struct nftnl_rule *r, uint32_t val, uint32_t op);
 void add_iniface(struct nftnl_rule *r, char *iface, uint32_t op);
 void add_outiface(struct nftnl_rule *r, char *iface, uint32_t op);
-void add_addr(struct nftnl_rule *r, int offset,
+void add_addr(struct nftnl_rule *r, enum nft_payload_bases base, int offset,
 	      void *data, void *mask, size_t len, uint32_t op);
 void add_proto(struct nftnl_rule *r, int offset, size_t len,
 	       uint8_t proto, uint32_t op);
-- 
2.28.0

