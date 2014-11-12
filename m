From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat-experimental5 PATCH] iptables/nft-bridge.c: fix
 inversion of builtin matches
Date: Wed, 12 Nov 2014 17:10:25 +0100
Message-ID: <20141112161025.9723.51400.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:33000 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753141AbaKLQKl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:10:41 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes inversion of builtin matches by updating the use of add_*()
functions and using nft_invflags2cmp() as well.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/nft-bridge.c |   67 ++++++++++++++++++-------------------------------
 1 file changed, 25 insertions(+), 42 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 3ed6239..b5aec00 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -64,22 +64,6 @@ static void ebt_print_mac_and_mask(const unsigned char *mac, const unsigned char
 	}
 }
 
-static uint8_t ebt_to_ipt_flags(uint16_t invflags)
-{
-	uint8_t result = 0;
-
-	if (invflags & EBT_IIN)
-		result |= IPT_INV_VIA_IN;
-
-	if (invflags & EBT_IOUT)
-		result |= IPT_INV_VIA_OUT;
-
-	if (invflags & EBT_IPROTO)
-		result |= IPT_INV_PROTO;
-
-	return result;
-}
-
 static uint16_t ipt_to_ebt_flags(uint8_t invflags)
 {
 	uint16_t result = 0;
@@ -96,18 +80,12 @@ static uint16_t ipt_to_ebt_flags(uint8_t invflags)
 	return result;
 }
 
-static void add_logical_iniface(struct nft_rule *r, char *iface, int invflags)
+static void add_logical_iniface(struct nft_rule *r, char *iface, uint32_t op)
 {
 	int iface_len;
-	uint32_t op;
 
 	iface_len = strlen(iface);
 
-	if (invflags & EBT_ILOGICALIN)
-		op = NFT_CMP_NEQ;
-	else
-		op = NFT_CMP_EQ;
-
 	add_meta(r, NFT_META_BRI_IIFNAME);
 	if (iface[iface_len - 1] == '+')
 		add_cmp_ptr(r, op, iface, iface_len - 1);
@@ -115,18 +93,12 @@ static void add_logical_iniface(struct nft_rule *r, char *iface, int invflags)
 		add_cmp_ptr(r, op, iface, iface_len + 1);
 }
 
-static void add_logical_outiface(struct nft_rule *r, char *iface, int invflags)
+static void add_logical_outiface(struct nft_rule *r, char *iface, uint32_t op)
 {
 	int iface_len;
-	uint32_t op;
 
 	iface_len = strlen(iface);
 
-	if (invflags & EBT_ILOGICALOUT)
-		op = NFT_CMP_NEQ;
-	else
-		op = NFT_CMP_EQ;
-
 	add_meta(r, NFT_META_BRI_OIFNAME);
 	if (iface[iface_len - 1] == '+')
 		add_cmp_ptr(r, op, iface, iface_len - 1);
@@ -164,36 +136,47 @@ static int nft_bridge_add(struct nft_rule *r, void *data)
 {
 	struct ebtables_command_state *cs = data;
 	struct ebt_entry *fw = &cs->fw;
-	uint8_t flags = ebt_to_ipt_flags(fw->invflags);
+	uint32_t op;
 	char *addr;
 
-	if (fw->in[0] != '\0')
-		add_iniface(r, fw->in, flags);
+	if (fw->in[0] != '\0') {
+		op = nft_invflags2cmp(fw->invflags, EBT_IIN);
+		add_iniface(r, fw->in, op);
+	}
 
-	if (fw->out[0] != '\0')
-		add_outiface(r, fw->out, flags);
+	if (fw->out[0] != '\0') {
+		op = nft_invflags2cmp(fw->invflags, EBT_IOUT);
+		add_outiface(r, fw->out, op);
+	}
 
-	if (fw->logical_in[0] != '\0')
-		add_logical_iniface(r, fw->logical_in, flags);
+	if (fw->logical_in[0] != '\0') {
+		op = nft_invflags2cmp(fw->invflags, EBT_ILOGICALIN);
+		add_logical_iniface(r, fw->logical_in, op);
+	}
 
-	if (fw->logical_out[0] != '\0')
-		add_logical_outiface(r, fw->logical_out, flags);
+	if (fw->logical_out[0] != '\0') {
+		op = nft_invflags2cmp(fw->invflags, EBT_ILOGICALOUT);
+		add_logical_outiface(r, fw->logical_out, op);
+	}
 
 	addr = ether_ntoa((struct ether_addr *) fw->sourcemac);
 	if (strcmp(addr, "0:0:0:0:0:0") != 0) {
+		op = nft_invflags2cmp(fw->invflags, EBT_ISOURCE);
 		add_payload(r, offsetof(struct ethhdr, h_source), 6);
-		add_cmp_ptr(r, NFT_CMP_EQ, fw->sourcemac, 6);
+		add_cmp_ptr(r, op, fw->sourcemac, 6);
 	}
 
 	addr = ether_ntoa((struct ether_addr *) fw->destmac);
 	if (strcmp(addr, "0:0:0:0:0:0") != 0) {
+		op = nft_invflags2cmp(fw->invflags, EBT_IDEST);
 		add_payload(r, offsetof(struct ethhdr, h_dest), 6);
-		add_cmp_ptr(r, NFT_CMP_EQ, fw->destmac, 6);
+		add_cmp_ptr(r, op, fw->destmac, 6);
 	}
 
 	if (fw->ethproto != 0) {
+		op = nft_invflags2cmp(fw->invflags, EBT_IPROTO);
 		add_payload(r, offsetof(struct ethhdr, h_proto), 2);
-		add_cmp_u16(r, fw->ethproto, NFT_CMP_EQ);
+		add_cmp_u16(r, fw->ethproto, op);
 	}
 
 	return _add_action(r, cs);

