From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: add support for rule human-readable comments
Date: Wed, 26 Feb 2014 02:52:50 +0100
Message-ID: <1393379570-16256-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40529 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbaBZBxB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:53:01 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for human-readable comments:

  nft add rule filter input accept comment \"accept all traffic\"

Note that comments *always* come at the end of the rule. This uses
the new data area that allows you to attach information to the rule
via netlink.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h            |    2 ++
 src/netlink.c             |    4 ++++
 src/netlink_delinearize.c |   11 +++++++++++
 src/parser.y              |   18 +++++++++++++++---
 src/rule.c                |    7 ++++++-
 src/scanner.l             |    1 +
 6 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index e06444e..ecf801f 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -14,6 +14,7 @@
  * @set:	set name (sets only)
  * @handle:	rule handle (rules only)
  * @position:	rule position (rules only)
+ * @comment:	human-readable comment (rules only)
  */
 struct handle {
 	uint32_t		family;
@@ -22,6 +23,7 @@ struct handle {
 	const char		*set;
 	uint64_t		handle;
 	uint64_t		position;
+	const char		*comment;
 };
 
 extern void handle_merge(struct handle *dst, const struct handle *src);
diff --git a/src/netlink.c b/src/netlink.c
index 2871888..94bda23 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -120,6 +120,10 @@ struct nft_rule *alloc_nft_rule(const struct handle *h)
 		nft_rule_attr_set_u64(nlr, NFT_RULE_ATTR_HANDLE, h->handle);
 	if (h->position)
 		nft_rule_attr_set_u64(nlr, NFT_RULE_ATTR_POSITION, h->position);
+	if (h->comment) {
+		nft_rule_attr_set_data(nlr, NFT_RULE_ATTR_USERDATA,
+				       h->comment, strlen(h->comment) + 1);
+	}
 	return nlr;
 }
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 5eec6cf..ca72091 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -884,9 +884,20 @@ struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 	h.table  = xstrdup(nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_TABLE));
 	h.chain  = xstrdup(nft_rule_attr_get_str(nlr, NFT_RULE_ATTR_CHAIN));
 	h.handle = nft_rule_attr_get_u64(nlr, NFT_RULE_ATTR_HANDLE);
+
 	if (nft_rule_attr_is_set(nlr, NFT_RULE_ATTR_POSITION))
 		h.position = nft_rule_attr_get_u64(nlr, NFT_RULE_ATTR_POSITION);
 
+	if (nft_rule_attr_is_set(nlr, NFT_RULE_ATTR_USERDATA)) {
+		uint32_t len;
+		const void *data;
+
+		data = nft_rule_attr_get_data(nlr, NFT_RULE_ATTR_USERDATA,
+					      &len);
+		h.comment = xmalloc(len);
+		memcpy((char *)h.comment, data, len);
+	}
+
 	pctx->rule = rule_alloc(&netlink_location, &h);
 	pctx->table = table_lookup(&h);
 	assert(pctx->table != NULL);
diff --git a/src/parser.y b/src/parser.y
index 07613e2..6e5904a 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -350,12 +350,13 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token OPTIONS			"options"
 
 %token POSITION			"position"
+%token COMMENT			"comment"
 
 %token XML			"xml"
 %token JSON			"json"
 
-%type <string>			identifier string
-%destructor { xfree($$); }	identifier string
+%type <string>			identifier string comment_spec
+%destructor { xfree($$); }	identifier string comment_spec
 
 %type <cmd>			line
 %destructor { cmd_free($$); }	line
@@ -1019,11 +1020,22 @@ ruleid_spec		:	chain_spec	handle_spec	position_spec
 			}
 			;
 
-rule			:	stmt_list
+comment_spec		:	/* empty */
+			{
+				$$ = NULL;
+			}
+			|	COMMENT		string
+			{
+				$$ = $2;
+			}
+			;
+
+rule			:	stmt_list	comment_spec
 			{
 				struct stmt *i;
 
 				$$ = rule_alloc(&@$, NULL);
+				$$->handle.comment = $2;
 				list_for_each_entry(i, $1, list)
 					$$->num_stmts++;
 				list_splice_tail($1, &$$->stmts);
diff --git a/src/rule.c b/src/rule.c
index ab96e62..23d3e5b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -47,6 +47,8 @@ void handle_merge(struct handle *dst, const struct handle *src)
 		dst->handle = src->handle;
 	if (dst->position == 0)
 		dst->position = src->position;
+	if (dst->comment == NULL && src->comment != NULL)
+		dst->comment = xstrdup(src->comment);
 }
 
 struct set *set_alloc(const struct location *loc)
@@ -154,7 +156,6 @@ void rule_print(const struct rule *rule)
 	}
 	if (handle_output > 0)
 		printf(" # handle %" PRIu64, rule->handle.handle);
-	printf("\n");
 }
 
 struct scope *scope_init(struct scope *scope, const struct scope *parent)
@@ -351,6 +352,10 @@ static void chain_print(const struct chain *chain)
 	list_for_each_entry(rule, &chain->rules, list) {
 		printf("\t\t");
 		rule_print(rule);
+		if (rule->handle.comment)
+			printf(" comment \"%s\"\n", rule->handle.comment);
+		else
+			printf("\n");
 	}
 	printf("\t}\n");
 }
diff --git a/src/scanner.l b/src/scanner.l
index e4cb398..ed6f067 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -258,6 +258,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "export"		{ return EXPORT; }
 
 "position"		{ return POSITION; }
+"comment"		{ return COMMENT; }
 
 "constant"		{ return CONSTANT; }
 "interval"		{ return INTERVAL; }
-- 
1.7.10.4

