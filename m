From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables RFC v3 PATCH 14/16] xtables: Support pure nft expressions for DNAT extension
Date: Fri,  9 Aug 2013 16:31:28 +0300
Message-ID: <1376055090-26551-15-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: netfilter-devel@vger.kernel.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:11450 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967780Ab3HINcC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:32:02 -0400
In-Reply-To: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add the support for DNAT xtables extensions to be expressed directly into
pure nft expression and not more via the compatible expression "target".
Provide also the function to register the different pattern of such
extension when expressed purely in nft so it can be parsed back, and the
memory blob can be recreated. Given callback from the core will then
feed the command structure relevantly.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 extensions/libipt_DNAT.c | 221 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 221 insertions(+)

diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index ff18799..f6f0769 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -7,6 +7,7 @@
 #include <limits.h> /* INT_MAX in ip_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter/nf_nat.h>
+#include <linux/netfilter/nf_tables.h>
 
 enum {
 	O_TO_DEST = 0,
@@ -242,6 +243,224 @@ static void DNAT_save(const void *ip, const struct xt_entry_target *target)
 	}
 }
 
+static struct nft_rule_expr *
+add_nat_data(struct nft_rule *rule, int reg, uint32_t data)
+{
+	struct nft_rule_expr *expr;
+
+	expr = nft_rule_expr_alloc("immediate");
+	if (expr == NULL)
+		return NULL;
+
+	nft_rule_expr_set_u32(expr, NFT_EXPR_IMM_DREG, reg);
+	nft_rule_expr_set_u32(expr, NFT_EXPR_IMM_DATA, data);
+
+	nft_rule_add_expr(rule, expr);
+
+	return expr;
+}
+
+static int add_nat_expr(struct nft_rule *rule,
+			const struct nf_nat_ipv4_range *r)
+{
+	struct nft_rule_expr *nat_expr;
+	int registers = 1;
+
+	nat_expr = nft_rule_expr_alloc("nat");
+	if (nat_expr == NULL)
+		return -1;
+
+	nft_rule_expr_set_u32(nat_expr, NFT_EXPR_NAT_TYPE, NFT_NAT_DNAT);
+	nft_rule_expr_set_u32(nat_expr, NFT_EXPR_NAT_FAMILY, AF_INET);
+
+	if (r->flags & NF_NAT_RANGE_MAP_IPS) {
+		nft_rule_expr_set_u32(nat_expr, NFT_EXPR_NAT_REG_ADDR_MIN,
+				      registers);
+		if (add_nat_data(rule, registers, r->min_ip) == NULL)
+			goto error;
+		registers++;
+
+		if (r->max_ip != r->min_ip) {
+			nft_rule_expr_set_u32(nat_expr,
+					      NFT_EXPR_NAT_REG_ADDR_MAX,
+					      registers);
+			if (add_nat_data(rule, registers, r->max_ip) == NULL)
+				goto error;
+			registers++;
+		}
+	}
+
+	if (r->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
+		nft_rule_expr_set_u32(nat_expr, NFT_EXPR_NAT_REG_PROTO_MIN,
+				      registers);
+		if (add_nat_data(rule, registers,
+					ntohs(r->min.tcp.port)) == NULL)
+			goto error;
+		registers++;
+
+		if (r->max.tcp.port != r->min.tcp.port) {
+			nft_rule_expr_set_u32(nat_expr,
+					      NFT_EXPR_NAT_REG_PROTO_MAX,
+					      registers);
+			if (add_nat_data(rule, registers,
+					ntohs(r->max.tcp.port)) == NULL)
+				goto error;
+		}
+	}
+
+	nft_rule_add_expr(rule, nat_expr);
+
+	return 0;
+
+error:
+	nft_rule_expr_free(nat_expr);
+	return -1;
+}
+
+static int DNAT_to_nft(struct nft_rule *rule, struct xt_entry_target *target)
+{
+	const struct ipt_natinfo *info = (const void *)target;
+	int i;
+
+	for (i = 0; i < info->mr.rangesize; i++) {
+		if (add_nat_expr(rule, &info->mr.range[i]) < 0)
+			return -1;
+	}
+
+	return 0;
+}
+
+static inline void get_nat_port(struct nft_rule_expr *expr, uint16_t *data)
+{
+	uint32_t value;
+
+	value = nft_rule_expr_get_u32(expr, NFT_EXPR_IMM_DATA);
+	*data = htons((uint16_t) value);
+}
+
+static int DNAT_parse_nft(struct nft_trans_rule_context *rule_ctx,
+			  struct nft_trans_instruction_context *first,
+			  struct nft_trans_instruction_context *last,
+			  nft_trans_parse_callback_f user_cb,
+			  void *user_data)
+{
+	struct nft_rule_expr *e_nat, *e;
+	struct nf_nat_ipv4_range range;
+	struct ipt_natinfo *info;
+	uint32_t type, reg;
+
+	if (user_cb == NULL)
+		return -1;
+
+	e_nat = nft_trans_instruction_context_get_expr(last);
+
+	if (!nft_rule_expr_is_set(e_nat, NFT_EXPR_NAT_TYPE))
+		return -1;
+
+	type = nft_rule_expr_get_u32(e_nat, NFT_EXPR_NAT_TYPE);
+	if (type != NFT_NAT_DNAT)
+		return -1;
+
+	if (nft_rule_expr_is_set(e_nat, NFT_EXPR_NAT_REG_ADDR_MIN)) {
+		range.flags |= NF_NAT_RANGE_MAP_IPS;
+
+		reg = nft_rule_expr_get_u32(e_nat, NFT_EXPR_NAT_REG_ADDR_MIN);
+		e = nft_trans_instruction_context_get_register(last, reg);
+		range.min_ip = nft_rule_expr_get_u32(e, NFT_EXPR_IMM_DATA);
+
+		if (nft_rule_expr_is_set(e_nat,	NFT_EXPR_NAT_REG_ADDR_MAX)) {
+			reg = nft_rule_expr_get_u32(e_nat,
+						NFT_EXPR_NAT_REG_ADDR_MAX);
+			e = nft_trans_instruction_context_get_register(last, reg);
+			range.max_ip = nft_rule_expr_get_u32(e,
+							NFT_EXPR_IMM_DATA);
+		} else
+			range.max_ip = range.min_ip;
+	}
+
+	if (nft_rule_expr_is_set(e_nat, NFT_EXPR_NAT_REG_PROTO_MIN)) {
+		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
+
+		reg = nft_rule_expr_get_u32(e_nat, NFT_EXPR_NAT_REG_PROTO_MIN);
+		e = nft_trans_instruction_context_get_register(last, reg);
+		get_nat_port(e, &range.min.tcp.port);
+
+		if (nft_rule_expr_is_set(e_nat, NFT_EXPR_NAT_REG_PROTO_MAX)) {
+			reg = nft_rule_expr_get_u32(e_nat,
+						NFT_EXPR_NAT_REG_PROTO_MAX);
+			e = nft_trans_instruction_context_get_register(last, reg);
+			get_nat_port(e, &range.max.tcp.port);
+		} else
+			range.max.tcp.port = range.min.tcp.port;
+	}
+
+	info = calloc(1, sizeof(struct ipt_natinfo));
+	if (info == NULL)
+		return -1;
+
+	info = append_range(NULL, &range);
+	if (user_cb("DNAT", &info->t, user_data) != 0) {
+		free(info);
+		return -1;
+	}
+
+	return 0;
+}
+
+static enum nft_instruction xt_dnat_instructions_1[] = {
+	NFT_INSTRUCTION_IMMEDIATE, NFT_INSTRUCTION_NAT,
+	NFT_INSTRUCTION_MAX,
+};
+
+static struct nft_trans_instruction xt_dnat_1 = {
+	.instructions = xt_dnat_instructions_1,
+	.function = DNAT_parse_nft,
+};
+
+static enum nft_instruction xt_dnat_instructions_2[] = {
+	NFT_INSTRUCTION_IMMEDIATE, NFT_INSTRUCTION_IMMEDIATE,
+	NFT_INSTRUCTION_NAT,
+	NFT_INSTRUCTION_MAX,
+};
+
+static struct nft_trans_instruction xt_dnat_2 = {
+	.instructions = xt_dnat_instructions_2,
+	.function = DNAT_parse_nft,
+};
+
+static enum nft_instruction xt_dnat_instructions_3[] = {
+	NFT_INSTRUCTION_IMMEDIATE, NFT_INSTRUCTION_IMMEDIATE,
+	NFT_INSTRUCTION_IMMEDIATE, NFT_INSTRUCTION_NAT,
+	NFT_INSTRUCTION_MAX,
+};
+
+static struct nft_trans_instruction xt_dnat_3 = {
+	.instructions = xt_dnat_instructions_3,
+	.function = DNAT_parse_nft,
+};
+
+static enum nft_instruction xt_dnat_instructions_4[] = {
+	NFT_INSTRUCTION_IMMEDIATE, NFT_INSTRUCTION_IMMEDIATE,
+	NFT_INSTRUCTION_IMMEDIATE, NFT_INSTRUCTION_IMMEDIATE,
+	NFT_INSTRUCTION_NAT,
+	NFT_INSTRUCTION_MAX,
+};
+
+static struct nft_trans_instruction xt_dnat_4 = {
+	.instructions = xt_dnat_instructions_4,
+	.function = DNAT_parse_nft,
+};
+
+static int DNAT_register_nft_instructions(struct nft_trans_instruction_tree *tree)
+{
+	nft_trans_add_instruction(tree, &xt_dnat_1);
+	nft_trans_add_instruction(tree, &xt_dnat_2);
+	nft_trans_add_instruction(tree, &xt_dnat_3);
+	nft_trans_add_instruction(tree, &xt_dnat_4);
+
+	return 0;
+}
+
 static struct xtables_target dnat_tg_reg = {
 	.name		= "DNAT",
 	.version	= XTABLES_VERSION,
@@ -254,6 +473,8 @@ static struct xtables_target dnat_tg_reg = {
 	.print		= DNAT_print,
 	.save		= DNAT_save,
 	.x6_options	= DNAT_opts,
+	.to_nft		= DNAT_to_nft,
+	.register_nft_instructions = DNAT_register_nft_instructions,
 };
 
 void _init(void)
-- 
1.8.3.2

