Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25726C76196
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 10:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2E2220880
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 10:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733173AbfGPK04 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 06:26:56 -0400
Received: from mail.us.es ([193.147.175.20]:60880 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732524AbfGPK0z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 06:26:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F1F43B6C61
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 12:26:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BE166D190F
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 12:26:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7509511541A; Tue, 16 Jul 2019 12:26:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 325001153F3
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 12:26:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jul 2019 12:26:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 105B44265A2F
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 12:26:27 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/5] src: add set_is_datamap(), set_is_objmap() and set_is_map() helpers
Date:   Tue, 16 Jul 2019 12:26:20 +0200
Message-Id: <20190716102624.4628-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Two map types are currently possible:

* data maps, ie. set_is_datamap().
* object maps, ie. set_is_objmap().

This patch adds helper function to check for the map type.

set_is_map() allows you to check for either map type.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h | 16 ++++++++++++++++
 src/evaluate.c | 12 ++++++------
 src/json.c     |  4 ++--
 src/mnl.c      |  6 +++---
 src/netlink.c  | 12 ++++++------
 src/rule.c     |  6 +++---
 6 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index aefb24d95163..bee1d4474216 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -6,6 +6,7 @@
 #include <list.h>
 #include <netinet/in.h>
 #include <libnftnl/object.h>	/* For NFTNL_CTTIMEOUT_ARRAY_MAX. */
+#include <linux/netfilter/nf_tables.h>
 
 /**
  * struct handle_spec - handle ID
@@ -321,6 +322,21 @@ extern const char *set_policy2str(uint32_t policy);
 extern void set_print(const struct set *set, struct output_ctx *octx);
 extern void set_print_plain(const struct set *s, struct output_ctx *octx);
 
+static inline bool set_is_datamap(uint32_t set_flags)
+{
+	return set_flags & NFT_SET_MAP;
+}
+
+static inline bool set_is_objmap(uint32_t set_flags)
+{
+	return set_flags & NFT_SET_OBJECT;
+}
+
+static inline bool set_is_map(uint32_t set_flags)
+{
+	return set_is_datamap(set_flags) || set_is_objmap(set_flags);
+}
+
 #include <statement.h>
 
 struct counter {
diff --git a/src/evaluate.c b/src/evaluate.c
index 8086f750417a..e1a827e723ae 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -83,7 +83,7 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 	struct set *set;
 	struct handle h;
 
-	if (expr->set_flags & NFT_SET_MAP)
+	if (set_is_datamap(expr->set_flags))
 		key_fix_dtype_byteorder(key);
 
 	set = set_alloc(&expr->location);
@@ -1381,7 +1381,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 		if (expr_evaluate(ctx, &map->mappings) < 0)
 			return -1;
 		if (map->mappings->etype != EXPR_SET_REF ||
-		    !(map->mappings->set->flags & NFT_SET_MAP))
+		    !set_is_datamap(map->mappings->set->flags))
 			return expr_error(ctx->msgs, map->mappings,
 					  "Expression is not a map");
 		break;
@@ -1416,7 +1416,7 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 	if (set == NULL)
 		return expr_error(ctx->msgs, mapping,
 				  "mapping outside of map context");
-	if (!(set->flags & (NFT_SET_MAP | NFT_SET_OBJECT)))
+	if (!set_is_map(set->flags))
 		return set_error(ctx, set, "set is not a map");
 
 	expr_set_context(&ctx->ectx, set->key->dtype, set->key->len);
@@ -2991,7 +2991,7 @@ static int stmt_evaluate_objref_map(struct eval_ctx *ctx, struct stmt *stmt)
 		if (map->mappings->etype != EXPR_SET_REF)
 			return expr_error(ctx->msgs, map->mappings,
 					  "Expression is not a map");
-		if (!(map->mappings->set->flags & NFT_SET_OBJECT))
+		if (!set_is_objmap(map->mappings->set->flags))
 			return expr_error(ctx->msgs, map->mappings,
 					  "Expression is not a map with objects");
 		break;
@@ -3149,7 +3149,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 	    set->key->etype == EXPR_CONCAT)
 		return set_error(ctx, set, "concatenated types not supported in interval sets");
 
-	if (set->flags & NFT_SET_MAP) {
+	if (set_is_datamap(set->flags)) {
 		if (set->datatype == NULL)
 			return set_error(ctx, set, "map definition does not "
 					 "specify mapping data type");
@@ -3158,7 +3158,7 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 		if (set->datalen == 0 && set->datatype->type != TYPE_VERDICT)
 			return set_error(ctx, set, "unqualified mapping data "
 					 "type specified in map definition");
-	} else if (set->flags & NFT_SET_OBJECT) {
+	} else if (set_is_objmap(set->flags)) {
 		set->datatype = &string_type;
 		set->datalen  = NFT_OBJ_MAXNAMELEN * BITS_PER_BYTE;
 	}
diff --git a/src/json.c b/src/json.c
index 1006d7bb7f22..f40dc51883b7 100644
--- a/src/json.c
+++ b/src/json.c
@@ -79,10 +79,10 @@ static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 	json_t *root, *tmp;
 	const char *type, *datatype_ext = NULL;
 
-	if (set->flags & NFT_SET_MAP) {
+	if (set_is_datamap(set->flags)) {
 		type = "map";
 		datatype_ext = set->datatype->name;
-	} else if (set->flags & NFT_SET_OBJECT) {
+	} else if (set_is_objmap(set->flags)) {
 		type = "map";
 		datatype_ext = obj_type_name(set->objtype);
 	} else if (set->flags & NFT_SET_EVAL) {
diff --git a/src/mnl.c b/src/mnl.c
index c145cc5c9228..a954e9d8f5cd 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -799,13 +799,13 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 			  dtype_map_to_kernel(set->key->dtype));
 	nftnl_set_set_u32(nls, NFTNL_SET_KEY_LEN,
 			  div_round_up(set->key->len, BITS_PER_BYTE));
-	if (set->flags & NFT_SET_MAP) {
+	if (set_is_datamap(set->flags)) {
 		nftnl_set_set_u32(nls, NFTNL_SET_DATA_TYPE,
 				  dtype_map_to_kernel(set->datatype));
 		nftnl_set_set_u32(nls, NFTNL_SET_DATA_LEN,
 				  set->datalen / BITS_PER_BYTE);
 	}
-	if (set->flags & NFT_SET_OBJECT)
+	if (set_is_objmap(set->flags))
 		nftnl_set_set_u32(nls, NFTNL_SET_OBJ_TYPE, set->objtype);
 
 	if (set->timeout)
@@ -833,7 +833,7 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 				 set->key->byteorder))
 		memory_allocation_error();
 
-	if (set->flags & NFT_SET_MAP &&
+	if (set_is_datamap(set->flags) &&
 	    !nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_DATABYTEORDER,
 				 set->datatype->byteorder))
 		memory_allocation_error();
diff --git a/src/netlink.c b/src/netlink.c
index 97eb082c6547..0374c39aca91 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -146,7 +146,7 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 				   nftnl_udata_buf_len(udbuf));
 		nftnl_udata_buf_free(udbuf);
 	}
-	if (set->set_flags & NFT_SET_MAP && data != NULL) {
+	if (set_is_datamap(set->set_flags) && data != NULL) {
 		netlink_gen_data(data, &nld);
 		switch (data->etype) {
 		case EXPR_VERDICT:
@@ -165,7 +165,7 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 			break;
 		}
 	}
-	if (set->set_flags & NFT_SET_OBJECT && data != NULL) {
+	if (set_is_objmap(set->set_flags) && data != NULL) {
 		netlink_gen_data(data, &nld);
 		nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_OBJREF,
 				   nld.value, nld.len);
@@ -581,7 +581,7 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	}
 
 	flags = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
-	if (flags & NFT_SET_MAP) {
+	if (set_is_datamap(flags)) {
 		data = nftnl_set_get_u32(nls, NFTNL_SET_DATA_TYPE);
 		datatype = dtype_map_from_kernel(data);
 		if (datatype == NULL) {
@@ -593,7 +593,7 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	} else
 		datatype = NULL;
 
-	if (flags & NFT_SET_OBJECT) {
+	if (set_is_objmap(flags)) {
 		objtype = nftnl_set_get_u32(nls, NFTNL_SET_OBJ_TYPE);
 		datatype = &string_type;
 	}
@@ -795,7 +795,7 @@ int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 	if (flags & NFT_SET_ELEM_INTERVAL_END)
 		expr->flags |= EXPR_F_INTERVAL_END;
 
-	if (set->flags & NFT_SET_MAP) {
+	if (set_is_datamap(set->flags)) {
 		if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_DATA)) {
 			nld.value = nftnl_set_elem_get(nlse, NFTNL_SET_ELEM_DATA,
 						       &nld.len);
@@ -817,7 +817,7 @@ int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 
 		expr = mapping_expr_alloc(&netlink_location, expr, data);
 	}
-	if (set->flags & NFT_SET_OBJECT) {
+	if (set_is_objmap(set->flags)) {
 		if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_OBJREF)) {
 			nld.value = nftnl_set_elem_get(nlse,
 						       NFTNL_SET_ELEM_OBJREF,
diff --git a/src/rule.c b/src/rule.c
index 0a91917f7568..e04fc09b0a5b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -449,7 +449,7 @@ static void set_print_declaration(const struct set *set,
 	if ((set->flags & (NFT_SET_EVAL | NFT_SET_ANONYMOUS)) ==
 				(NFT_SET_EVAL | NFT_SET_ANONYMOUS))
 		type = "meter";
-	else if (set->flags & (NFT_SET_MAP | NFT_SET_OBJECT))
+	else if (set_is_map(set->flags))
 		type = "map";
 	else
 		type = "set";
@@ -469,9 +469,9 @@ static void set_print_declaration(const struct set *set,
 	nft_print(octx, "%s", opts->nl);
 	nft_print(octx, "%s%stype %s",
 		  opts->tab, opts->tab, set->key->dtype->name);
-	if (set->flags & NFT_SET_MAP)
+	if (set_is_datamap(set->flags))
 		nft_print(octx, " : %s", set->datatype->name);
-	else if (set->flags & NFT_SET_OBJECT)
+	else if (set_is_objmap(set->flags))
 		nft_print(octx, " : %s", obj_type_name(set->objtype));
 
 	nft_print(octx, "%s", opts->stmt_separator);
-- 
2.11.0

