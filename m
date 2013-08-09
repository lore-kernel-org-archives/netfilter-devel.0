From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables RFC v3 PATCH 04/16] nft: Integrate nft translator engine in current core
Date: Fri,  9 Aug 2013 16:31:18 +0300
Message-ID: <1376055090-26551-5-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: netfilter-devel@vger.kernel.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:11450 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967795Ab3HINbo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:31:44 -0400
In-Reply-To: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

First step of using the nft translation engine: supporting basic rule
information to recreat the command structure.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/Makefile.am  |   2 +-
 iptables/nft-ipv4.c   |  23 ++++-
 iptables/nft-ipv6.c   |   9 +-
 iptables/nft-shared.c | 255 ++++++++++++++++++++++++++++++++++++--------------
 iptables/nft-shared.h |  16 +++-
 iptables/nft.c        |   3 +
 6 files changed, 224 insertions(+), 84 deletions(-)

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index dc8af34..3a7983c 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -32,7 +32,7 @@ xtables_multi_SOURCES += xtables-save.c xtables-restore.c \
 			 xtables-standalone.c xtables.c nft.c \
 			 nft-shared.c nft-ipv4.c nft-ipv6.c \
 			 xtables-config.c xtables-events.c
-xtables_multi_LDADD   += -lmnl -lnftables ${libmnl_LIBS} ${libnftables_LIBS}
+xtables_multi_LDADD   += -lmnl -lnftables ${libmnl_LIBS} ${libnftables_LIBS} ../libnfttrans/libnfttrans.la
 xtables_multi_CFLAGS  += -DENABLE_NFTABLES
 # yacc and lex generate dirty code
 xtables_multi-xtables-config-parser.o xtables_multi-xtables-config-syntax.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-declarations -Wno-implicit-function-declaration -Wno-nested-externs -Wno-undef -Wno-redundant-decls
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 81be9f4..038d04f 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -85,6 +85,18 @@ static bool nft_ipv4_is_same(const struct iptables_command_state *a,
 				  b->fw.ip.iniface_mask, b->fw.ip.outiface_mask);
 }
 
+static void get_frag_from_expr(struct nft_rule_expr *e, bool *inv)
+{
+	uint8_t op;
+
+	/* e is directly pointing to the cmp expr */
+	op = nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP);
+	if (op == NFT_CMP_EQ)
+		*inv = true;
+	else
+		*inv = false;
+}
+
 static void get_frag(struct nft_rule_expr_iter *iter, bool *inv)
 {
 	struct nft_rule_expr *e;
@@ -207,7 +219,8 @@ static void nft_ipv4_parse_meta(struct nft_rule_expr *e, uint8_t key,
 		   &cs->fw.ip.invflags);
 }
 
-static void nft_ipv4_parse_payload(struct nft_rule_expr_iter *iter,
+static void nft_ipv4_parse_payload(struct nft_rule_expr *e_1,
+				   struct nft_rule_expr *e_2,
 				   struct iptables_command_state *cs,
 				   uint32_t offset)
 {
@@ -217,28 +230,28 @@ static void nft_ipv4_parse_payload(struct nft_rule_expr_iter *iter,
 	bool inv;
 
 	case offsetof(struct iphdr, saddr):
-		get_cmp_data(iter, &addr, sizeof(addr), &inv);
+		get_expr_cmp_data(e_1, &addr, sizeof(addr), &inv);
 		cs->fw.ip.src.s_addr = addr.s_addr;
 		cs->fw.ip.smsk.s_addr = 0xffffffff;
 		if (inv)
 			cs->fw.ip.invflags |= IPT_INV_SRCIP;
 		break;
 	case offsetof(struct iphdr, daddr):
-		get_cmp_data(iter, &addr, sizeof(addr), &inv);
+		get_expr_cmp_data(e_1, &addr, sizeof(addr), &inv);
 		cs->fw.ip.dst.s_addr = addr.s_addr;
 		cs->fw.ip.dmsk.s_addr = 0xffffffff;
 		if (inv)
 			cs->fw.ip.invflags |= IPT_INV_DSTIP;
 		break;
 	case offsetof(struct iphdr, protocol):
-		get_cmp_data(iter, &proto, sizeof(proto), &inv);
+		get_expr_cmp_data(e_1, &proto, sizeof(proto), &inv);
 		cs->fw.ip.proto = proto;
 		if (inv)
 			cs->fw.ip.invflags |= IPT_INV_PROTO;
 		break;
 	case offsetof(struct iphdr, frag_off):
 		cs->fw.ip.flags |= IPT_F_FRAG;
-		get_frag(iter, &inv);
+		get_frag_from_expr(e_2, &inv);
 		if (inv)
 			cs->fw.ip.invflags |= IPT_INV_FRAG;
 		break;
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 0214dcf..5c79912 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -119,7 +119,8 @@ static void nft_ipv6_parse_meta(struct nft_rule_expr *e, uint8_t key,
 		   cs->fw6.ipv6.outiface_mask, &cs->fw6.ipv6.invflags);
 }
 
-static void nft_ipv6_parse_payload(struct nft_rule_expr_iter *iter,
+static void nft_ipv6_parse_payload(struct nft_rule_expr *e_1,
+				   struct nft_rule_expr *e_2,
 				   struct iptables_command_state *cs,
 				   uint32_t offset)
 {
@@ -129,19 +130,19 @@ static void nft_ipv6_parse_payload(struct nft_rule_expr_iter *iter,
 	bool inv;
 
 	case offsetof(struct ip6_hdr, ip6_src):
-		get_cmp_data(iter, &addr, sizeof(addr), &inv);
+		get_expr_cmp_data(e_1, &addr, sizeof(addr), &inv);
 		memcpy(cs->fw6.ipv6.src.s6_addr, &addr, sizeof(addr));
 		if (inv)
 			cs->fw6.ipv6.invflags |= IPT_INV_SRCIP;
 		break;
 	case offsetof(struct ip6_hdr, ip6_dst):
-		get_cmp_data(iter, &addr, sizeof(addr), &inv);
+		get_expr_cmp_data(e_1, &addr, sizeof(addr), &inv);
 		memcpy(cs->fw6.ipv6.dst.s6_addr, &addr, sizeof(addr));
 		if (inv)
 			cs->fw6.ipv6.invflags |= IPT_INV_DSTIP;
 		break;
 	case offsetof(struct ip6_hdr, ip6_nxt):
-		get_cmp_data(iter, &proto, sizeof(proto), &inv);
+		get_expr_cmp_data(e_1, &proto, sizeof(proto), &inv);
 		cs->fw6.ipv6.flags |= IP6T_F_PROTO;
 		cs->fw6.ipv6.proto = proto;
 		if (inv)
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index dd4766b..614b7ae 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -28,6 +28,8 @@
 #include "nft-shared.h"
 #include "xshared.h"
 
+struct nft_trans_instruction_tree *xt_nft_tree;
+
 extern struct nft_family_ops nft_family_ops_ipv4;
 extern struct nft_family_ops nft_family_ops_ipv6;
 
@@ -349,21 +351,16 @@ void print_proto(uint16_t proto, int invert)
 	printf("-p %u ", proto);
 }
 
-void get_cmp_data(struct nft_rule_expr_iter *iter,
-		  void *data, size_t dlen, bool *inv)
+void get_expr_cmp_data(struct nft_rule_expr *e,
+		       void *data, size_t dlen, bool *inv)
 {
-	struct nft_rule_expr *e;
 	const char *name;
 	size_t len;
 	uint8_t op;
 
-	e = nft_rule_expr_iter_next(iter);
-	if (e == NULL)
-		return;
-
 	name = nft_rule_expr_get_str(e, NFT_RULE_EXPR_ATTR_NAME);
 	if (strcmp(name, "cmp") != 0) {
-		DEBUGP("skipping no cmp after meta\n");
+		DEBUGP("skipping - Not a cmp expression\n");
 		return;
 	}
 
@@ -375,105 +372,154 @@ void get_cmp_data(struct nft_rule_expr_iter *iter,
 		*inv = false;
 }
 
-static void
-nft_parse_meta(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-	       int family, struct iptables_command_state *cs)
+void get_cmp_data(struct nft_rule_expr_iter *iter,
+		  void *data, size_t dlen, bool *inv)
 {
-	uint8_t key = nft_rule_expr_get_u8(e, NFT_EXPR_META_KEY);
-	struct nft_family_ops *ops = nft_family_ops_lookup(family);
-	const char *name;
+	struct nft_rule_expr *e;
 
 	e = nft_rule_expr_iter_next(iter);
 	if (e == NULL)
 		return;
 
-	name = nft_rule_expr_get_str(e, NFT_RULE_EXPR_ATTR_NAME);
-	if (strcmp(name, "cmp") != 0) {
-		DEBUGP("skipping no cmp after meta\n");
-		return;
-	}
-
-	ops->parse_meta(e, key, cs);
+	get_expr_cmp_data(e, data, dlen, inv);
 }
 
-static void
-nft_parse_payload(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-		  int family, struct iptables_command_state *cs)
+static int
+nft_parse_counters(struct nft_trans_rule_context *rule_ctx,
+		   struct nft_trans_instruction_context *first,
+		   struct nft_trans_instruction_context *useless,
+		   nft_trans_parse_callback_f user_cb,
+		   void *user_data)
 {
-	struct nft_family_ops *ops = nft_family_ops_lookup(family);
-	uint32_t offset;
+	struct nft_to_cs_data *i2cs = user_data;
+	struct xt_counters *counters;
+	struct nft_rule_expr *e;
 
-	offset = nft_rule_expr_get_u32(e, NFT_EXPR_PAYLOAD_OFFSET);
+	e = nft_trans_instruction_context_get_expr(first);
 
-	ops->parse_payload(iter, cs, offset);
-}
+	if (!nft_rule_expr_is_set(e, NFT_EXPR_CTR_PACKETS) ||
+				!nft_rule_expr_is_set(e, NFT_EXPR_CTR_BYTES))
+		return -1;
 
-static void
-nft_parse_counter(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-		  struct xt_counters *counters)
-{
+	counters = &i2cs->cs->counters;
 	counters->pcnt = nft_rule_expr_get_u64(e, NFT_EXPR_CTR_PACKETS);
 	counters->bcnt = nft_rule_expr_get_u64(e, NFT_EXPR_CTR_BYTES);
+
+	return 0;
 }
 
-static void
-nft_parse_immediate(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-		    int family, struct iptables_command_state *cs)
+static int
+nft_parse_verdict(struct nft_trans_rule_context *rule_ctx,
+		  struct nft_trans_instruction_context *first,
+		  struct nft_trans_instruction_context *useless,
+		  nft_trans_parse_callback_f user_cb,
+		  void *user_data)
 {
-	int verdict = nft_rule_expr_get_u32(e, NFT_EXPR_IMM_VERDICT);
-	const char *chain = nft_rule_expr_get_str(e, NFT_EXPR_IMM_CHAIN);
+	struct nft_to_cs_data *i2cs = user_data;
 	struct nft_family_ops *ops;
+	struct nft_rule_expr *e;
+	const char *chain;
+	int verdict;
+
+	e = nft_trans_instruction_context_get_expr(first);
+	if (!nft_rule_expr_is_set(e, NFT_EXPR_IMM_VERDICT))
+		return -1;
 
+	verdict = nft_rule_expr_get_u32(e, NFT_EXPR_IMM_VERDICT);
 	/* Standard target? */
 	switch(verdict) {
 	case NF_ACCEPT:
-		cs->jumpto = "ACCEPT";
-		return;
+		i2cs->cs->jumpto = "ACCEPT";
+		break;
 	case NF_DROP:
-		cs->jumpto = "DROP";
-		return;
+		i2cs->cs->jumpto = "DROP";
+		break;
 	case NFT_RETURN:
-		cs->jumpto = "RETURN";
-		return;
+		i2cs->cs->jumpto = "RETURN";
+		break;
 	case NFT_GOTO:
-		ops = nft_family_ops_lookup(family);
-		ops->parse_immediate(cs);
+		ops = nft_family_ops_lookup(i2cs->family);
+		ops->parse_immediate(i2cs->cs);
 	case NFT_JUMP:
-		cs->jumpto = chain;
-		return;
+		if (!nft_rule_expr_is_set(e, NFT_EXPR_IMM_CHAIN))
+			return -1;
+
+		chain = nft_rule_expr_get_str(e, NFT_EXPR_IMM_CHAIN);
+		i2cs->cs->jumpto = chain;
+		break;
 	}
+
+	return 0;
 }
 
-void nft_rule_to_iptables_command_state(struct nft_rule *r,
-					struct iptables_command_state *cs)
+static int nft_parse_io_ifs(struct nft_trans_rule_context *rule_ctx,
+			    struct nft_trans_instruction_context *first,
+			    struct nft_trans_instruction_context *second,
+			    nft_trans_parse_callback_f user_cb,
+			    void *user_data)
 {
-	struct nft_rule_expr_iter *iter;
-	struct nft_rule_expr *expr;
-	int family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
+	struct nft_to_cs_data *i2cs = user_data;
+	struct nft_family_ops *ops;
+	struct nft_rule_expr *e;
+	uint8_t key;
 
-	iter = nft_rule_expr_iter_create(r);
-	if (iter == NULL)
-		return;
+	e = nft_trans_instruction_context_get_expr(first);
+	if (!nft_rule_expr_is_set(e, NFT_EXPR_META_KEY))
+		return -1;
 
-	expr = nft_rule_expr_iter_next(iter);
-	while (expr != NULL) {
-		const char *name =
-			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
+	key = nft_rule_expr_get_u8(e, NFT_EXPR_META_KEY);
+	ops = nft_family_ops_lookup(i2cs->family);
 
-		if (strcmp(name, "counter") == 0) {
-			nft_parse_counter(expr, iter, &cs->counters);
-		} else if (strcmp(name, "payload") == 0) {
-			nft_parse_payload(expr, iter, family, cs);
-		} else if (strcmp(name, "meta") == 0) {
-			nft_parse_meta(expr, iter, family, cs);
-		} else if (strcmp(name, "immediate") == 0) {
-			nft_parse_immediate(expr, iter, family, cs);
-		}
+	e = nft_trans_instruction_context_get_expr(second);
+	ops->parse_meta(e, key, i2cs->cs);
 
-		expr = nft_rule_expr_iter_next(iter);
-	}
+	return 0;
+}
 
-	nft_rule_expr_iter_destroy(iter);
+static int nft_parse_ip_addresses(struct nft_trans_rule_context *rule_ctx,
+				  struct nft_trans_instruction_context *first,
+				  struct nft_trans_instruction_context *last,
+				  nft_trans_parse_callback_f user_cb,
+				  void *user_data)
+{
+	struct nft_to_cs_data *i2cs = user_data;
+	struct nft_rule_expr *e1, *e2;
+	struct nft_family_ops *ops;
+	uint32_t offset;
+
+	e1 = nft_trans_instruction_context_get_expr(first);
+	if (!nft_rule_expr_is_set(e1, NFT_EXPR_PAYLOAD_OFFSET))
+		return -1;
+
+	offset = nft_rule_expr_get_u32(e1, NFT_EXPR_PAYLOAD_OFFSET);
+	ops = nft_family_ops_lookup(i2cs->family);
+
+	first = nft_trans_instruction_context_get_next(first);
+	e1 = nft_trans_instruction_context_get_expr(first);
+	e2 = nft_trans_instruction_context_get_expr(last);
+
+	ops->parse_payload(e1, e2, i2cs->cs, offset);
+
+	return 0;
+}
+
+void nft_rule_to_iptables_command_state(struct nft_rule *r,
+					struct iptables_command_state *cs)
+{
+	struct nft_to_cs_data i2cs = {};
+
+	i2cs.family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
+	i2cs.cs = cs;
+
+	nft_trans_rule_translate_to_instructions(xt_nft_tree, r, NULL, &i2cs);
+
+	if (i2cs.cs->target != NULL)
+		i2cs.cs->jumpto = i2cs.cs->target->name;
+	else if (i2cs.cs->jumpto != NULL)
+		i2cs.cs->target = xtables_find_target(i2cs.cs->jumpto,
+							XTF_TRY_LOAD);
+	else
+		i2cs.cs->jumpto = "";
 }
 
 static void
@@ -646,6 +692,71 @@ void print_firewall_details(const struct iptables_command_state *cs,
 	}
 }
 
+static enum nft_instruction nft_ipt_counters_instructions[] = {
+	NFT_INSTRUCTION_COUNTER,
+	NFT_INSTRUCTION_MAX,
+};
+
+static struct nft_trans_instruction nft_ipt_counters = {
+	.instructions = nft_ipt_counters_instructions,
+	.function = nft_parse_counters,
+};
+
+static enum nft_instruction nft_ipt_verdict_instructions[] = {
+	NFT_INSTRUCTION_IMMEDIATE,
+	NFT_INSTRUCTION_MAX,
+};
+
+static struct nft_trans_instruction nft_ipt_verdict = {
+	.instructions = nft_ipt_verdict_instructions,
+	.function = nft_parse_verdict,
+};
+
+static enum nft_instruction nft_ipt_io_ifs_instructions[] = {
+	NFT_INSTRUCTION_META, NFT_INSTRUCTION_CMP,
+	NFT_INSTRUCTION_MAX,
+};
+
+static struct nft_trans_instruction nft_ipt_io_ifs = {
+	.instructions = nft_ipt_io_ifs_instructions,
+	.function = nft_parse_io_ifs,
+};
+
+static enum nft_instruction nft_ipt_ip_addr_instructions_1[] = {
+	NFT_INSTRUCTION_PAYLOAD, NFT_INSTRUCTION_CMP,
+	NFT_INSTRUCTION_MAX,
+};
+
+static struct nft_trans_instruction nft_ipt_ip_addr_1 = {
+	.instructions = nft_ipt_ip_addr_instructions_1,
+	.function = nft_parse_ip_addresses,
+};
+
+static enum nft_instruction nft_ipt_ip_addr_instructions_2[] = {
+	NFT_INSTRUCTION_PAYLOAD, NFT_INSTRUCTION_BITWISE, NFT_INSTRUCTION_CMP,
+	NFT_INSTRUCTION_MAX,
+};
+
+static struct nft_trans_instruction nft_ipt_ip_addr_2 = {
+	.instructions = nft_ipt_ip_addr_instructions_2,
+	.function = nft_parse_ip_addresses,
+};
+
+int nft_initiate_translation_tree(void)
+{
+	xt_nft_tree = nft_trans_instruction_tree_new();
+	if (xt_nft_tree == NULL)
+		return -1;
+
+	nft_trans_add_instruction(xt_nft_tree, &nft_ipt_counters);
+	nft_trans_add_instruction(xt_nft_tree, &nft_ipt_verdict);
+	nft_trans_add_instruction(xt_nft_tree, &nft_ipt_io_ifs);
+	nft_trans_add_instruction(xt_nft_tree, &nft_ipt_ip_addr_1);
+	nft_trans_add_instruction(xt_nft_tree, &nft_ipt_ip_addr_2);
+
+	return 0;
+}
+
 struct nft_family_ops *nft_family_ops_lookup(int family)
 {
 	switch (family) {
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 488ed63..176abed 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -6,6 +6,8 @@
 #include <libnftables/rule.h>
 #include <libnftables/expr.h>
 
+#include <nft-translator.h>
+
 #include "xshared.h"
 
 #if 0
@@ -34,6 +36,8 @@
 			| FMT_NUMERIC | FMT_NOTABLE)
 #define FMT(tab,notab) ((format) & FMT_NOTABLE ? (notab) : (tab))
 
+extern struct nft_trans_instruction_tree *xt_nft_tree;
+
 struct xtables_args;
 
 struct nft_family_ops {
@@ -44,7 +48,8 @@ struct nft_family_ops {
 			      struct nft_rule_expr_iter *iter);
 	void (*parse_meta)(struct nft_rule_expr *e, uint8_t key,
 			   struct iptables_command_state *cs);
-	void (*parse_payload)(struct nft_rule_expr_iter *iter,
+	void (*parse_payload)(struct nft_rule_expr *e_1,
+			      struct nft_rule_expr *e_2,
 			      struct iptables_command_state *cs,
 			      uint32_t offset);
 	void (*parse_immediate)(struct iptables_command_state *cs);
@@ -82,6 +87,8 @@ void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
 const char *nft_parse_target(struct nft_rule *r, const void **targinfo,
 			     size_t *target_len);
 void print_proto(uint16_t proto, int invert);
+void get_expr_cmp_data(struct nft_rule_expr *e,
+		       void *data, size_t dlen, bool *inv);
 void get_cmp_data(struct nft_rule_expr_iter *iter,
 		  void *data, size_t dlen, bool *inv);
 void nft_rule_to_iptables_command_state(struct nft_rule *r,
@@ -95,7 +102,7 @@ void print_firewall_details(const struct iptables_command_state *cs,
 			    uint8_t invflags, uint8_t proto,
 			    const char *iniface, const char *outiface,
 			    unsigned int num, unsigned int format);
-
+int nft_initiate_translation_tree(void);
 struct nft_family_ops *nft_family_ops_lookup(int family);
 
 struct addr_mask {
@@ -126,6 +133,11 @@ struct xtables_args {
 	unsigned long long pcnt_cnt, bcnt_cnt;
 };
 
+struct nft_to_cs_data {
+	int family;
+	struct iptables_command_state *cs;
+};
+
 #define CMD_NONE		0x0000U
 #define CMD_INSERT		0x0001U
 #define CMD_DELETE		0x0002U
diff --git a/iptables/nft.c b/iptables/nft.c
index d92e8bb..7171752 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -388,6 +388,9 @@ int nft_init(struct nft_handle *h, struct builtin_table *t)
 	h->portid = mnl_socket_get_portid(h->nl);
 	h->tables = t;
 
+	if (nft_initiate_translation_tree() != 0)
+		return -1;
+
 	return 0;
 }
 
-- 
1.8.3.2

