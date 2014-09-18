From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft 3/3] src: add set optimization options
Date: Thu, 18 Sep 2014 20:39:22 +0200
Message-ID: <49a03ccd-ddb8-47dc-b455-885ddf607e6a@email.android.com>
References: <1411064300-4433-1-git-send-email-arturo.borrero.glez@gmail.com> <1411064300-4433-3-git-send-email-arturo.borrero.glez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34379 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424AbaIRSja (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:39:30 -0400
In-Reply-To: <1411064300-4433-3-git-send-email-arturo.borrero.glez@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18. September 2014 20:18:20 MESZ, Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
>This patch adds options to choose set optimization mechanisms.
>
>Two new statements are added to the set syntax, and they can be mixed:
>
> nft add set filter set1 { type ipv4_addr ; size 1024 ; }
> nft add set filter set1 { type ipv4_addr ; policy memory ; }
> nft add set filter set1 { type ipv4_addr ; policy performance ; }
>nft add set filter set1 { type ipv4_addr ; policy memory ; size 1024 ;
>}
>nft add set filter set1 { type ipv4_addr ; size 1024 ; policy memory ;
>}
>nft add set filter set1 { type ipv4_addr ; policy performance ; size
>1024 ; }
>nft add set filter set1 { type ipv4_addr ; size 1024 ; policy
>performance ; }
>
>Also valid for maps:
>
>nft add map filter map1 { type ipv4_addr : verdict ; policy performace
>; }
> [...]
>
>
>This is the output format, which can be imported later with `nft -f':
>
>table filter {
>	set set1 {
>		type ipv4_addr
>		policy memory
>		size 1024
>	}
>}

Conceptually this looks good, I'll have a look at the implementation after dinner.

What my patch did was only handle the case where limits can be determined automatically, IOW literal sets. Both is needed.

>
>Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
>---
> include/rule.h |    8 ++++++++
> src/netlink.c  |   19 +++++++++++++++++++
> src/parser.y   |   31 +++++++++++++++++++++++++++++++
> src/rule.c     |   27 +++++++++++++++++++++++++++
> src/scanner.l  |    5 +++++
> 5 files changed, 90 insertions(+)
>
>diff --git a/include/rule.h b/include/rule.h
>index 88aefc6..49a39ea 100644
>--- a/include/rule.h
>+++ b/include/rule.h
>@@ -180,6 +180,9 @@ enum set_flags {
>  * @datatype:	mapping data type
>  * @datalen:	mapping data len
>  * @init:	initializer
>+ * @attr_flags:	set attr flags
>+ * @policy:	set mechanism policy
>+ * @desc:	set mechanism desc
>  */
> struct set {
> 	struct list_head	list;
>@@ -192,6 +195,11 @@ struct set {
> 	const struct datatype	*datatype;
> 	unsigned int		datalen;
> 	struct expr		*init;
>+	uint32_t		attr_flags;
>+	uint32_t		policy;
>+	struct {
>+		uint32_t	size;
>+	} desc;
> };
> 
> extern struct set *set_alloc(const struct location *loc);
>diff --git a/src/netlink.c b/src/netlink.c
>index 84d5db3..eca4858 100644
>--- a/src/netlink.c
>+++ b/src/netlink.c
>@@ -1045,6 +1045,17 @@ static struct set
>*netlink_delinearize_set(struct netlink_ctx *ctx,
> 		set->datalen = data_len * BITS_PER_BYTE;
> 	}
> 
>+	if (nft_set_attr_is_set(nls, NFT_SET_ATTR_POLICY)) {
>+		set->policy = nft_set_attr_get_u32(nls, NFT_SET_ATTR_POLICY);
>+		set->attr_flags |= (1 << NFT_SET_ATTR_POLICY);
>+	}
>+
>+	if (nft_set_attr_is_set(nls, NFT_SET_ATTR_DESC_SIZE)) {
>+		set->desc.size = nft_set_attr_get_u32(nls,
>+						      NFT_SET_ATTR_DESC_SIZE);
>+		set->attr_flags |= (1 << NFT_SET_ATTR_DESC_SIZE);
>+	}
>+
> 	return set;
> }
> 
>@@ -1103,6 +1114,14 @@ static int netlink_add_set_batch(struct
>netlink_ctx *ctx,
> 	}
> 	set->handle.set_id = ++set_id;
> 	nft_set_attr_set_u32(nls, NFT_SET_ATTR_ID, set->handle.set_id);
>+
>+	if (set->attr_flags & (1 << NFT_SET_ATTR_POLICY))
>+		nft_set_attr_set_u32(nls, NFT_SET_ATTR_POLICY, set->policy);
>+
>+	if (set->attr_flags & (1 << NFT_SET_ATTR_DESC_SIZE))
>+		nft_set_attr_set_u32(nls, NFT_SET_ATTR_DESC_SIZE,
>+				     set->desc.size);
>+
> 	netlink_dump_set(nls);
> 
> 	err = mnl_nft_set_batch_add(nf_sock, nls, NLM_F_EXCL, ctx->seqnum);
>diff --git a/src/parser.y b/src/parser.y
>index c9b22f0..8c8f94a 100644
>--- a/src/parser.y
>+++ b/src/parser.y
>@@ -20,6 +20,7 @@
> #include <linux/netfilter/nf_tables.h>
> #include <linux/netfilter/nf_conntrack_tuple_common.h>
> #include <libnftnl/common.h>
>+#include <libnftnl/set.h>
> 
> #include <rule.h>
> #include <statement.h>
>@@ -201,6 +202,11 @@ static void location_update(struct location *loc,
>struct location *rhs, int n)
> %token INTERVAL			"interval"
> %token ELEMENTS			"elements"
> 
>+%token POLICY			"policy"
>+%token MEMORY			"memory"
>+%token PERFORMANCE		"performance"
>+%token SIZE			"size"
>+
> %token <val> NUM		"number"
> %token <string> STRING		"string"
> %token <string> QUOTED_STRING
>@@ -401,6 +407,9 @@ static void location_update(struct location *loc,
>struct location *rhs, int n)
> 
> %type <val>			set_flag_list	set_flag
> 
>+%type <val>			set_policy_spec
>+%type <val>			set_size_spec
>+
> %type <set>			set_block_alloc set_block
> %destructor { set_free($$); }	set_block_alloc
> 
>@@ -953,6 +962,7 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
> 						   state->msgs);
> 					YYERROR;
> 				}
>+
> 				$$ = $1;
> 			}
> 			|	set_block	FLAGS		set_flag_list	stmt_seperator
>@@ -965,6 +975,7 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
> 				$1->init = $4;
> 				$$ = $1;
> 			}
>+			|	set_block	set_mechanism	stmt_seperator
> 			;
> 
> set_flag_list		:	set_flag_list	COMMA		set_flag
>@@ -1018,6 +1029,26 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
> 				$1->init = $4;
> 				$$ = $1;
> 			}
>+			|	map_block	set_mechanism	stmt_seperator
>+			;
>+
>+set_mechanism		:	set_policy_spec
>+			{
>+				$<set>0->attr_flags |= (1 << NFT_SET_ATTR_POLICY);
>+				$<set>0->policy = $1;
>+			}
>+			|	set_size_spec
>+			{
>+				$<set>0->attr_flags |= (1 << NFT_SET_ATTR_DESC_SIZE);
>+				$<set>0->desc.size = $1;
>+			}
>+			;
>+
>+set_policy_spec		:	POLICY	PERFORMANCE	{ $$ = NFT_SET_POL_PERFORMANCE;
>}
>+			|	POLICY	MEMORY		{ $$ = NFT_SET_POL_MEMORY; }
>+			;
>+
>+set_size_spec		:	SIZE	NUM	{ $$ = $2; }
> 			;
> 
> hook_spec		:	TYPE		STRING		HOOK		STRING		PRIORITY	NUM
>diff --git a/src/rule.c b/src/rule.c
>index 80deb1b..e2290d7 100644
>--- a/src/rule.c
>+++ b/src/rule.c
>@@ -75,6 +75,7 @@ void set_free(struct set *set)
> 	if (--set->refcnt > 0)
> 		return;
> 	handle_free(&set->handle);
>+
> 	xfree(set);
> }
> 
>@@ -90,6 +91,9 @@ struct set *set_clone(const struct set *set)
> 	newset->datatype = set->datatype;
> 	newset->datalen = set->datalen;
> 	newset->init = expr_clone(set->init);
>+	newset->attr_flags = set->attr_flags;
>+	newset->policy = set->policy;
>+	newset->desc.size = set->desc.size;
> 
> 	return newset;
> }
>@@ -134,6 +138,18 @@ struct print_fmt_options {
> 	const char	*stmt_separator;
> };
> 
>+static const char *set_policy2str(uint32_t policy)
>+{
>+	switch (policy) {
>+	case NFT_SET_POL_PERFORMANCE:
>+		return "performance";
>+	case NFT_SET_POL_MEMORY:
>+		return "memory";
>+	default:
>+		return "unknown";
>+	}
>+}
>+
>static void do_set_print(const struct set *set, struct
>print_fmt_options *opts)
> {
> 	const char *delim = "";
>@@ -153,8 +169,19 @@ static void do_set_print(const struct set *set,
>struct print_fmt_options *opts)
> 	printf("%s%stype %s", opts->tab, opts->tab, set->keytype->name);
> 	if (set->flags & SET_F_MAP)
> 		printf(" : %s", set->datatype->name);
>+
> 	printf("%s", opts->stmt_separator);
> 
>+	if (set->attr_flags & (1 << NFT_SET_ATTR_POLICY)) {
>+		printf("%s%spolicy %s%s", opts->tab, opts->tab,
>+		       set_policy2str(set->policy), opts->stmt_separator);
>+	}
>+
>+	if (set->attr_flags & (1 << NFT_SET_ATTR_DESC_SIZE)) {
>+		printf("%s%ssize %u%s", opts->tab, opts->tab,
>+		       set->desc.size, opts->stmt_separator);
>+	}
>+
> 	if (set->flags & (SET_F_CONSTANT | SET_F_INTERVAL)) {
> 		printf("%s%sflags ", opts->tab, opts->tab);
> 		if (set->flags & SET_F_CONSTANT) {
>diff --git a/src/scanner.l b/src/scanner.l
>index 8aab38f..6458d09 100644
>--- a/src/scanner.l
>+++ b/src/scanner.l
>@@ -271,6 +271,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
> "interval"		{ return INTERVAL; }
> "elements"		{ return ELEMENTS; }
> 
>+"policy"		{ return POLICY; }
>+"size"			{ return SIZE; }
>+"performance"		{ return PERFORMANCE; }
>+"memory"		{ return MEMORY; }
>+
> "counter"		{ return COUNTER; }
> "packets"		{ return PACKETS; }
> "bytes"			{ return BYTES; }


