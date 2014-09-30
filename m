From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables-compat] iptables-compat: fix address prefix
Date: Tue, 30 Sep 2014 14:48:30 +0200
Message-ID: <1412081310-30073-1-git-send-email-pablo@netfilter.org>
Cc: giuseppelng@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51223 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbaI3MrV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:47:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes:

 # iptables-compat -I INPUT -s 1.2.3.0/24

generates this bytecode:

ip filter INPUT 20
  [ payload load 4b @ network header + 12 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x00ffffff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x00030201 ]
  [ counter pkts 0 bytes 0 ]

and it displays:

 # iptables-compat-save
...
-A INPUT -s 1.2.3.0/24

ip6tables-compat and arptables-compat are also fixed.

This patch uses the new context structure to annotate payload, meta
and bitwise, so it interprets the cmp expression based on the context.
This provides a rudimentary way to delinearize the iptables-compat
rule-set, but it should be enough for the built-in xtables selectors
since we still use the xtables extensions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-arp.c    |   62 +++++++++++++++++++++++-----------
 iptables/nft-ipv4.c   |   74 +++++++++++++++++++---------------------
 iptables/nft-ipv6.c   |   45 +++++++++++++++++--------
 iptables/nft-shared.c |   90 +++++++++++++++++++++++++++++++------------------
 iptables/nft-shared.h |   36 ++++++++++++++++----
 5 files changed, 196 insertions(+), 111 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 902d1d2..bb4bab2 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -198,18 +198,22 @@ static int nft_arp_add(struct nft_rule *r, void *data)
 		add_cmp_ptr(r, NFT_CMP_EQ, fw->arp.src_devaddr.addr, fw->arp.arhln);
 	}
 
-	if (fw->arp.src.s_addr != 0)
+	if (fw->arp.src.s_addr != 0) {
 		add_addr(r, sizeof(struct arphdr) + fw->arp.arhln,
-			 &fw->arp.src.s_addr, 4, flags);
+			 &fw->arp.src.s_addr, &fw->arp.smsk.s_addr,
+			 sizeof(struct in_addr), flags);
+	}
 
 	if (fw->arp.tgt_devaddr.addr[0] != '\0') {
 		add_payload(r, sizeof(struct arphdr) + fw->arp.arhln + 4, fw->arp.arhln);
 		add_cmp_ptr(r, NFT_CMP_EQ, fw->arp.tgt_devaddr.addr, fw->arp.arhln);
 	}
 
-	if (fw->arp.tgt.s_addr != 0)
+	if (fw->arp.tgt.s_addr != 0) {
 		add_addr(r, sizeof(struct arphdr) + fw->arp.arhln + sizeof(struct in_addr),
-			 &fw->arp.tgt.s_addr, 4, flags);
+			 &fw->arp.tgt.s_addr, &fw->arp.tmsk.s_addr,
+			 sizeof(struct in_addr), flags);
+	}
 
 	/* Counters need to me added before the target, otherwise they are
 	 * increased for each rule because of the way nf_tables works.
@@ -257,13 +261,13 @@ static uint16_t ipt_to_arpt_flags(uint8_t invflags)
 	return result;
 }
 
-static void nft_arp_parse_meta(struct nft_rule_expr *e, uint8_t key,
+static void nft_arp_parse_meta(struct nft_xt_ctx *ctx, struct nft_rule_expr *e,
 			       void *data)
 {
 	struct arpt_entry *fw = data;
 	uint8_t flags = 0;
 
-	parse_meta(e, key, fw->arp.iniface, fw->arp.iniface_mask,
+	parse_meta(e, ctx->meta.key, fw->arp.iniface, fw->arp.iniface_mask,
 		   fw->arp.outiface, fw->arp.outiface_mask,
 		   &flags);
 
@@ -301,38 +305,43 @@ static void nft_arp_parse_immediate(const char *jumpto, bool nft_goto,
 	nft_arp_parse_target(target, data);
 }
 
-static void nft_arp_parse_payload(struct nft_rule_expr_iter *iter,
-				  uint32_t offset, void *data)
+static void parse_mask_ipv4(struct nft_xt_ctx *ctx, struct in_addr *mask)
+{
+	mask->s_addr = ctx->bitwise.mask[0];
+}
+
+static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
+				  struct nft_rule_expr *e, void *data)
 {
 	struct arpt_entry *fw = data;
 	struct in_addr addr;
 	unsigned short int ar_hrd, ar_pro, ar_op, ar_hln;
 	bool inv;
 
-	switch (offset) {
+	switch (ctx->payload.offset) {
 	case offsetof(struct arphdr, ar_hrd):
-		get_cmp_data(iter, &ar_hrd, sizeof(ar_hrd), &inv);
+		get_cmp_data(e, &ar_hrd, sizeof(ar_hrd), &inv);
 		fw->arp.arhrd = ar_hrd;
 		fw->arp.arhrd_mask = 0xffff;
 		if (inv)
 			fw->arp.invflags |= ARPT_INV_ARPHRD;
 		break;
 	case offsetof(struct arphdr, ar_pro):
-		get_cmp_data(iter, &ar_pro, sizeof(ar_pro), &inv);
+		get_cmp_data(e, &ar_pro, sizeof(ar_pro), &inv);
 		fw->arp.arpro = ar_pro;
 		fw->arp.arpro_mask = 0xffff;
 		if (inv)
 			fw->arp.invflags |= ARPT_INV_ARPPRO;
 		break;
 	case offsetof(struct arphdr, ar_op):
-		get_cmp_data(iter, &ar_op, sizeof(ar_op), &inv);
+		get_cmp_data(e, &ar_op, sizeof(ar_op), &inv);
 		fw->arp.arpop = ar_op;
 		fw->arp.arpop_mask = 0xffff;
 		if (inv)
 			fw->arp.invflags |= ARPT_INV_ARPOP;
 		break;
 	case offsetof(struct arphdr, ar_hln):
-		get_cmp_data(iter, &ar_hln, sizeof(ar_op), &inv);
+		get_cmp_data(e, &ar_hln, sizeof(ar_op), &inv);
 		fw->arp.arhln = ar_hln;
 		fw->arp.arhln_mask = 0xff;
 		if (inv)
@@ -342,16 +351,27 @@ static void nft_arp_parse_payload(struct nft_rule_expr_iter *iter,
 		if (fw->arp.arhln < 0)
 			break;
 
-		if (offset == sizeof(struct arphdr) + fw->arp.arhln) {
-			get_cmp_data(iter, &addr, sizeof(addr), &inv);
+		if (ctx->payload.offset == sizeof(struct arphdr) +
+					   fw->arp.arhln) {
+			get_cmp_data(e, &addr, sizeof(addr), &inv);
 			fw->arp.src.s_addr = addr.s_addr;
-			fw->arp.smsk.s_addr = 0xffffffff;
+			if (ctx->flags & NFT_XT_CTX_BITWISE)
+				parse_mask_ipv4(ctx, &fw->arp.smsk);
+			else
+				fw->arp.smsk.s_addr = 0xffffffff;
+
 			if (inv)
 				fw->arp.invflags |= ARPT_INV_SRCIP;
-		} else if (offset == sizeof(struct arphdr) + fw->arp.arhln + sizeof(struct in_addr)) {
-			get_cmp_data(iter, &addr, sizeof(addr), &inv);
+		} else if (ctx->payload.offset == sizeof(struct arphdr) +
+						  fw->arp.arhln +
+						  sizeof(struct in_addr)) {
+			get_cmp_data(e, &addr, sizeof(addr), &inv);
 			fw->arp.tgt.s_addr = addr.s_addr;
-			fw->arp.tmsk.s_addr = 0xffffffff;
+			if (ctx->flags & NFT_XT_CTX_BITWISE)
+				parse_mask_ipv4(ctx, &fw->arp.tmsk);
+			else
+				fw->arp.tmsk.s_addr = 0xffffffff;
+
 			if (inv)
 				fw->arp.invflags |= ARPT_INV_TGTIP;
 		}
@@ -385,6 +405,10 @@ void nft_rule_to_arpt_entry(struct nft_rule *r, struct arpt_entry *fw)
 			nft_parse_payload(&ctx, expr);
 		else if (strcmp(name, "meta") == 0)
 			nft_parse_meta(&ctx, expr);
+		else if (strcmp(name, "bitwise") == 0)
+			nft_parse_bitwise(&ctx, expr);
+		else if (strcmp(name, "cmp") == 0)
+			nft_parse_cmp(&ctx, expr);
 		else if (strcmp(name, "immediate") == 0)
 			nft_parse_immediate(&ctx, expr);
 		else if (strcmp(name, "target") == 0)
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 70050ba..cb1d45b 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -41,14 +41,16 @@ static int nft_ipv4_add(struct nft_rule *r, void *data)
 		add_proto(r, offsetof(struct iphdr, protocol), 1,
 			  cs->fw.ip.proto, cs->fw.ip.invflags);
 
-	if (cs->fw.ip.src.s_addr != 0)
+	if (cs->fw.ip.src.s_addr != 0) {
 		add_addr(r, offsetof(struct iphdr, saddr),
-			 &cs->fw.ip.src.s_addr, 4, cs->fw.ip.invflags);
-
-	if (cs->fw.ip.dst.s_addr != 0)
+			 &cs->fw.ip.src.s_addr, &cs->fw.ip.smsk.s_addr,
+			 sizeof(struct in_addr), cs->fw.ip.invflags);
+	}
+	if (cs->fw.ip.dst.s_addr != 0) {
 		add_addr(r, offsetof(struct iphdr, daddr),
-			 &cs->fw.ip.dst.s_addr, 4, cs->fw.ip.invflags);
-
+			 &cs->fw.ip.dst.s_addr, &cs->fw.ip.dmsk.s_addr,
+			 sizeof(struct in_addr), cs->fw.ip.invflags);
+	}
 	if (cs->fw.ip.flags & IPT_F_FRAG) {
 		add_payload(r, offsetof(struct iphdr, frag_off), 2);
 		/* get the 13 bits that contain the fragment offset */
@@ -102,35 +104,15 @@ static bool nft_ipv4_is_same(const void *data_a,
 				  b->fw.ip.iniface_mask, b->fw.ip.outiface_mask);
 }
 
-static void get_frag(struct nft_rule_expr_iter *iter, bool *inv)
+static void get_frag(struct nft_xt_ctx *ctx, struct nft_rule_expr *e, bool *inv)
 {
-	struct nft_rule_expr *e;
-	const char *name;
 	uint8_t op;
 
-	e = nft_rule_expr_iter_next(iter);
-	if (e == NULL)
-		return;
-
 	/* we assume correct mask and xor */
-	name = nft_rule_expr_get_str(e, NFT_RULE_EXPR_ATTR_NAME);
-	if (strcmp(name, "bitwise") != 0) {
-		DEBUGP("skipping no bitwise after payload\n");
-		return;
-	}
-
-	/* Now check for cmp */
-	e = nft_rule_expr_iter_next(iter);
-	if (e == NULL)
+	if (!(ctx->flags & NFT_XT_CTX_BITWISE))
 		return;
 
 	/* we assume correct data */
-	name = nft_rule_expr_get_str(e, NFT_RULE_EXPR_ATTR_NAME);
-	if (strcmp(name, "cmp") != 0) {
-		DEBUGP("skipping no cmp after payload\n");
-		return;
-	}
-
 	op = nft_rule_expr_get_u32(e, NFT_EXPR_CMP_OP);
 	if (op == NFT_CMP_EQ)
 		*inv = true;
@@ -164,49 +146,61 @@ static const char *mask_to_str(uint32_t mask)
 	return mask_str;
 }
 
-static void nft_ipv4_parse_meta(struct nft_rule_expr *e, uint8_t key,
+static void nft_ipv4_parse_meta(struct nft_xt_ctx *ctx, struct nft_rule_expr *e,
 				void *data)
 {
 	struct iptables_command_state *cs = data;
 
-	parse_meta(e, key, cs->fw.ip.iniface, cs->fw.ip.iniface_mask,
+	parse_meta(e, ctx->meta.key, cs->fw.ip.iniface, cs->fw.ip.iniface_mask,
 		   cs->fw.ip.outiface, cs->fw.ip.outiface_mask,
 		   &cs->fw.ip.invflags);
 }
 
-static void nft_ipv4_parse_payload(struct nft_rule_expr_iter *iter,
-				   uint32_t offset, void *data)
+static void parse_mask_ipv4(struct nft_xt_ctx *ctx, struct in_addr *mask)
 {
-	struct iptables_command_state *cs = data;
+	mask->s_addr = ctx->bitwise.mask[0];
+}
 
-	switch(offset) {
+static void nft_ipv4_parse_payload(struct nft_xt_ctx *ctx,
+				   struct nft_rule_expr *e, void *data)
+{
+	struct iptables_command_state *cs = data;
 	struct in_addr addr;
 	uint8_t proto;
 	bool inv;
 
+	switch(ctx->payload.offset) {
 	case offsetof(struct iphdr, saddr):
-		get_cmp_data(iter, &addr, sizeof(addr), &inv);
+		get_cmp_data(e, &addr, sizeof(addr), &inv);
 		cs->fw.ip.src.s_addr = addr.s_addr;
-		cs->fw.ip.smsk.s_addr = 0xffffffff;
+		if (ctx->flags & NFT_XT_CTX_BITWISE)
+			parse_mask_ipv4(ctx, &cs->fw.ip.smsk);
+		else
+			cs->fw.ip.smsk.s_addr = 0xffffffff;
+
 		if (inv)
 			cs->fw.ip.invflags |= IPT_INV_SRCIP;
 		break;
 	case offsetof(struct iphdr, daddr):
-		get_cmp_data(iter, &addr, sizeof(addr), &inv);
+		get_cmp_data(e, &addr, sizeof(addr), &inv);
 		cs->fw.ip.dst.s_addr = addr.s_addr;
-		cs->fw.ip.dmsk.s_addr = 0xffffffff;
+		if (ctx->flags & NFT_XT_CTX_BITWISE)
+			parse_mask_ipv4(ctx, &cs->fw.ip.dmsk);
+		else
+			cs->fw.ip.dmsk.s_addr = 0xffffffff;
+
 		if (inv)
 			cs->fw.ip.invflags |= IPT_INV_DSTIP;
 		break;
 	case offsetof(struct iphdr, protocol):
-		get_cmp_data(iter, &proto, sizeof(proto), &inv);
+		get_cmp_data(e, &proto, sizeof(proto), &inv);
 		cs->fw.ip.proto = proto;
 		if (inv)
 			cs->fw.ip.invflags |= IPT_INV_PROTO;
 		break;
 	case offsetof(struct iphdr, frag_off):
 		cs->fw.ip.flags |= IPT_F_FRAG;
-		get_frag(iter, &inv);
+		get_frag(ctx, e, &inv);
 		if (inv)
 			cs->fw.ip.invflags |= IPT_INV_FRAG;
 		break;
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 52de5b6..a70afcc 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -38,14 +38,16 @@ static int nft_ipv6_add(struct nft_rule *r, void *data)
 		add_proto(r, offsetof(struct ip6_hdr, ip6_nxt), 1,
 			  cs->fw6.ipv6.proto, cs->fw6.ipv6.invflags);
 
-	if (!IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.src))
+	if (!IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.src)) {
 		add_addr(r, offsetof(struct ip6_hdr, ip6_src),
-			 &cs->fw6.ipv6.src, 16, cs->fw6.ipv6.invflags);
-
-	if (!IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.dst))
+			 &cs->fw6.ipv6.src, &cs->fw6.ipv6.smsk,
+			 sizeof(struct in6_addr), cs->fw6.ipv6.invflags);
+	}
+	if (!IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.dst)) {
 		add_addr(r, offsetof(struct ip6_hdr, ip6_dst),
-			 &cs->fw6.ipv6.dst, 16, cs->fw6.ipv6.invflags);
-
+			 &cs->fw6.ipv6.dst, &cs->fw6.ipv6.dmsk,
+			 sizeof(struct in6_addr), cs->fw6.ipv6.invflags);
+	}
 	add_compat(r, cs->fw6.ipv6.proto, cs->fw6.ipv6.invflags);
 
 	for (matchp = cs->matches; matchp; matchp = matchp->next) {
@@ -87,39 +89,54 @@ static bool nft_ipv6_is_same(const void *data_a,
 				  b->fw6.ipv6.outiface_mask);
 }
 
-static void nft_ipv6_parse_meta(struct nft_rule_expr *e, uint8_t key,
+static void nft_ipv6_parse_meta(struct nft_xt_ctx *ctx, struct nft_rule_expr *e,
 				void *data)
 {
 	struct iptables_command_state *cs = data;
 
-	parse_meta(e, key, cs->fw6.ipv6.iniface,
+	parse_meta(e, ctx->meta.key, cs->fw6.ipv6.iniface,
 		   cs->fw6.ipv6.iniface_mask, cs->fw6.ipv6.outiface,
 		   cs->fw6.ipv6.outiface_mask, &cs->fw6.ipv6.invflags);
 }
 
-static void nft_ipv6_parse_payload(struct nft_rule_expr_iter *iter,
-				   uint32_t offset, void *data)
+static void parse_mask_ipv6(struct nft_xt_ctx *ctx, struct in6_addr *mask)
+{
+	memcpy(mask, ctx->bitwise.mask, sizeof(struct in6_addr));
+}
+
+static void nft_ipv6_parse_payload(struct nft_xt_ctx *ctx,
+				   struct nft_rule_expr *e, void *data)
 {
 	struct iptables_command_state *cs = data;
-	switch (offset) {
 	struct in6_addr addr;
 	uint8_t proto;
 	bool inv;
 
+	switch (ctx->payload.offset) {
 	case offsetof(struct ip6_hdr, ip6_src):
-		get_cmp_data(iter, &addr, sizeof(addr), &inv);
+		get_cmp_data(e, &addr, sizeof(addr), &inv);
 		memcpy(cs->fw6.ipv6.src.s6_addr, &addr, sizeof(addr));
+                if (ctx->flags & NFT_XT_CTX_BITWISE)
+                        parse_mask_ipv6(ctx, &cs->fw6.ipv6.smsk);
+                else
+                        memset(&cs->fw.ip.smsk, 0xff, sizeof(struct in6_addr));
+
 		if (inv)
 			cs->fw6.ipv6.invflags |= IPT_INV_SRCIP;
 		break;
 	case offsetof(struct ip6_hdr, ip6_dst):
-		get_cmp_data(iter, &addr, sizeof(addr), &inv);
+		get_cmp_data(e, &addr, sizeof(addr), &inv);
 		memcpy(cs->fw6.ipv6.dst.s6_addr, &addr, sizeof(addr));
+                if (ctx->flags & NFT_XT_CTX_BITWISE)
+                        parse_mask_ipv6(ctx, &cs->fw6.ipv6.dmsk);
+                else
+                        memset(&cs->fw.ip.dmsk, 0xff, sizeof(struct in6_addr));
+
 		if (inv)
 			cs->fw6.ipv6.invflags |= IPT_INV_DSTIP;
 		break;
 	case offsetof(struct ip6_hdr, ip6_nxt):
-		get_cmp_data(iter, &proto, sizeof(proto), &inv);
+		get_cmp_data(e, &proto, sizeof(proto), &inv);
 		cs->fw6.ipv6.flags |= IP6T_F_PROTO;
 		cs->fw6.ipv6.proto = proto;
 		if (inv)
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 0a4b85a..c22e83d 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -82,6 +82,24 @@ void add_bitwise_u16(struct nft_rule *r, int mask, int xor)
 	nft_rule_add_expr(r, expr);
 }
 
+static void add_bitwise(struct nft_rule *r, uint8_t *mask, size_t len)
+{
+	struct nft_rule_expr *expr;
+	uint32_t xor[4] = { 0 };
+
+	expr = nft_rule_expr_alloc("bitwise");
+	if (expr == NULL)
+		return;
+
+	nft_rule_expr_set_u32(expr, NFT_EXPR_BITWISE_SREG, NFT_REG_1);
+	nft_rule_expr_set_u32(expr, NFT_EXPR_BITWISE_DREG, NFT_REG_1);
+	nft_rule_expr_set_u32(expr, NFT_EXPR_BITWISE_LEN, len);
+	nft_rule_expr_set(expr, NFT_EXPR_BITWISE_MASK, mask, len);
+	nft_rule_expr_set(expr, NFT_EXPR_BITWISE_XOR, &xor, len);
+
+	nft_rule_add_expr(r, expr);
+}
+
 void add_cmp_ptr(struct nft_rule *r, uint32_t op, void *data, size_t len)
 {
 	struct nft_rule_expr *expr;
@@ -151,11 +169,12 @@ void add_outiface(struct nft_rule *r, char *iface, int invflags)
 }
 
 void add_addr(struct nft_rule *r, int offset,
-	      void *data, size_t len, int invflags)
+	      void *data, void *mask, size_t len, int invflags)
 {
 	uint32_t op;
 
 	add_payload(r, offset, len);
+	add_bitwise(r, mask, len);
 
 	if (invflags & IPT_INV_SRCIP || invflags & IPT_INV_DSTIP)
 		op = NFT_CMP_NEQ;
@@ -298,8 +317,8 @@ void nft_parse_target(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
 	const void *targinfo = nft_rule_expr_get(e, NFT_EXPR_TG_INFO, &tg_len);
 	struct xtables_target *target;
 	struct xt_entry_target *t;
-	struct nft_family_ops *ops;
 	size_t size;
+	struct nft_family_ops *ops;
 	void *data = nft_get_data(ctx);
 
 	target = xtables_find_target(targname, XTF_TRY_LOAD);
@@ -365,24 +384,11 @@ void print_proto(uint16_t proto, int invert)
 	printf("-p %u ", proto);
 }
 
-void get_cmp_data(struct nft_rule_expr_iter *iter,
-		  void *data, size_t dlen, bool *inv)
+void get_cmp_data(struct nft_rule_expr *e, void *data, size_t dlen, bool *inv)
 {
-	struct nft_rule_expr *e;
-	const char *name;
 	uint32_t len;
 	uint8_t op;
 
-	e = nft_rule_expr_iter_next(iter);
-	if (e == NULL)
-		return;
-
-	name = nft_rule_expr_get_str(e, NFT_RULE_EXPR_ATTR_NAME);
-	if (strcmp(name, "cmp") != 0) {
-		DEBUGP("skipping no cmp after meta\n");
-		return;
-	}
-
 	memcpy(data, nft_rule_expr_get(e, NFT_EXPR_CMP_DATA, &len), dlen);
 	op = nft_rule_expr_get_u32(e, NFT_EXPR_CMP_OP);
 	if (op == NFT_CMP_NEQ)
@@ -393,33 +399,49 @@ void get_cmp_data(struct nft_rule_expr_iter *iter,
 
 void nft_parse_meta(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
 {
-	uint8_t key = nft_rule_expr_get_u32(e, NFT_EXPR_META_KEY);
-	struct nft_family_ops *ops = nft_family_ops_lookup(ctx->family);
-	const char *name;
-	void *data = nft_get_data(ctx);
+	ctx->reg = nft_rule_expr_get_u32(e, NFT_EXPR_META_DREG);
+	ctx->meta.key = nft_rule_expr_get_u32(e, NFT_EXPR_META_KEY);
+	ctx->flags |= NFT_XT_CTX_META;
+}
 
-	e = nft_rule_expr_iter_next(ctx->iter);
-	if (e == NULL)
-		return;
+void nft_parse_payload(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
+{
+	ctx->reg = nft_rule_expr_get_u32(e, NFT_EXPR_META_DREG);
+	ctx->payload.offset = nft_rule_expr_get_u32(e, NFT_EXPR_PAYLOAD_OFFSET);
+	ctx->flags |= NFT_XT_CTX_PAYLOAD;
+}
+
+void nft_parse_bitwise(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
+{
+	uint32_t reg, len;
+	const void *data;
 
-	name = nft_rule_expr_get_str(e, NFT_RULE_EXPR_ATTR_NAME);
-	if (strcmp(name, "cmp") != 0) {
-		DEBUGP("skipping no cmp after meta\n");
+	reg = nft_rule_expr_get_u32(e, NFT_EXPR_BITWISE_SREG);
+	if (ctx->reg && reg != ctx->reg)
 		return;
-	}
 
-	ops->parse_meta(e, key, data);
+	data = nft_rule_expr_get(e, NFT_EXPR_BITWISE_XOR, &len);
+	memcpy(ctx->bitwise.xor, data, len);
+	data = nft_rule_expr_get(e, NFT_EXPR_BITWISE_MASK, &len);
+	memcpy(ctx->bitwise.mask, data, len);
+	ctx->flags |= NFT_XT_CTX_BITWISE;
 }
 
-void nft_parse_payload(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
+void nft_parse_cmp(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
 {
 	struct nft_family_ops *ops = nft_family_ops_lookup(ctx->family);
-	uint32_t offset;
 	void *data = nft_get_data(ctx);
+	uint32_t reg;
 
-	offset = nft_rule_expr_get_u32(e, NFT_EXPR_PAYLOAD_OFFSET);
+	reg = nft_rule_expr_get_u32(e, NFT_EXPR_CMP_SREG);
+	if (ctx->reg && reg != ctx->reg)
+		return;
 
-	ops->parse_payload(ctx->iter, offset, data);
+	if (ctx->flags & NFT_XT_CTX_META)
+		ops->parse_meta(ctx, e, data);
+	/* bitwise context is interpreted from payload */
+	if (ctx->flags & NFT_XT_CTX_PAYLOAD);
+		ops->parse_payload(ctx, e, data);
 }
 
 void nft_parse_counter(struct nft_rule_expr *e, struct xt_counters *counters)
@@ -486,6 +508,10 @@ void nft_rule_to_iptables_command_state(struct nft_rule *r,
 			nft_parse_payload(&ctx, expr);
 		else if (strcmp(name, "meta") == 0)
 			nft_parse_meta(&ctx, expr);
+		else if (strcmp(name, "bitwise") == 0)
+			nft_parse_bitwise(&ctx, expr);
+		else if (strcmp(name, "cmp") == 0)
+			nft_parse_cmp(&ctx, expr);
 		else if (strcmp(name, "immediate") == 0)
 			nft_parse_immediate(&ctx, expr);
 		else if (strcmp(name, "match") == 0)
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index c4936dd..c383292 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -38,6 +38,12 @@
 
 struct xtables_args;
 
+enum {
+	NFT_XT_CTX_PAYLOAD	= (1 << 0),
+	NFT_XT_CTX_META		= (1 << 1),
+	NFT_XT_CTX_BITWISE	= (1 << 2),
+};
+
 struct nft_xt_ctx {
 	union {
 		struct iptables_command_state *cs;
@@ -46,6 +52,19 @@ struct nft_xt_ctx {
 	struct nft_rule_expr_iter *iter;
 	int family;
 	uint32_t flags;
+
+	uint32_t reg;
+	struct {
+		uint32_t offset;
+		uint32_t len;
+	} payload;
+	struct {
+		uint32_t key;
+	} meta;
+	struct {
+		uint32_t mask[4];
+		uint32_t xor[4];
+	} bitwise;
 };
 
 struct nft_family_ops {
@@ -54,10 +73,14 @@ struct nft_family_ops {
 			const void *data_b);
 	void (*print_payload)(struct nft_rule_expr *e,
 			      struct nft_rule_expr_iter *iter);
-	void (*parse_meta)(struct nft_rule_expr *e, uint8_t key,
+	void (*parse_meta)(struct nft_xt_ctx *ctx, struct nft_rule_expr *e,
 			   void *data);
-	void (*parse_payload)(struct nft_rule_expr_iter *iter,
-			      uint32_t offset, void *data);
+	void (*parse_payload)(struct nft_xt_ctx *ctx, struct nft_rule_expr *e,
+			      void *data);
+	void (*parse_bitwise)(struct nft_xt_ctx *ctx, struct nft_rule_expr *e,
+			      void *data);
+	void (*parse_cmp)(struct nft_xt_ctx *ctx, struct nft_rule_expr *e,
+			  void *data);
 	void (*parse_immediate)(const char *jumpto, bool nft_goto, void *data);
 	void (*print_firewall)(struct nft_rule *r, unsigned int num,
 			       unsigned int format);
@@ -82,7 +105,7 @@ void add_cmp_u32(struct nft_rule *r, uint32_t val, uint32_t op);
 void add_iniface(struct nft_rule *r, char *iface, int invflags);
 void add_outiface(struct nft_rule *r, char *iface, int invflags);
 void add_addr(struct nft_rule *r, int offset,
-	      void *data, size_t len, int invflags);
+	      void *data, void *mask, size_t len, int invflags);
 void add_proto(struct nft_rule *r, int offset, size_t len,
 	       uint8_t proto, int invflags);
 void add_compat(struct nft_rule *r, uint32_t proto, bool inv);
@@ -98,8 +121,9 @@ void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
 		unsigned char *iniface_mask, char *outiface,
 		unsigned char *outiface_mask, uint8_t *invflags);
 void print_proto(uint16_t proto, int invert);
-void get_cmp_data(struct nft_rule_expr_iter *iter,
-		  void *data, size_t dlen, bool *inv);
+void get_cmp_data(struct nft_rule_expr *e, void *data, size_t dlen, bool *inv);
+void nft_parse_bitwise(struct nft_xt_ctx *ctx, struct nft_rule_expr *e);
+void nft_parse_cmp(struct nft_xt_ctx *ctx, struct nft_rule_expr *e);
 void nft_parse_target(struct nft_xt_ctx *ctx, struct nft_rule_expr *e);
 void nft_parse_meta(struct nft_xt_ctx *ctx, struct nft_rule_expr *e);
 void nft_parse_payload(struct nft_xt_ctx *ctx, struct nft_rule_expr *e);
-- 
1.7.10.4

