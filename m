From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - RFC v2 PATCH  05/17] nft: Integrate nft translator engine in current core
Date: Thu, 25 Jul 2013 20:16:25 +0300
Message-ID: <1374772597-20548-6-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374772597-20548-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33431 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab3GYRQu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:16:50 -0400
In-Reply-To: <1374772597-20548-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

First step of using the nft translation engine: supporting basic rule
information to recreat the command structure.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/Makefile.am  |   2 +-
 iptables/nft-ipv4.c   |  23 ++++-
 iptables/nft-ipv6.c   |   9 +-
 iptables/nft-shared.c |  23 +++--
 iptables/nft-shared.h |  10 +-
 iptables/nft.c        | 249 +++++++++++++++++++++++++++++++++++---------------
 6 files changed, 225 insertions(+), 91 deletions(-)

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
index 51ee422..4b8f146 100644
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
index 61c660a..e5c8db9 100644
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
index c0ee4c8..99a7681 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -292,21 +292,16 @@ void print_proto(uint16_t proto, int invert)
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
 
@@ -318,6 +313,18 @@ void get_cmp_data(struct nft_rule_expr_iter *iter,
 		*inv = false;
 }
 
+void get_cmp_data(struct nft_rule_expr_iter *iter,
+		  void *data, size_t dlen, bool *inv)
+{
+	struct nft_rule_expr *e;
+
+	e = nft_rule_expr_iter_next(iter);
+	if (e == NULL)
+		return;
+
+	get_expr_cmp_data(e, data, dlen, inv);
+}
+
 void print_num(uint64_t number, unsigned int format)
 {
 	if (format & FMT_KILOMEGAGIGA) {
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index c59ab21..2c199b4 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -44,7 +44,8 @@ struct nft_family_ops {
 			      struct nft_rule_expr_iter *iter);
 	void (*parse_meta)(struct nft_rule_expr *e, uint8_t key,
 			   struct iptables_command_state *cs);
-	void (*parse_payload)(struct nft_rule_expr_iter *iter,
+	void (*parse_payload)(struct nft_rule_expr *e_1,
+			      struct nft_rule_expr *e_2,
 			      struct iptables_command_state *cs,
 			      uint32_t offset);
 	void (*parse_immediate)(struct iptables_command_state *cs);
@@ -82,6 +83,8 @@ void parse_meta(struct nft_rule_expr *e, uint8_t key, char *iniface,
 		unsigned char *outiface_mask, uint8_t *invflags);
 
 void print_proto(uint16_t proto, int invert);
+void get_expr_cmp_data(struct nft_rule_expr *e,
+		       void *data, size_t dlen, bool *inv);
 void get_cmp_data(struct nft_rule_expr_iter *iter,
 		  void *data, size_t dlen, bool *inv);
 void print_num(uint64_t number, unsigned int format);
@@ -121,6 +124,11 @@ struct xtables_args {
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
index 685a203..7a44e4d 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -46,12 +46,16 @@
 #include <netinet/in.h>	/* inet_ntoa */
 #include <arpa/inet.h>
 
+#include <nft-translator.h>
 #include "nft.h"
 #include "xshared.h" /* proto_to_name */
 #include "nft-shared.h"
 #include "xtables-config-parser.h"
 
+static void initiate_nft_translation_tree(void);
+
 static void *nft_fn;
+struct nft_trans_instruction_tree *xt_nft_tree;
 
 static int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
 		    int (*cb)(const struct nlmsghdr *nlh, void *data),
@@ -403,6 +407,8 @@ int nft_init(struct nft_handle *h)
 	}
 	h->portid = mnl_socket_get_portid(h->nl);
 
+	initiate_nft_translation_tree();
+
 	return 0;
 }
 
@@ -1684,106 +1690,142 @@ next:
 	return 0;
 }
 
-static void
-nft_parse_meta(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-	       int family, struct iptables_command_state *cs)
-{
-	uint8_t key = nft_rule_expr_get_u8(e, NFT_EXPR_META_KEY);
-	struct nft_family_ops *ops = nft_family_ops_lookup(family);
-	const char *name;
-
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
-	ops->parse_meta(e, key, cs);
-}
-
-static void
-nft_parse_payload(struct nft_rule_expr *e, struct nft_rule_expr_iter *iter,
-		  int family, struct iptables_command_state *cs)
+static int nft_parse_counters(struct nft_trans_rule_context *rule_ctx,
+			      struct nft_trans_instruction_context *first,
+			      struct nft_trans_instruction_context *useless,
+			      nft_trans_parse_callback_f user_cb,
+			      void *user_data)
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
+static int nft_parse_verdict(struct nft_trans_rule_context *rule_ctx,
+			     struct nft_trans_instruction_context *first,
+			     struct nft_trans_instruction_context *useless,
+			     nft_trans_parse_callback_f user_cb,
+			     void *user_data)
 {
-	int verdict = nft_rule_expr_get_u32(e, NFT_EXPR_IMM_VERDICT);
-	const char *chain = nft_rule_expr_get_str(e, NFT_EXPR_IMM_CHAIN);
+	struct nft_to_cs_data *i2cs = user_data;
 	struct nft_family_ops *ops;
+	struct nft_rule_expr *e;
+	const char *chain;
+	int verdict;
 
+	e = nft_trans_instruction_context_get_expr(first);
+
+	if (!nft_rule_expr_is_set(e, NFT_EXPR_IMM_VERDICT))
+		return -1;
+
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
+}
+
+static int nft_parse_io_ifs(struct nft_trans_rule_context *rule_ctx,
+			    struct nft_trans_instruction_context *first,
+			    struct nft_trans_instruction_context *second,
+			    nft_trans_parse_callback_f user_cb,
+			    void *user_data)
+{
+	struct nft_to_cs_data *i2cs = user_data;
+	struct nft_family_ops *ops;
+	struct nft_rule_expr *e;
+	uint8_t key;
+
+	e = nft_trans_instruction_context_get_expr(first);
+	if (!nft_rule_expr_is_set(e, NFT_EXPR_META_KEY))
+		return -1;
+
+	key = nft_rule_expr_get_u8(e, NFT_EXPR_META_KEY);
+	ops = nft_family_ops_lookup(i2cs->family);
+
+	e = nft_trans_instruction_context_get_expr(second);
+	ops->parse_meta(e, key, i2cs->cs);
+
+	return 0;
+}
+
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
 }
 
 static void
 nft_rule_to_iptables_command_state(struct nft_rule *r,
 				   struct iptables_command_state *cs)
 {
-	struct nft_rule_expr_iter *iter;
-	struct nft_rule_expr *expr;
-	int family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
-
-	iter = nft_rule_expr_iter_create(r);
-	if (iter == NULL)
-		return;
-
-	expr = nft_rule_expr_iter_next(iter);
-	while (expr != NULL) {
-		const char *name =
-			nft_rule_expr_get_str(expr, NFT_RULE_EXPR_ATTR_NAME);
+	struct nft_to_cs_data i2cs = {};
 
-		if (strcmp(name, "counter") == 0) {
-			nft_parse_counter(expr, iter, &cs->counters);
-		} else if (strcmp(name, "payload") == 0) {
-			nft_parse_payload(expr, iter, family, cs);
-		} else if (strcmp(name, "meta") == 0) {
-			nft_parse_meta(expr, iter, family, cs);
-		} else if (strcmp(name, "immediate") == 0) {
-			nft_parse_immediate(expr, iter, family, cs);
-		}
+	i2cs.family = nft_rule_attr_get_u8(r, NFT_RULE_ATTR_FAMILY);
+	i2cs.cs = cs;
 
-		expr = nft_rule_expr_iter_next(iter);
-	}
+	nft_trans_rule_translate_to_instructions(xt_nft_tree, r, NULL, &i2cs);
 
-	nft_rule_expr_iter_destroy(iter);
+	if (i2cs.cs->target != NULL)
+		i2cs.cs->jumpto = i2cs.cs->target->name;
+	else if (i2cs.cs->jumpto != NULL)
+		i2cs.cs->target = xtables_find_target(i2cs.cs->jumpto,
+								XTF_TRY_LOAD);
+	else
+		i2cs.cs->jumpto = "";
 }
 
 static int matches_howmany(struct xtables_rule_match *matches)
@@ -2839,6 +2881,69 @@ static void xtables_config_perror(uint32_t flags, const char *fmt, ...)
 	va_end(args);
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
+static void initiate_nft_translation_tree(void)
+{
+	xt_nft_tree = nft_trans_instruction_tree_new();
+	if (xt_nft_tree == NULL)
+		return;
+
+	nft_trans_add_instruction(xt_nft_tree, &nft_ipt_counters);
+	nft_trans_add_instruction(xt_nft_tree, &nft_ipt_verdict);
+	nft_trans_add_instruction(xt_nft_tree, &nft_ipt_io_ifs);
+	nft_trans_add_instruction(xt_nft_tree, &nft_ipt_ip_addr_1);
+	nft_trans_add_instruction(xt_nft_tree, &nft_ipt_ip_addr_2);
+}
+
 int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 			    uint32_t flags)
 {
-- 
1.8.3.2

