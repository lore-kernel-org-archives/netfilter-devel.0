From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 6/6] xtables: add suport for DNAT rule translation to nft extensions
Date: Tue, 14 May 2013 13:52:07 +0300
Message-ID: <1368528727-10127-7-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <519216B6.7060701@linux.intel.com>
 <1368528727-10127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55132 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757041Ab3ENKwT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 May 2013 06:52:19 -0400
In-Reply-To: <1368528727-10127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 extensions/libipt_DNAT.c | 135 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 124 insertions(+), 11 deletions(-)

diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 466c9de..1d397fe 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -7,6 +7,7 @@
 #include <limits.h> /* INT_MAX in ip_tables.h */
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <net/netfilter/nf_nat.h>
+#include <linux/netfilter/nf_tables.h>
 
 enum {
 	O_TO_DEST = 0,
@@ -242,18 +243,130 @@ static void DNAT_save(const void *ip, const struct xt_entry_target *target)
 	}
 }
 
+static struct nft_rule_expr_list *
+add_nat_data(struct nft_rule_expr_list *expr_list, int reg, uint32_t data)
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
+	nft_rule_expr_list_add(expr, expr_list);
+
+	return expr_list;
+}
+
+static struct nft_rule_expr_list *
+create_nat_expr_list(const struct nf_nat_range *r)
+{
+	struct nft_rule_expr_list *expr_list;
+	struct nft_rule_expr *nat_expr;
+	int registers = 1;
+
+	expr_list = nft_rule_expr_list_alloc();
+	if (expr_list == NULL)
+		return NULL;
+
+	nat_expr = nft_rule_expr_alloc("nat");
+	if (nat_expr == NULL)
+		goto err;
+
+	nft_rule_expr_set_u32(nat_expr, NFT_EXPR_NAT_TYPE, NFT_NAT_DNAT);
+	nft_rule_expr_set_u32(nat_expr, NFT_EXPR_NAT_FAMILY, AF_INET);
+
+	if (r->flags & IP_NAT_RANGE_MAP_IPS) {
+		nft_rule_expr_set_u32(nat_expr, NFT_EXPR_NAT_REG_ADDR_MIN,
+				      registers);
+		if (add_nat_data(expr_list, registers, r->min_ip) == NULL)
+			goto err;
+		registers++;
+
+		if (r->max_ip != r->min_ip) {
+			nft_rule_expr_set_u32(nat_expr,
+					      NFT_EXPR_NAT_REG_ADDR_MAX,
+					      registers);
+			if (add_nat_data(expr_list,
+					 registers, r->max_ip) == NULL)
+				goto err;
+			registers++;
+		}
+	}
+
+	if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
+		nft_rule_expr_set_u32(nat_expr, NFT_EXPR_NAT_REG_PROTO_MIN,
+				      registers);
+		if (add_nat_data(expr_list, registers,
+				 ntohs(r->min.tcp.port)) == NULL)
+			goto err;
+		registers++;
+
+		if (r->max.tcp.port != r->min.tcp.port) {
+			nft_rule_expr_set_u32(nat_expr,
+					      NFT_EXPR_NAT_REG_PROTO_MAX,
+					      registers);
+			if (add_nat_data(expr_list, registers,
+					 ntohs(r->max.tcp.port)) == NULL)
+				goto err;
+		}
+	}
+
+	nft_rule_expr_list_add(nat_expr, expr_list);
+	return expr_list;
+err:
+	nft_rule_expr_list_free(expr_list);
+
+	if (nat_expr != NULL)
+		nft_rule_expr_free(nat_expr);
+
+	return NULL;
+}
+
+static struct nft_rule_expr_list *DNAT_to_nft(struct xt_entry_target *target)
+{
+	const struct ipt_natinfo *info = (const void *)target;
+	struct nft_rule_expr_list *nat_expr_list;
+	int i;
+
+	nat_expr_list = nft_rule_expr_list_alloc();
+	if (nat_expr_list == NULL)
+		goto err;
+
+	for (i = 0; i < info->mr.rangesize; i++) {
+		struct nft_rule_expr_list *nat_expr;
+
+		nat_expr = create_nat_expr_list(&info->mr.range[i]);
+		if (nat_expr == NULL)
+			goto err;
+
+		nft_rule_expr_list_add_list(nat_expr, nat_expr_list);
+	}
+
+	return nat_expr_list;
+
+err:
+	if (nat_expr_list != NULL)
+		nft_rule_expr_list_free(nat_expr_list);
+
+	return NULL;
+}
+
 static struct xtables_target dnat_tg_reg = {
-	.name		= "DNAT",
-	.version	= XTABLES_VERSION,
-	.family		= NFPROTO_IPV4,
-	.size		= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
-	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_multi_range)),
-	.help		= DNAT_help,
-	.x6_parse	= DNAT_parse,
-	.x6_fcheck	= DNAT_fcheck,
-	.print		= DNAT_print,
-	.save		= DNAT_save,
-	.x6_options	= DNAT_opts,
+	.name		  = "DNAT",
+	.version	  = XTABLES_VERSION,
+	.family		  = NFPROTO_IPV4,
+	.size		  = XT_ALIGN(sizeof(struct nf_nat_multi_range)),
+	.userspacesize	  = XT_ALIGN(sizeof(struct nf_nat_multi_range)),
+	.help		  = DNAT_help,
+	.x6_parse	  = DNAT_parse,
+	.x6_fcheck	  = DNAT_fcheck,
+	.print		  = DNAT_print,
+	.save		  = DNAT_save,
+	.x6_options	  = DNAT_opts,
+	.translate_to_nft = DNAT_to_nft,
 };
 
 void _init(void)
-- 
1.8.2.1

