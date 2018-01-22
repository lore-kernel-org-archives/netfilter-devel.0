From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,RFC] src: add 'auto-merge' option to sets
Date: Mon, 22 Jan 2018 11:50:31 +0100
Message-ID: <20180122105031.19988-1-pablo@netfilter.org>
Cc: netfilter@allycomm.com, karel@unitednetworks.cz, phil@nwl.cc
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43250 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751024AbeAVKuk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jan 2018 05:50:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 92E692EFEA4
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jan 2018 11:50:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81AECBAAAE
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jan 2018 11:50:38 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

After discussions with Karel here:

https://bugzilla.netfilter.org/show_bug.cgi?id=1184

And later on with Phil Sutter, we decided to disable the automatic merge
feature in sets with intervals. This feature is problematic because it
introduces an inconsistency between what we add and what we later on
get. This is going to get worse with the upcoming timeout support for
intervals. Therefore, we turned off this by default.

However, Jeff Kletsky and folks like this feature, so let's restore this
behaviour on demand with this new 'auto-merge' statement, that you can
place on the set definition, eg.

 # nft list ruleset
 table ip x {
	...
        set y {
                type ipv4_addr
                flags interval
                auto-merge
        }
 }
 # nft add element x z { 1.1.1.1-2.2.2.2, 1.1.1.2 }

Regarding implementation details: Given this feature only makes sense
from userspace, let's store this in the set user data area, so nft knows
it has to do automatic merge of adjacent/overlapping elements as per
user request.

 # nft add set x z { type ipv4_addr\; auto-merge\; }
 Error: auto-merge only works with interval sets
 add set x z { type ipv4_addr; auto-merge; }
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Fixes: https://bugzilla.netfilter.org/show_bug.cgi?id=1216
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.xml        |  6 ++++++
 include/netlink.h  |  2 --
 include/nftables.h |  1 -
 include/rule.h     |  3 +++
 src/evaluate.c     |  3 +++
 src/libnftables.c  |  1 -
 src/netlink.c      | 11 +++++++++++
 src/parser_bison.y |  6 ++++++
 src/rule.c         |  9 ++++++---
 src/scanner.l      |  1 +
 10 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 9e979af3c280..6a95ea688965 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -883,6 +883,7 @@ filter input iif $int_ifs accept
 				<arg choice="opt">elements = { <replaceable>element</replaceable>[,...] } ;</arg>
 				<arg choice="opt">size <replaceable>size</replaceable> ;</arg>
 				<arg choice="opt">policy <replaceable>policy</replaceable> ;</arg>
+				<arg choice="opt">auto-merge <replaceable>auto-merge</replaceable> ;</arg>
 				}
 			</cmdsynopsis>
 			<cmdsynopsis>
@@ -1013,6 +1014,11 @@ filter input iif $int_ifs accept
 						<entry>set policy</entry>
 						<entry>string: performance [default], memory</entry>
 					</row>
+					<row>
+						<entry>auto-merge</entry>
+						<entry>automatic merge of adjacent/overlapping set elements (only for interval sets)</entry>
+						<entry></entry>
+					</row>
 				</tbody>
 			</tgroup>
 		</table>
diff --git a/include/netlink.h b/include/netlink.h
index 0d71a6b96d82..66686e5a3313 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -42,7 +42,6 @@ extern const struct location netlink_location;
  * @octx:	output context
  * @debug_mask:	display debugging information
  * @cache:	cache context
- * @range_merge: merge adjacent/overlapping ranges in new set elements
  */
 struct netlink_ctx {
 	struct mnl_socket	*nf_sock;
@@ -56,7 +55,6 @@ struct netlink_ctx {
 	unsigned int		debug_mask;
 	struct output_ctx	*octx;
 	struct nft_cache	*cache;
-	bool			range_merge;
 };
 
 extern struct nftnl_table *alloc_nftnl_table(const struct handle *h);
diff --git a/include/nftables.h b/include/nftables.h
index f22df0d1ddc1..3bfa33e5cb33 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -31,7 +31,6 @@ struct nft_ctx {
 	unsigned int		debug_mask;
 	struct output_ctx	output;
 	bool			check;
-	bool			range_merge;
 	struct nft_cache	cache;
 	uint32_t		flags;
 };
diff --git a/include/rule.h b/include/rule.h
index 4e5a349a806a..d9c172dd9359 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -220,6 +220,7 @@ extern struct rule *rule_lookup(const struct chain *chain, uint64_t handle);
  * @init:	initializer
  * @rg_cache:	cached range element (left)
  * @policy:	set mechanism policy
+ * @automerge:	merge adjacents and overlapping elements, if possible
  * @desc:	set mechanism desc
  */
 struct set {
@@ -237,6 +238,7 @@ struct set {
 	struct expr		*init;
 	struct expr		*rg_cache;
 	uint32_t		policy;
+	bool			automerge;
 	struct {
 		uint32_t	size;
 	} desc;
@@ -528,6 +530,7 @@ enum udata_type {
 enum udata_set_type {
 	UDATA_SET_KEYBYTEORDER,
 	UDATA_SET_DATABYTEORDER,
+	UDATA_SET_MERGE_ELEMENTS,
 	__UDATA_SET_MAX,
 };
 #define UDATA_SET_MAX (__UDATA_SET_MAX - 1)
diff --git a/src/evaluate.c b/src/evaluate.c
index 2da589c01a62..bcdd2dfd857f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2846,6 +2846,9 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 		return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 				 ctx->cmd->handle.table);
 
+	if (!(set->flags & NFT_SET_INTERVAL) && set->automerge)
+		return set_error(ctx, set, "auto-merge only works with interval sets");
+
 	type = set->flags & NFT_SET_MAP ? "map" : "set";
 
 	if (set->key == NULL)
diff --git a/src/libnftables.c b/src/libnftables.c
index 8a18bb78f0d9..c86d89477e77 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -43,7 +43,6 @@ static int nft_netlink(struct nft_ctx *nft,
 		ctx.nf_sock = nf_sock;
 		ctx.cache = &nft->cache;
 		ctx.debug_mask = nft->debug_mask;
-		ctx.range_merge = nft->range_merge;
 		init_list_head(&ctx.list);
 		ret = do_command(&ctx, cmd);
 		if (ret < 0)
diff --git a/src/netlink.c b/src/netlink.c
index 23f92443f8c4..488ae6f3971f 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1052,6 +1052,7 @@ static int set_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 	switch (type) {
 	case UDATA_SET_KEYBYTEORDER:
 	case UDATA_SET_DATABYTEORDER:
+	case UDATA_SET_MERGE_ELEMENTS:
 		if (len != sizeof(uint32_t))
 			return -1;
 		break;
@@ -1070,6 +1071,7 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	enum byteorder keybyteorder = BYTEORDER_INVALID;
 	enum byteorder databyteorder = BYTEORDER_INVALID;
 	const struct datatype *keytype, *datatype;
+	bool automerge = false;
 	const char *udata;
 	struct set *set;
 	uint32_t ulen;
@@ -1087,6 +1089,9 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 		if (ud[UDATA_SET_DATABYTEORDER])
 			databyteorder =
 				nftnl_udata_get_u32(ud[UDATA_SET_DATABYTEORDER]);
+		if (ud[UDATA_SET_MERGE_ELEMENTS])
+			automerge =
+				nftnl_udata_get_u32(ud[UDATA_SET_MERGE_ELEMENTS]);
 	}
 
 	key = nftnl_set_get_u32(nls, NFTNL_SET_KEY_TYPE);
@@ -1119,6 +1124,7 @@ static struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	set->handle.family = nftnl_set_get_u32(nls, NFTNL_SET_FAMILY);
 	set->handle.table  = xstrdup(nftnl_set_get_str(nls, NFTNL_SET_TABLE));
 	set->handle.set    = xstrdup(nftnl_set_get_str(nls, NFTNL_SET_NAME));
+	set->automerge	   = automerge;
 
 	set->key     = constant_expr_alloc(&netlink_location,
 					   set_datatype_alloc(keytype, keybyteorder),
@@ -1238,6 +1244,11 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 				 set->datatype->byteorder))
 		memory_allocation_error();
 
+	if (set->automerge &&
+	    !nftnl_udata_put_u32(udbuf, UDATA_SET_MERGE_ELEMENTS,
+				 set->automerge))
+		memory_allocation_error();
+
 	nftnl_set_set_data(nls, NFTNL_SET_USERDATA, nftnl_udata_buf_data(udbuf),
 			   nftnl_udata_buf_len(udbuf));
 	nftnl_udata_buf_free(udbuf);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 009b801f9d6b..2e79109f4da3 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -234,6 +234,7 @@ int nft_lex(void *, void *, void *);
 
 %token CONSTANT			"constant"
 %token INTERVAL			"interval"
+%token AUTOMERGE		"auto-merge"
 %token TIMEOUT			"timeout"
 %token GC_INTERVAL		"gc-interval"
 %token ELEMENTS			"elements"
@@ -1407,6 +1408,11 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->init = $4;
 				$$ = $1;
 			}
+			|	set_block	AUTOMERGE
+			{
+				$1->automerge = true;
+				$$ = $1;
+			}
 			|	set_block	set_mechanism	stmt_separator
 			;
 
diff --git a/src/rule.c b/src/rule.c
index f19197fe240d..c7b4b4988011 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -344,6 +344,9 @@ static void set_print_declaration(const struct set *set,
 		}
 		nft_print(octx, "%s", opts->stmt_separator);
 	}
+	if (set->automerge)
+		nft_print(octx, "%s%sauto-merge%s", opts->tab, opts->tab,
+			  opts->stmt_separator);
 
 	if (set->timeout) {
 		nft_print(octx, "%s%stimeout ", opts->tab, opts->tab);
@@ -998,7 +1001,7 @@ static int do_add_setelems(struct netlink_ctx *ctx, const struct handle *h,
 
 	if (set->flags & NFT_SET_INTERVAL &&
 	    set_to_intervals(ctx->msgs, set, init, true,
-			     ctx->debug_mask, ctx->range_merge) < 0)
+			     ctx->debug_mask, set->automerge) < 0)
 		return -1;
 
 	return __do_add_setelems(ctx, h, set, init, flags);
@@ -1010,7 +1013,7 @@ static int do_add_set(struct netlink_ctx *ctx, const struct handle *h,
 	if (set->init != NULL) {
 		if (set->flags & NFT_SET_INTERVAL &&
 		    set_to_intervals(ctx->msgs, set, set->init, true,
-				     ctx->debug_mask, ctx->range_merge) < 0)
+				     ctx->debug_mask, set->automerge) < 0)
 			return -1;
 	}
 	if (netlink_add_set(ctx, h, set, flags) < 0)
@@ -1110,7 +1113,7 @@ static int do_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
 
 	if (set->flags & NFT_SET_INTERVAL &&
 	    set_to_intervals(ctx->msgs, set, expr, false,
-			     ctx->debug_mask, ctx->range_merge) < 0)
+			     ctx->debug_mask, set->automerge) < 0)
 		return -1;
 
 	if (netlink_delete_setelems(ctx, h, expr) < 0)
diff --git a/src/scanner.l b/src/scanner.l
index 5402be1cc2b0..c3992a784c71 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -283,6 +283,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "constant"		{ return CONSTANT; }
 "interval"		{ return INTERVAL; }
+"auto-merge"		{ return AUTOMERGE; }
 "timeout"		{ return TIMEOUT; }
 "gc-interval"		{ return GC_INTERVAL; }
 "elements"		{ return ELEMENTS; }
-- 
2.11.0

