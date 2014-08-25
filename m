From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [{ip,ip6}tables-compat PATCH] nft: fix network prefixes
Date: Mon, 25 Aug 2014 22:54:56 +0200
Message-ID: <1409000096-4335-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:56315 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128AbaHYUvJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Aug 2014 16:51:09 -0400
Received: by mail-we0-f177.google.com with SMTP id w62so13792346wes.22
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Aug 2014 13:51:07 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is fixing the network prefixes (eg. /24) in the {ip,ip6} compat utility

The following below

generate respectively the following netlink code:
ip filter INPUT 20
  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 4b @ network header + 12 => reg 1 ]
  [ cmp eq reg 1 0x0000a8c0 ]
  [ match name tcp rev 0 ]
  [ match name conntrack rev 3 ]
  [ counter pkts 0 bytes 0 ]
  [ immediate reg 0 accept ]

ip6 filter INPUT 36
  [ payload load 16b @ network header + 8 => reg 1 ]
  [ cmp eq reg 1 0x00004023 0x00000000 0x00000000 0x00000000 ]
  [ counter pkts 0 bytes 0 ]
  [ immediate reg 0 accept ]

With this patch the netlink code becomes:

ip filter INPUT 20
  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 4b @ network header + 12 => reg 1 ]
  [ cmp eq reg 1 0x0000a8c0 ]
  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
  [ match name tcp rev 0 ]
  [ match name conntrack rev 3 ]
  [ counter pkts 0 bytes 0 ]
  [ immediate reg 0 accept ]

ip6 filter INPUT 36
  [ payload load 16b @ network header + 8 => reg 1 ]
  [ cmp eq reg 1 0x00004023 0x00000000 0x00000000 0x00000000 ]
  [ bitwise reg 1 = (reg=1 & 0x0000ffff 0x00000000 0x00000000 0x00000000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
  [ counter pkts 0 bytes 0 ]
  [ immediate reg 0 accept ]

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-arp.c    | 13 ++++++-----
 iptables/nft-ipv4.c   | 34 +++++++++++++++++++++++------
 iptables/nft-ipv6.c   | 31 +++++++++++++++++++++-----
 iptables/nft-shared.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++---
 iptables/nft-shared.h | 14 +++++++++---
 5 files changed, 129 insertions(+), 23 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index bc25de3..4fff793 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -202,8 +202,8 @@ static int nft_arp_add(struct nft_rule *r, void *data)
 	}
 
 	if (fw->arp.src.s_addr != 0)
-		add_addr(r, sizeof(struct arphdr) + fw->arp.arhln,
-			 &fw->arp.src.s_addr, 4, flags);
+		add_addr(r, AF_INET, sizeof(struct arphdr) + fw->arp.arhln,
+			 &fw->arp.src.s_addr, NULL, 4, flags);
 
 	if (fw->arp.tgt_devaddr.addr[0] != '\0') {
 		add_payload(r, sizeof(struct arphdr) + fw->arp.arhln + 4, fw->arp.arhln);
@@ -211,8 +211,9 @@ static int nft_arp_add(struct nft_rule *r, void *data)
 	}
 
 	if (fw->arp.tgt.s_addr != 0)
-		add_addr(r, sizeof(struct arphdr) + fw->arp.arhln + sizeof(struct in_addr),
-			 &fw->arp.tgt.s_addr, 4, flags);
+		add_addr(r, AF_INET,
+			 sizeof(struct arphdr) + fw->arp.arhln + sizeof(struct in_addr),
+			 &fw->arp.tgt.s_addr, NULL, 4, flags);
 
 	/* Counters need to me added before the target, otherwise they are
 	 * increased for each rule because of the way nf_tables works.
@@ -308,7 +309,8 @@ static void nft_arp_parse_immediate(const char *jumpto, bool nft_goto,
 }
 
 static void nft_arp_parse_payload(struct nft_rule_expr_iter *iter,
-				  uint32_t offset, void *data)
+				  uint32_t offset, void *data,
+				  uint32_t *flags)
 {
 	struct arpt_entry *fw = data;
 	struct in_addr addr;
@@ -694,6 +696,7 @@ struct nft_family_ops nft_family_ops_arp = {
 	.parse_meta		= nft_arp_parse_meta,
 	.parse_payload		= nft_arp_parse_payload,
 	.parse_immediate	= nft_arp_parse_immediate,
+	.parse_bitwise		= NULL,
 	.print_firewall		= nft_arp_print_firewall,
 	.save_firewall		= nft_arp_save_firewall,
 	.save_counters		= nft_arp_save_counters,
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 33bc581..dfbb31f 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -38,12 +38,14 @@ static int nft_ipv4_add(struct nft_rule *r, void *data)
 		add_outiface(r, cs->fw.ip.outiface, cs->fw.ip.invflags);
 
 	if (cs->fw.ip.src.s_addr != 0)
-		add_addr(r, offsetof(struct iphdr, saddr),
-			 &cs->fw.ip.src.s_addr, 4, cs->fw.ip.invflags);
+		add_addr(r, AF_INET, offsetof(struct iphdr, saddr),
+			 &cs->fw.ip.src.s_addr, &cs->fw.ip.smsk.s_addr,
+			 4, cs->fw.ip.invflags);
 
 	if (cs->fw.ip.dst.s_addr != 0)
-		add_addr(r, offsetof(struct iphdr, daddr),
-			 &cs->fw.ip.dst.s_addr, 4, cs->fw.ip.invflags);
+		add_addr(r, AF_INET, offsetof(struct iphdr, daddr),
+			 &cs->fw.ip.dst.s_addr, &cs->fw.ip.dmsk.s_addr,
+			 4, cs->fw.ip.invflags);
 
 	if (cs->fw.ip.proto != 0)
 		add_proto(r, offsetof(struct iphdr, protocol), 1,
@@ -175,7 +177,8 @@ static void nft_ipv4_parse_meta(struct nft_rule_expr *e, uint8_t key,
 }
 
 static void nft_ipv4_parse_payload(struct nft_rule_expr_iter *iter,
-				   uint32_t offset, void *data)
+				   uint32_t offset, void *data,
+				   uint32_t *flags)
 {
 	struct iptables_command_state *cs = data;
 
@@ -187,14 +190,14 @@ static void nft_ipv4_parse_payload(struct nft_rule_expr_iter *iter,
 	case offsetof(struct iphdr, saddr):
 		get_cmp_data(iter, &addr, sizeof(addr), &inv);
 		cs->fw.ip.src.s_addr = addr.s_addr;
-		cs->fw.ip.smsk.s_addr = 0xffffffff;
+		*flags = NFT_PARSE_SOURCE_MASK;
 		if (inv)
 			cs->fw.ip.invflags |= IPT_INV_SRCIP;
 		break;
 	case offsetof(struct iphdr, daddr):
 		get_cmp_data(iter, &addr, sizeof(addr), &inv);
 		cs->fw.ip.dst.s_addr = addr.s_addr;
-		cs->fw.ip.dmsk.s_addr = 0xffffffff;
+		*flags = NFT_PARSE_DESTINATION_MASK;
 		if (inv)
 			cs->fw.ip.invflags |= IPT_INV_DSTIP;
 		break;
@@ -216,6 +219,22 @@ static void nft_ipv4_parse_payload(struct nft_rule_expr_iter *iter,
 	}
 }
 
+static void nft_ipv4_parse_bitwise(struct nft_rule_expr *e, void *data,
+				   uint32_t flags)
+{
+	struct iptables_command_state *cs = data;
+	uint32_t mask;
+
+	mask = nft_rule_expr_get_u32(e, NFT_EXPR_BITWISE_MASK);
+	if (mask == 0)
+		mask = 0xffffffff;
+
+	if (flags & NFT_PARSE_SOURCE_MASK)
+		cs->fw.ip.smsk.s_addr = mask;
+	else if (flags & NFT_PARSE_DESTINATION_MASK)
+		cs->fw.ip.dmsk.s_addr = mask;
+}
+
 static void nft_ipv4_parse_immediate(const char *jumpto, bool nft_goto,
 				     void *data)
 {
@@ -421,6 +440,7 @@ struct nft_family_ops nft_family_ops_ipv4 = {
 	.parse_meta		= nft_ipv4_parse_meta,
 	.parse_payload		= nft_ipv4_parse_payload,
 	.parse_immediate	= nft_ipv4_parse_immediate,
+	.parse_bitwise		= nft_ipv4_parse_bitwise,
 	.print_firewall		= nft_ipv4_print_firewall,
 	.save_firewall		= nft_ipv4_save_firewall,
 	.save_counters		= nft_ipv4_save_counters,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 00f1bf8..67387dd 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -35,12 +35,14 @@ static int nft_ipv6_add(struct nft_rule *r, void *data)
 		add_outiface(r, cs->fw6.ipv6.outiface, cs->fw6.ipv6.invflags);
 
 	if (!IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.src))
-		add_addr(r, offsetof(struct ip6_hdr, ip6_src),
-			 &cs->fw6.ipv6.src, 16, cs->fw6.ipv6.invflags);
+		add_addr(r, AF_INET6, offsetof(struct ip6_hdr, ip6_src),
+			 &cs->fw6.ipv6.src, &cs->fw6.ipv6.smsk,
+			 16, cs->fw6.ipv6.invflags);
 
 	if (!IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.dst))
-		add_addr(r, offsetof(struct ip6_hdr, ip6_dst),
-			 &cs->fw6.ipv6.dst, 16, cs->fw6.ipv6.invflags);
+		add_addr(r, AF_INET6, offsetof(struct ip6_hdr, ip6_dst),
+			 &cs->fw6.ipv6.dst, &cs->fw6.ipv6.dmsk,
+			 16, cs->fw6.ipv6.invflags);
 
 	if (cs->fw6.ipv6.proto != 0)
 		add_proto(r, offsetof(struct ip6_hdr, ip6_nxt), 1,
@@ -98,7 +100,8 @@ static void nft_ipv6_parse_meta(struct nft_rule_expr *e, uint8_t key,
 }
 
 static void nft_ipv6_parse_payload(struct nft_rule_expr_iter *iter,
-				   uint32_t offset, void *data)
+				   uint32_t offset, void *data,
+				   uint32_t *flags)
 {
 	struct iptables_command_state *cs = data;
 	switch (offset) {
@@ -109,12 +112,14 @@ static void nft_ipv6_parse_payload(struct nft_rule_expr_iter *iter,
 	case offsetof(struct ip6_hdr, ip6_src):
 		get_cmp_data(iter, &addr, sizeof(addr), &inv);
 		memcpy(cs->fw6.ipv6.src.s6_addr, &addr, sizeof(addr));
+		*flags |= NFT_PARSE_SOURCE_MASK;
 		if (inv)
 			cs->fw6.ipv6.invflags |= IPT_INV_SRCIP;
 		break;
 	case offsetof(struct ip6_hdr, ip6_dst):
 		get_cmp_data(iter, &addr, sizeof(addr), &inv);
 		memcpy(cs->fw6.ipv6.dst.s6_addr, &addr, sizeof(addr));
+		*flags |= NFT_PARSE_DESTINATION_MASK;
 		if (inv)
 			cs->fw6.ipv6.invflags |= IPT_INV_DSTIP;
 		break;
@@ -141,6 +146,21 @@ static void nft_ipv6_parse_immediate(const char *jumpto, bool nft_goto,
 		cs->fw6.ipv6.flags |= IP6T_F_GOTO;
 }
 
+static void nft_ipv6_parse_bitwise(struct nft_rule_expr *e, void *data,
+				   uint32_t flags)
+{
+	struct iptables_command_state *cs = data;
+	const void *mask;
+	uint32_t len;
+
+	mask = nft_rule_expr_get(e, NFT_EXPR_BITWISE_MASK, &len);
+
+	if (flags & NFT_PARSE_SOURCE_MASK)
+		memcpy(cs->fw6.ipv6.smsk.s6_addr, mask, len);
+	else if (flags & NFT_PARSE_DESTINATION_MASK)
+		memcpy(cs->fw6.ipv6.dmsk.s6_addr, mask, len);
+}
+
 static void print_ipv6_addr(const struct iptables_command_state *cs,
 			    unsigned int format)
 {
@@ -343,6 +363,7 @@ struct nft_family_ops nft_family_ops_ipv6 = {
 	.parse_meta		= nft_ipv6_parse_meta,
 	.parse_payload		= nft_ipv6_parse_payload,
 	.parse_immediate	= nft_ipv6_parse_immediate,
+	.parse_bitwise		= nft_ipv6_parse_bitwise,
 	.print_firewall		= nft_ipv6_print_firewall,
 	.save_firewall		= nft_ipv6_save_firewall,
 	.save_counters		= nft_ipv6_save_counters,
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 05fb29b..de5f018 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -82,6 +82,40 @@ void add_bitwise_u16(struct nft_rule *r, int mask, int xor)
 	nft_rule_add_expr(r, expr);
 }
 
+void add_bitwise_u32(struct nft_rule *r, int mask, int xor)
+{
+	struct nft_rule_expr *expr;
+
+	expr = nft_rule_expr_alloc("bitwise");
+	if (expr == NULL)
+		return;
+
+	nft_rule_expr_set_u32(expr, NFT_EXPR_BITWISE_SREG, NFT_REG_1);
+	nft_rule_expr_set_u32(expr, NFT_EXPR_BITWISE_DREG, NFT_REG_1);
+	nft_rule_expr_set_u32(expr, NFT_EXPR_BITWISE_LEN, sizeof(uint32_t));
+	nft_rule_expr_set(expr, NFT_EXPR_BITWISE_MASK, &mask, sizeof(uint32_t));
+	nft_rule_expr_set(expr, NFT_EXPR_BITWISE_XOR, &xor, sizeof(uint32_t));
+
+	nft_rule_add_expr(r, expr);
+}
+
+void add_bitwise_u128(struct nft_rule *r, uint8_t *mask, uint8_t *xor)
+{
+	struct nft_rule_expr *expr;
+
+	expr = nft_rule_expr_alloc("bitwise");
+	if (expr == NULL)
+		return;
+
+	nft_rule_expr_set_u32(expr, NFT_EXPR_BITWISE_SREG, NFT_REG_1);
+	nft_rule_expr_set_u32(expr, NFT_EXPR_BITWISE_DREG, NFT_REG_1);
+	nft_rule_expr_set_u32(expr, NFT_EXPR_BITWISE_LEN, 16);
+	nft_rule_expr_set(expr, NFT_EXPR_BITWISE_MASK, mask, 16);
+	nft_rule_expr_set(expr, NFT_EXPR_BITWISE_XOR, xor, 16);
+
+	nft_rule_add_expr(r, expr);
+}
+
 void add_cmp_ptr(struct nft_rule *r, uint32_t op, void *data, size_t len)
 {
 	struct nft_rule_expr *expr;
@@ -150,8 +184,8 @@ void add_outiface(struct nft_rule *r, char *iface, int invflags)
 		add_cmp_ptr(r, op, iface, iface_len + 1);
 }
 
-void add_addr(struct nft_rule *r, int offset,
-	      void *data, size_t len, int invflags)
+void add_addr(struct nft_rule *r, int family, int offset,
+	      void *data, void *mask, size_t len, int invflags)
 {
 	uint32_t op;
 
@@ -163,6 +197,16 @@ void add_addr(struct nft_rule *r, int offset,
 		op = NFT_CMP_EQ;
 
 	add_cmp_ptr(r, op, data, len);
+
+	if (family == AF_INET) {
+		uint32_t *mask4 = mask;
+		uint32_t xor = 0;
+		add_bitwise_u32(r, *mask4, xor);
+	} else {
+		uint8_t *mask6 = mask;
+		uint8_t xor[16] = {0};
+		add_bitwise_u128(r, mask6, xor);
+	}
 }
 
 void add_proto(struct nft_rule *r, int offset, size_t len,
@@ -421,7 +465,7 @@ nft_parse_payload(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
 
 	offset = nft_rule_expr_get_u32(e, NFT_EXPR_PAYLOAD_OFFSET);
 
-	ops->parse_payload(ctx->iter, offset, data);
+	ops->parse_payload(ctx->iter, offset, data, &ctx->flags);
 }
 
 void
@@ -463,6 +507,14 @@ nft_parse_immediate(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
 	ops->parse_immediate(jumpto, nft_goto, data);
 }
 
+void nft_parse_bitwise(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
+{
+	struct nft_family_ops *ops = nft_family_ops_lookup(ctx->family);
+	void *data = nft_get_data(ctx);
+
+	ops->parse_bitwise(e, data, ctx->flags);
+}
+
 void nft_rule_to_iptables_command_state(struct nft_rule *r,
 					struct iptables_command_state *cs)
 {
@@ -489,6 +541,8 @@ void nft_rule_to_iptables_command_state(struct nft_rule *r,
 			nft_parse_counter(expr, &ctx.state.cs->counters);
 		else if (strcmp(name, "payload") == 0)
 			nft_parse_payload(&ctx, expr);
+		else if (strcmp(name, "bitwise") == 0)
+			nft_parse_bitwise(&ctx, expr);
 		else if (strcmp(name, "meta") == 0)
 			nft_parse_meta(&ctx, expr);
 		else if (strcmp(name, "immediate") == 0)
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index c4936dd..834ea32 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -36,6 +36,9 @@
 			| FMT_NUMERIC | FMT_NOTABLE)
 #define FMT(tab,notab) ((format) & FMT_NOTABLE ? (notab) : (tab))
 
+#define NFT_PARSE_SOURCE_MASK (1 << 0)
+#define NFT_PARSE_DESTINATION_MASK (1 << 1)
+
 struct xtables_args;
 
 struct nft_xt_ctx {
@@ -57,8 +60,10 @@ struct nft_family_ops {
 	void (*parse_meta)(struct nft_rule_expr *e, uint8_t key,
 			   void *data);
 	void (*parse_payload)(struct nft_rule_expr_iter *iter,
-			      uint32_t offset, void *data);
+			      uint32_t offset, void *data, uint32_t *flags);
 	void (*parse_immediate)(const char *jumpto, bool nft_goto, void *data);
+	void (*parse_bitwise)(struct nft_rule_expr *e, void *data,
+			      uint32_t flags);
 	void (*print_firewall)(struct nft_rule *r, unsigned int num,
 			       unsigned int format);
 	void (*save_firewall)(const void *data, unsigned int format);
@@ -75,14 +80,16 @@ struct nft_family_ops {
 void add_meta(struct nft_rule *r, uint32_t key);
 void add_payload(struct nft_rule *r, int offset, int len);
 void add_bitwise_u16(struct nft_rule *r, int mask, int xor);
+void add_bitwise_u32(struct nft_rule *r, int mask, int xor);
+void add_bitwise_u128(struct nft_rule *r, uint8_t *mask, uint8_t *xor);
 void add_cmp_ptr(struct nft_rule *r, uint32_t op, void *data, size_t len);
 void add_cmp_u8(struct nft_rule *r, uint8_t val, uint32_t op);
 void add_cmp_u16(struct nft_rule *r, uint16_t val, uint32_t op);
 void add_cmp_u32(struct nft_rule *r, uint32_t val, uint32_t op);
 void add_iniface(struct nft_rule *r, char *iface, int invflags);
 void add_outiface(struct nft_rule *r, char *iface, int invflags);
-void add_addr(struct nft_rule *r, int offset,
-	      void *data, size_t len, int invflags);
+void add_addr(struct nft_rule *r, int family, int offset,
+	      void *data, void *mask, size_t len, int invflags);
 void add_proto(struct nft_rule *r, int offset, size_t len,
 	       uint8_t proto, int invflags);
 void add_compat(struct nft_rule *r, uint32_t proto, bool inv);
@@ -105,6 +112,7 @@ void nft_parse_meta(struct nft_xt_ctx *ctx, struct nft_rule_expr *e);
 void nft_parse_payload(struct nft_xt_ctx *ctx, struct nft_rule_expr *e);
 void nft_parse_counter(struct nft_rule_expr *e, struct xt_counters *counters);
 void nft_parse_immediate(struct nft_xt_ctx *ctx, struct nft_rule_expr *e);
+void nft_parse_bitwise(struct nft_xt_ctx *ctx, struct nft_rule_expr *e);
 void nft_rule_to_iptables_command_state(struct nft_rule *r,
 					struct iptables_command_state *cs);
 void print_firewall_details(const struct iptables_command_state *cs,
-- 
1.8.3.2

