From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables-compat PATCH 5/5 v2] nft: adds parse_bitwise function
Date: Fri, 22 Aug 2014 11:16:33 +0200
Message-ID: <1408698993-17706-5-git-send-email-giuseppelng@gmail.com>
References: <1408698993-17706-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:59364 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbaHVJND (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:13:03 -0400
Received: by mail-wg0-f49.google.com with SMTP id k14so10194287wgh.20
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Aug 2014 02:13:01 -0700 (PDT)
In-Reply-To: <1408698993-17706-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a function that returns the mask associated to a rule

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-arp.c    |  4 +++-
 iptables/nft-ipv4.c   | 24 +++++++++++++++++++++---
 iptables/nft-ipv6.c   | 21 ++++++++++++++++++++-
 iptables/nft-shared.c | 19 +++++++++++++++----
 iptables/nft-shared.h |  8 +++++++-
 5 files changed, 66 insertions(+), 10 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index c9dbee6..4fff793 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -309,7 +309,8 @@ static void nft_arp_parse_immediate(const char *jumpto, bool nft_goto,
 }
 
 static void nft_arp_parse_payload(struct nft_rule_expr_iter *iter,
-				  uint32_t offset, void *data)
+				  uint32_t offset, void *data,
+				  uint32_t *flags)
 {
 	struct arpt_entry *fw = data;
 	struct in_addr addr;
@@ -695,6 +696,7 @@ struct nft_family_ops nft_family_ops_arp = {
 	.parse_meta		= nft_arp_parse_meta,
 	.parse_payload		= nft_arp_parse_payload,
 	.parse_immediate	= nft_arp_parse_immediate,
+	.parse_bitwise		= NULL,
 	.print_firewall		= nft_arp_print_firewall,
 	.save_firewall		= nft_arp_save_firewall,
 	.save_counters		= nft_arp_save_counters,
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 6e520b2..8af1a3c 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -177,7 +177,8 @@ static void nft_ipv4_parse_meta(struct nft_rule_expr *e, uint8_t key,
 }
 
 static void nft_ipv4_parse_payload(struct nft_rule_expr_iter *iter,
-				   uint32_t offset, void *data)
+				   uint32_t offset, void *data,
+				   uint32_t *flags)
 {
 	struct iptables_command_state *cs = data;
 
@@ -189,14 +190,14 @@ static void nft_ipv4_parse_payload(struct nft_rule_expr_iter *iter,
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
@@ -218,6 +219,22 @@ static void nft_ipv4_parse_payload(struct nft_rule_expr_iter *iter,
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
@@ -423,6 +440,7 @@ struct nft_family_ops nft_family_ops_ipv4 = {
 	.parse_meta		= nft_ipv4_parse_meta,
 	.parse_payload		= nft_ipv4_parse_payload,
 	.parse_immediate	= nft_ipv4_parse_immediate,
+	.parse_bitwise		= nft_ipv4_parse_bitwise,
 	.print_firewall		= nft_ipv4_print_firewall,
 	.save_firewall		= nft_ipv4_save_firewall,
 	.save_counters		= nft_ipv4_save_counters,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 662c563..1351823 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -100,7 +100,8 @@ static void nft_ipv6_parse_meta(struct nft_rule_expr *e, uint8_t key,
 }
 
 static void nft_ipv6_parse_payload(struct nft_rule_expr_iter *iter,
-				   uint32_t offset, void *data)
+				   uint32_t offset, void *data,
+				   uint32_t *flags)
 {
 	struct iptables_command_state *cs = data;
 	switch (offset) {
@@ -111,12 +112,14 @@ static void nft_ipv6_parse_payload(struct nft_rule_expr_iter *iter,
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
@@ -143,6 +146,21 @@ static void nft_ipv6_parse_immediate(const char *jumpto, bool nft_goto,
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
@@ -345,6 +363,7 @@ struct nft_family_ops nft_family_ops_ipv6 = {
 	.parse_meta		= nft_ipv6_parse_meta,
 	.parse_payload		= nft_ipv6_parse_payload,
 	.parse_immediate	= nft_ipv6_parse_immediate,
+	.parse_bitwise		= nft_ipv6_parse_bitwise,
 	.print_firewall		= nft_ipv6_print_firewall,
 	.save_firewall		= nft_ipv6_save_firewall,
 	.save_counters		= nft_ipv6_save_counters,
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 2dcdfd1..de5f018 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -199,10 +199,11 @@ void add_addr(struct nft_rule *r, int family, int offset,
 	add_cmp_ptr(r, op, data, len);
 
 	if (family == AF_INET) {
-		uint32_t *msk = mask;
-		add_bitwise_u32(r, *msk, 0x00000000);
+		uint32_t *mask4 = mask;
+		uint32_t xor = 0;
+		add_bitwise_u32(r, *mask4, xor);
 	} else {
-		uint8_t mask6[16] = {0};
+		uint8_t *mask6 = mask;
 		uint8_t xor[16] = {0};
 		add_bitwise_u128(r, mask6, xor);
 	}
@@ -464,7 +465,7 @@ nft_parse_payload(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
 
 	offset = nft_rule_expr_get_u32(e, NFT_EXPR_PAYLOAD_OFFSET);
 
-	ops->parse_payload(ctx->iter, offset, data);
+	ops->parse_payload(ctx->iter, offset, data, &ctx->flags);
 }
 
 void
@@ -506,6 +507,14 @@ nft_parse_immediate(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
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
@@ -532,6 +541,8 @@ void nft_rule_to_iptables_command_state(struct nft_rule *r,
 			nft_parse_counter(expr, &ctx.state.cs->counters);
 		else if (strcmp(name, "payload") == 0)
 			nft_parse_payload(&ctx, expr);
+		else if (strcmp(name, "bitwise") == 0)
+			nft_parse_bitwise(&ctx, expr);
 		else if (strcmp(name, "meta") == 0)
 			nft_parse_meta(&ctx, expr);
 		else if (strcmp(name, "immediate") == 0)
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index e5b6f1d..834ea32 100644
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
@@ -107,6 +112,7 @@ void nft_parse_meta(struct nft_xt_ctx *ctx, struct nft_rule_expr *e);
 void nft_parse_payload(struct nft_xt_ctx *ctx, struct nft_rule_expr *e);
 void nft_parse_counter(struct nft_rule_expr *e, struct xt_counters *counters);
 void nft_parse_immediate(struct nft_xt_ctx *ctx, struct nft_rule_expr *e);
+void nft_parse_bitwise(struct nft_xt_ctx *ctx, struct nft_rule_expr *e);
 void nft_rule_to_iptables_command_state(struct nft_rule *r,
 					struct iptables_command_state *cs);
 void print_firewall_details(const struct iptables_command_state *cs,
-- 
1.8.3.2

