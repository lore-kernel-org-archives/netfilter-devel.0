Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BB0C77B7A
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Jun 2023 19:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbjFAT2f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Jun 2023 15:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjFAT2f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Jun 2023 15:28:35 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A965189
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Jun 2023 12:28:33 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH iptables] nft: check for source and destination address in first place
Date:   Thu,  1 Jun 2023 21:28:28 +0200
Message-Id: <20230601192828.86384-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When generating bytecode, check for source and destination address in
first place, then, check for the input and output device. In general,
the first expression in the rule is the most evaluated during the
evaluation process. These selectors are likely to show more variability
in rulesets.

 # iptables-nft -vv -I INPUT -s 1.2.3.4 -p tcp
  tcp opt -- in * out *  1.2.3.4  -> 0.0.0.0/0
table filter ip flags 0 use 0 handle 0
ip filter INPUT use 0 type filter hook input prio 0 policy accept packets 0 bytes 0
ip filter INPUT
  [ payload load 4b @ network header + 12 => reg 1 ]
  [ cmp eq reg 1 0x04030201 ]
  [ meta load l4proto => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ counter pkts 0 bytes 0 ]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-bridge.c | 28 ++++++++++++++--------------
 iptables/nft-ipv4.c   | 30 ++++++++++++++++--------------
 iptables/nft-ipv6.c   | 32 +++++++++++++++++---------------
 3 files changed, 47 insertions(+), 43 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index f3dfa488c620..6e50950774e6 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -163,6 +163,20 @@ static int nft_bridge_add(struct nft_handle *h,
 	struct ebt_entry *fw = &cs->eb;
 	uint32_t op;
 
+	if (fw->bitmask & EBT_ISOURCE) {
+		op = nft_invflags2cmp(fw->invflags, EBT_ISOURCE);
+		add_addr(h, r, NFT_PAYLOAD_LL_HEADER,
+			 offsetof(struct ethhdr, h_source),
+			 fw->sourcemac, fw->sourcemsk, ETH_ALEN, op);
+	}
+
+	if (fw->bitmask & EBT_IDEST) {
+		op = nft_invflags2cmp(fw->invflags, EBT_IDEST);
+		add_addr(h, r, NFT_PAYLOAD_LL_HEADER,
+			 offsetof(struct ethhdr, h_dest),
+			 fw->destmac, fw->destmsk, ETH_ALEN, op);
+	}
+
 	if (fw->in[0] != '\0') {
 		op = nft_invflags2cmp(fw->invflags, EBT_IIN);
 		add_iniface(h, r, fw->in, op);
@@ -183,20 +197,6 @@ static int nft_bridge_add(struct nft_handle *h,
 		add_logical_outiface(h, r, fw->logical_out, op);
 	}
 
-	if (fw->bitmask & EBT_ISOURCE) {
-		op = nft_invflags2cmp(fw->invflags, EBT_ISOURCE);
-		add_addr(h, r, NFT_PAYLOAD_LL_HEADER,
-			 offsetof(struct ethhdr, h_source),
-			 fw->sourcemac, fw->sourcemsk, ETH_ALEN, op);
-	}
-
-	if (fw->bitmask & EBT_IDEST) {
-		op = nft_invflags2cmp(fw->invflags, EBT_IDEST);
-		add_addr(h, r, NFT_PAYLOAD_LL_HEADER,
-			 offsetof(struct ethhdr, h_dest),
-			 fw->destmac, fw->destmsk, ETH_ALEN, op);
-	}
-
 	if ((fw->bitmask & EBT_NOPROTO) == 0) {
 		uint16_t ethproto = fw->ethproto;
 		uint8_t reg;
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 6df4e46bc377..d67d8198bfaf 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -33,6 +33,22 @@ static int nft_ipv4_add(struct nft_handle *h, struct nftnl_rule *r,
 	uint32_t op;
 	int ret;
 
+	if (cs->fw.ip.src.s_addr || cs->fw.ip.smsk.s_addr || cs->fw.ip.invflags & IPT_INV_SRCIP) {
+		op = nft_invflags2cmp(cs->fw.ip.invflags, IPT_INV_SRCIP);
+		add_addr(h, r, NFT_PAYLOAD_NETWORK_HEADER,
+			 offsetof(struct iphdr, saddr),
+			 &cs->fw.ip.src.s_addr, &cs->fw.ip.smsk.s_addr,
+			 sizeof(struct in_addr), op);
+	}
+
+	if (cs->fw.ip.dst.s_addr || cs->fw.ip.dmsk.s_addr || cs->fw.ip.invflags & IPT_INV_DSTIP) {
+		op = nft_invflags2cmp(cs->fw.ip.invflags, IPT_INV_DSTIP);
+		add_addr(h, r, NFT_PAYLOAD_NETWORK_HEADER,
+			 offsetof(struct iphdr, daddr),
+			 &cs->fw.ip.dst.s_addr, &cs->fw.ip.dmsk.s_addr,
+			 sizeof(struct in_addr), op);
+	}
+
 	if (cs->fw.ip.iniface[0] != '\0') {
 		op = nft_invflags2cmp(cs->fw.ip.invflags, IPT_INV_VIA_IN);
 		add_iniface(h, r, cs->fw.ip.iniface, op);
@@ -48,20 +64,6 @@ static int nft_ipv4_add(struct nft_handle *h, struct nftnl_rule *r,
 		add_l4proto(h, r, cs->fw.ip.proto, op);
 	}
 
-	if (cs->fw.ip.src.s_addr || cs->fw.ip.smsk.s_addr || cs->fw.ip.invflags & IPT_INV_SRCIP) {
-		op = nft_invflags2cmp(cs->fw.ip.invflags, IPT_INV_SRCIP);
-		add_addr(h, r, NFT_PAYLOAD_NETWORK_HEADER,
-			 offsetof(struct iphdr, saddr),
-			 &cs->fw.ip.src.s_addr, &cs->fw.ip.smsk.s_addr,
-			 sizeof(struct in_addr), op);
-	}
-	if (cs->fw.ip.dst.s_addr || cs->fw.ip.dmsk.s_addr || cs->fw.ip.invflags & IPT_INV_DSTIP) {
-		op = nft_invflags2cmp(cs->fw.ip.invflags, IPT_INV_DSTIP);
-		add_addr(h, r, NFT_PAYLOAD_NETWORK_HEADER,
-			 offsetof(struct iphdr, daddr),
-			 &cs->fw.ip.dst.s_addr, &cs->fw.ip.dmsk.s_addr,
-			 sizeof(struct in_addr), op);
-	}
 	if (cs->fw.ip.flags & IPT_F_FRAG) {
 		uint8_t reg;
 
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 693a1c87b997..658a4f201895 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -32,21 +32,6 @@ static int nft_ipv6_add(struct nft_handle *h, struct nftnl_rule *r,
 	uint32_t op;
 	int ret;
 
-	if (cs->fw6.ipv6.iniface[0] != '\0') {
-		op = nft_invflags2cmp(cs->fw6.ipv6.invflags, IPT_INV_VIA_IN);
-		add_iniface(h, r, cs->fw6.ipv6.iniface, op);
-	}
-
-	if (cs->fw6.ipv6.outiface[0] != '\0') {
-		op = nft_invflags2cmp(cs->fw6.ipv6.invflags, IPT_INV_VIA_OUT);
-		add_outiface(h, r, cs->fw6.ipv6.outiface, op);
-	}
-
-	if (cs->fw6.ipv6.proto != 0) {
-		op = nft_invflags2cmp(cs->fw6.ipv6.invflags, XT_INV_PROTO);
-		add_l4proto(h, r, cs->fw6.ipv6.proto, op);
-	}
-
 	if (!IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.src) ||
 	    !IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.smsk) ||
 	    (cs->fw6.ipv6.invflags & IPT_INV_SRCIP)) {
@@ -56,6 +41,7 @@ static int nft_ipv6_add(struct nft_handle *h, struct nftnl_rule *r,
 			 &cs->fw6.ipv6.src, &cs->fw6.ipv6.smsk,
 			 sizeof(struct in6_addr), op);
 	}
+
 	if (!IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.dst) ||
 	    !IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.dmsk) ||
 	    (cs->fw6.ipv6.invflags & IPT_INV_DSTIP)) {
@@ -65,6 +51,22 @@ static int nft_ipv6_add(struct nft_handle *h, struct nftnl_rule *r,
 			 &cs->fw6.ipv6.dst, &cs->fw6.ipv6.dmsk,
 			 sizeof(struct in6_addr), op);
 	}
+
+	if (cs->fw6.ipv6.iniface[0] != '\0') {
+		op = nft_invflags2cmp(cs->fw6.ipv6.invflags, IPT_INV_VIA_IN);
+		add_iniface(h, r, cs->fw6.ipv6.iniface, op);
+	}
+
+	if (cs->fw6.ipv6.outiface[0] != '\0') {
+		op = nft_invflags2cmp(cs->fw6.ipv6.invflags, IPT_INV_VIA_OUT);
+		add_outiface(h, r, cs->fw6.ipv6.outiface, op);
+	}
+
+	if (cs->fw6.ipv6.proto != 0) {
+		op = nft_invflags2cmp(cs->fw6.ipv6.invflags, XT_INV_PROTO);
+		add_l4proto(h, r, cs->fw6.ipv6.proto, op);
+	}
+
 	add_compat(r, cs->fw6.ipv6.proto, cs->fw6.ipv6.invflags & XT_INV_PROTO);
 
 	for (matchp = cs->matches; matchp; matchp = matchp->next) {
-- 
2.30.2

