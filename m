From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 4/4 v3] nftables: rule: Change the field "rule->comment" for an nftnl_udata_buf MIME-Version: 1.0
Date: Mon,  7 Mar 2016 18:10:41 +0100
Message-ID: <1457370643-14408-2-git-send-email-carlosfg@riseup.net>
References: <1457370643-14408-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:49560 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbcCGRLG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 12:11:06 -0500
In-Reply-To: <1457370643-14408-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now it is possible to store multiple variable length user data into rul=
e.
Modify the parser in order to fill the nftnl_udata with the comment, an=
d the
print function for extract these commentary and print it to user.

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 include/rule.h            | 11 +++++++++--
 src/netlink_delinearize.c |  7 +++++--
 src/netlink_linearize.c   |  6 ++++--
 src/parser_bison.y        | 15 ++++++++++++++-
 src/rule.c                | 41 ++++++++++++++++++++++++++++++++++++++-=
--
 5 files changed, 70 insertions(+), 10 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index c848f0f..c500e88 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -4,6 +4,7 @@
 #include <stdint.h>
 #include <nftables.h>
 #include <list.h>
+#include <libnftnl/udata.h>
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
@@ -163,7 +164,7 @@ struct rule {
 	struct location		location;
 	struct list_head	stmts;
 	unsigned int		num_stmts;
-	const char		*comment;
+	struct nftnl_udata_buf	*udata;
 };
=20
 extern struct rule *rule_alloc(const struct location *loc,
@@ -396,4 +397,10 @@ extern int do_command(struct netlink_ctx *ctx, str=
uct cmd *cmd);
 extern int cache_update(enum cmd_ops cmd, struct list_head *msgs);
 extern void cache_release(void);
=20
+enum udata_type {
+	UDATA_TYPE_COMMENT,
+	__UDATA_TYPE_MAX,
+};
+#define UDATA_TYPE_MAX (__UDATA_TYPE_MAX - 1)
+
 #endif /* NFTABLES_RULE_H */
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index ae6abb0..2f8c512 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -25,6 +25,7 @@
 #include <utils.h>
 #include <erec.h>
 #include <sys/socket.h>
+#include <libnftnl/udata.h>
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
+		pctx->rule->udata =3D nftnl_udata_alloc(len);
+		if (!pctx->rule->udata)
+			memory_allocation_error();
+		nftnl_udata_copy_data(pctx->rule->udata, data, len);
 	}
=20
 	nftnl_expr_foreach((struct nftnl_rule *)nlr, netlink_parse_expr, pctx=
);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 86b49c6..00f81ea 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -21,6 +21,7 @@
 #include <netinet/in.h>
=20
 #include <linux/netfilter.h>
+#include <libnftnl/udata.h>
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
+				    nftnl_udata_data(rule->udata),
+				    nftnl_udata_len(rule->udata));
=20
 	netlink_dump_rule(nlr);
 }
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 05ade0f..ed1b63a 100644
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
@@ -1304,7 +1305,19 @@ rule			:	stmt_list	comment_spec
 				struct stmt *i;
=20
 				$$ =3D rule_alloc(&@$, NULL);
-				$$->comment =3D $2;
+
+				if ($2) {
+					if (!($$->udata =3D nftnl_udata_alloc(NFT_USERDATA_MAXLEN)))
+						memory_allocation_error();
+
+					if (!nftnl_udata_put_strz($$->udata,
+						UDATA_TYPE_COMMENT, $2)) {
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
index 18ff592..60d9b38 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -23,6 +23,7 @@
=20
 #include <libnftnl/common.h>
 #include <libnftnl/ruleset.h>
+#include <libnftnl/udata.h>
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
@@ -375,21 +377,54 @@ void rule_free(struct rule *rule)
 {
 	stmt_list_free(&rule->stmts);
 	handle_free(&rule->handle);
-	xfree(rule->comment);
+	nftnl_udata_free(rule->udata);
 	xfree(rule);
 }
=20
+static int rule_parse_userdata_cb(const struct nftnl_udata *attr,
+				  void *data)
+{
+	const struct nftnl_udata **tb =3D data;
+	uint8_t type =3D nftnl_udata_attr_type(attr);
+	uint8_t len =3D nftnl_udata_attr_len(attr);
+	unsigned char *value =3D nftnl_udata_attr_value(attr);
+
+	/* Validation */
+	switch (type) {
+	case UDATA_TYPE_COMMENT:
+		if (value[len-1] !=3D '\0')
+			return NFTNL_CB_ERROR;
+		break;
+	default:
+		break;
+	};
+
+	tb[type] =3D attr;
+	return NFTNL_CB_OK;
+}
+
+
 void rule_print(const struct rule *rule)
 {
 	const struct stmt *stmt;
+	const struct nftnl_udata *tb[UDATA_TYPE_MAX + 1] =3D {};
+	const struct nftnl_udata *attr;
=20
 	list_for_each_entry(stmt, &rule->stmts, list) {
 		stmt->ops->print(stmt);
 		printf(" ");
 	}
=20
-	if (rule->comment)
-		printf("comment \"%s\" ", rule->comment);
+	if (rule->udata) {
+		if (nftnl_udata_parse(rule->udata, rule_parse_userdata_cb, tb)
+			!=3D NFTNL_CB_ERROR
+		) {
+			attr =3D tb[UDATA_TYPE_COMMENT];
+			if (attr)
+				printf("comment \"%s\" ",
+					(char *)nftnl_udata_attr_value(attr));
+		}
+	}
=20
 	if (handle_output > 0)
 		printf("# handle %" PRIu64, rule->handle.handle);
--=20
2.7.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
