From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 4/4 v6] nftables: rule: Change the field "rule->comment" for an nftnl_udata_buf
Date: Tue, 22 Mar 2016 20:46:27 +0100
Message-ID: <1458675987-32398-4-git-send-email-carlosfg@riseup.net>
References: <1458675987-32398-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:51491 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbcCVTqr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2016 15:46:47 -0400
In-Reply-To: <1458675987-32398-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now it is possible to store multiple variable length user data into rul=
e.
Modify the parser in order to fill the nftnl_udata with the comment, an=
d
the print function for extract these commentary and print it to user.

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 include/rule.h            |  7 +++++++
 src/netlink_delinearize.c | 40 ++++++++++++++++++++++++++++++++++++++-=
-
 src/netlink_linearize.c   | 18 ++++++++++++++++--
 3 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index c848f0f..b52f0ac 100644
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
index d431588..1171e6f 100644
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
@@ -1746,6 +1747,42 @@ static void rule_parse_postprocess(struct netlin=
k_parse_ctx *ctx, struct rule *r
 	}
 }
=20
+static int parse_udata_cb(const struct nftnl_udata *attr, void *data)
+{
+	unsigned char *value =3D nftnl_udata_attr_value(attr);
+	uint8_t type =3D nftnl_udata_attr_type(attr);
+	uint8_t len =3D nftnl_udata_attr_len(attr);
+	const struct nftnl_udata **tb =3D data;
+
+	switch (type) {
+	case UDATA_TYPE_COMMENT:
+		if (value[len - 1] !=3D '\0')
+			return -1;
+		break;
+	default:
+		break;
+	};
+
+	tb[type] =3D attr;
+	return 1;
+}
+
+static char *udata_get_comment(const void *data, uint32_t data_len)
+{
+	const struct nftnl_udata *tb[UDATA_TYPE_MAX + 1] =3D {};
+	char *comment =3D NULL;
+
+	if (nftnl_udata_parse(data, data_len, parse_udata_cb, tb) <=3D 0)
+		return NULL;
+
+	if (!tb[UDATA_TYPE_COMMENT])
+		return NULL;
+
+	comment =3D xstrdup(nftnl_udata_attr_value(tb[UDATA_TYPE_COMMENT]));
+
+	return comment;
+}
+
 struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 				      const struct nftnl_rule *nlr)
 {
@@ -1773,8 +1810,7 @@ struct rule *netlink_delinearize_rule(struct netl=
ink_ctx *ctx,
 		uint32_t len;
=20
 		data =3D nftnl_rule_get_data(nlr, NFTNL_RULE_USERDATA, &len);
-		pctx->rule->comment =3D xmalloc(len);
-		memcpy((char *)pctx->rule->comment, data, len);
+		pctx->rule->comment =3D udata_get_comment(data, len);
 	}
=20
 	nftnl_expr_foreach((struct nftnl_rule *)nlr, netlink_parse_expr, pctx=
);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index bb51de7..a690994 100644
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
@@ -1162,6 +1163,7 @@ void netlink_linearize_rule(struct netlink_ctx *c=
tx, struct nftnl_rule *nlr,
 			    const struct rule *rule)
 {
 	struct netlink_linearize_ctx lctx;
+	struct nftnl_udata_buf *udata;
 	const struct stmt *stmt;
=20
 	memset(&lctx, 0, sizeof(lctx));
@@ -1171,9 +1173,21 @@ void netlink_linearize_rule(struct netlink_ctx *=
ctx, struct nftnl_rule *nlr,
 	list_for_each_entry(stmt, &rule->stmts, list)
 		netlink_gen_stmt(&lctx, stmt);
=20
-	if (rule->comment)
+	if (rule->comment) {
+		udata =3D nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
+		if (!udata)
+			memory_allocation_error();
+
+		if (!nftnl_udata_put_strz(udata, UDATA_TYPE_COMMENT,
+					  rule->comment))
+			memory_allocation_error();
+
 		nftnl_rule_set_data(nlr, NFTNL_RULE_USERDATA,
-				    rule->comment, strlen(rule->comment) + 1);
+				    nftnl_udata_buf_data(udata),
+				    nftnl_udata_buf_len(udata));
+
+		nftnl_udata_buf_free(udata);
+	}
=20
 	netlink_dump_rule(nlr);
 }
--=20
2.7.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
