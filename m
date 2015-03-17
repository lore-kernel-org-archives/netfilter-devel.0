From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/3] parser: allow to reorder chain options
Date: Tue, 17 Mar 2015 13:13:04 +0100
Message-ID: <1426594385-24063-2-git-send-email-pablo@netfilter.org>
References: <1426594385-24063-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35494 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbbCQMJZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2015 08:09:25 -0400
In-Reply-To: <1426594385-24063-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows all possible combinations to work:

 nft add chain filter input { type filter hook input priority 0 \; }
 nft add chain filter input { priority 0 type filter hook input \; }

Wrt. error reporting, this also improves interaction with humans a bit:

 # nft add chain filter input { type filter hook input \; }
 <cmdline>:1:24-49: Error: missing chain priority
 add chain filter input { type filter hook input ; }
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^

 # nft add chain filter input { type filter hook input priority 0 hook input \; }
 <cmdline>:1:65-69: Error: you cannot set chain hook twice
 add chain filter input { type filter hook input priority 0 hook input ; }
                                                            ^^^^^^^^^^
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h     |   11 +++++++++++
 src/evaluate.c     |   11 ++++++++++-
 src/parser_bison.y |   54 ++++++++++++++++++++++++++++++++++++----------------
 3 files changed, 59 insertions(+), 17 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 90836bc..b0ea1ba 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -92,6 +92,15 @@ extern void table_free(struct table *table);
 extern void table_add_hash(struct table *table);
 extern struct table *table_lookup(const struct handle *h);
 
+enum chain_obj_flags {
+	CHAIN_OBJ_F_HOOK	= (1 << 0),
+	CHAIN_OBJ_F_TYPE	= (1 << 1),
+	CHAIN_OBJ_F_PRIO	= (1 << 2),
+	CHAIN_OBJ_F_BASE	= (CHAIN_OBJ_F_HOOK |
+				   CHAIN_OBJ_F_TYPE |
+				   CHAIN_OBJ_F_PRIO),
+};
+
 /**
  * enum chain_flags - chain flags
  *
@@ -112,6 +121,7 @@ enum chain_flags {
  * @hooknum:	hook number (base chains)
  * @priority:	hook priority (base chains)
  * @type:	chain type
+ * @obj_flags:	internal object flags (indicates structure field is set)
  * @rules:	rules contained in the chain
  */
 struct chain {
@@ -123,6 +133,7 @@ struct chain {
 	unsigned int		hooknum;
 	int			priority;
 	const char		*type;
+	uint32_t		obj_flags;
 	struct scope		scope;
 	struct list_head	rules;
 };
diff --git a/src/evaluate.c b/src/evaluate.c
index a3484c6..79c49ae 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1804,7 +1804,16 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 {
 	struct rule *rule;
 
-	if (chain->flags & CHAIN_F_BASECHAIN) {
+	if (chain->flags & CHAIN_OBJ_F_BASE) {
+		if (!(chain->obj_flags & CHAIN_OBJ_F_HOOK))
+			return chain_error(ctx, chain, "missing chain hook");
+		if (!(chain->obj_flags & CHAIN_OBJ_F_PRIO))
+			return chain_error(ctx, chain, "missing chain priority");
+		if (!(chain->obj_flags & CHAIN_OBJ_F_TYPE))
+			return chain_error(ctx, chain, "missing chain type");
+	}
+
+	if (chain->obj_flags & CHAIN_OBJ_F_HOOK) {
 		chain->hooknum = str2hooknum(chain->handle.family,
 					     chain->hookstr);
 		if (chain->hooknum == NF_INET_NUMHOOKS)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 6fc834d..6fa201d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1034,39 +1034,61 @@ type_identifier		:	identifier
 			}
 			;
 
-hook_spec		:	TYPE		STRING		HOOK		STRING		PRIORITY	NUM
+hook_spec		:	hook_options
+			;
+
+hook_options		:	hook_options	hook_option
+			|	hook_option
 			{
-				$<chain>0->type		= chain_type_name_lookup($2);
-				if ($<chain>0->type == NULL) {
-					erec_queue(error(&@2, "unknown chain type %s", $2),
+				$<stmt>$	= $<stmt>0;
+			}
+			;
+
+hook_option		:	TYPE		STRING
+			{
+				if ($<chain>0->flags & CHAIN_OBJ_F_TYPE) {
+					erec_queue(error(&@$, "you cannot set chain type twice"),
 						   state->msgs);
 					YYERROR;
 				}
-				$<chain>0->hookstr	= chain_hookname_lookup($4);
-				if ($<chain>0->hookstr == NULL) {
-					erec_queue(error(&@4, "unknown chain hook %s", $4),
+				$<chain>0->type		= chain_type_name_lookup($2);
+				if ($<chain>0->type == NULL) {
+					erec_queue(error(&@2, "unknown chain type %s", $2),
 						   state->msgs);
 					YYERROR;
 				}
-				$<chain>0->priority	= $6;
-				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
+				$<chain>0->obj_flags	|= CHAIN_OBJ_F_TYPE;
 			}
-			|	TYPE		STRING		HOOK		STRING		PRIORITY	DASH	NUM
+			|	HOOK		STRING
 			{
-				$<chain>0->type		= chain_type_name_lookup($2);
-				if ($<chain>0->type == NULL) {
-					erec_queue(error(&@2, "unknown type name %s", $2),
+				if ($<chain>0->flags & CHAIN_OBJ_F_HOOK) {
+					erec_queue(error(&@$, "you cannot set chain hook twice"),
 						   state->msgs);
 					YYERROR;
 				}
-				$<chain>0->hookstr	= chain_hookname_lookup($4);
+				$<chain>0->hookstr	= chain_hookname_lookup($2);
 				if ($<chain>0->hookstr == NULL) {
-					erec_queue(error(&@4, "unknown hook name %s", $4),
+					erec_queue(error(&@2, "unknown hook name %s", $2),
 						   state->msgs);
 					YYERROR;
 				}
-				$<chain>0->priority	= -$7;
 				$<chain>0->flags	|= CHAIN_F_BASECHAIN;
+				$<chain>0->obj_flags	|= CHAIN_OBJ_F_HOOK;
+			}
+			|	PRIORITY	NUM
+			{
+				if ($<chain>0->flags & CHAIN_OBJ_F_PRIO) {
+					erec_queue(error(&@$, "you cannot set chain priority twice"),
+						   state->msgs);
+					YYERROR;
+				}
+				$<chain>0->priority	= $2;
+				$<chain>0->obj_flags	|= CHAIN_OBJ_F_PRIO;
+			}
+			|	PRIORITY	DASH	NUM
+			{
+				$<chain>0->priority	= -$3;
+				$<chain>0->obj_flags	|= CHAIN_OBJ_F_PRIO;
 			}
 			;
 
-- 
1.7.10.4

