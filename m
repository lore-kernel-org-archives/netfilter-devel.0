From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: store parser location for handle and position IDs
Date: Wed, 23 Mar 2016 16:51:05 +0100
Message-ID: <1458748265-6100-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58203 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388AbcCWPvZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Mar 2016 11:51:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1EFB98426
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2016 16:51:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BCD35DA8F9
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2016 16:51:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A1C5EDA8F9
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2016 16:51:17 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Store the parser location structure for handle and position IDs so we
can use this information from the evaluation step, to provide better
error reporting.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h            | 26 ++++++++++++++++++++++++--
 src/netlink.c             | 14 +++++++-------
 src/netlink_delinearize.c |  4 ++--
 src/parser_bison.y        | 19 ++++++++++++++-----
 src/rule.c                |  6 +++---
 5 files changed, 50 insertions(+), 19 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index c848f0f..f36f912 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -6,6 +6,28 @@
 #include <list.h>
 
 /**
+ * struct handle_id - handle ID
+ *
+ * @location:	location this handle was defined at
+ * @id:		handle ID value
+ */
+struct handle_id {
+	struct location		location;
+	uint64_t		id;
+};
+
+/**
+ * struct position_id - position ID
+ *
+ * @location:	location this position was defined at
+ * @id:		position ID value
+ */
+struct position_id {
+	struct location		location;
+	uint64_t		id;
+};
+
+/**
  * struct handle - handle for tables, chains, rules and sets
  *
  * @family:	protocol family
@@ -21,8 +43,8 @@ struct handle {
 	const char		*table;
 	const char		*chain;
 	const char		*set;
-	uint64_t		handle;
-	uint64_t		position;
+	struct handle_id	handle;
+	struct position_id	position;
 	uint32_t		set_id;
 };
 
diff --git a/src/netlink.c b/src/netlink.c
index ba0c20a..e3ba2ed 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -143,8 +143,8 @@ struct nftnl_chain *alloc_nftnl_chain(const struct handle *h)
 
 	nftnl_chain_set_u32(nlc, NFTNL_CHAIN_FAMILY, h->family);
 	nftnl_chain_set_str(nlc, NFTNL_CHAIN_TABLE, h->table);
-	if (h->handle != 0)
-		nftnl_chain_set_u64(nlc, NFTNL_CHAIN_HANDLE, h->handle);
+	if (h->handle.id != 0)
+		nftnl_chain_set_u64(nlc, NFTNL_CHAIN_HANDLE, h->handle.id);
 	if (h->chain != NULL)
 		nftnl_chain_set_str(nlc, NFTNL_CHAIN_NAME, h->chain);
 
@@ -163,10 +163,10 @@ struct nftnl_rule *alloc_nftnl_rule(const struct handle *h)
 	nftnl_rule_set_str(nlr, NFTNL_RULE_TABLE, h->table);
 	if (h->chain != NULL)
 		nftnl_rule_set_str(nlr, NFTNL_RULE_CHAIN, h->chain);
-	if (h->handle)
-		nftnl_rule_set_u64(nlr, NFTNL_RULE_HANDLE, h->handle);
-	if (h->position)
-		nftnl_rule_set_u64(nlr, NFTNL_RULE_POSITION, h->position);
+	if (h->handle.id)
+		nftnl_rule_set_u64(nlr, NFTNL_RULE_HANDLE, h->handle.id);
+	if (h->position.id)
+		nftnl_rule_set_u64(nlr, NFTNL_RULE_POSITION, h->position.id);
 
 	return nlr;
 }
@@ -700,7 +700,7 @@ static struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 		nftnl_chain_get_u32(nlc, NFTNL_CHAIN_FAMILY);
 	chain->handle.table  =
 		xstrdup(nftnl_chain_get_str(nlc, NFTNL_CHAIN_TABLE));
-	chain->handle.handle =
+	chain->handle.handle.id =
 		nftnl_chain_get_u64(nlc, NFTNL_CHAIN_HANDLE);
 
 	if (nftnl_chain_is_set(nlc, NFTNL_CHAIN_HOOKNUM) &&
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index d431588..848acd6 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1759,10 +1759,10 @@ struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 	h.family = nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY);
 	h.table  = xstrdup(nftnl_rule_get_str(nlr, NFTNL_RULE_TABLE));
 	h.chain  = xstrdup(nftnl_rule_get_str(nlr, NFTNL_RULE_CHAIN));
-	h.handle = nftnl_rule_get_u64(nlr, NFTNL_RULE_HANDLE);
+	h.handle.id = nftnl_rule_get_u64(nlr, NFTNL_RULE_HANDLE);
 
 	if (nftnl_rule_is_set(nlr, NFTNL_RULE_POSITION))
-		h.position = nftnl_rule_get_u64(nlr, NFTNL_RULE_POSITION);
+		h.position.id = nftnl_rule_get_u64(nlr, NFTNL_RULE_POSITION);
 
 	pctx->rule = rule_alloc(&netlink_location, &h);
 	pctx->table = table_lookup(&h);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 7790865..a2d2687 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -133,6 +133,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 	struct expr		*expr;
 	struct set		*set;
 	const struct datatype	*datatype;
+	struct handle_id	handle_id;
+	struct position_id	position_id;
 }
 
 %token TOKEN_EOF 0		"end of file"
@@ -423,7 +425,10 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { handle_free(&$$); } table_spec chain_spec chain_identifier ruleid_spec ruleset_spec
 %type <handle>			set_spec set_identifier
 %destructor { handle_free(&$$); } set_spec set_identifier
-%type <val>			handle_spec family_spec family_spec_explicit position_spec chain_policy prio_spec
+%type <val>			family_spec family_spec_explicit chain_policy prio_spec
+
+%type <handle_id>		handle_spec
+%type <position_id>		position_spec
 
 %type <string>			dev_spec
 %destructor { xfree($$); }	dev_spec
@@ -1224,21 +1229,25 @@ set_identifier		:	identifier
 
 handle_spec		:	/* empty */
 			{
-				$$ = 0;
+				memset(&$$, 0, sizeof($$));
 			}
 			|	HANDLE		NUM
 			{
-				$$ = $2;
+				memset(&$$, 0, sizeof($$));
+				$$.location	= @$;
+				$$.id		= $2;
 			}
 			;
 
 position_spec		:	/* empty */
 			{
-				$$ = 0;
+				memset(&$$, 0, sizeof($$));
 			}
 			|	POSITION	NUM
 			{
-				$$ = $2;
+				memset(&$$, 0, sizeof($$));
+				$$.location	= @$;
+				$$.id		= $2;
 			}
 			;
 
diff --git a/src/rule.c b/src/rule.c
index 85987b9..28e16d0 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -44,9 +44,9 @@ void handle_merge(struct handle *dst, const struct handle *src)
 		dst->chain = xstrdup(src->chain);
 	if (dst->set == NULL && src->set != NULL)
 		dst->set = xstrdup(src->set);
-	if (dst->handle == 0)
+	if (dst->handle.id == 0)
 		dst->handle = src->handle;
-	if (dst->position == 0)
+	if (dst->position.id == 0)
 		dst->position = src->position;
 }
 
@@ -392,7 +392,7 @@ void rule_print(const struct rule *rule)
 		printf("comment \"%s\" ", rule->comment);
 
 	if (handle_output > 0)
-		printf("# handle %" PRIu64, rule->handle.handle);
+		printf("# handle %" PRIu64, rule->handle.handle.id);
 }
 
 struct scope *scope_init(struct scope *scope, const struct scope *parent)
-- 
2.1.4

