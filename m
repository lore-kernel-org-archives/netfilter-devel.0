Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8404EC4167B
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Apr 2022 21:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239698AbiDXV72 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Apr 2022 17:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239697AbiDXV71 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Apr 2022 17:59:27 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E53B393E6
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Apr 2022 14:56:25 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables 5/7] nft: prepare for dynamic register allocation
Date:   Sun, 24 Apr 2022 23:56:11 +0200
Message-Id: <20220424215613.106165-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220424215613.106165-1-pablo@netfilter.org>
References: <20220424215613.106165-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Store the register that has been allocated and pass it on to the next
expression. NFT_REG_1 is still used.

No functional changes are expected.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-arp.c    | 18 +++++---
 iptables/nft-bridge.c | 20 +++++----
 iptables/nft-ipv4.c   |  8 ++--
 iptables/nft-shared.c | 99 ++++++++++++++++++++++++++-----------------
 iptables/nft-shared.h | 16 +++----
 iptables/nft.c        | 70 ++++++++++++++++--------------
 6 files changed, 137 insertions(+), 94 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 8c5ce3525dd5..65bd965eb69f 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -73,18 +73,22 @@ static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r,
 
 	if (fw->arp.arhrd != 0 ||
 	    fw->arp.invflags & IPT_INV_ARPHRD) {
+		uint8_t reg;
+
 		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_ARPHRD);
 		add_payload(h, r, offsetof(struct arphdr, ar_hrd), 2,
-			    NFT_PAYLOAD_NETWORK_HEADER);
-		add_cmp_u16(r, fw->arp.arhrd, op);
+			    NFT_PAYLOAD_NETWORK_HEADER, &reg);
+		add_cmp_u16(r, fw->arp.arhrd, op, reg);
 	}
 
 	if (fw->arp.arpro != 0 ||
 	    fw->arp.invflags & IPT_INV_PROTO) {
+		uint8_t reg;
+
 		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_PROTO);
 	        add_payload(h, r, offsetof(struct arphdr, ar_pro), 2,
-			    NFT_PAYLOAD_NETWORK_HEADER);
-		add_cmp_u16(r, fw->arp.arpro, op);
+			    NFT_PAYLOAD_NETWORK_HEADER, &reg);
+		add_cmp_u16(r, fw->arp.arpro, op, reg);
 	}
 
 	if (fw->arp.arhln != 0 ||
@@ -98,10 +102,12 @@ static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r,
 
 	if (fw->arp.arpop != 0 ||
 	    fw->arp.invflags & IPT_INV_ARPOP) {
+		uint8_t reg;
+
 		op = nft_invflags2cmp(fw->arp.invflags, IPT_INV_ARPOP);
 		add_payload(h, r, offsetof(struct arphdr, ar_op), 2,
-			    NFT_PAYLOAD_NETWORK_HEADER);
-		add_cmp_u16(r, fw->arp.arpop, op);
+			    NFT_PAYLOAD_NETWORK_HEADER, &reg);
+		add_cmp_u16(r, fw->arp.arpop, op, reg);
 	}
 
 	if (need_devaddr(&fw->arp.src_devaddr)) {
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 888d4b6baa57..106bcc72889f 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -69,28 +69,30 @@ static void add_logical_iniface(struct nft_handle *h, struct nftnl_rule *r,
 				char *iface, uint32_t op)
 {
 	int iface_len;
+	uint8_t reg;
 
 	iface_len = strlen(iface);
 
-	add_meta(h, r, NFT_META_BRI_IIFNAME);
+	add_meta(h, r, NFT_META_BRI_IIFNAME, &reg);
 	if (iface[iface_len - 1] == '+')
-		add_cmp_ptr(r, op, iface, iface_len - 1);
+		add_cmp_ptr(r, op, iface, iface_len - 1, reg);
 	else
-		add_cmp_ptr(r, op, iface, iface_len + 1);
+		add_cmp_ptr(r, op, iface, iface_len + 1, reg);
 }
 
 static void add_logical_outiface(struct nft_handle *h, struct nftnl_rule *r,
 				 char *iface, uint32_t op)
 {
 	int iface_len;
+	uint8_t reg;
 
 	iface_len = strlen(iface);
 
-	add_meta(h, r, NFT_META_BRI_OIFNAME);
+	add_meta(h, r, NFT_META_BRI_OIFNAME, &reg);
 	if (iface[iface_len - 1] == '+')
-		add_cmp_ptr(r, op, iface, iface_len - 1);
+		add_cmp_ptr(r, op, iface, iface_len - 1, reg);
 	else
-		add_cmp_ptr(r, op, iface, iface_len + 1);
+		add_cmp_ptr(r, op, iface, iface_len + 1, reg);
 }
 
 static int _add_action(struct nftnl_rule *r, struct iptables_command_state *cs)
@@ -141,10 +143,12 @@ static int nft_bridge_add(struct nft_handle *h,
 	}
 
 	if ((fw->bitmask & EBT_NOPROTO) == 0) {
+		uint8_t reg;
+
 		op = nft_invflags2cmp(fw->invflags, EBT_IPROTO);
 		add_payload(h, r, offsetof(struct ethhdr, h_proto), 2,
-			    NFT_PAYLOAD_LL_HEADER);
-		add_cmp_u16(r, fw->ethproto, op);
+			    NFT_PAYLOAD_LL_HEADER, &reg);
+		add_cmp_u16(r, fw->ethproto, op, reg);
 	}
 
 	add_compat(r, fw->ethproto, fw->invflags & EBT_IPROTO);
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 76a0e0de378c..59c4a41f1a05 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -63,17 +63,19 @@ static int nft_ipv4_add(struct nft_handle *h, struct nftnl_rule *r,
 			 sizeof(struct in_addr), op);
 	}
 	if (cs->fw.ip.flags & IPT_F_FRAG) {
+		uint8_t reg;
+
 		add_payload(h, r, offsetof(struct iphdr, frag_off), 2,
-			    NFT_PAYLOAD_NETWORK_HEADER);
+			    NFT_PAYLOAD_NETWORK_HEADER, &reg);
 		/* get the 13 bits that contain the fragment offset */
-		add_bitwise_u16(r, htons(0x1fff), 0);
+		add_bitwise_u16(h, r, htons(0x1fff), 0, reg, &reg);
 
 		/* if offset is non-zero, this is a fragment */
 		op = NFT_CMP_NEQ;
 		if (cs->fw.ip.invflags & IPT_INV_FRAG)
 			op = NFT_CMP_EQ;
 
-		add_cmp_u16(r, 0, op);
+		add_cmp_u16(r, 0, op, reg);
 	}
 
 	add_compat(r, cs->fw.ip.proto, cs->fw.ip.invflags & XT_INV_PROTO);
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 52821684445b..27e95c1ae4f3 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -40,74 +40,89 @@ extern struct nft_family_ops nft_family_ops_ipv6;
 extern struct nft_family_ops nft_family_ops_arp;
 extern struct nft_family_ops nft_family_ops_bridge;
 
-void add_meta(struct nft_handle *h, struct nftnl_rule *r, uint32_t key)
+void add_meta(struct nft_handle *h, struct nftnl_rule *r, uint32_t key,
+	      uint8_t *dreg)
 {
 	struct nftnl_expr *expr;
+	uint8_t reg;
 
 	expr = nftnl_expr_alloc("meta");
 	if (expr == NULL)
 		return;
 
+	reg = NFT_REG_1;
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_META_KEY, key);
-	nftnl_expr_set_u32(expr, NFTNL_EXPR_META_DREG, NFT_REG_1);
-
+	nftnl_expr_set_u32(expr, NFTNL_EXPR_META_DREG, reg);
 	nftnl_rule_add_expr(r, expr);
+
+	*dreg = reg;
 }
 
 void add_payload(struct nft_handle *h, struct nftnl_rule *r,
-		 int offset, int len, uint32_t base)
+		 int offset, int len, uint32_t base, uint8_t *dreg)
 {
 	struct nftnl_expr *expr;
+	uint8_t reg;
 
 	expr = nftnl_expr_alloc("payload");
 	if (expr == NULL)
 		return;
 
+	reg = NFT_REG_1;
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_PAYLOAD_BASE, base);
-	nftnl_expr_set_u32(expr, NFTNL_EXPR_PAYLOAD_DREG, NFT_REG_1);
+	nftnl_expr_set_u32(expr, NFTNL_EXPR_PAYLOAD_DREG, reg);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_PAYLOAD_OFFSET, offset);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_PAYLOAD_LEN, len);
-
 	nftnl_rule_add_expr(r, expr);
+
+	*dreg = reg;
 }
 
 /* bitwise operation is = sreg & mask ^ xor */
-void add_bitwise_u16(struct nftnl_rule *r, uint16_t mask, uint16_t xor)
+void add_bitwise_u16(struct nft_handle *h, struct nftnl_rule *r,
+		     uint16_t mask, uint16_t xor, uint8_t sreg, uint8_t *dreg)
 {
 	struct nftnl_expr *expr;
+	uint8_t reg;
 
 	expr = nftnl_expr_alloc("bitwise");
 	if (expr == NULL)
 		return;
 
-	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_SREG, NFT_REG_1);
-	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_DREG, NFT_REG_1);
+	reg = NFT_REG_1;
+	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_SREG, sreg);
+	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_DREG, reg);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_LEN, sizeof(uint16_t));
 	nftnl_expr_set(expr, NFTNL_EXPR_BITWISE_MASK, &mask, sizeof(uint16_t));
 	nftnl_expr_set(expr, NFTNL_EXPR_BITWISE_XOR, &xor, sizeof(uint16_t));
-
 	nftnl_rule_add_expr(r, expr);
+
+	*dreg = reg;
 }
 
-void add_bitwise(struct nftnl_rule *r, uint8_t *mask, size_t len)
+void add_bitwise(struct nft_handle *h, struct nftnl_rule *r,
+		 uint8_t *mask, size_t len, uint8_t sreg, uint8_t *dreg)
 {
 	struct nftnl_expr *expr;
 	uint32_t xor[4] = { 0 };
+	uint8_t reg = *dreg;
 
 	expr = nftnl_expr_alloc("bitwise");
 	if (expr == NULL)
 		return;
 
-	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_SREG, NFT_REG_1);
-	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_DREG, NFT_REG_1);
+	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_SREG, sreg);
+	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_DREG, reg);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_BITWISE_LEN, len);
 	nftnl_expr_set(expr, NFTNL_EXPR_BITWISE_MASK, mask, len);
 	nftnl_expr_set(expr, NFTNL_EXPR_BITWISE_XOR, &xor, len);
-
 	nftnl_rule_add_expr(r, expr);
+
+	*dreg = reg;
 }
 
-void add_cmp_ptr(struct nftnl_rule *r, uint32_t op, void *data, size_t len)
+void add_cmp_ptr(struct nftnl_rule *r, uint32_t op, void *data, size_t len,
+		 uint8_t sreg)
 {
 	struct nftnl_expr *expr;
 
@@ -115,56 +130,59 @@ void add_cmp_ptr(struct nftnl_rule *r, uint32_t op, void *data, size_t len)
 	if (expr == NULL)
 		return;
 
-	nftnl_expr_set_u32(expr, NFTNL_EXPR_CMP_SREG, NFT_REG_1);
+	nftnl_expr_set_u32(expr, NFTNL_EXPR_CMP_SREG, sreg);
 	nftnl_expr_set_u32(expr, NFTNL_EXPR_CMP_OP, op);
 	nftnl_expr_set(expr, NFTNL_EXPR_CMP_DATA, data, len);
-
 	nftnl_rule_add_expr(r, expr);
 }
 
-void add_cmp_u8(struct nftnl_rule *r, uint8_t val, uint32_t op)
+void add_cmp_u8(struct nftnl_rule *r, uint8_t val, uint32_t op, uint8_t sreg)
 {
-	add_cmp_ptr(r, op, &val, sizeof(val));
+	add_cmp_ptr(r, op, &val, sizeof(val), sreg);
 }
 
-void add_cmp_u16(struct nftnl_rule *r, uint16_t val, uint32_t op)
+void add_cmp_u16(struct nftnl_rule *r, uint16_t val, uint32_t op, uint8_t sreg)
 {
-	add_cmp_ptr(r, op, &val, sizeof(val));
+	add_cmp_ptr(r, op, &val, sizeof(val), sreg);
 }
 
-void add_cmp_u32(struct nftnl_rule *r, uint32_t val, uint32_t op)
+void add_cmp_u32(struct nftnl_rule *r, uint32_t val, uint32_t op, uint8_t sreg)
 {
-	add_cmp_ptr(r, op, &val, sizeof(val));
+	add_cmp_ptr(r, op, &val, sizeof(val), sreg);
 }
 
 void add_iniface(struct nft_handle *h, struct nftnl_rule *r,
 		 char *iface, uint32_t op)
 {
 	int iface_len;
+	uint8_t reg;
 
 	iface_len = strlen(iface);
 
-	add_meta(h, r, NFT_META_IIFNAME);
+	add_meta(h, r, NFT_META_IIFNAME, &reg);
 	if (iface[iface_len - 1] == '+') {
 		if (iface_len > 1)
-			add_cmp_ptr(r, op, iface, iface_len - 1);
-	} else
-		add_cmp_ptr(r, op, iface, iface_len + 1);
+			add_cmp_ptr(r, op, iface, iface_len - 1, reg);
+	} else {
+		add_cmp_ptr(r, op, iface, iface_len + 1, reg);
+	}
 }
 
 void add_outiface(struct nft_handle *h, struct nftnl_rule *r,
 		  char *iface, uint32_t op)
 {
 	int iface_len;
+	uint8_t reg;
 
 	iface_len = strlen(iface);
 
-	add_meta(h, r, NFT_META_OIFNAME);
+	add_meta(h, r, NFT_META_OIFNAME, &reg);
 	if (iface[iface_len - 1] == '+') {
 		if (iface_len > 1)
-			add_cmp_ptr(r, op, iface, iface_len - 1);
-	} else
-		add_cmp_ptr(r, op, iface, iface_len + 1);
+			add_cmp_ptr(r, op, iface, iface_len - 1, reg);
+	} else {
+		add_cmp_ptr(r, op, iface, iface_len + 1, reg);
+	}
 }
 
 void add_addr(struct nft_handle *h, struct nftnl_rule *r,
@@ -173,6 +191,7 @@ void add_addr(struct nft_handle *h, struct nftnl_rule *r,
 {
 	const unsigned char *m = mask;
 	bool bitwise = false;
+	uint8_t reg;
 	int i, j;
 
 	for (i = 0; i < len; i++) {
@@ -187,26 +206,30 @@ void add_addr(struct nft_handle *h, struct nftnl_rule *r,
 	if (!bitwise)
 		len = i;
 
-	add_payload(h, r, offset, len, base);
+	add_payload(h, r, offset, len, base, &reg);
 
 	if (bitwise)
-		add_bitwise(r, mask, len);
+		add_bitwise(h, r, mask, len, reg, &reg);
 
-	add_cmp_ptr(r, op, data, len);
+	add_cmp_ptr(r, op, data, len, reg);
 }
 
 void add_proto(struct nft_handle *h, struct nftnl_rule *r,
 	       int offset, size_t len, uint8_t proto, uint32_t op)
 {
-	add_payload(h, r, offset, len, NFT_PAYLOAD_NETWORK_HEADER);
-	add_cmp_u8(r, proto, op);
+	uint8_t reg;
+
+	add_payload(h, r, offset, len, NFT_PAYLOAD_NETWORK_HEADER, &reg);
+	add_cmp_u8(r, proto, op, reg);
 }
 
 void add_l4proto(struct nft_handle *h, struct nftnl_rule *r,
 		 uint8_t proto, uint32_t op)
 {
-	add_meta(h, r, NFT_META_L4PROTO);
-	add_cmp_u8(r, proto, op);
+	uint8_t reg;
+
+	add_meta(h, r, NFT_META_L4PROTO, &reg);
+	add_cmp_u8(r, proto, op, reg);
 }
 
 bool is_same_interfaces(const char *a_iniface, const char *a_outiface,
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 0bdb6848d853..b04049047116 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -132,14 +132,14 @@ struct nft_family_ops {
 			     int rulenum);
 };
 
-void add_meta(struct nft_handle *h, struct nftnl_rule *r, uint32_t key);
-void add_payload(struct nft_handle *h, struct nftnl_rule *r, int offset, int len, uint32_t base);
-void add_bitwise(struct nftnl_rule *r, uint8_t *mask, size_t len);
-void add_bitwise_u16(struct nftnl_rule *r, uint16_t mask, uint16_t xor);
-void add_cmp_ptr(struct nftnl_rule *r, uint32_t op, void *data, size_t len);
-void add_cmp_u8(struct nftnl_rule *r, uint8_t val, uint32_t op);
-void add_cmp_u16(struct nftnl_rule *r, uint16_t val, uint32_t op);
-void add_cmp_u32(struct nftnl_rule *r, uint32_t val, uint32_t op);
+void add_meta(struct nft_handle *h, struct nftnl_rule *r, uint32_t key, uint8_t *dreg);
+void add_payload(struct nft_handle *h, struct nftnl_rule *r, int offset, int len, uint32_t base, uint8_t *dreg);
+void add_bitwise(struct nft_handle *h, struct nftnl_rule *r, uint8_t *mask, size_t len, uint8_t sreg, uint8_t *dreg);
+void add_bitwise_u16(struct nft_handle *h, struct nftnl_rule *r, uint16_t mask, uint16_t xor, uint8_t sreg, uint8_t *dreg);
+void add_cmp_ptr(struct nftnl_rule *r, uint32_t op, void *data, size_t len, uint8_t sreg);
+void add_cmp_u8(struct nftnl_rule *r, uint8_t val, uint32_t op, uint8_t sreg);
+void add_cmp_u16(struct nftnl_rule *r, uint16_t val, uint32_t op, uint8_t sreg);
+void add_cmp_u32(struct nftnl_rule *r, uint32_t val, uint32_t op, uint8_t sreg);
 void add_iniface(struct nft_handle *h, struct nftnl_rule *r, char *iface, uint32_t op);
 void add_outiface(struct nft_handle *h, struct nftnl_rule *r, char *iface, uint32_t op);
 void add_addr(struct nft_handle *h, struct nftnl_rule *r, enum nft_payload_bases base, int offset,
diff --git a/iptables/nft.c b/iptables/nft.c
index 987b3c957b98..bdfef0244b38 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1090,16 +1090,22 @@ static struct nftnl_set *add_anon_set(struct nft_handle *h, const char *table,
 }
 
 static struct nftnl_expr *
-gen_payload(uint32_t base, uint32_t offset, uint32_t len, uint32_t dreg)
+gen_payload(struct nft_handle *h, uint32_t base, uint32_t offset, uint32_t len,
+	    uint8_t *dreg)
 {
 	struct nftnl_expr *e = nftnl_expr_alloc("payload");
+	uint8_t reg;
 
 	if (!e)
 		return NULL;
+
+	reg = NFT_REG_1;
 	nftnl_expr_set_u32(e, NFTNL_EXPR_PAYLOAD_BASE, base);
 	nftnl_expr_set_u32(e, NFTNL_EXPR_PAYLOAD_OFFSET, offset);
 	nftnl_expr_set_u32(e, NFTNL_EXPR_PAYLOAD_LEN, len);
-	nftnl_expr_set_u32(e, NFTNL_EXPR_PAYLOAD_DREG, dreg);
+	nftnl_expr_set_u32(e, NFTNL_EXPR_PAYLOAD_DREG, reg);
+	*dreg = reg;
+
 	return e;
 }
 
@@ -1144,6 +1150,7 @@ static int __add_nft_among(struct nft_handle *h, const char *table,
 	struct nftnl_expr *e;
 	struct nftnl_set *s;
 	uint32_t flags = 0;
+	uint8_t reg;
 	int idx = 0;
 
 	if (ip) {
@@ -1184,21 +1191,22 @@ static int __add_nft_among(struct nft_handle *h, const char *table,
 		nftnl_set_elem_add(s, elem);
 	}
 
-	e = gen_payload(NFT_PAYLOAD_LL_HEADER,
-			eth_addr_off[dst], ETH_ALEN, NFT_REG_1);
+	e = gen_payload(h, NFT_PAYLOAD_LL_HEADER,
+			eth_addr_off[dst], ETH_ALEN, &reg);
 	if (!e)
 		return -ENOMEM;
 	nftnl_rule_add_expr(r, e);
 
 	if (ip) {
-		e = gen_payload(NFT_PAYLOAD_NETWORK_HEADER, ip_addr_off[dst],
-				sizeof(struct in_addr), NFT_REG32_02);
+		e = gen_payload(h, NFT_PAYLOAD_NETWORK_HEADER, ip_addr_off[dst],
+				sizeof(struct in_addr), &reg);
 		if (!e)
 			return -ENOMEM;
 		nftnl_rule_add_expr(r, e);
 	}
 
-	e = gen_lookup(NFT_REG_1, "__set%d", set_id, inv);
+	reg = NFT_REG_1;
+	e = gen_lookup(reg, "__set%d", set_id, inv);
 	if (!e)
 		return -ENOMEM;
 	nftnl_rule_add_expr(r, e);
@@ -1215,9 +1223,10 @@ static int add_nft_among(struct nft_handle *h,
 	if ((data->src.cnt && data->src.ip) ||
 	    (data->dst.cnt && data->dst.ip)) {
 		uint16_t eth_p_ip = htons(ETH_P_IP);
+		uint8_t reg;
 
-		add_meta(h, r, NFT_META_PROTOCOL);
-		add_cmp_ptr(r, NFT_CMP_EQ, &eth_p_ip, 2);
+		add_meta(h, r, NFT_META_PROTOCOL, &reg);
+		add_cmp_ptr(r, NFT_CMP_EQ, &eth_p_ip, 2, reg);
 	}
 
 	if (data->src.cnt)
@@ -1233,17 +1242,17 @@ static int add_nft_among(struct nft_handle *h,
 static int expr_gen_range_cmp16(struct nftnl_rule *r,
 				uint16_t lo,
 				uint16_t hi,
-				bool invert)
+				bool invert, uint8_t reg)
 {
 	struct nftnl_expr *e;
 
 	if (lo == hi) {
-		add_cmp_u16(r, htons(lo), invert ? NFT_CMP_NEQ : NFT_CMP_EQ);
+		add_cmp_u16(r, htons(lo), invert ? NFT_CMP_NEQ : NFT_CMP_EQ, reg);
 		return 0;
 	}
 
 	if (lo == 0 && hi < 0xffff) {
-		add_cmp_u16(r, htons(hi) , invert ? NFT_CMP_GT : NFT_CMP_LTE);
+		add_cmp_u16(r, htons(hi) , invert ? NFT_CMP_GT : NFT_CMP_LTE, reg);
 		return 0;
 	}
 
@@ -1251,7 +1260,7 @@ static int expr_gen_range_cmp16(struct nftnl_rule *r,
 	if (!e)
 		return -ENOMEM;
 
-	nftnl_expr_set_u32(e, NFTNL_EXPR_RANGE_SREG, NFT_REG_1);
+	nftnl_expr_set_u32(e, NFTNL_EXPR_RANGE_SREG, reg);
 	nftnl_expr_set_u32(e, NFTNL_EXPR_RANGE_OP, invert ? NFT_RANGE_NEQ : NFT_RANGE_EQ);
 
 	lo = htons(lo);
@@ -1269,6 +1278,7 @@ static int add_nft_tcpudp(struct nft_handle *h,struct nftnl_rule *r,
 {
 	struct nftnl_expr *expr;
 	uint8_t op = NFT_CMP_EQ;
+	uint8_t reg;
 	int ret;
 
 	if (src[0] && src[0] == src[1] &&
@@ -1279,36 +1289,33 @@ static int add_nft_tcpudp(struct nft_handle *h,struct nftnl_rule *r,
 		if (invert_src)
 			op = NFT_CMP_NEQ;
 
-		expr = gen_payload(NFT_PAYLOAD_TRANSPORT_HEADER, 0, 4,
-				   NFT_REG_1);
+		expr = gen_payload(h, NFT_PAYLOAD_TRANSPORT_HEADER, 0, 4, &reg);
 		if (!expr)
 			return -ENOMEM;
 
 		nftnl_rule_add_expr(r, expr);
-		add_cmp_u32(r, htonl(combined), op);
+		add_cmp_u32(r, htonl(combined), op, reg);
 		return 0;
 	}
 
 	if (src[0] || src[1] < 0xffff) {
-		expr = gen_payload(NFT_PAYLOAD_TRANSPORT_HEADER,
-				   0, 2, NFT_REG_1);
+		expr = gen_payload(h, NFT_PAYLOAD_TRANSPORT_HEADER, 0, 2, &reg);
 		if (!expr)
 			return -ENOMEM;
 
 		nftnl_rule_add_expr(r, expr);
-		ret = expr_gen_range_cmp16(r, src[0], src[1], invert_src);
+		ret = expr_gen_range_cmp16(r, src[0], src[1], invert_src, reg);
 		if (ret)
 			return ret;
 	}
 
 	if (dst[0] || dst[1] < 0xffff) {
-		expr = gen_payload(NFT_PAYLOAD_TRANSPORT_HEADER,
-				   2, 2, NFT_REG_1);
+		expr = gen_payload(h, NFT_PAYLOAD_TRANSPORT_HEADER, 2, 2, &reg);
 		if (!expr)
 			return -ENOMEM;
 
 		nftnl_rule_add_expr(r, expr);
-		ret = expr_gen_range_cmp16(r, dst[0], dst[1], invert_dst);
+		ret = expr_gen_range_cmp16(r, dst[0], dst[1], invert_dst, reg);
 		if (ret)
 			return ret;
 	}
@@ -1349,22 +1356,22 @@ static int add_nft_udp(struct nft_handle *h, struct nftnl_rule *r,
 			      udp->dpts, udp->invflags & XT_UDP_INV_DSTPT);
 }
 
-static int add_nft_tcpflags(struct nftnl_rule *r,
+static int add_nft_tcpflags(struct nft_handle *h, struct nftnl_rule *r,
 			    uint8_t cmp, uint8_t mask,
 			    bool invert)
 {
 	struct nftnl_expr *e;
+	uint8_t reg;
 
-	e = gen_payload(NFT_PAYLOAD_TRANSPORT_HEADER,
-			13, 1, NFT_REG_1);
+	e = gen_payload(h, NFT_PAYLOAD_TRANSPORT_HEADER, 13, 1, &reg);
 
 	if (!e)
 		return -ENOMEM;
 
 	nftnl_rule_add_expr(r, e);
 
-	add_bitwise(r, &mask, 1);
-	add_cmp_u8(r, cmp, invert ? NFT_CMP_NEQ : NFT_CMP_EQ);
+	add_bitwise(h, r, &mask, 1, reg, &reg);
+	add_cmp_u8(r, cmp, invert ? NFT_CMP_NEQ : NFT_CMP_EQ, reg);
 
 	return 0;
 }
@@ -1396,7 +1403,7 @@ static int add_nft_tcp(struct nft_handle *h, struct nftnl_rule *r,
 	}
 
 	if (tcp->flg_mask) {
-		int ret = add_nft_tcpflags(r, tcp->flg_cmp, tcp->flg_mask,
+		int ret = add_nft_tcpflags(h, r, tcp->flg_cmp, tcp->flg_mask,
 					   tcp->invflags & XT_TCP_INV_FLAGS);
 
 		if (ret < 0)
@@ -1411,18 +1418,19 @@ static int add_nft_mark(struct nft_handle *h, struct nftnl_rule *r,
 			struct xt_entry_match *m)
 {
 	struct xt_mark_mtinfo1 *mark = (void *)m->data;
+	uint8_t reg;
 	int op;
 
-	add_meta(h, r, NFT_META_MARK);
+	add_meta(h, r, NFT_META_MARK, &reg);
 	if (mark->mask != 0xffffffff)
-		add_bitwise(r, (uint8_t *)&mark->mask, sizeof(uint32_t));
+		add_bitwise(h, r, (uint8_t *)&mark->mask, sizeof(uint32_t), reg, &reg);
 
 	if (mark->invert)
 		op = NFT_CMP_NEQ;
 	else
 		op = NFT_CMP_EQ;
 
-	add_cmp_u32(r, mark->mark, op);
+	add_cmp_u32(r, mark->mark, op, reg);
 
 	return 0;
 }
-- 
2.30.2

