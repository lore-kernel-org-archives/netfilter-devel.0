From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft RFC PATCH] src: add set optimization options
Date: Wed, 13 Aug 2014 10:17:06 +0200
Message-ID: <20140813081649.25737.82564.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:58121 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750916AbaHMIRM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:17:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds options to choose set optimization mechanisms.

The syntax is one of:

 nft add set filter set1 { type ipv4_addr size 1024 ; }
 nft add set filter set1 { type ipv4_addr policy memory ; }
 nft add set filter set1 { type ipv4_addr policy performance ; }
 nft add set filter set1 { type ipv4_addr policy memory size 1024 ; }
 nft add set filter set1 { type ipv4_addr size 1024 policy memory ; }
 nft add set filter set1 { type ipv4_addr policy performance size 1024 ; }
 nft add set filter set1 { type ipv4_addr size 1024 policy performance ; }

Also valid for maps:

 nft add map filter map1 { type ipv4_addr : verdict policy performace ; }
 [...]


This is the output format, which can be imported later with `nft -f':

table filter {
	set set1 {
		type ipv4_addr policy memory size 1024
	}
}

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---

This is my proposal for set internal mechanism selection in nft.

My idea is: given the kernel uses optional arguments to choose the
set mechanism, in userspace the configuration should be also optional.

The patch is not fully tested, there are still some issues; It seems that the
kernel is lacking some details.
For example, it doesn't dump back to userspace the policy configuration.

In my opinion, we should be able to inform userspace of the configuration, in a
way that userspace can differentiate between default values and fixed ones.
For example, NFT_SET_POL_PERFORMANCE seems to be the default in kernel, but
we don't want every set to be printed with "policy performance".

Please, feel free to comment.

 include/linux/netfilter/nf_tables.h |   29 +++++++++++++++++++++
 include/rule.h                      |    8 ++++++
 src/netlink.c                       |   19 ++++++++++++++
 src/parser.y                        |   49 ++++++++++++++++++++++++++++++++++-
 src/rule.c                          |   21 +++++++++++++++
 src/scanner.l                       |    5 ++++
 6 files changed, 129 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index a5f8ec0..fce770c 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -209,6 +209,29 @@ enum nft_set_flags {
 };
 
 /**
+ * enum nft_set_policies - set selection policy
+ *
+ * @NFT_SET_POL_PERFORMANCE: prefer high performance over low memory use
+ * @NFT_SET_POL_MEMORY: prefer low memory use over high performance
+ */
+enum nft_set_policies {
+	NFT_SET_POL_PERFORMANCE,
+	NFT_SET_POL_MEMORY,
+};
+
+/**
+ * enum nft_set_desc_attributes - set element description
+ *
+ * @NFTA_SET_DESC_SIZE: number of elements in set (NLA_U32)
+ */
+enum nft_set_desc_attributes {
+	NFTA_SET_DESC_UNSPEC,
+	NFTA_SET_DESC_SIZE,
+	__NFTA_SET_DESC_MAX
+};
+#define NFTA_SET_DESC_MAX	(__NFTA_SET_DESC_MAX - 1)
+
+/**
  * enum nft_set_attributes - nf_tables set netlink attributes
  *
  * @NFTA_SET_TABLE: table name (NLA_STRING)
@@ -218,6 +241,9 @@ enum nft_set_flags {
  * @NFTA_SET_KEY_LEN: key data length (NLA_U32)
  * @NFTA_SET_DATA_TYPE: mapping data type (NLA_U32)
  * @NFTA_SET_DATA_LEN: mapping data length (NLA_U32)
+ * @NFTA_SET_POLICY: selection policy (NLA_U32)
+ * @NFTA_SET_DESC: set description (NLA_NESTED)
+ * @NFTA_SET_ID: uniquely identifies a set in a transaction (NLA_U32)
  */
 enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
@@ -228,6 +254,9 @@ enum nft_set_attributes {
 	NFTA_SET_KEY_LEN,
 	NFTA_SET_DATA_TYPE,
 	NFTA_SET_DATA_LEN,
+	NFTA_SET_POLICY,
+	NFTA_SET_DESC,
+	NFTA_SET_ID,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
diff --git a/include/rule.h b/include/rule.h
index db91406..646e634 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -180,6 +180,7 @@ enum set_flags {
  * @datatype:	mapping data type
  * @datalen:	mapping data len
  * @init:	initializer
+ * @mechanism:	internal mechanism
  */
 struct set {
 	struct list_head	list;
@@ -192,6 +193,13 @@ struct set {
 	const struct datatype	*datatype;
 	unsigned int		datalen;
 	struct expr		*init;
+	struct {
+		uint32_t	flags;
+		uint32_t	policy;
+		struct {
+			uint32_t	size;
+		} desc;
+	} mechanism;
 };
 
 extern struct set *set_alloc(const struct location *loc);
diff --git a/src/netlink.c b/src/netlink.c
index e149215..e8ae324 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1044,6 +1044,17 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 		set->datalen = data_len * BITS_PER_BYTE;
 	}
 
+	if (nft_set_attr_is_set(nls, NFT_SET_ATTR_POLICY)) {
+		set->mechanism.policy = nft_set_attr_get_u32(nls, NFT_SET_ATTR_POLICY);
+		set->mechanism.flags |= (1 << NFT_SET_ATTR_POLICY);
+	}
+
+	if (nft_set_attr_is_set(nls, NFT_SET_ATTR_DESC_SIZE)) {
+		set->mechanism.desc.size = nft_set_attr_get_u32(nls,
+						     NFT_SET_ATTR_DESC_SIZE);
+		set->mechanism.flags |= (1 << NFT_SET_ATTR_DESC_SIZE);
+	}
+
 	return set;
 }
 
@@ -1102,6 +1113,14 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 	}
 	set->handle.set_id = ++set_id;
 	nft_set_attr_set_u32(nls, NFT_SET_ATTR_ID, set->handle.set_id);
+
+	if (set->mechanism.flags & (1 << NFT_SET_ATTR_POLICY))
+		nft_set_attr_set_u32(nls, NFT_SET_ATTR_POLICY,
+				     set->mechanism.policy);
+	if (set->mechanism.flags & (1 << NFT_SET_ATTR_DESC_SIZE))
+		nft_set_attr_set_u32(nls, NFT_SET_ATTR_DESC_SIZE,
+				     set->mechanism.desc.size);
+
 	netlink_dump_set(nls);
 
 	err = mnl_nft_set_batch_add(nf_sock, nls, NLM_F_EXCL, ctx->seqnum);
diff --git a/src/parser.y b/src/parser.y
index 26d2879..cc4efd7 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -20,6 +20,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
 #include <libnftnl/common.h>
+#include <libnftnl/set.h>
 
 #include <rule.h>
 #include <statement.h>
@@ -212,6 +213,11 @@ static int monitor_lookup_event(const char *event)
 %token INTERVAL			"interval"
 %token ELEMENTS			"elements"
 
+%token POLICY			"policy"
+%token MEMORY			"memory"
+%token PERFORMANCE		"performance"
+%token SIZE			"size"
+
 %token <val> NUM		"number"
 %token <string> STRING		"string"
 %token <string> QUOTED_STRING
@@ -408,6 +414,9 @@ static int monitor_lookup_event(const char *event)
 
 %type <val>			set_flag_list	set_flag
 
+%type <val>			set_policy_spec
+%type <val>			set_size_spec
+
 %type <set>			set_block_alloc set_block
 %destructor { set_free($$); }	set_block_alloc
 
@@ -1042,7 +1051,8 @@ set_block_alloc		:	/* empty */
 set_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	set_block	common_block
 			|	set_block	stmt_seperator
-			|	set_block	TYPE		identifier	stmt_seperator
+			|	set_block	TYPE		identifier
+						set_mechanism	stmt_seperator
 			{
 				$1->keytype = datatype_lookup_byname($3);
 				if ($1->keytype == NULL) {
@@ -1050,6 +1060,7 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
 						   state->msgs);
 					YYERROR;
 				}
+
 				$$ = $1;
 			}
 			|	set_block	FLAGS		set_flag_list	stmt_seperator
@@ -1087,7 +1098,7 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			|	map_block	stmt_seperator
 			|	map_block	TYPE
 						identifier	COLON	identifier
-						stmt_seperator
+						set_mechanism	stmt_seperator
 			{
 				$1->keytype = datatype_lookup_byname($3);
 				if ($1->keytype == NULL) {
@@ -1117,6 +1128,40 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 			}
 			;
 
+set_mechanism		:	/* empty */
+			|	set_policy_spec
+			{
+				$<set>0->mechanism.flags |= (1 << NFT_SET_ATTR_POLICY);
+				$<set>0->mechanism.policy = $1;
+			}
+			|	set_size_spec
+			{
+				$<set>0->mechanism.flags |= (1 << NFT_SET_ATTR_DESC_SIZE);
+				$<set>0->mechanism.desc.size = $1;
+			}
+			|	set_policy_spec	set_size_spec
+			{
+				$<set>0->mechanism.flags |= (1 << NFT_SET_ATTR_POLICY);
+				$<set>0->mechanism.policy = $1;
+				$<set>0->mechanism.flags |= (1 << NFT_SET_ATTR_DESC_SIZE);
+				$<set>0->mechanism.desc.size = $2;
+			}
+			|	set_size_spec	set_policy_spec
+			{
+				$<set>0->mechanism.flags |= (1 << NFT_SET_ATTR_DESC_SIZE);
+				$<set>0->mechanism.desc.size = $1;
+				$<set>0->mechanism.flags |= (1 << NFT_SET_ATTR_POLICY);
+				$<set>0->mechanism.policy = $2;
+			}
+			;
+
+set_policy_spec		:	POLICY	PERFORMANCE	{ $$ = NFT_SET_POL_PERFORMANCE; }
+			|	POLICY	MEMORY		{ $$ = NFT_SET_POL_MEMORY; }
+			;
+
+set_size_spec		:	SIZE	NUM	{ $$ = $2; }
+			;
+
 hook_spec		:	TYPE		STRING		HOOK		STRING		PRIORITY	NUM
 			{
 				$<chain>0->type		= chain_type_name_lookup($2);
diff --git a/src/rule.c b/src/rule.c
index 1e54526..9195a01 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -75,6 +75,7 @@ void set_free(struct set *set)
 	if (--set->refcnt > 0)
 		return;
 	handle_free(&set->handle);
+
 	xfree(set);
 }
 
@@ -90,6 +91,7 @@ struct set *set_clone(const struct set *set)
 	newset->datatype = set->datatype;
 	newset->datalen = set->datalen;
 	newset->init = expr_clone(set->init);
+	newset->mechanism = set->mechanism;
 
 	return newset;
 }
@@ -134,6 +136,18 @@ struct print_fmt_options {
 	const char	*stmt_separator;
 };
 
+static const char *set_policy2str(uint32_t policy)
+{
+	switch (policy) {
+	case NFT_SET_POL_PERFORMANCE:
+		return "performance";
+	case NFT_SET_POL_MEMORY:
+		return "memory";
+	default:
+		return "unknown";
+	}
+}
+
 static void do_set_print(const struct set *set, struct print_fmt_options *opts)
 {
 	const char *delim = "";
@@ -153,6 +167,13 @@ static void do_set_print(const struct set *set, struct print_fmt_options *opts)
 	printf("%s%stype %s", opts->tab, opts->tab, set->keytype->name);
 	if (set->flags & SET_F_MAP)
 		printf(" : %s", set->datatype->name);
+
+	if (set->mechanism.flags & NFT_SET_ATTR_POLICY)
+		printf(" policy %s",
+		       set_policy2str(set->mechanism.policy));
+	if (set->mechanism.flags & NFT_SET_ATTR_DESC_SIZE)
+		printf(" size %d", set->mechanism.desc.size);
+
 	printf("%s", opts->stmt_separator);
 
 	if (set->flags & (SET_F_CONSTANT | SET_F_INTERVAL)) {
diff --git a/src/scanner.l b/src/scanner.l
index 4eec92f..846fc34 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -267,6 +267,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "interval"		{ return INTERVAL; }
 "elements"		{ return ELEMENTS; }
 
+"policy"		{ return POLICY; }
+"size"			{ return SIZE; }
+"performance"		{ return PERFORMANCE; }
+"memory"		{ return MEMORY; }
+
 "counter"		{ return COUNTER; }
 "packets"		{ return PACKETS; }
 "bytes"			{ return BYTES; }

