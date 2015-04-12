From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 07/10] set: add timeout support for sets
Date: Sun, 12 Apr 2015 13:16:15 +0100
Message-ID: <1428840978-27226-8-git-send-email-kaber@trash.net>
References: <1428840978-27226-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58911 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbbDLMQ1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Apr 2015 08:16:27 -0400
In-Reply-To: <1428840978-27226-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Timeout support can be enabled in one of two ways:

1. Using a default timeout value:

set test {
	type ipv4_addr;
	timeout 1h;
}

2. Using the timeout flag without a default:

set test {
	type ipv4_addr;
	flags timeout;
}

Optionally a garbage collection interval can be specified using

gc-interval <interval>;

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/linux/netfilter/nf_tables.h |  6 ++++++
 include/rule.h                      |  5 +++++
 src/evaluate.c                      |  4 ++++
 src/netlink.c                       | 10 ++++++++++
 src/parser_bison.y                  | 13 +++++++++++++
 src/rule.c                          | 23 ++++++++++++++++++++++-
 src/scanner.l                       |  2 ++
 7 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 832bc46..8671505 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -207,12 +207,14 @@ enum nft_rule_compat_attributes {
  * @NFT_SET_CONSTANT: set contents may not change while bound
  * @NFT_SET_INTERVAL: set contains intervals
  * @NFT_SET_MAP: set is used as a dictionary
+ * @NFT_SET_TIMEOUT: set uses timeouts
  */
 enum nft_set_flags {
 	NFT_SET_ANONYMOUS		= 0x1,
 	NFT_SET_CONSTANT		= 0x2,
 	NFT_SET_INTERVAL		= 0x4,
 	NFT_SET_MAP			= 0x8,
+	NFT_SET_TIMEOUT			= 0x10,
 };
 
 /**
@@ -251,6 +253,8 @@ enum nft_set_desc_attributes {
  * @NFTA_SET_POLICY: selection policy (NLA_U32)
  * @NFTA_SET_DESC: set description (NLA_NESTED)
  * @NFTA_SET_ID: uniquely identifies a set in a transaction (NLA_U32)
+ * @NFTA_SET_TIMEOUT: default timeout value (NLA_U64)
+ * @NFTA_SET_GC_INTERVAL: garbage collection interval (NLA_U32)
  */
 enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
@@ -264,6 +268,8 @@ enum nft_set_attributes {
 	NFTA_SET_POLICY,
 	NFTA_SET_DESC,
 	NFTA_SET_ID,
+	NFTA_SET_TIMEOUT,
+	NFTA_SET_GC_INTERVAL,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
diff --git a/include/rule.h b/include/rule.h
index 97959f7..5d44599 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -173,6 +173,7 @@ enum set_flags {
 	SET_F_CONSTANT		= 0x2,
 	SET_F_INTERVAL		= 0x4,
 	SET_F_MAP		= 0x8,
+	SET_F_TIMEOUT		= 0x10,
 };
 
 /**
@@ -183,6 +184,8 @@ enum set_flags {
  * @location:	location the set was defined/declared at
  * @refcnt:	reference count
  * @flags:	bitmask of set flags
+ * @gc_int:	garbage collection interval
+ * @timeout:	default timeout value
  * @keytype:	key data type
  * @keylen:	key length
  * @datatype:	mapping data type
@@ -197,6 +200,8 @@ struct set {
 	struct location		location;
 	unsigned int		refcnt;
 	uint32_t		flags;
+	uint32_t		gc_int;
+	uint64_t		timeout;
 	const struct datatype	*keytype;
 	unsigned int		keylen;
 	const struct datatype	*datatype;
diff --git a/src/evaluate.c b/src/evaluate.c
index 37db107..04ca08d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1737,6 +1737,10 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 			return -1;
 	}
 
+	/* Default timeout value implies timeout support */
+	if (set->timeout)
+		set->flags |= SET_F_TIMEOUT;
+
 	if (!(set->flags & SET_F_MAP))
 		return 0;
 
diff --git a/src/netlink.c b/src/netlink.c
index 75fbb25..337d8a1 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -908,6 +908,11 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 		set->datalen = data_len * BITS_PER_BYTE;
 	}
 
+	if (nft_set_attr_is_set(nls, NFT_SET_ATTR_TIMEOUT))
+		set->timeout = nft_set_attr_get_u64(nls, NFT_SET_ATTR_TIMEOUT);
+	if (nft_set_attr_is_set(nls, NFT_SET_ATTR_GC_INTERVAL))
+		set->gc_int  = nft_set_attr_get_u32(nls, NFT_SET_ATTR_GC_INTERVAL);
+
 	if (nft_set_attr_is_set(nls, NFT_SET_ATTR_POLICY))
 		set->policy = nft_set_attr_get_u32(nls, NFT_SET_ATTR_POLICY);
 
@@ -939,6 +944,11 @@ int netlink_add_set(struct netlink_ctx *ctx, const struct handle *h,
 		nft_set_attr_set_u32(nls, NFT_SET_ATTR_DATA_LEN,
 				     set->datalen / BITS_PER_BYTE);
 	}
+	if (set->timeout)
+		nft_set_attr_set_u64(nls, NFT_SET_ATTR_TIMEOUT, set->timeout);
+	if (set->gc_int)
+		nft_set_attr_set_u32(nls, NFT_SET_ATTR_GC_INTERVAL, set->gc_int);
+
 	set->handle.set_id = ++set_id;
 	nft_set_attr_set_u32(nls, NFT_SET_ATTR_ID, set->handle.set_id);
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 9fbc590..8083187 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -201,6 +201,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %token CONSTANT			"constant"
 %token INTERVAL			"interval"
+%token TIMEOUT			"timeout"
+%token GC_INTERVAL		"gc-interval"
 %token ELEMENTS			"elements"
 
 %token POLICY			"policy"
@@ -944,6 +946,16 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->flags = $3;
 				$$ = $1;
 			}
+			|	set_block	TIMEOUT		time_spec	stmt_seperator
+			{
+				$1->timeout = $3 * 1000;
+				$$ = $1;
+			}
+			|	set_block	GC_INTERVAL	time_spec	stmt_seperator
+			{
+				$1->gc_int = $3 * 1000;
+				$$ = $1;
+			}
 			|	set_block	ELEMENTS	'='		set_expr
 			{
 				$1->init = $4;
@@ -961,6 +973,7 @@ set_flag_list		:	set_flag_list	COMMA		set_flag
 
 set_flag		:	CONSTANT	{ $$ = SET_F_CONSTANT; }
 			|	INTERVAL	{ $$ = SET_F_INTERVAL; }
+			|	TIMEOUT		{ $$ = SET_F_TIMEOUT; }
 			;
 
 map_block_alloc		:	/* empty */
diff --git a/src/rule.c b/src/rule.c
index 86cf080..a9ed749 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -136,6 +136,7 @@ static void do_set_print(const struct set *set, struct print_fmt_options *opts)
 {
 	const char *delim = "";
 	const char *type;
+	uint32_t flags;
 
 	type = set->flags & SET_F_MAP ? "map" : "set";
 	printf("%s%s", opts->tab, type);
@@ -167,7 +168,12 @@ static void do_set_print(const struct set *set, struct print_fmt_options *opts)
 		}
 	}
 
-	if (set->flags & (SET_F_CONSTANT | SET_F_INTERVAL)) {
+	flags = set->flags;
+	/* "timeout" flag is redundant if a default timeout exists */
+	if (set->timeout)
+		flags &= ~SET_F_TIMEOUT;
+
+	if (flags & (SET_F_CONSTANT | SET_F_INTERVAL | SET_F_TIMEOUT)) {
 		printf("%s%sflags ", opts->tab, opts->tab);
 		if (set->flags & SET_F_CONSTANT) {
 			printf("%sconstant", delim);
@@ -177,6 +183,21 @@ static void do_set_print(const struct set *set, struct print_fmt_options *opts)
 			printf("%sinterval", delim);
 			delim = ",";
 		}
+		if (set->flags & SET_F_TIMEOUT) {
+			printf("%stimeout", delim);
+			delim = ",";
+		}
+		printf("%s", opts->nl);
+	}
+
+	if (set->timeout) {
+		printf("%s%stimeout ", opts->tab, opts->tab);
+		time_print(set->timeout / 1000);
+		printf("%s", opts->nl);
+	}
+	if (set->gc_int) {
+		printf("%s%sgc-interval ", opts->tab, opts->tab);
+		time_print(set->gc_int / 1000);
 		printf("%s", opts->nl);
 	}
 
diff --git a/src/scanner.l b/src/scanner.l
index 27d95bf..4231d27 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -271,6 +271,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "constant"		{ return CONSTANT; }
 "interval"		{ return INTERVAL; }
+"timeout"		{ return TIMEOUT; }
+"gc-interval"		{ return GC_INTERVAL; }
 "elements"		{ return ELEMENTS; }
 
 "policy"		{ return POLICY; }
-- 
2.1.0

