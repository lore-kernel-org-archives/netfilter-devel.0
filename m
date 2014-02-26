From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/7] src: fix wrong type in NFT_ATTR_*_FAMILY
Date: Wed, 26 Feb 2014 02:51:56 +0100
Message-ID: <1393379519-16189-5-git-send-email-pablo@netfilter.org>
References: <1393379519-16189-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40466 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbaBZBwN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:52:13 -0500
In-Reply-To: <1393379519-16189-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This fixes assertions in the test files.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/chain.c                  |    8 ++++----
 src/rule.c                   |    8 ++++----
 src/table.c                  |    8 ++++----
 tests/nft-chain-test.c       |    6 +++---
 tests/nft-expr_ct-test.c     |    6 +++---
 tests/nft-expr_exthdr-test.c |    6 +++---
 tests/nft-expr_meta-test.c   |    4 ++--
 tests/nft-table-test.c       |    6 +++---
 8 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index a704502..33540b1 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -34,7 +34,7 @@ struct nft_chain {
 	char		name[NFT_CHAIN_MAXNAMELEN];
 	const char	*type;
 	const char	*table;
-	uint8_t		family;
+	uint32_t	family;
 	uint32_t	policy;
 	uint32_t	hooknum;
 	int32_t		prio;
@@ -147,7 +147,7 @@ static uint32_t nft_chain_attr_validate[NFT_CHAIN_ATTR_MAX + 1] = {
 	[NFT_CHAIN_ATTR_BYTES]		= sizeof(uint64_t),
 	[NFT_CHAIN_ATTR_PACKETS]	= sizeof(uint64_t),
 	[NFT_CHAIN_ATTR_HANDLE]		= sizeof(uint64_t),
-	[NFT_CHAIN_ATTR_FAMILY]		= sizeof(uint8_t),
+	[NFT_CHAIN_ATTR_FAMILY]		= sizeof(uint32_t),
 };
 
 void nft_chain_attr_set_data(struct nft_chain *c, uint16_t attr,
@@ -190,7 +190,7 @@ void nft_chain_attr_set_data(struct nft_chain *c, uint16_t attr,
 		c->handle = *((uint64_t *)data);
 		break;
 	case NFT_CHAIN_ATTR_FAMILY:
-		c->family = *((uint8_t *)data);
+		c->family = *((uint32_t *)data);
 		break;
 	case NFT_CHAIN_ATTR_TYPE:
 		if (c->type)
@@ -272,7 +272,7 @@ const void *nft_chain_attr_get_data(struct nft_chain *c, uint16_t attr,
 		*data_len = sizeof(uint64_t);
 		return &c->handle;
 	case NFT_CHAIN_ATTR_FAMILY:
-		*data_len = sizeof(uint8_t);
+		*data_len = sizeof(uint32_t);
 		return &c->family;
 	case NFT_CHAIN_ATTR_TYPE:
 		*data_len = sizeof(uint32_t);
diff --git a/src/rule.c b/src/rule.c
index ca4235b..adb7426 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -34,9 +34,9 @@ struct nft_rule {
 	struct list_head head;
 
 	uint32_t	flags;
+	uint32_t	family;
 	const char	*table;
 	const char	*chain;
-	uint8_t		family;
 	uint64_t	handle;
 	uint64_t	position;
 	struct {
@@ -117,7 +117,7 @@ static uint32_t nft_rule_attr_validate[NFT_RULE_ATTR_MAX + 1] = {
 	[NFT_RULE_ATTR_HANDLE]		= sizeof(uint64_t),
 	[NFT_RULE_ATTR_COMPAT_PROTO]	= sizeof(uint32_t),
 	[NFT_RULE_ATTR_COMPAT_FLAGS]	= sizeof(uint32_t),
-	[NFT_RULE_ATTR_FAMILY]		= sizeof(uint8_t),
+	[NFT_RULE_ATTR_FAMILY]		= sizeof(uint32_t),
 	[NFT_RULE_ATTR_POSITION]	= sizeof(uint64_t),
 };
 
@@ -152,7 +152,7 @@ void nft_rule_attr_set_data(struct nft_rule *r, uint16_t attr,
 		r->compat.flags = *((uint32_t *)data);
 		break;
 	case NFT_RULE_ATTR_FAMILY:
-		r->family = *((uint8_t *)data);
+		r->family = *((uint32_t *)data);
 		break;
 	case NFT_RULE_ATTR_POSITION:
 		r->position = *((uint64_t *)data);
@@ -194,7 +194,7 @@ const void *nft_rule_attr_get_data(const struct nft_rule *r, uint16_t attr,
 
 	switch(attr) {
 	case NFT_RULE_ATTR_FAMILY:
-		*data_len = sizeof(uint8_t);
+		*data_len = sizeof(uint32_t);
 		return &r->family;
 	case NFT_RULE_ATTR_TABLE:
 		return r->table;
diff --git a/src/table.c b/src/table.c
index 33d6a8d..0299209 100644
--- a/src/table.c
+++ b/src/table.c
@@ -29,7 +29,7 @@ struct nft_table {
 	struct list_head head;
 
 	const char	*name;
-	uint8_t		family;
+	uint32_t	family;
 	uint32_t	table_flags;
 	uint32_t	use;
 	uint32_t	flags;
@@ -81,7 +81,7 @@ EXPORT_SYMBOL(nft_table_attr_unset);
 
 static uint32_t nft_table_attr_validate[NFT_TABLE_ATTR_MAX + 1] = {
 	[NFT_TABLE_ATTR_FLAGS]	= sizeof(uint32_t),
-	[NFT_TABLE_ATTR_FAMILY]	= sizeof(uint8_t),
+	[NFT_TABLE_ATTR_FAMILY]	= sizeof(uint32_t),
 };
 
 void nft_table_attr_set_data(struct nft_table *t, uint16_t attr,
@@ -103,7 +103,7 @@ void nft_table_attr_set_data(struct nft_table *t, uint16_t attr,
 		t->table_flags = *((uint32_t *)data);
 		break;
 	case NFT_TABLE_ATTR_FAMILY:
-		t->family = *((uint8_t *)data);
+		t->family = *((uint32_t *)data);
 		break;
 	case NFT_TABLE_ATTR_USE:
 		/* Cannot be set, ignoring it */
@@ -150,7 +150,7 @@ const void *nft_table_attr_get_data(struct nft_table *t, uint16_t attr,
 		*data_len = sizeof(uint32_t);
 		return &t->table_flags;
 	case NFT_TABLE_ATTR_FAMILY:
-		*data_len = sizeof(uint8_t);
+		*data_len = sizeof(uint32_t);
 		return &t->family;
 	case NFT_TABLE_ATTR_USE:
 		*data_len = sizeof(uint32_t);
diff --git a/tests/nft-chain-test.c b/tests/nft-chain-test.c
index 125562a..1ff8334 100644
--- a/tests/nft-chain-test.c
+++ b/tests/nft-chain-test.c
@@ -32,8 +32,8 @@ static void cmp_nft_chain(struct nft_chain *a, struct nft_chain *b)
 	if (strcmp(nft_chain_attr_get_str(a, NFT_CHAIN_ATTR_TABLE),
 		   nft_chain_attr_get_str(b, NFT_CHAIN_ATTR_TABLE)) != 0)
 		print_err("Chain table mismatches");
-	if (nft_chain_attr_get_u8(a, NFT_CHAIN_ATTR_FAMILY) !=
-	    nft_chain_attr_get_u8(b, NFT_CHAIN_ATTR_FAMILY))
+	if (nft_chain_attr_get_u32(a, NFT_CHAIN_ATTR_FAMILY) !=
+	    nft_chain_attr_get_u32(b, NFT_CHAIN_ATTR_FAMILY))
 		print_err("Chain family mismatches");
 	if (nft_chain_attr_get_u32(a, NFT_CHAIN_ATTR_POLICY) !=
 	    nft_chain_attr_get_u32(b, NFT_CHAIN_ATTR_POLICY))
@@ -73,7 +73,7 @@ int main(int argc, char *argv[])
 		print_err("OOM");
 
 	nft_chain_attr_set_str(a, NFT_CHAIN_ATTR_NAME, "test");
-	nft_chain_attr_set_u8(a, NFT_CHAIN_ATTR_FAMILY, AF_INET);
+	nft_chain_attr_set_u32(a, NFT_CHAIN_ATTR_FAMILY, AF_INET);
 	nft_chain_attr_set_str(a, NFT_CHAIN_ATTR_TABLE, "Table");
 	nft_chain_attr_set_u32(a, NFT_CHAIN_ATTR_POLICY,0x12345678);
 	nft_chain_attr_set_u32(a, NFT_CHAIN_ATTR_HOOKNUM, 0x12345678);
diff --git a/tests/nft-expr_ct-test.c b/tests/nft-expr_ct-test.c
index 341d9e6..dd07854 100644
--- a/tests/nft-expr_ct-test.c
+++ b/tests/nft-expr_ct-test.c
@@ -32,8 +32,8 @@ static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
 	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_CT_KEY) !=
 	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_CT_KEY))
 		print_err("Expr CT_KEY mismatches");
-	if (nft_rule_expr_get_u8(rule_a, NFT_EXPR_CT_DIR) !=
-	    nft_rule_expr_get_u8(rule_b, NFT_EXPR_CT_DIR))
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_CT_DIR) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_CT_DIR))
 		print_err("Expr CT_DIR mismatches");
 	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_CT_DREG) !=
 	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_CT_DREG))
@@ -57,7 +57,7 @@ int main(int argc, char *argv[])
 		print_err("OOM");
 
 	nft_rule_expr_set_u32(ex, NFT_EXPR_CT_KEY, 0x1234568);
-	nft_rule_expr_set_u8(ex, NFT_EXPR_CT_DIR, 0x12);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_CT_DIR, 0x12);
 	nft_rule_expr_set_u32(ex, NFT_EXPR_CT_DREG, 0x12345678);
 
 	nft_rule_add_expr(a, ex);
diff --git a/tests/nft-expr_exthdr-test.c b/tests/nft-expr_exthdr-test.c
index a712903..c0dc609 100644
--- a/tests/nft-expr_exthdr-test.c
+++ b/tests/nft-expr_exthdr-test.c
@@ -33,8 +33,8 @@ static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
 	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_EXTHDR_DREG) !=
 	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_EXTHDR_DREG))
 		print_err("Expr NFT_EXPR_EXTHDR_DREG mismatches");
-	if (nft_rule_expr_get_u8(rule_a, NFT_EXPR_EXTHDR_TYPE) !=
-	    nft_rule_expr_get_u8(rule_b, NFT_EXPR_EXTHDR_TYPE))
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_EXTHDR_TYPE) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_EXTHDR_TYPE))
 		print_err("Expr NFT_EXPR_EXTHDR_TYPE mismatches");
 	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_EXTHDR_OFFSET) !=
 	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_EXTHDR_OFFSET))
@@ -62,7 +62,7 @@ int main(int argc, char *argv[])
 		print_err("OOM");
 
 	nft_rule_expr_set_u32(ex, NFT_EXPR_EXTHDR_DREG, 0x12345678);
-	nft_rule_expr_set_u8(ex, NFT_EXPR_EXTHDR_TYPE, 0x12);
+	nft_rule_expr_set_u32(ex, NFT_EXPR_EXTHDR_TYPE, 0x12);
 	nft_rule_expr_set_u32(ex, NFT_EXPR_EXTHDR_OFFSET, 0x12345678);
 	nft_rule_expr_set_u32(ex, NFT_EXPR_EXTHDR_LEN, 0x12345678);
 
diff --git a/tests/nft-expr_meta-test.c b/tests/nft-expr_meta-test.c
index 9196f9c..d9569ec 100644
--- a/tests/nft-expr_meta-test.c
+++ b/tests/nft-expr_meta-test.c
@@ -33,8 +33,8 @@ static void cmp_nft_rule_expr(struct nft_rule_expr *rule_a,
 	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_META_KEY) !=
 	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_META_KEY))
 		print_err("Expr NFT_EXPR_META_KEY mismatches");
-	if (nft_rule_expr_get_u8(rule_a, NFT_EXPR_META_DREG) !=
-	    nft_rule_expr_get_u8(rule_b, NFT_EXPR_META_DREG))
+	if (nft_rule_expr_get_u32(rule_a, NFT_EXPR_META_DREG) !=
+	    nft_rule_expr_get_u32(rule_b, NFT_EXPR_META_DREG))
 		print_err("Expr NFT_EXPR_META_DREG mismatches");
 }
 
diff --git a/tests/nft-table-test.c b/tests/nft-table-test.c
index 051163b..2096ea5 100644
--- a/tests/nft-table-test.c
+++ b/tests/nft-table-test.c
@@ -32,8 +32,8 @@ static void cmp_nft_table(struct nft_table *a, struct nft_table *b)
 	if (nft_table_attr_get_u32(a, NFT_TABLE_ATTR_FLAGS) !=
 	    nft_table_attr_get_u32(b, NFT_TABLE_ATTR_FLAGS))
 		print_err("table flags mismatches");
-	if (nft_table_attr_get_u8(a, NFT_TABLE_ATTR_FAMILY) !=
-	    nft_table_attr_get_u8(b, NFT_TABLE_ATTR_FAMILY))
+	if (nft_table_attr_get_u32(a, NFT_TABLE_ATTR_FAMILY) !=
+	    nft_table_attr_get_u32(b, NFT_TABLE_ATTR_FAMILY))
 		print_err("tabke family mismatches");
 }
 
@@ -51,7 +51,7 @@ int main(int argc, char *argv[])
 		print_err("OOM");
 
 	nft_table_attr_set_str(a, NFT_TABLE_ATTR_NAME, "test");
-	nft_table_attr_set_u8(a, NFT_TABLE_ATTR_FAMILY, AF_INET);
+	nft_table_attr_set_u32(a, NFT_TABLE_ATTR_FAMILY, AF_INET);
 	nft_table_attr_set_u32(a, NFT_TABLE_ATTR_FLAGS, 0);
 
 	/* cmd extracted from include/linux/netfilter/nf_tables.h */
-- 
1.7.10.4

