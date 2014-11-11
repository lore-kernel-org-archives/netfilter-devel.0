From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [iptables PATCH] iptables/nft-shared.c: kill add_*() invflags
 parameter
Date: Tue, 11 Nov 2014 19:30:28 +0100
Message-ID: <20141111183028.5708.94480.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:55703 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751739AbaKKSak (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:30:40 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's kill the invflags parameter and use directly NFT_CMP_[N]EQ.

The caller must calculate which kind of cmp operation requires.
For this to happen within not so much LOCs, a small macro is included.

BTW, the this patch solves absence of inversion in some arptables-compat
builtin matches. Thus, translating arptables inv flags is no longer needed.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/nft-arp.c    |   65 +++++++++++++++++++++----------------------------
 iptables/nft-ipv4.c   |   30 +++++++++++++----------
 iptables/nft-ipv6.c   |   25 +++++++++++++------
 iptables/nft-shared.c |   35 +++-----------------------
 iptables/nft-shared.h |   14 ++++++++---
 5 files changed, 76 insertions(+), 93 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index f45ad0f..4c90e2b 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -137,82 +137,73 @@ static void print_mac_and_mask(const unsigned char *mac, const unsigned char *ma
 	print_mac(mask, l);
 }
 
-static uint8_t arpt_to_ipt_flags(uint16_t invflags)
-{
-	uint8_t result = 0;
-
-	if (invflags & ARPT_INV_VIA_IN)
-		result |= IPT_INV_VIA_IN;
-
-	if (invflags & ARPT_INV_VIA_OUT)
-		result |= IPT_INV_VIA_OUT;
-
-	if (invflags & ARPT_INV_SRCIP)
-		result |= IPT_INV_SRCIP;
-
-	if (invflags & ARPT_INV_TGTIP)
-		result |= IPT_INV_DSTIP;
-
-	if (invflags & ARPT_INV_ARPPRO)
-		result |= IPT_INV_PROTO;
-
-	return result;
-}
-
 static int nft_arp_add(struct nft_rule *r, void *data)
 {
 	struct arptables_command_state *cs = data;
 	struct arpt_entry *fw = &cs->fw;
-	uint8_t flags = arpt_to_ipt_flags(fw->arp.invflags);
+	uint32_t op = NFT_CMP_EQ;
 	int ret = 0;
 
-	if (fw->arp.iniface[0] != '\0')
-		add_iniface(r, fw->arp.iniface, flags);
+	if (fw->arp.iniface[0] != '\0') {
+		NFT_INVFLAGS2CMP(op, fw->arp.invflags, ARPT_INV_VIA_IN);
+		add_iniface(r, fw->arp.iniface, op);
+	}
 
-	if (fw->arp.outiface[0] != '\0')
-		add_outiface(r, fw->arp.outiface, flags);
+	if (fw->arp.outiface[0] != '\0') {
+		NFT_INVFLAGS2CMP(op, fw->arp.invflags, ARPT_INV_VIA_OUT);
+		add_outiface(r, fw->arp.outiface, op);
+	}
 
 	if (fw->arp.arhrd != 0) {
+		NFT_INVFLAGS2CMP(op, fw->arp.invflags, ARPT_INV_ARPHRD);
 		add_payload(r, offsetof(struct arphdr, ar_hrd), 2);
-		add_cmp_u16(r, fw->arp.arhrd, NFT_CMP_EQ);
+		add_cmp_u16(r, fw->arp.arhrd, op);
 	}
 
 	if (fw->arp.arpro != 0) {
+		NFT_INVFLAGS2CMP(op, fw->arp.invflags, ARPT_INV_ARPPRO);
 	        add_payload(r, offsetof(struct arphdr, ar_pro), 2);
-		add_cmp_u16(r, fw->arp.arpro, NFT_CMP_EQ);
+		add_cmp_u16(r, fw->arp.arpro, op);
 	}
 
-	if (fw->arp.arhln != 0)
+	if (fw->arp.arhln != 0) {
+		NFT_INVFLAGS2CMP(op, fw->arp.invflags, ARPT_INV_ARPHLN);
 		add_proto(r, offsetof(struct arphdr, ar_hln), 1,
-			  fw->arp.arhln, flags);
+			  fw->arp.arhln, op);
+	}
 
-	add_proto(r, offsetof(struct arphdr, ar_pln), 1, 4, 0);
+	add_proto(r, offsetof(struct arphdr, ar_pln), 1, 4, NFT_CMP_EQ);
 
 	if (fw->arp.arpop != 0) {
+		NFT_INVFLAGS2CMP(op, fw->arp.invflags, ARPT_INV_ARPOP);
 		add_payload(r, offsetof(struct arphdr, ar_op), 2);
-		add_cmp_u16(r, fw->arp.arpop, NFT_CMP_EQ);
+		add_cmp_u16(r, fw->arp.arpop, op);
 	}
 
 	if (fw->arp.src_devaddr.addr[0] != '\0') {
+		NFT_INVFLAGS2CMP(op, fw->arp.invflags, ARPT_INV_SRCDEVADDR);
 		add_payload(r, sizeof(struct arphdr), fw->arp.arhln);
-		add_cmp_ptr(r, NFT_CMP_EQ, fw->arp.src_devaddr.addr, fw->arp.arhln);
+		add_cmp_ptr(r, op, fw->arp.src_devaddr.addr, fw->arp.arhln);
 	}
 
 	if (fw->arp.src.s_addr != 0) {
+		NFT_INVFLAGS2CMP(op, fw->arp.invflags, ARPT_INV_SRCIP);
 		add_addr(r, sizeof(struct arphdr) + fw->arp.arhln,
 			 &fw->arp.src.s_addr, &fw->arp.smsk.s_addr,
-			 sizeof(struct in_addr), flags);
+			 sizeof(struct in_addr), op);
 	}
 
 	if (fw->arp.tgt_devaddr.addr[0] != '\0') {
+		NFT_INVFLAGS2CMP(op, fw->arp.invflags, ARPT_INV_TGTDEVADDR);
 		add_payload(r, sizeof(struct arphdr) + fw->arp.arhln + 4, fw->arp.arhln);
-		add_cmp_ptr(r, NFT_CMP_EQ, fw->arp.tgt_devaddr.addr, fw->arp.arhln);
+		add_cmp_ptr(r, io, fw->arp.tgt_devaddr.addr, fw->arp.arhln);
 	}
 
 	if (fw->arp.tgt.s_addr != 0) {
+		NFT_INVFLAGS2CMP(op, fw->arp.invflags, ARPT_INV_TGTIP);
 		add_addr(r, sizeof(struct arphdr) + fw->arp.arhln + sizeof(struct in_addr),
 			 &fw->arp.tgt.s_addr, &fw->arp.tmsk.s_addr,
-			 sizeof(struct in_addr), flags);
+			 sizeof(struct in_addr), op);
 	}
 
 	/* Counters need to me added before the target, otherwise they are
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index a2c5806..366b349 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -31,25 +31,33 @@ static int nft_ipv4_add(struct nft_rule *r, void *data)
 	struct xtables_rule_match *matchp;
 	uint32_t op;
 
-	if (cs->fw.ip.iniface[0] != '\0')
-		add_iniface(r, cs->fw.ip.iniface, cs->fw.ip.invflags);
+	if (cs->fw.ip.iniface[0] != '\0') {
+		NFT_INVFLAGS2CMP(op, cs->fw.ip.invflags, IPT_INV_VIA_IN);
+		add_iniface(r, cs->fw.ip.iniface, op);
+	}
 
-	if (cs->fw.ip.outiface[0] != '\0')
-		add_outiface(r, cs->fw.ip.outiface, cs->fw.ip.invflags);
+	if (cs->fw.ip.outiface[0] != '\0') {
+		NFT_INVFLAGS2CMP(op, cs->fw.ip.invflags, IPT_INV_VIA_OUT);
+		add_outiface(r, cs->fw.ip.outiface, op);
+	}
 
-	if (cs->fw.ip.proto != 0)
+	if (cs->fw.ip.proto != 0) {
+		NFT_INVFLAGS2CMP(op, cs->fw.ip.invflags, XT_INV_PROTO);
 		add_proto(r, offsetof(struct iphdr, protocol), 1,
-			  cs->fw.ip.proto, cs->fw.ip.invflags);
+			  cs->fw.ip.proto, op);
+	}
 
 	if (cs->fw.ip.src.s_addr != 0) {
+		NFT_INVFLAGS2CMP(op, cs->fw.ip.invflags, IPT_INV_SRCIP);
 		add_addr(r, offsetof(struct iphdr, saddr),
 			 &cs->fw.ip.src.s_addr, &cs->fw.ip.smsk.s_addr,
-			 sizeof(struct in_addr), cs->fw.ip.invflags);
+			 sizeof(struct in_addr), op);
 	}
 	if (cs->fw.ip.dst.s_addr != 0) {
+		NFT_INVFLAGS2CMP(op, cs->fw.ip.invflags, IPT_INV_DSTIP);
 		add_addr(r, offsetof(struct iphdr, daddr),
 			 &cs->fw.ip.dst.s_addr, &cs->fw.ip.dmsk.s_addr,
-			 sizeof(struct in_addr), cs->fw.ip.invflags);
+			 sizeof(struct in_addr), op);
 	}
 	if (cs->fw.ip.flags & IPT_F_FRAG) {
 		add_payload(r, offsetof(struct iphdr, frag_off), 2);
@@ -57,11 +65,7 @@ static int nft_ipv4_add(struct nft_rule *r, void *data)
 		add_bitwise_u16(r, 0x1fff, !0x1fff);
 
 		/* if offset is non-zero, this is a fragment */
-		if (cs->fw.ip.invflags & IPT_INV_FRAG)
-			op = NFT_CMP_EQ;
-		else
-			op = NFT_CMP_NEQ;
-
+		NFT_INVFLAGS2CMP(op, cs->fw.ip.invflags, IPT_INV_FRAG);
 		add_cmp_u16(r, 0, op);
 	}
 
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 5489398..d4af29d 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -27,26 +27,35 @@ static int nft_ipv6_add(struct nft_rule *r, void *data)
 {
 	struct iptables_command_state *cs = data;
 	struct xtables_rule_match *matchp;
+	uint32_t op = NFT_CMP_EQ;
 
-	if (cs->fw6.ipv6.iniface[0] != '\0')
-		add_iniface(r, cs->fw6.ipv6.iniface, cs->fw6.ipv6.invflags);
+	if (cs->fw6.ipv6.iniface[0] != '\0') {
+		NFT_INVFLAGS2CMP(op, cs->fw6.ipv6.invflags, IPT_INV_VIA_IN);
+		add_iniface(r, cs->fw6.ipv6.iniface, op);
+	}
 
-	if (cs->fw6.ipv6.outiface[0] != '\0')
-		add_outiface(r, cs->fw6.ipv6.outiface, cs->fw6.ipv6.invflags);
+	if (cs->fw6.ipv6.outiface[0] != '\0') {
+		NFT_INVFLAGS2CMP(op, cs->fw6.ipv6.invflags, IPT_INV_VIA_OUT);
+		add_outiface(r, cs->fw6.ipv6.outiface, op);
+	}
 
-	if (cs->fw6.ipv6.proto != 0)
+	if (cs->fw6.ipv6.proto != 0) {
+		NFT_INVFLAGS2CMP(op, cs->fw6.ipv6.invflags, XT_INV_PROTO);
 		add_proto(r, offsetof(struct ip6_hdr, ip6_nxt), 1,
-			  cs->fw6.ipv6.proto, cs->fw6.ipv6.invflags);
+			  cs->fw6.ipv6.proto, op);
+	}
 
 	if (!IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.src)) {
+		NFT_INVFLAGS2CMP(op, cs->fw6.ipv6.invflags, IPT_INV_SRCIP);
 		add_addr(r, offsetof(struct ip6_hdr, ip6_src),
 			 &cs->fw6.ipv6.src, &cs->fw6.ipv6.smsk,
-			 sizeof(struct in6_addr), cs->fw6.ipv6.invflags);
+			 sizeof(struct in6_addr), op);
 	}
 	if (!IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.dst)) {
+		NFT_INVFLAGS2CMP(op, cs->fw6.ipv6.invflags, IPT_INV_DSTIP);
 		add_addr(r, offsetof(struct ip6_hdr, ip6_dst),
 			 &cs->fw6.ipv6.dst, &cs->fw6.ipv6.dmsk,
-			 sizeof(struct in6_addr), cs->fw6.ipv6.invflags);
+			 sizeof(struct in6_addr), op);
 	}
 	add_compat(r, cs->fw6.ipv6.proto, cs->fw6.ipv6.invflags);
 
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 00310a3..d4a54be 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -130,18 +130,12 @@ void add_cmp_u32(struct nft_rule *r, uint32_t val, uint32_t op)
 	add_cmp_ptr(r, op, &val, sizeof(val));
 }
 
-void add_iniface(struct nft_rule *r, char *iface, int invflags)
+void add_iniface(struct nft_rule *r, char *iface, uint32_t op)
 {
 	int iface_len;
-	uint32_t op;
 
 	iface_len = strlen(iface);
 
-	if (invflags & IPT_INV_VIA_IN)
-		op = NFT_CMP_NEQ;
-	else
-		op = NFT_CMP_EQ;
-
 	add_meta(r, NFT_META_IIFNAME);
 	if (iface[iface_len - 1] == '+')
 		add_cmp_ptr(r, op, iface, iface_len - 1);
@@ -149,18 +143,12 @@ void add_iniface(struct nft_rule *r, char *iface, int invflags)
 		add_cmp_ptr(r, op, iface, iface_len + 1);
 }
 
-void add_outiface(struct nft_rule *r, char *iface, int invflags)
+void add_outiface(struct nft_rule *r, char *iface, uint32_t op)
 {
 	int iface_len;
-	uint32_t op;
 
 	iface_len = strlen(iface);
 
-	if (invflags & IPT_INV_VIA_OUT)
-		op = NFT_CMP_NEQ;
-	else
-		op = NFT_CMP_EQ;
-
 	add_meta(r, NFT_META_OIFNAME);
 	if (iface[iface_len - 1] == '+')
 		add_cmp_ptr(r, op, iface, iface_len - 1);
@@ -169,33 +157,18 @@ void add_outiface(struct nft_rule *r, char *iface, int invflags)
 }
 
 void add_addr(struct nft_rule *r, int offset,
-	      void *data, void *mask, size_t len, int invflags)
+	      void *data, void *mask, size_t len, uint32_t op)
 {
-	uint32_t op;
-
 	add_payload(r, offset, len);
 	add_bitwise(r, mask, len);
 
-	if (invflags & IPT_INV_SRCIP || invflags & IPT_INV_DSTIP)
-		op = NFT_CMP_NEQ;
-	else
-		op = NFT_CMP_EQ;
-
 	add_cmp_ptr(r, op, data, len);
 }
 
 void add_proto(struct nft_rule *r, int offset, size_t len,
-	       uint8_t proto, int invflags)
+	       uint8_t proto, uint32_t op)
 {
-	uint32_t op;
-
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
index 468da5c..4872226 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -38,6 +38,12 @@
 
 struct xtables_args;
 
+#define NFT_INVFLAGS2CMP(op, invflags, flag)	\
+	if (invflags & flag)			\
+		op = NFT_CMP_NEQ;		\
+	else					\
+		op = NFT_CMP_EQ;		\
+
 enum {
 	NFT_XT_CTX_PAYLOAD	= (1 << 0),
 	NFT_XT_CTX_META		= (1 << 1),
@@ -107,12 +113,12 @@ void add_cmp_ptr(struct nft_rule *r, uint32_t op, void *data, size_t len);
 void add_cmp_u8(struct nft_rule *r, uint8_t val, uint32_t op);
 void add_cmp_u16(struct nft_rule *r, uint16_t val, uint32_t op);
 void add_cmp_u32(struct nft_rule *r, uint32_t val, uint32_t op);
-void add_iniface(struct nft_rule *r, char *iface, int invflags);
-void add_outiface(struct nft_rule *r, char *iface, int invflags);
+void add_iniface(struct nft_rule *r, char *iface, uint32_t op);
+void add_outiface(struct nft_rule *r, char *iface, uint32_t op);
 void add_addr(struct nft_rule *r, int offset,
-	      void *data, void *mask, size_t len, int invflags);
+	      void *data, void *mask, size_t len, uint32_t op);
 void add_proto(struct nft_rule *r, int offset, size_t len,
-	       uint8_t proto, int invflags);
+	       uint8_t proto, uint32_t op);
 void add_compat(struct nft_rule *r, uint32_t proto, bool inv);
 
 bool is_same_interfaces(const char *a_iniface, const char *a_outiface,

