From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat PATCH 6/7] ebtables-compat: fix nft payload bases
Date: Mon, 19 Jan 2015 14:28:02 +0100
Message-ID: <20150119132802.7422.13417.stgit@nfdev.cica.es>
References: <20150119132735.7422.85388.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:48781 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751811AbbASN2L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:28:11 -0500
In-Reply-To: <20150119132735.7422.85388.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ebtables should use NFT_PAYLOAD_LL_HEADER to fetch basic payload information
from packets in the bridge family.

Let's allow the add_payload() function to know in which base it should work.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/nft-arp.c    |   15 ++++++++++-----
 iptables/nft-bridge.c |    9 ++++++---
 iptables/nft-ipv4.c   |    3 ++-
 iptables/nft-shared.c |    9 ++++-----
 iptables/nft-shared.h |    2 +-
 5 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index b10b45f..24b31c5 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -156,13 +156,15 @@ static int nft_arp_add(struct nft_rule *r, void *data)
 
 	if (fw->arp.arhrd != 0) {
 		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_ARPHRD);
-		add_payload(r, offsetof(struct arphdr, ar_hrd), 2);
+		add_payload(r, offsetof(struct arphdr, ar_hrd), 2,
+			    NFT_PAYLOAD_NETWORK_HEADER);
 		add_cmp_u16(r, fw->arp.arhrd, op);
 	}
 
 	if (fw->arp.arpro != 0) {
 		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_ARPPRO);
-	        add_payload(r, offsetof(struct arphdr, ar_pro), 2);
+	        add_payload(r, offsetof(struct arphdr, ar_pro), 2,
+			    NFT_PAYLOAD_NETWORK_HEADER);
 		add_cmp_u16(r, fw->arp.arpro, op);
 	}
 
@@ -176,13 +178,15 @@ static int nft_arp_add(struct nft_rule *r, void *data)
 
 	if (fw->arp.arpop != 0) {
 		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_ARPOP);
-		add_payload(r, offsetof(struct arphdr, ar_op), 2);
+		add_payload(r, offsetof(struct arphdr, ar_op), 2,
+			    NFT_PAYLOAD_NETWORK_HEADER);
 		add_cmp_u16(r, fw->arp.arpop, op);
 	}
 
 	if (fw->arp.src_devaddr.addr[0] != '\0') {
 		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_SRCDEVADDR);
-		add_payload(r, sizeof(struct arphdr), fw->arp.arhln);
+		add_payload(r, sizeof(struct arphdr), fw->arp.arhln,
+			    NFT_PAYLOAD_NETWORK_HEADER);
 		add_cmp_ptr(r, op, fw->arp.src_devaddr.addr, fw->arp.arhln);
 	}
 
@@ -195,7 +199,8 @@ static int nft_arp_add(struct nft_rule *r, void *data)
 
 	if (fw->arp.tgt_devaddr.addr[0] != '\0') {
 		op = nft_invflags2cmp(fw->arp.invflags, ARPT_INV_TGTDEVADDR);
-		add_payload(r, sizeof(struct arphdr) + fw->arp.arhln + 4, fw->arp.arhln);
+		add_payload(r, sizeof(struct arphdr) + fw->arp.arhln + 4,
+			    fw->arp.arhln, NFT_PAYLOAD_NETWORK_HEADER);
 		add_cmp_ptr(r, op, fw->arp.tgt_devaddr.addr, fw->arp.arhln);
 	}
 
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 3ef1357..62aab04 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -167,20 +167,23 @@ static int nft_bridge_add(struct nft_rule *r, void *data)
 	addr = ether_ntoa((struct ether_addr *) fw->sourcemac);
 	if (strcmp(addr, "0:0:0:0:0:0") != 0) {
 		op = nft_invflags2cmp(fw->invflags, EBT_ISOURCE);
-		add_payload(r, offsetof(struct ethhdr, h_source), 6);
+		add_payload(r, offsetof(struct ethhdr, h_source), 6,
+			    NFT_PAYLOAD_LL_HEADER);
 		add_cmp_ptr(r, op, fw->sourcemac, 6);
 	}
 
 	addr = ether_ntoa((struct ether_addr *) fw->destmac);
 	if (strcmp(addr, "0:0:0:0:0:0") != 0) {
 		op = nft_invflags2cmp(fw->invflags, EBT_IDEST);
-		add_payload(r, offsetof(struct ethhdr, h_dest), 6);
+		add_payload(r, offsetof(struct ethhdr, h_dest), 6,
+			    NFT_PAYLOAD_LL_HEADER);
 		add_cmp_ptr(r, op, fw->destmac, 6);
 	}
 
 	if (fw->ethproto != 0) {
 		op = nft_invflags2cmp(fw->invflags, EBT_IPROTO);
-		add_payload(r, offsetof(struct ethhdr, h_proto), 2);
+		add_payload(r, offsetof(struct ethhdr, h_proto), 2,
+			    NFT_PAYLOAD_LL_HEADER);
 		add_cmp_u16(r, fw->ethproto, op);
 	}
 
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 1b0dc2a..ed30920 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -60,7 +60,8 @@ static int nft_ipv4_add(struct nft_rule *r, void *data)
 			 sizeof(struct in_addr), op);
 	}
 	if (cs->fw.ip.flags & IPT_F_FRAG) {
-		add_payload(r, offsetof(struct iphdr, frag_off), 2);
+		add_payload(r, offsetof(struct iphdr, frag_off), 2,
+			    NFT_PAYLOAD_NETWORK_HEADER);
 		/* get the 13 bits that contain the fragment offset */
 		add_bitwise_u16(r, 0x1fff, !0x1fff);
 
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index dd1dfca..76984e8 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -49,7 +49,7 @@ void add_meta(struct nft_rule *r, uint32_t key)
 	nft_rule_add_expr(r, expr);
 }
 
-void add_payload(struct nft_rule *r, int offset, int len)
+void add_payload(struct nft_rule *r, int offset, int len, uint32_t base)
 {
 	struct nft_rule_expr *expr;
 
@@ -57,8 +57,7 @@ void add_payload(struct nft_rule *r, int offset, int len)
 	if (expr == NULL)
 		return;
 
-	nft_rule_expr_set_u32(expr, NFT_EXPR_PAYLOAD_BASE,
-			      NFT_PAYLOAD_NETWORK_HEADER);
+	nft_rule_expr_set_u32(expr, NFT_EXPR_PAYLOAD_BASE, base);
 	nft_rule_expr_set_u32(expr, NFT_EXPR_PAYLOAD_DREG, NFT_REG_1);
 	nft_rule_expr_set_u32(expr, NFT_EXPR_PAYLOAD_OFFSET, offset);
 	nft_rule_expr_set_u32(expr, NFT_EXPR_PAYLOAD_LEN, len);
@@ -161,7 +160,7 @@ void add_outiface(struct nft_rule *r, char *iface, uint32_t op)
 void add_addr(struct nft_rule *r, int offset,
 	      void *data, void *mask, size_t len, uint32_t op)
 {
-	add_payload(r, offset, len);
+	add_payload(r, offset, len, NFT_PAYLOAD_NETWORK_HEADER);
 	add_bitwise(r, mask, len);
 
 	add_cmp_ptr(r, op, data, len);
@@ -170,7 +169,7 @@ void add_addr(struct nft_rule *r, int offset,
 void add_proto(struct nft_rule *r, int offset, size_t len,
 	       uint8_t proto, uint32_t op)
 {
-	add_payload(r, offset, len);
+	add_payload(r, offset, len, NFT_PAYLOAD_NETWORK_HEADER);
 	add_cmp_u8(r, proto, op);
 }
 
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index feef24f..33582aa 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -103,7 +103,7 @@ struct nft_family_ops {
 };
 
 void add_meta(struct nft_rule *r, uint32_t key);
-void add_payload(struct nft_rule *r, int offset, int len);
+void add_payload(struct nft_rule *r, int offset, int len, uint32_t base);
 void add_bitwise_u16(struct nft_rule *r, int mask, int xor);
 void add_cmp_ptr(struct nft_rule *r, uint32_t op, void *data, size_t len);
 void add_cmp_u8(struct nft_rule *r, uint8_t val, uint32_t op);

