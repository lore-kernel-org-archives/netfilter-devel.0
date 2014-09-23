From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 2/2 v2] src: add set optimization options
Date: Tue, 23 Sep 2014 13:30:42 +0200
Message-ID: <1411471842-4854-2-git-send-email-arturo.borrero.glez@gmail.com>
References: <1411471842-4854-1-git-send-email-arturo.borrero.glez@gmail.com>
Cc: pablo@netfilter.org, kaber@trash.net,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:38846 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755185AbaIWLau (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:30:50 -0400
In-Reply-To: <1411471842-4854-1-git-send-email-arturo.borrero.glez@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds options to choose set optimization mechanisms.

Two new statements are added to the set syntax, and they can be mixed:

 nft add set filter set1 { type ipv4_addr ; size 1024 ; }
 nft add set filter set1 { type ipv4_addr ; policy memory ; }
 nft add set filter set1 { type ipv4_addr ; policy performance ; }
 nft add set filter set1 { type ipv4_addr ; policy memory ; size 1024 ; }
 nft add set filter set1 { type ipv4_addr ; size 1024 ; policy memory ; }
 nft add set filter set1 { type ipv4_addr ; policy performance ; size 1024 ; }
 nft add set filter set1 { type ipv4_addr ; size 1024 ; policy performance ; }

Also valid for maps:

 nft add map filter map1 { type ipv4_addr : verdict ; policy performace ; }
 [...]


This is the output format, which can be imported later with `nft -f':

table filter {
	set set1 {
		type ipv4_addr
		policy memory
		size 1024
	}
}

In this approach the parser accepts default options such as 'performance',
given they are a valid configurations, but aren't sent to the kernel.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: address comments by Patrick. Put the "policy" keyword one level upper in
    the parser.
    Also, ignore default policy and size configurations.

 include/rule.h |    6 ++++++
 src/netlink.c  |   20 ++++++++++++++++++++
 src/parser.y   |   25 +++++++++++++++++++++++++
 src/rule.c     |   28 ++++++++++++++++++++++++++++
 src/scanner.l  |    5 +++++
 5 files changed, 84 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index 88aefc6..a1d5890 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -180,6 +180,8 @@ enum set_flags {
  * @datatype:	mapping data type
  * @datalen:	mapping data len
  * @init:	initializer
+ * @policy:	set mechanism policy
+ * @desc:	set mechanism desc
  */
 struct set {
 	struct list_head	list;
@@ -192,6 +194,10 @@ struct set {
 	const struct datatype	*datatype;
 	unsigned int		datalen;
 	struct expr		*init;
+	uint32_t		policy;
+	struct {
+		uint32_t	size;
+	} desc;
 };
 
 extern struct set *set_alloc(const struct location *loc);
diff --git a/src/netlink.c b/src/netlink.c
index 17b82ee..64960ad 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1050,6 +1050,13 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 		set->datalen = data_len * BITS_PER_BYTE;
 	}
 
+	if (nft_set_attr_is_set(nls, NFT_SET_ATTR_POLICY))
+		set->policy = nft_set_attr_get_u32(nls, NFT_SET_ATTR_POLICY);
+
+	if (nft_set_attr_is_set(nls, NFT_SET_ATTR_DESC_SIZE))
+		set->desc.size = nft_set_attr_get_u32(nls,
+						      NFT_SET_ATTR_DESC_SIZE);
+
 	return set;
 }
 
@@ -1108,6 +1115,19 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 	}
 	set->handle.set_id = ++set_id;
 	nft_set_attr_set_u32(nls, NFT_SET_ATTR_ID, set->handle.set_id);
+
+	if (!(set->flags & (SET_F_CONSTANT))) {
+		if (set->policy != NFT_SET_POL_PERFORMANCE) {
+			nft_set_attr_set_u32(nls, NFT_SET_ATTR_POLICY,
+					     set->policy);
+		}
+
+		if (set->desc.size != 0) {
+			nft_set_attr_set_u32(nls, NFT_SET_ATTR_DESC_SIZE,
+					     set->desc.size);
+		}
+	}
+
 	netlink_dump_set(nls);
 
 	err = mnl_nft_set_batch_add(nf_sock, nls, NLM_F_EXCL, ctx->seqnum);
diff --git a/src/parser.y b/src/parser.y
index c9b22f0..8453ba5 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -20,6 +20,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
 #include <libnftnl/common.h>
+#include <libnftnl/set.h>
 
 #include <rule.h>
 #include <statement.h>
@@ -201,6 +202,11 @@ static void location_update(struct location *loc, struct location *rhs, int n)
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
@@ -401,6 +407,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %type <val>			set_flag_list	set_flag
 
+%type <val>			set_policy_spec
+%type <val>			set_size_spec
+
 %type <set>			set_block_alloc set_block
 %destructor { set_free($$); }	set_block_alloc
 
@@ -965,6 +974,7 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->init = $4;
 				$$ = $1;
 			}
+			|	set_block	set_mechanism	stmt_seperator
 			;
 
 set_flag_list		:	set_flag_list	COMMA		set_flag
@@ -1018,6 +1028,21 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->init = $4;
 				$$ = $1;
 			}
+			|	map_block	set_mechanism	stmt_seperator
+			;
+
+set_mechanism		:	POLICY		set_policy_spec
+			{
+				$<set>0->policy = $2;
+			}
+			|	SIZE		NUM
+			{
+				$<set>0->desc.size = $2;
+			}
+			;
+
+set_policy_spec		:	PERFORMANCE	{ $$ = NFT_SET_POL_PERFORMANCE; }
+			|	MEMORY		{ $$ = NFT_SET_POL_MEMORY; }
 			;
 
 hook_spec		:	TYPE		STRING		HOOK		STRING		PRIORITY	NUM
diff --git a/src/rule.c b/src/rule.c
index 80deb1b..2de99b0 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -90,6 +90,8 @@ struct set *set_clone(const struct set *set)
 	newset->datatype = set->datatype;
 	newset->datalen = set->datalen;
 	newset->init = expr_clone(set->init);
+	newset->policy = set->policy;
+	newset->desc.size = set->desc.size;
 
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
@@ -153,8 +167,22 @@ static void do_set_print(const struct set *set, struct print_fmt_options *opts)
 	printf("%s%stype %s", opts->tab, opts->tab, set->keytype->name);
 	if (set->flags & SET_F_MAP)
 		printf(" : %s", set->datatype->name);
+
 	printf("%s", opts->stmt_separator);
 
+	if (!(set->flags & (SET_F_CONSTNAT))) {
+		if (set->policy != NFT_SET_POL_PERFORMANCE) {
+			printf("%s%spolicy %s%s", opts->tab, opts->tab,
+			       set_policy2str(set->policy),
+			       opts->stmt_separator);
+		}
+
+		if (set->desc.size > 0 && !(set->flags & (SET_F_CONSTNAT))) {
+			printf("%s%ssize %u%s", opts->tab, opts->tab,
+			       set->desc.size, opts->stmt_separator);
+		}
+	}
+
 	if (set->flags & (SET_F_CONSTANT | SET_F_INTERVAL)) {
 		printf("%s%sflags ", opts->tab, opts->tab);
 		if (set->flags & SET_F_CONSTANT) {
diff --git a/src/scanner.l b/src/scanner.l
index 8aab38f..6458d09 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -271,6 +271,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
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
-- 
1.7.10.4

