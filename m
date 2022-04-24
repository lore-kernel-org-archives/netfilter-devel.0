Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52149C43219
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Apr 2022 21:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239694AbiDXV72 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Apr 2022 17:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239695AbiDXV71 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Apr 2022 17:59:27 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8F3D396A2
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Apr 2022 14:56:23 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables 4/7] nft: pass handle to helper functions to build netlink payload
Date:   Sun, 24 Apr 2022 23:56:10 +0200
Message-Id: <20220424215613.106165-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220424215613.106165-1-pablo@netfilter.org>
References: <20220424215613.106165-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pass struct nft_handle to helper functions in preparation for the
dynamic register allocation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-arp.c    | 22 +++++++++++-----------
 iptables/nft-bridge.c | 24 +++++++++++++-----------
 iptables/nft-ipv4.c   | 12 ++++++------
 iptables/nft-ipv6.c   | 10 +++++-----
 iptables/nft-shared.c | 31 ++++++++++++++++++-------------
 iptables/nft-shared.h | 14 +++++++-------
 iptables/nft.c        | 26 +++++++++++++-------------
 7 files changed, 73 insertions(+), 66 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 89e6413441e2..8c5ce3525dd5 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -63,18 +63,18 @@ static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r,
 
 	if (fw->arp.iniface[0] != '\0') {
 		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_VIA_IN);
-		add_iniface(r, fw->arp.iniface, op);
+		add_iniface(h, r, fw->arp.iniface, op);
 	}
 
 	if (fw->arp.outiface[0] != '\0') {
 		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_VIA_OUT);
-		add_outiface(r, fw->arp.outiface, op);
+		add_outiface(h, r, fw->arp.outiface, op);
 	}
 
 	if (fw->arp.arhrd != 0 ||
 	    fw->arp.invflags & IPT_INV_ARPHRD) {
 		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_ARPHRD);
-		add_payload(r, offsetof(struct arphdr, ar_hrd), 2,
+		add_payload(h, r, offsetof(struct arphdr, ar_hrd), 2,
 			    NFT_PAYLOAD_NETWORK_HEADER);
 		add_cmp_u16(r, fw->arp.arhrd, op);
 	}
@@ -82,7 +82,7 @@ static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r,
 	if (fw->arp.arpro != 0 ||
 	    fw->arp.invflags & IPT_INV_PROTO) {
 		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_PROTO);
-	        add_payload(r, offsetof(struct arphdr, ar_pro), 2,
+	        add_payload(h, r, offsetof(struct arphdr, ar_pro), 2,
 			    NFT_PAYLOAD_NETWORK_HEADER);
 		add_cmp_u16(r, fw->arp.arpro, op);
 	}
@@ -90,23 +90,23 @@ static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r,
 	if (fw->arp.arhln != 0 ||
 	    fw->arp.invflags & IPT_INV_ARPHLN) {
 		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_ARPHLN);
-		add_proto(r, offsetof(struct arphdr, ar_hln), 1,
+		add_proto(h, r, offsetof(struct arphdr, ar_hln), 1,
 			  fw->arp.arhln, op);
 	}
 
-	add_proto(r, offsetof(struct arphdr, ar_pln), 1, 4, NFT_CMP_EQ);
+	add_proto(h, r, offsetof(struct arphdr, ar_pln), 1, 4, NFT_CMP_EQ);
 
 	if (fw->arp.arpop != 0 ||
 	    fw->arp.invflags & IPT_INV_ARPOP) {
 		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_ARPOP);
-		add_payload(r, offsetof(struct arphdr, ar_op), 2,
+		add_payload(h, r, offsetof(struct arphdr, ar_op), 2,
 			    NFT_PAYLOAD_NETWORK_HEADER);
 		add_cmp_u16(r, fw->arp.arpop, op);
 	}
 
 	if (need_devaddr(&fw->arp.src_devaddr)) {
 		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_SRCDEVADDR);
-		add_addr(r, NFT_PAYLOAD_NETWORK_HEADER,
+		add_addr(h, r, NFT_PAYLOAD_NETWORK_HEADER,
 			 sizeof(struct arphdr),
 			 &fw->arp.src_devaddr.addr,
 			 &fw->arp.src_devaddr.mask,
@@ -118,7 +118,7 @@ static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r,
 	    fw->arp.smsk.s_addr != 0 ||
 	    fw->arp.invflags & IPT_INV_SRCIP) {
 		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_SRCIP);
-		add_addr(r, NFT_PAYLOAD_NETWORK_HEADER,
+		add_addr(h, r, NFT_PAYLOAD_NETWORK_HEADER,
 			 sizeof(struct arphdr) + fw->arp.arhln,
 			 &fw->arp.src.s_addr, &fw->arp.smsk.s_addr,
 			 sizeof(struct in_addr), op);
@@ -127,7 +127,7 @@ static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r,
 
 	if (need_devaddr(&fw->arp.tgt_devaddr)) {
 		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_TGTDEVADDR);
-		add_addr(r, NFT_PAYLOAD_NETWORK_HEADER,
+		add_addr(h, r, NFT_PAYLOAD_NETWORK_HEADER,
 			 sizeof(struct arphdr) + fw->arp.arhln + sizeof(struct in_addr),
 			 &fw->arp.tgt_devaddr.addr,
 			 &fw->arp.tgt_devaddr.mask,
@@ -138,7 +138,7 @@ static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r,
 	    fw->arp.tmsk.s_addr != 0 ||
 	    fw->arp.invflags & IPT_INV_DSTIP) {
 		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_DSTIP);
-		add_addr(r, NFT_PAYLOAD_NETWORK_HEADER,
+		add_addr(h, r, NFT_PAYLOAD_NETWORK_HEADER,
 			 sizeof(struct arphdr) + fw->arp.arhln + sizeof(struct in_addr) + fw->arp.arhln,
 			 &fw->arp.tgt.s_addr, &fw->arp.tmsk.s_addr,
 			 sizeof(struct in_addr), op);
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 097ef6e16827..888d4b6baa57 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -65,26 +65,28 @@ static void ebt_print_mac_and_mask(const unsigned char *mac, const unsigned char
 		xtables_print_mac_and_mask(mac, mask);
 }
 
-static void add_logical_iniface(struct nftnl_rule *r, char *iface, uint32_t op)
+static void add_logical_iniface(struct nft_handle *h, struct nftnl_rule *r,
+				char *iface, uint32_t op)
 {
 	int iface_len;
 
 	iface_len = strlen(iface);
 
-	add_meta(r, NFT_META_BRI_IIFNAME);
+	add_meta(h, r, NFT_META_BRI_IIFNAME);
 	if (iface[iface_len - 1] == '+')
 		add_cmp_ptr(r, op, iface, iface_len - 1);
 	else
 		add_cmp_ptr(r, op, iface, iface_len + 1);
 }
 
-static void add_logical_outiface(struct nftnl_rule *r, char *iface, uint32_t op)
+static void add_logical_outiface(struct nft_handle *h, struct nftnl_rule *r,
+				 char *iface, uint32_t op)
 {
 	int iface_len;
 
 	iface_len = strlen(iface);
 
-	add_meta(r, NFT_META_BRI_OIFNAME);
+	add_meta(h, r, NFT_META_BRI_OIFNAME);
 	if (iface[iface_len - 1] == '+')
 		add_cmp_ptr(r, op, iface, iface_len - 1);
 	else
@@ -106,41 +108,41 @@ static int nft_bridge_add(struct nft_handle *h,
 
 	if (fw->in[0] != '\0') {
 		op = nft_invflags2cmp(fw->invflags, EBT_IIN);
-		add_iniface(r, fw->in, op);
+		add_iniface(h, r, fw->in, op);
 	}
 
 	if (fw->out[0] != '\0') {
 		op = nft_invflags2cmp(fw->invflags, EBT_IOUT);
-		add_outiface(r, fw->out, op);
+		add_outiface(h, r, fw->out, op);
 	}
 
 	if (fw->logical_in[0] != '\0') {
 		op = nft_invflags2cmp(fw->invflags, EBT_ILOGICALIN);
-		add_logical_iniface(r, fw->logical_in, op);
+		add_logical_iniface(h, r, fw->logical_in, op);
 	}
 
 	if (fw->logical_out[0] != '\0') {
 		op = nft_invflags2cmp(fw->invflags, EBT_ILOGICALOUT);
-		add_logical_outiface(r, fw->logical_out, op);
+		add_logical_outiface(h, r, fw->logical_out, op);
 	}
 
 	if (fw->bitmask & EBT_ISOURCE) {
 		op = nft_invflags2cmp(fw->invflags, EBT_ISOURCE);
-		add_addr(r, NFT_PAYLOAD_LL_HEADER,
+		add_addr(h, r, NFT_PAYLOAD_LL_HEADER,
 			 offsetof(struct ethhdr, h_source),
 			 fw->sourcemac, fw->sourcemsk, ETH_ALEN, op);
 	}
 
 	if (fw->bitmask & EBT_IDEST) {
 		op = nft_invflags2cmp(fw->invflags, EBT_IDEST);
-		add_addr(r, NFT_PAYLOAD_LL_HEADER,
+		add_addr(h, r, NFT_PAYLOAD_LL_HEADER,
 			 offsetof(struct ethhdr, h_dest),
 			 fw->destmac, fw->destmsk, ETH_ALEN, op);
 	}
 
 	if ((fw->bitmask & EBT_NOPROTO) == 0) {
 		op = nft_invflags2cmp(fw->invflags, EBT_IPROTO);
-		add_payload(r, offsetof(struct ethhdr, h_proto), 2,
+		add_payload(h, r, offsetof(struct ethhdr, h_proto), 2,
 			    NFT_PAYLOAD_LL_HEADER);
 		add_cmp_u16(r, fw->ethproto, op);
 	}
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index cf03edfae9ac..76a0e0de378c 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -35,35 +35,35 @@ static int nft_ipv4_add(struct nft_handle *h, struct nftnl_rule *r,
 
 	if (cs->fw.ip.iniface[0] != '\0') {
 		op = nft_invflags2cmp(cs->fw.ip.invflags, IPT_INV_VIA_IN);
-		add_iniface(r, cs->fw.ip.iniface, op);
+		add_iniface(h, r, cs->fw.ip.iniface, op);
 	}
 
 	if (cs->fw.ip.outiface[0] != '\0') {
 		op = nft_invflags2cmp(cs->fw.ip.invflags, IPT_INV_VIA_OUT);
-		add_outiface(r, cs->fw.ip.outiface, op);
+		add_outiface(h, r, cs->fw.ip.outiface, op);
 	}
 
 	if (cs->fw.ip.proto != 0) {
 		op = nft_invflags2cmp(cs->fw.ip.invflags, XT_INV_PROTO);
-		add_l4proto(r, cs->fw.ip.proto, op);
+		add_l4proto(h, r, cs->fw.ip.proto, op);
 	}
 
 	if (cs->fw.ip.src.s_addr || cs->fw.ip.smsk.s_addr || cs->fw.ip.invflags & IPT_INV_SRCIP) {
 		op = nft_invflags2cmp(cs->fw.ip.invflags, IPT_INV_SRCIP);
-		add_addr(r, NFT_PAYLOAD_NETWORK_HEADER,
+		add_addr(h, r, NFT_PAYLOAD_NETWORK_HEADER,
 			 offsetof(struct iphdr, saddr),
 			 &cs->fw.ip.src.s_addr, &cs->fw.ip.smsk.s_addr,
 			 sizeof(struct in_addr), op);
 	}
 	if (cs->fw.ip.dst.s_addr || cs->fw.ip.dmsk.s_addr || cs->fw.ip.invflags & IPT_INV_DSTIP) {
 		op = nft_invflags2cmp(cs->fw.ip.invflags, IPT_INV_DSTIP);
-		add_addr(r, NFT_PAYLOAD_NETWORK_HEADER,
+		add_addr(h, r, NFT_PAYLOAD_NETWORK_HEADER,
 			 offsetof(struct iphdr, daddr),
 			 &cs->fw.ip.dst.s_addr, &cs->fw.ip.dmsk.s_addr,
 			 sizeof(struct in_addr), op);
 	}
 	if (cs->fw.ip.flags & IPT_F_FRAG) {
-		add_payload(r, offsetof(struct iphdr, frag_off), 2,
+		add_payload(h, r, offsetof(struct iphdr, frag_off), 2,
 			    NFT_PAYLOAD_NETWORK_HEADER);
 		/* get the 13 bits that contain the fragment offset */
 		add_bitwise_u16(r, htons(0x1fff), 0);
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 5b767a4059e6..9a29d18bc215 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -34,24 +34,24 @@ static int nft_ipv6_add(struct nft_handle *h, struct nftnl_rule *r,
 
 	if (cs->fw6.ipv6.iniface[0] != '\0') {
 		op = nft_invflags2cmp(cs->fw6.ipv6.invflags, IPT_INV_VIA_IN);
-		add_iniface(r, cs->fw6.ipv6.iniface, op);
+		add_iniface(h, r, cs->fw6.ipv6.iniface, op);
 	}
 
 	if (cs->fw6.ipv6.outiface[0] != '\0') {
 		op = nft_invflags2cmp(cs->fw6.ipv6.invflags, IPT_INV_VIA_OUT);
-		add_outiface(r, cs->fw6.ipv6.outiface, op);
+		add_outiface(h, r, cs->fw6.ipv6.outiface, op);
 	}
 
 	if (cs->fw6.ipv6.proto != 0) {
 		op = nft_invflags2cmp(cs->fw6.ipv6.invflags, XT_INV_PROTO);
-		add_l4proto(r, cs->fw6.ipv6.proto, op);
+		add_l4proto(h, r, cs->fw6.ipv6.proto, op);
 	}
 
 	if (!IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.src) ||
 	    !IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.smsk) ||
 	    (cs->fw6.ipv6.invflags & IPT_INV_SRCIP)) {
 		op = nft_invflags2cmp(cs->fw6.ipv6.invflags, IPT_INV_SRCIP);
-		add_addr(r, NFT_PAYLOAD_NETWORK_HEADER,
+		add_addr(h, r, NFT_PAYLOAD_NETWORK_HEADER,
 			 offsetof(struct ip6_hdr, ip6_src),
 			 &cs->fw6.ipv6.src, &cs->fw6.ipv6.smsk,
 			 sizeof(struct in6_addr), op);
@@ -60,7 +60,7 @@ static int nft_ipv6_add(struct nft_handle *h, struct nftnl_rule *r,
 	    !IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.dmsk) ||
 	    (cs->fw6.ipv6.invflags & IPT_INV_DSTIP)) {
 		op = nft_invflags2cmp(cs->fw6.ipv6.invflags, IPT_INV_DSTIP);
-		add_addr(r, NFT_PAYLOAD_NETWORK_HEADER,
+		add_addr(h, r, NFT_PAYLOAD_NETWORK_HEADER,
 			 offsetof(struct ip6_hdr, ip6_dst),
 			 &cs->fw6.ipv6.dst, &cs->fw6.ipv6.dmsk,
 			 sizeof(struct in6_addr), op);
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 54a911801639..52821684445b 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -40,7 +40,7 @@ extern struct nft_family_ops nft_family_ops_ipv6;
 extern struct nft_family_ops nft_family_ops_arp;
 extern struct nft_family_ops nft_family_ops_bridge;
 
-void add_meta(struct nftnl_rule *r, uint32_t key)
+void add_meta(struct nft_handle *h, struct nftnl_rule *r, uint32_t key)
 {
 	struct nftnl_expr *expr;
 
@@ -54,7 +54,8 @@ void add_meta(struct nftnl_rule *r, uint32_t key)
 	nftnl_rule_add_expr(r, expr);
 }
 
-void add_payload(struct nftnl_rule *r, int offset, int len, uint32_t base)
+void add_payload(struct nft_handle *h, struct nftnl_rule *r,
+		 int offset, int len, uint32_t base)
 {
 	struct nftnl_expr *expr;
 
@@ -136,13 +137,14 @@ void add_cmp_u32(struct nftnl_rule *r, uint32_t val, uint32_t op)
 	add_cmp_ptr(r, op, &val, sizeof(val));
 }
 
-void add_iniface(struct nftnl_rule *r, char *iface, uint32_t op)
+void add_iniface(struct nft_handle *h, struct nftnl_rule *r,
+		 char *iface, uint32_t op)
 {
 	int iface_len;
 
 	iface_len = strlen(iface);
 
-	add_meta(r, NFT_META_IIFNAME);
+	add_meta(h, r, NFT_META_IIFNAME);
 	if (iface[iface_len - 1] == '+') {
 		if (iface_len > 1)
 			add_cmp_ptr(r, op, iface, iface_len - 1);
@@ -150,13 +152,14 @@ void add_iniface(struct nftnl_rule *r, char *iface, uint32_t op)
 		add_cmp_ptr(r, op, iface, iface_len + 1);
 }
 
-void add_outiface(struct nftnl_rule *r, char *iface, uint32_t op)
+void add_outiface(struct nft_handle *h, struct nftnl_rule *r,
+		  char *iface, uint32_t op)
 {
 	int iface_len;
 
 	iface_len = strlen(iface);
 
-	add_meta(r, NFT_META_OIFNAME);
+	add_meta(h, r, NFT_META_OIFNAME);
 	if (iface[iface_len - 1] == '+') {
 		if (iface_len > 1)
 			add_cmp_ptr(r, op, iface, iface_len - 1);
@@ -164,7 +167,8 @@ void add_outiface(struct nftnl_rule *r, char *iface, uint32_t op)
 		add_cmp_ptr(r, op, iface, iface_len + 1);
 }
 
-void add_addr(struct nftnl_rule *r, enum nft_payload_bases base, int offset,
+void add_addr(struct nft_handle *h, struct nftnl_rule *r,
+	      enum nft_payload_bases base, int offset,
 	      void *data, void *mask, size_t len, uint32_t op)
 {
 	const unsigned char *m = mask;
@@ -183,7 +187,7 @@ void add_addr(struct nftnl_rule *r, enum nft_payload_bases base, int offset,
 	if (!bitwise)
 		len = i;
 
-	add_payload(r, offset, len, base);
+	add_payload(h, r, offset, len, base);
 
 	if (bitwise)
 		add_bitwise(r, mask, len);
@@ -191,16 +195,17 @@ void add_addr(struct nftnl_rule *r, enum nft_payload_bases base, int offset,
 	add_cmp_ptr(r, op, data, len);
 }
 
-void add_proto(struct nftnl_rule *r, int offset, size_t len,
-	       uint8_t proto, uint32_t op)
+void add_proto(struct nft_handle *h, struct nftnl_rule *r,
+	       int offset, size_t len, uint8_t proto, uint32_t op)
 {
-	add_payload(r, offset, len, NFT_PAYLOAD_NETWORK_HEADER);
+	add_payload(h, r, offset, len, NFT_PAYLOAD_NETWORK_HEADER);
 	add_cmp_u8(r, proto, op);
 }
 
-void add_l4proto(struct nftnl_rule *r, uint8_t proto, uint32_t op)
+void add_l4proto(struct nft_handle *h, struct nftnl_rule *r,
+		 uint8_t proto, uint32_t op)
 {
-	add_meta(r, NFT_META_L4PROTO);
+	add_meta(h, r, NFT_META_L4PROTO);
 	add_cmp_u8(r, proto, op);
 }
 
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 092958cd67fa..0bdb6848d853 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -132,21 +132,21 @@ struct nft_family_ops {
 			     int rulenum);
 };
 
-void add_meta(struct nftnl_rule *r, uint32_t key);
-void add_payload(struct nftnl_rule *r, int offset, int len, uint32_t base);
+void add_meta(struct nft_handle *h, struct nftnl_rule *r, uint32_t key);
+void add_payload(struct nft_handle *h, struct nftnl_rule *r, int offset, int len, uint32_t base);
 void add_bitwise(struct nftnl_rule *r, uint8_t *mask, size_t len);
 void add_bitwise_u16(struct nftnl_rule *r, uint16_t mask, uint16_t xor);
 void add_cmp_ptr(struct nftnl_rule *r, uint32_t op, void *data, size_t len);
 void add_cmp_u8(struct nftnl_rule *r, uint8_t val, uint32_t op);
 void add_cmp_u16(struct nftnl_rule *r, uint16_t val, uint32_t op);
 void add_cmp_u32(struct nftnl_rule *r, uint32_t val, uint32_t op);
-void add_iniface(struct nftnl_rule *r, char *iface, uint32_t op);
-void add_outiface(struct nftnl_rule *r, char *iface, uint32_t op);
-void add_addr(struct nftnl_rule *r, enum nft_payload_bases base, int offset,
+void add_iniface(struct nft_handle *h, struct nftnl_rule *r, char *iface, uint32_t op);
+void add_outiface(struct nft_handle *h, struct nftnl_rule *r, char *iface, uint32_t op);
+void add_addr(struct nft_handle *h, struct nftnl_rule *r, enum nft_payload_bases base, int offset,
 	      void *data, void *mask, size_t len, uint32_t op);
-void add_proto(struct nftnl_rule *r, int offset, size_t len,
+void add_proto(struct nft_handle *h, struct nftnl_rule *r, int offset, size_t len,
 	       uint8_t proto, uint32_t op);
-void add_l4proto(struct nftnl_rule *r, uint8_t proto, uint32_t op);
+void add_l4proto(struct nft_handle *h, struct nftnl_rule *r, uint8_t proto, uint32_t op);
 void add_compat(struct nftnl_rule *r, uint32_t proto, bool inv);
 
 bool is_same_interfaces(const char *a_iniface, const char *a_outiface,
diff --git a/iptables/nft.c b/iptables/nft.c
index a629aeff98b0..987b3c957b98 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1216,7 +1216,7 @@ static int add_nft_among(struct nft_handle *h,
 	    (data->dst.cnt && data->dst.ip)) {
 		uint16_t eth_p_ip = htons(ETH_P_IP);
 
-		add_meta(r, NFT_META_PROTOCOL);
+		add_meta(h, r, NFT_META_PROTOCOL);
 		add_cmp_ptr(r, NFT_CMP_EQ, &eth_p_ip, 2);
 	}
 
@@ -1263,11 +1263,9 @@ static int expr_gen_range_cmp16(struct nftnl_rule *r,
 	return 0;
 }
 
-static int add_nft_tcpudp(struct nftnl_rule *r,
-			  uint16_t src[2],
-			  bool invert_src,
-			  uint16_t dst[2],
-			  bool invert_dst)
+static int add_nft_tcpudp(struct nft_handle *h,struct nftnl_rule *r,
+			  uint16_t src[2], bool invert_src,
+			  uint16_t dst[2], bool invert_dst)
 {
 	struct nftnl_expr *expr;
 	uint8_t op = NFT_CMP_EQ;
@@ -1332,7 +1330,8 @@ static bool udp_all_zero(const struct xt_udp *u)
 	return memcmp(u, &zero, sizeof(*u)) == 0;
 }
 
-static int add_nft_udp(struct nftnl_rule *r, struct xt_entry_match *m)
+static int add_nft_udp(struct nft_handle *h, struct nftnl_rule *r,
+		       struct xt_entry_match *m)
 {
 	struct xt_udp *udp = (void *)m->data;
 
@@ -1346,7 +1345,7 @@ static int add_nft_udp(struct nftnl_rule *r, struct xt_entry_match *m)
 		return ret;
 	}
 
-	return add_nft_tcpudp(r, udp->spts, udp->invflags & XT_UDP_INV_SRCPT,
+	return add_nft_tcpudp(h, r, udp->spts, udp->invflags & XT_UDP_INV_SRCPT,
 			      udp->dpts, udp->invflags & XT_UDP_INV_DSTPT);
 }
 
@@ -1380,7 +1379,8 @@ static bool tcp_all_zero(const struct xt_tcp *t)
 	return memcmp(t, &zero, sizeof(*t)) == 0;
 }
 
-static int add_nft_tcp(struct nftnl_rule *r, struct xt_entry_match *m)
+static int add_nft_tcp(struct nft_handle *h, struct nftnl_rule *r,
+		       struct xt_entry_match *m)
 {
 	static const uint8_t supported = XT_TCP_INV_SRCPT | XT_TCP_INV_DSTPT | XT_TCP_INV_FLAGS;
 	struct xt_tcp *tcp = (void *)m->data;
@@ -1403,7 +1403,7 @@ static int add_nft_tcp(struct nftnl_rule *r, struct xt_entry_match *m)
 			return ret;
 	}
 
-	return add_nft_tcpudp(r, tcp->spts, tcp->invflags & XT_TCP_INV_SRCPT,
+	return add_nft_tcpudp(h, r, tcp->spts, tcp->invflags & XT_TCP_INV_SRCPT,
 			      tcp->dpts, tcp->invflags & XT_TCP_INV_DSTPT);
 }
 
@@ -1413,7 +1413,7 @@ static int add_nft_mark(struct nft_handle *h, struct nftnl_rule *r,
 	struct xt_mark_mtinfo1 *mark = (void *)m->data;
 	int op;
 
-	add_meta(r, NFT_META_MARK);
+	add_meta(h, r, NFT_META_MARK);
 	if (mark->mask != 0xffffffff)
 		add_bitwise(r, (uint8_t *)&mark->mask, sizeof(uint32_t));
 
@@ -1438,9 +1438,9 @@ int add_match(struct nft_handle *h,
 	else if (!strcmp(m->u.user.name, "among"))
 		return add_nft_among(h, r, m);
 	else if (!strcmp(m->u.user.name, "udp"))
-		return add_nft_udp(r, m);
+		return add_nft_udp(h, r, m);
 	else if (!strcmp(m->u.user.name, "tcp"))
-		return add_nft_tcp(r, m);
+		return add_nft_tcp(h, r, m);
 	else if (!strcmp(m->u.user.name, "mark"))
 		return add_nft_mark(h, r, m);
 
-- 
2.30.2

