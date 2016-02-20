From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 2/2] nftables: rule: Change the field "rule->comment" for an nftnl_attrbuf.
Date: Sat, 20 Feb 2016 23:43:54 +0100
Message-ID: <1456008234-26845-3-git-send-email-carlosfg@riseup.net>
References: <1456008234-26845-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:46500 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbcBTWoJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Feb 2016 17:44:09 -0500
In-Reply-To: <1456008234-26845-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now it is possible to store multiple variable length user data into rul=
e.
Modify the parser in order to fill the nftnl_attrbuf with the comment, =
and
the print function for extract these commentary and print it to user.

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 include/rule.h            |  7 +++++--
 src/netlink_delinearize.c |  7 +++++--
 src/netlink_linearize.c   |  6 ++++--
 src/parser_bison.y        | 17 ++++++++++++++++-
 src/rule.c                | 28 +++++++++++++++++++++++++---
 5 files changed, 55 insertions(+), 10 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index c848f0f..96086ab 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -4,6 +4,7 @@
 #include <stdint.h>
 #include <nftables.h>
 #include <list.h>
+#include <libnftnl/attr.h>
=20
 /**
  * struct handle - handle for tables, chains, rules and sets
@@ -155,7 +156,7 @@ extern void chain_print_plain(const struct chain *c=
hain);
  * @location:	location the rule was defined at
  * @stmt:	list of statements
  * @num_stmts:	number of statements in stmts list
- * @comment:	comment
+ * @udata:	user data
  */
 struct rule {
 	struct list_head	list;
@@ -163,9 +164,11 @@ struct rule {
 	struct location		location;
 	struct list_head	stmts;
 	unsigned int		num_stmts;
-	const char		*comment;
+	struct nftnl_attrbuf	*udata;
 };
=20
+#define RULE_UDATA_MAX_LEN 256
+
 extern struct rule *rule_alloc(const struct location *loc,
 			       const struct handle *h);
 extern void rule_free(struct rule *rule);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index ae6abb0..c7448d3 100644
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
@@ -1738,8 +1739,10 @@ struct rule *netlink_delinearize_rule(struct net=
link_ctx *ctx,
 		uint32_t len;
=20
 		data =3D nftnl_rule_get_data(nlr, NFTNL_RULE_USERDATA, &len);
-		pctx->rule->comment =3D xmalloc(len);
-		memcpy((char *)pctx->rule->comment, data, len);
+		pctx->rule->udata =3D nftnl_attrbuf_alloc(len);
+		if (!pctx->rule->udata)
+			memory_allocation_error();
+		nftnl_attrbuf_copy_data(pctx->rule->udata, data, len);
 	}
=20
 	nftnl_expr_foreach((struct nftnl_rule *)nlr, netlink_parse_expr, pctx=
);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 86b49c6..7b33f33 100644
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
@@ -1108,9 +1109,10 @@ void netlink_linearize_rule(struct netlink_ctx *=
ctx, struct nftnl_rule *nlr,
 	list_for_each_entry(stmt, &rule->stmts, list)
 		netlink_gen_stmt(&lctx, stmt);
=20
-	if (rule->comment)
+	if (rule->udata)
 		nftnl_rule_set_data(nlr, NFTNL_RULE_USERDATA,
-				    rule->comment, strlen(rule->comment) + 1);
+				    nftnl_attrbuf_get_data(rule->udata),
+				    nftnl_attrbuf_get_len(rule->udata));
=20
 	netlink_dump_rule(nlr);
 }
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 05ade0f..8990975 100644
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
@@ -1304,7 +1305,21 @@ rule			:	stmt_list	comment_spec
 				struct stmt *i;
=20
 				$$ =3D rule_alloc(&@$, NULL);
-				$$->comment =3D $2;
+
+				if ($2) {
+					if (!($$->udata =3D nftnl_attrbuf_alloc(RULE_UDATA_MAX_LEN)))
+						memory_allocation_error();
+
+					if (!(nftnl_attr_put_check($$->udata,
+						NFTNL_ATTR_TYPE_COMMENT,
+						strlen($2) + 1, $2))
+					) {
+						erec_queue(error(&@2, "Comment too long: \"%s\"", $2),
+							state->msgs);
+						YYERROR;
+					}
+				}
+
 				list_for_each_entry(i, $1, list)
 					$$->num_stmts++;
 				list_splice_tail($1, &$$->stmts);
diff --git a/src/rule.c b/src/rule.c
index 18ff592..8ca4bb0 100644
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
@@ -366,6 +367,7 @@ struct rule *rule_alloc(const struct location *loc,=
 const struct handle *h)
 	rule->location =3D *loc;
 	init_list_head(&rule->list);
 	init_list_head(&rule->stmts);
+	rule->udata =3D NULL;
 	if (h !=3D NULL)
 		rule->handle =3D *h;
 	return rule;
@@ -375,21 +377,41 @@ void rule_free(struct rule *rule)
 {
 	stmt_list_free(&rule->stmts);
 	handle_free(&rule->handle);
-	xfree(rule->comment);
+	nftnl_attrbuf_free(rule->udata);
 	xfree(rule);
 }
=20
+static int rule_parse_userdata_cb(const struct nftnl_attr *attr,
+				  void *data)
+{
+	const struct nftnl_attr **tb =3D data;
+	uint8_t type =3D nftnl_attr_get_type(attr);
+
+	tb[type] =3D attr;
+	return NFTNL_CB_OK;
+}
+
+
 void rule_print(const struct rule *rule)
 {
 	const struct stmt *stmt;
+	const struct nftnl_attr *tb[NFTNL_ATTR_TYPE_MAX+1] =3D {};
+	const struct nftnl_attr *attr;
=20
 	list_for_each_entry(stmt, &rule->stmts, list) {
 		stmt->ops->print(stmt);
 		printf(" ");
 	}
=20
-	if (rule->comment)
-		printf("comment \"%s\" ", rule->comment);
+	if (rule->udata) {
+		if (nftnl_attr_parse(rule->udata, rule_parse_userdata_cb, tb)
+			!=3D NFTNL_CB_ERROR
+		) {
+			attr =3D tb[NFTNL_ATTR_TYPE_COMMENT];
+			printf("comment \"%s\" ",
+					(char *)nftnl_attr_get_value(attr));
+		}
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
