From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 2/2] Rule comment is now stored into a TLV attribute.
Date: Thu,  4 Feb 2016 20:38:40 +0100
Message-ID: <1454614720-8126-2-git-send-email-carlosfg@riseup.net>
References: <1454614720-8126-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:60920 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966004AbcBDTi5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Feb 2016 14:38:57 -0500
In-Reply-To: <1454614720-8126-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Modify the rule structure and the parser to store the comment string in=
to a TLV
attribute. This way more data of any type could be stored with a rule.

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 include/rule.h            |  4 +++-
 src/netlink_delinearize.c | 10 ++++++++--
 src/netlink_linearize.c   |  4 +++-
 src/parser_bison.y        | 19 ++++++++++++++++---
 src/rule.c                | 12 +++++++++---
 5 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index c848f0f..7a18c50 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -163,9 +163,11 @@ struct rule {
 	struct location		location;
 	struct list_head	stmts;
 	unsigned int		num_stmts;
-	const char		*comment;
+	struct nftnl_attrbuf	*comment;
 };
=20
+#define RULE_COMMENT_MAX_LEN 256
+
 extern struct rule *rule_alloc(const struct location *loc,
 			       const struct handle *h);
 extern void rule_free(struct rule *rule);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index ae6abb0..d0d85aa 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -25,6 +25,7 @@
 #include <utils.h>
 #include <erec.h>
 #include <sys/socket.h>
+#include <libnftnl/attr.h>
=20
 struct netlink_parse_ctx {
 	struct list_head	*msgs;
@@ -1734,12 +1735,17 @@ struct rule *netlink_delinearize_rule(struct ne=
tlink_ctx *ctx,
 	assert(pctx->table !=3D NULL);
=20
 	if (nftnl_rule_is_set(nlr, NFTNL_RULE_USERDATA)) {
+		struct nftnl_attrbuf *attrbuf;
 		const void *data;
 		uint32_t len;
=20
 		data =3D nftnl_rule_get_data(nlr, NFTNL_RULE_USERDATA, &len);
-		pctx->rule->comment =3D xmalloc(len);
-		memcpy((char *)pctx->rule->comment, data, len);
+		if (!(attrbuf =3D nftnl_attrbuf_alloc(len))) {
+			perror("Error allocating memory for attrbuf: ");
+			exit(EXIT_FAILURE);
+		}
+		pctx->rule->comment =3D nftnl_attrbuf_alloc(len);
+		nftnl_attrbuf_set_data(pctx->rule->comment, data, len);
 	}
=20
 	nftnl_expr_foreach((struct nftnl_rule *)nlr, netlink_parse_expr, pctx=
);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 86b49c6..4fd5e1e 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -21,6 +21,7 @@
 #include <netinet/in.h>
=20
 #include <linux/netfilter.h>
+#include <libnftnl/attr.h>
=20
=20
 struct netlink_linearize_ctx {
@@ -1110,7 +1111,8 @@ void netlink_linearize_rule(struct netlink_ctx *c=
tx, struct nftnl_rule *nlr,
=20
 	if (rule->comment)
 		nftnl_rule_set_data(nlr, NFTNL_RULE_USERDATA,
-				    rule->comment, strlen(rule->comment) + 1);
+				    nftnl_attrbuf_get_data(rule->comment),
+				    nftnl_attrbuf_get_len(rule->comment));
=20
 	netlink_dump_rule(nlr);
 }
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 05ade0f..3ebed7a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -24,6 +24,7 @@
 #include <netinet/icmp6.h>
 #include <libnftnl/common.h>
 #include <libnftnl/set.h>
+#include <libnftnl/attr.h>
=20
 #include <rule.h>
 #include <statement.h>
@@ -132,6 +133,7 @@ static void location_update(struct location *loc, s=
truct location *rhs, int n)
 	struct stmt		*stmt;
 	struct expr		*expr;
 	struct set		*set;
+	struct nftnl_attrbuf	*attrbuf;
 	const struct datatype	*datatype;
 }
=20
@@ -406,8 +408,8 @@ static void location_update(struct location *loc, s=
truct location *rhs, int n)
 %token XML			"xml"
 %token JSON			"json"
=20
-%type <string>			identifier type_identifier string comment_spec
-%destructor { xfree($$); }	identifier type_identifier string comment_s=
pec
+%type <string>			identifier type_identifier string
+%destructor { xfree($$); }	identifier type_identifier string
=20
 %type <val>			time_spec
=20
@@ -432,6 +434,8 @@ static void location_update(struct location *loc, s=
truct location *rhs, int n)
 %destructor { close_scope(state); chain_free($$); }	chain_block_alloc
 %type <rule>			rule
 %destructor { rule_free($$); }	rule
+%type <attrbuf>			comment_spec
+%destructor { nftnl_attrbuf_free($$); }      comment_spec
=20
 %type <val>			set_flag_list	set_flag
=20
@@ -1283,7 +1287,16 @@ comment_spec		:	/* empty */
 			}
 			|	COMMENT		string
 			{
-				$$ =3D $2;
+				$$ =3D nftnl_attrbuf_alloc(RULE_COMMENT_MAX_LEN);
+				if (!nftnl_attr_put_check($$,
+					RULE_COMMENT_MAX_LEN,
+					NFTNL_ATTR_TYPE_STRING,
+					strlen($2), $2)
+				) {
+					erec_queue(error(&@2, "Comment too long: \"%s\"", $2),
+						state->msgs);
+					YYERROR;
+				}
 			}
 			;
=20
diff --git a/src/rule.c b/src/rule.c
index 18ff592..79c665c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -23,6 +23,7 @@
=20
 #include <libnftnl/common.h>
 #include <libnftnl/ruleset.h>
+#include <libnftnl/attr.h>
 #include <netinet/ip.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter_arp.h>
@@ -368,6 +369,7 @@ struct rule *rule_alloc(const struct location *loc,=
 const struct handle *h)
 	init_list_head(&rule->stmts);
 	if (h !=3D NULL)
 		rule->handle =3D *h;
+	rule->comment =3D NULL;
 	return rule;
 }
=20
@@ -375,21 +377,25 @@ void rule_free(struct rule *rule)
 {
 	stmt_list_free(&rule->stmts);
 	handle_free(&rule->handle);
-	xfree(rule->comment);
+	if (rule->comment)
+		nftnl_attrbuf_free(rule->comment);
 	xfree(rule);
 }
=20
 void rule_print(const struct rule *rule)
 {
 	const struct stmt *stmt;
+	struct nftnl_attr *attr;
=20
 	list_for_each_entry(stmt, &rule->stmts, list) {
 		stmt->ops->print(stmt);
 		printf(" ");
 	}
=20
-	if (rule->comment)
-		printf("comment \"%s\" ", rule->comment);
+	if (rule->comment) {
+		attr =3D nftnl_attrbuf_get_head(rule->comment);
+		printf("comment \"%s\" ", (char *)nftnl_attr_get_value(attr));
+	}
=20
 	if (handle_output > 0)
 		printf("# handle %" PRIu64, rule->handle.handle);
--=20
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
