From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat PATCH 1/2] nft-shared: rework inversion of matches
Date: Tue, 28 Oct 2014 19:32:59 +0100
Message-ID: <20141028183259.3948.15098.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:44365 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751390AbaJ1SdQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:33:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Previous to this patch, inversion of matches didn't work in ebtables-compat.

A way to solve this is to refactor the logic to calculate the proper NFT_CMP_*
operation, and let ebtables-compat to use this new logic.

With this patch, rules like this are correctly sent to the kernel:
 % ebtables-compat -A FORWARD -p ! 0x0800 -j ACCEPT

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/nft-bridge.c |   21 ++++++---------------
 iptables/nft-shared.c |   44 ++++++++++++++++++--------------------------
 iptables/nft-shared.h |    1 +
 3 files changed, 25 insertions(+), 41 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 0e21b46..70501ac 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -99,15 +99,10 @@ static uint16_t ipt_to_ebt_flags(uint8_t invflags)
 static void add_logical_iniface(struct nft_rule *r, char *iface, int invflags)
 {
 	int iface_len;
-	uint32_t op;
+	uint16_t op = invflags2cmp_op(invflags);
 
 	iface_len = strlen(iface);
 
-	if (invflags & EBT_ILOGICALIN)
-		op = NFT_CMP_NEQ;
-	else
-		op = NFT_CMP_EQ;
-
 	add_meta(r, NFT_META_BRI_IIFNAME);
 	if (iface[iface_len - 1] == '+')
 		add_cmp_ptr(r, op, iface, iface_len - 1);
@@ -118,15 +113,10 @@ static void add_logical_iniface(struct nft_rule *r, char *iface, int invflags)
 static void add_logical_outiface(struct nft_rule *r, char *iface, int invflags)
 {
 	int iface_len;
-	uint32_t op;
+	uint16_t op = invflags2cmp_op(invflags);
 
 	iface_len = strlen(iface);
 
-	if (invflags & EBT_ILOGICALOUT)
-		op = NFT_CMP_NEQ;
-	else
-		op = NFT_CMP_EQ;
-
 	add_meta(r, NFT_META_BRI_OIFNAME);
 	if (iface[iface_len - 1] == '+')
 		add_cmp_ptr(r, op, iface, iface_len - 1);
@@ -165,6 +155,7 @@ static int nft_bridge_add(struct nft_rule *r, void *data)
 	struct ebtables_command_state *cs = data;
 	struct ebt_entry *fw = &cs->fw;
 	uint8_t flags = ebt_to_ipt_flags(fw->invflags);
+	uint32_t op = invflags2cmp_op(flags);
 	char *addr;
 
 	if (fw->in[0] != '\0')
@@ -182,18 +173,18 @@ static int nft_bridge_add(struct nft_rule *r, void *data)
 	addr = ether_ntoa((struct ether_addr *) fw->sourcemac);
 	if (strcmp(addr, "0:0:0:0:0:0") != 0) {
 		add_payload(r, offsetof(struct ethhdr, h_source), 6);
-		add_cmp_ptr(r, NFT_CMP_EQ, fw->sourcemac, 6);
+		add_cmp_ptr(r, op, fw->sourcemac, 6);
 	}
 
 	addr = ether_ntoa((struct ether_addr *) fw->destmac);
 	if (strcmp(addr, "0:0:0:0:0:0") != 0) {
 		add_payload(r, offsetof(struct ethhdr, h_dest), 6);
-		add_cmp_ptr(r, NFT_CMP_EQ, fw->destmac, 6);
+		add_cmp_ptr(r, op, fw->destmac, 6);
 	}
 
 	if (fw->ethproto != 0) {
 		add_payload(r, offsetof(struct ethhdr, h_proto), 2);
-		add_cmp_u16(r, fw->ethproto, NFT_CMP_EQ);
+		add_cmp_u16(r, fw->ethproto, op);
 	}
 
 	return _add_action(r, cs);
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index d6f838c..2e6bf74 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -34,6 +34,20 @@ extern struct nft_family_ops nft_family_ops_ipv6;
 extern struct nft_family_ops nft_family_ops_arp;
 extern struct nft_family_ops nft_family_ops_bridge;
 
+uint16_t invflags2cmp_op(uint16_t invflags)
+{
+	if ((invflags & XT_INV_PROTO)
+	    || (invflags & IPT_INV_PROTO)
+	    || (invflags & IPT_INV_VIA_IN)
+	    || (invflags & IPT_INV_VIA_OUT)
+	    || (invflags & IPT_INV_SRCIP)
+	    || (invflags & IPT_INV_DSTIP)
+	    || (invflags & IPT_INV_FRAG))
+		return NFT_CMP_NEQ;
+
+	return NFT_CMP_EQ;
+}
+
 void add_meta(struct nft_rule *r, uint32_t key)
 {
 	struct nft_rule_expr *expr;
@@ -134,15 +148,10 @@ void add_cmp_u32(struct nft_rule *r, uint32_t val, uint32_t op)
 void add_iniface(struct nft_rule *r, char *iface, int invflags)
 {
 	int iface_len;
-	uint32_t op;
+	uint32_t op = invflags2cmp_op(invflags);
 
 	iface_len = strlen(iface);
 
-	if (invflags & IPT_INV_VIA_IN)
-		op = NFT_CMP_NEQ;
-	else
-		op = NFT_CMP_EQ;
-
 	add_meta(r, NFT_META_IIFNAME);
 	if (iface[iface_len - 1] == '+')
 		add_cmp_ptr(r, op, iface, iface_len - 1);
@@ -153,15 +162,10 @@ void add_iniface(struct nft_rule *r, char *iface, int invflags)
 void add_outiface(struct nft_rule *r, char *iface, int invflags)
 {
 	int iface_len;
-	uint32_t op;
+	uint32_t op = invflags2cmp_op(invflags);
 
 	iface_len = strlen(iface);
 
-	if (invflags & IPT_INV_VIA_OUT)
-		op = NFT_CMP_NEQ;
-	else
-		op = NFT_CMP_EQ;
-
 	add_meta(r, NFT_META_OIFNAME);
 	if (iface[iface_len - 1] == '+')
 		add_cmp_ptr(r, op, iface, iface_len - 1);
@@ -172,31 +176,19 @@ void add_outiface(struct nft_rule *r, char *iface, int invflags)
 void add_addr(struct nft_rule *r, int offset,
 	      void *data, void *mask, size_t len, int invflags)
 {
-	uint32_t op;
+	uint32_t op = invflags2cmp_op(invflags);
 
 	add_payload(r, offset, len);
 	add_bitwise(r, mask, len);
-
-	if (invflags & IPT_INV_SRCIP || invflags & IPT_INV_DSTIP)
-		op = NFT_CMP_NEQ;
-	else
-		op = NFT_CMP_EQ;
-
 	add_cmp_ptr(r, op, data, len);
 }
 
 void add_proto(struct nft_rule *r, int offset, size_t len,
 	       uint8_t proto, int invflags)
 {
-	uint32_t op;
+	uint32_t op = invflags2cmp_op(invflags);
 
 	add_payload(r, offset, len);
-
-	if (invflags & XT_INV_PROTO)
-		op = NFT_CMP_NEQ;
-	else
-		op = NFT_CMP_EQ;
-
 	add_cmp_u8(r, proto, op);
 }
 
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index f637b6e..1048d3b 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -102,6 +102,7 @@ struct nft_family_ops {
 			  void *data);
 };
 
+uint16_t invflags2cmp_op(uint16_t invflags);
 void add_meta(struct nft_rule *r, uint32_t key);
 void add_payload(struct nft_rule *r, int offset, int len);
 void add_bitwise_u16(struct nft_rule *r, int mask, int xor);

