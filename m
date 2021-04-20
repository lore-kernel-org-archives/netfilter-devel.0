Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E25C433ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 23:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6682E6141A
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 23:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbhDTX1W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Apr 2021 19:27:22 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40444 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234280AbhDTX1W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Apr 2021 19:27:22 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id BCF1763E7F
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Apr 2021 01:26:17 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: add cgroupsv2 support
Date:   Wed, 21 Apr 2021 01:26:46 +0200
Message-Id: <20210420232646.10985-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add support for matching on the cgroups version 2.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/datatype.h                  |  3 +
 include/expression.h                |  1 +
 include/linux/netfilter/nf_tables.h |  2 +
 include/socket.h                    |  2 +-
 src/datatype.c                      | 91 +++++++++++++++++++++++++++++
 src/netlink_delinearize.c           |  5 +-
 src/netlink_linearize.c             |  1 +
 src/parser_bison.y                  |  7 ++-
 src/parser_json.c                   |  2 +-
 src/scanner.l                       |  2 +
 src/socket.c                        | 18 +++++-
 11 files changed, 126 insertions(+), 8 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index a16f8f2bf5c4..448be57fbc7f 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -48,6 +48,7 @@
  * @TYPE_TIME_DATA	Date type (integer subtype)
  * @TYPE_TIME_HOUR	Hour type (integer subtype)
  * @TYPE_TIME_DAY	Day type (integer subtype)
+ * @TYPE_CGROUPV2	cgroups v2 (integer subtype)
  */
 enum datatypes {
 	TYPE_INVALID,
@@ -96,6 +97,7 @@ enum datatypes {
 	TYPE_TIME_DATE,
 	TYPE_TIME_HOUR,
 	TYPE_TIME_DAY,
+	TYPE_CGROUPV2,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
@@ -271,6 +273,7 @@ extern const struct datatype time_type;
 extern const struct datatype boolean_type;
 extern const struct datatype priority_type;
 extern const struct datatype policy_type;
+extern const struct datatype cgroupv2_type;
 
 void inet_service_type_print(const struct expr *expr, struct output_ctx *octx);
 
diff --git a/include/expression.h b/include/expression.h
index 2d07f3d96beb..7e626c48d5ea 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -325,6 +325,7 @@ struct expr {
 		struct {
 			/* SOCKET */
 			enum nft_socket_keys	key;
+			uint32_t		level;
 		} socket;
 		struct {
 			/* EXPR_RT */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index b1633e7ba529..8c85ef8e994d 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1014,6 +1014,7 @@ enum nft_socket_attributes {
 	NFTA_SOCKET_UNSPEC,
 	NFTA_SOCKET_KEY,
 	NFTA_SOCKET_DREG,
+	NFTA_SOCKET_LEVEL,
 	__NFTA_SOCKET_MAX
 };
 #define NFTA_SOCKET_MAX		(__NFTA_SOCKET_MAX - 1)
@@ -1029,6 +1030,7 @@ enum nft_socket_keys {
 	NFT_SOCKET_TRANSPARENT,
 	NFT_SOCKET_MARK,
 	NFT_SOCKET_WILDCARD,
+	NFT_SOCKET_CGROUPV2,
 	__NFT_SOCKET_MAX
 };
 #define NFT_SOCKET_MAX	(__NFT_SOCKET_MAX - 1)
diff --git a/include/socket.h b/include/socket.h
index fbfddd117822..79938ccfad83 100644
--- a/include/socket.h
+++ b/include/socket.h
@@ -19,6 +19,6 @@ struct socket_template {
 extern const struct socket_template socket_templates[];
 
 extern struct expr *socket_expr_alloc(const struct location *loc,
-				    enum nft_socket_keys key);
+				      enum nft_socket_keys key, uint32_t level);
 
 #endif /* NFTABLES_SOCKET_H */
diff --git a/src/datatype.c b/src/datatype.c
index fae1aa262599..c4e66c4633f8 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -18,6 +18,8 @@
 #include <linux/types.h>
 #include <linux/netfilter.h>
 #include <linux/icmpv6.h>
+#include <dirent.h>
+#include <sys/stat.h>
 
 #include <nftables.h>
 #include <datatype.h>
@@ -74,6 +76,7 @@ static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_TIME_DATE]	= &date_type,
 	[TYPE_TIME_HOUR]	= &hour_type,
 	[TYPE_TIME_DAY]		= &day_type,
+	[TYPE_CGROUPV2]		= &cgroupv2_type,
 };
 
 const struct datatype *datatype_lookup(enum datatypes type)
@@ -1331,3 +1334,91 @@ const struct datatype policy_type = {
 	.desc		= "policy type",
 	.parse		= policy_type_parse,
 };
+
+#define SYSFS_CGROUPSV2_PATH	"/sys/fs/cgroup"
+
+static const char *cgroupv2_get_path(const char *path, uint64_t id)
+{
+	const char *cgroup_path = NULL;
+	char dent_name[PATH_MAX + 1];
+	struct dirent *dent;
+	struct stat st;
+	DIR *d;
+
+	d = opendir(path);
+	if (!d)
+		return NULL;
+
+	while ((dent = readdir(d)) != NULL) {
+		if (!strcmp(dent->d_name, ".") ||
+		    !strcmp(dent->d_name, ".."))
+			continue;
+
+		snprintf(dent_name, sizeof(dent_name), "%s/%s",
+			 path, dent->d_name);
+		dent_name[sizeof(dent_name) - 1] = '\0';
+
+		if (dent->d_ino == id) {
+			cgroup_path = xstrdup(dent_name);
+			break;
+		}
+
+		if (stat(dent_name, &st) >= 0 && S_ISDIR(st.st_mode)) {
+			cgroup_path = cgroupv2_get_path(dent_name, id);
+			if (cgroup_path)
+				break;
+		}
+	}
+	closedir(d);
+
+	return cgroup_path;
+}
+
+static void cgroupv2_type_print(const struct expr *expr,
+				struct output_ctx *octx)
+{
+	uint64_t id = mpz_get_uint64(expr->value);
+	const char *cgroup_path;
+
+	cgroup_path = cgroupv2_get_path(SYSFS_CGROUPSV2_PATH, id);
+	if (cgroup_path)
+		nft_print(octx, "\"%s\"", cgroup_path);
+	else
+		nft_print(octx, "%lu", id);
+
+	xfree(cgroup_path);
+}
+
+static struct error_record *cgroupv2_type_parse(struct parse_ctx *ctx,
+						const struct expr *sym,
+						struct expr **res)
+{
+	char cgroupv2_path[PATH_MAX + 1];
+	struct stat st;
+	uint64_t ino;
+
+	snprintf(cgroupv2_path, sizeof(cgroupv2_path), "%s/%s",
+		 SYSFS_CGROUPSV2_PATH, sym->identifier);
+	cgroupv2_path[sizeof(cgroupv2_path) - 1] = '\0';
+
+	if (stat(cgroupv2_path, &st) < 0)
+		return error(&sym->location, "cgroupv2 path fails: %s",
+			     strerror(errno));
+
+	ino = st.st_ino;
+	*res = constant_expr_alloc(&sym->location, &cgroupv2_type,
+				   BYTEORDER_HOST_ENDIAN,
+				   sizeof(ino) * BITS_PER_BYTE, &ino);
+	return NULL;
+}
+
+const struct datatype cgroupv2_type = {
+	.type		= TYPE_CGROUPV2,
+	.name		= "cgroupsv2",
+	.desc		= "cgroupsv2 path",
+	.byteorder	= BYTEORDER_HOST_ENDIAN,
+	.size		= 8 * BITS_PER_BYTE,
+	.basetype	= &integer_type,
+	.print		= cgroupv2_type_print,
+	.parse		= cgroupv2_type_parse,
+};
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 710c668a0258..3844e46fbecd 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -731,11 +731,12 @@ static void netlink_parse_socket(struct netlink_parse_ctx *ctx,
 				      const struct nftnl_expr *nle)
 {
 	enum nft_registers dreg;
-	uint32_t key;
+	uint32_t key, level;
 	struct expr * expr;
 
 	key = nftnl_expr_get_u32(nle, NFTNL_EXPR_SOCKET_KEY);
-	expr = socket_expr_alloc(loc, key);
+	level = nftnl_expr_get_u32(nle, NFTNL_EXPR_SOCKET_LEVEL);
+	expr = socket_expr_alloc(loc, key, level);
 
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_SOCKET_DREG);
 	netlink_set_register(ctx, dreg, expr);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 21bc492e85f4..7b35aae1f913 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -248,6 +248,7 @@ static void netlink_gen_socket(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("socket");
 	netlink_put_register(nle, NFTNL_EXPR_SOCKET_DREG, dreg);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_SOCKET_KEY, expr->socket.key);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_SOCKET_LEVEL, expr->socket.level);
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index cc477e65672a..fe336f0a6e1f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -224,6 +224,7 @@ int nft_lex(void *, void *, void *);
 %token SOCKET			"socket"
 %token TRANSPARENT		"transparent"
 %token WILDCARD			"wildcard"
+%token CGROUPV2			"cgroupv2"
 
 %token TPROXY			"tproxy"
 
@@ -4818,7 +4819,11 @@ meta_stmt		:	META	meta_key	SET	stmt_expr
 
 socket_expr		:	SOCKET	socket_key	close_scope_socket
 			{
-				$$ = socket_expr_alloc(&@$, $2);
+				$$ = socket_expr_alloc(&@$, $2, 0);
+			}
+			|	SOCKET	CGROUPV2	LEVEL	NUM	close_scope_socket
+			{
+				$$ = socket_expr_alloc(&@$, NFT_SOCKET_CGROUPV2, $4);
 			}
 			;
 
diff --git a/src/parser_json.c b/src/parser_json.c
index ddbf9d9c027b..17bb10c34cbc 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -435,7 +435,7 @@ static struct expr *json_parse_socket_expr(struct json_ctx *ctx,
 		return NULL;
 	}
 
-	return socket_expr_alloc(int_loc, keyval);
+	return socket_expr_alloc(int_loc, keyval, 0);
 }
 
 static int json_parse_payload_field(const struct proto_desc *desc,
diff --git a/src/scanner.l b/src/scanner.l
index a9232db8978e..72469b4e07b0 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -292,6 +292,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 <SCANSTATE_EXPR_SOCKET>{
 	"transparent"		{ return TRANSPARENT; }
 	"wildcard"		{ return WILDCARD; }
+	"cgroupv2"		{ return CGROUPV2; }
+	"level"			{ return LEVEL; }
 }
 "tproxy"		{ return TPROXY; }
 
diff --git a/src/socket.c b/src/socket.c
index 673e5d0f570d..eb0751536120 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -32,21 +32,31 @@ const struct socket_template socket_templates[] = {
 		.len		= BITS_PER_BYTE,
 		.byteorder	= BYTEORDER_HOST_ENDIAN,
 	},
+	[NFT_SOCKET_CGROUPV2] = {
+		.token		= "cgroupv2",
+		.dtype		= &cgroupv2_type,
+		.len		= 8 * BITS_PER_BYTE,
+		.byteorder	= BYTEORDER_HOST_ENDIAN,
+	},
 };
 
 static void socket_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
 	nft_print(octx, "socket %s", socket_templates[expr->socket.key].token);
+	if (expr->socket.key == NFT_SOCKET_CGROUPV2)
+		nft_print(octx, " level %u", expr->socket.level);
 }
 
 static bool socket_expr_cmp(const struct expr *e1, const struct expr *e2)
 {
-	return e1->socket.key == e2->socket.key;
+	return e1->socket.key == e2->socket.key &&
+	       e1->socket.level == e2->socket.level;
 }
 
 static void socket_expr_clone(struct expr *new, const struct expr *expr)
 {
 	new->socket.key = expr->socket.key;
+	new->socket.level = expr->socket.level;
 }
 
 #define NFTNL_UDATA_SOCKET_KEY 0
@@ -95,7 +105,7 @@ static struct expr *socket_expr_parse_udata(const struct nftnl_udata *attr)
 
 	key = nftnl_udata_get_u32(ud[NFTNL_UDATA_SOCKET_KEY]);
 
-	return socket_expr_alloc(&internal_location, key);
+	return socket_expr_alloc(&internal_location, key, 0);
 }
 
 const struct expr_ops socket_expr_ops = {
@@ -109,7 +119,8 @@ const struct expr_ops socket_expr_ops = {
 	.parse_udata	= socket_expr_parse_udata,
 };
 
-struct expr *socket_expr_alloc(const struct location *loc, enum nft_socket_keys key)
+struct expr *socket_expr_alloc(const struct location *loc,
+			       enum nft_socket_keys key, uint32_t level)
 {
 	const struct socket_template *tmpl = &socket_templates[key];
 	struct expr *expr;
@@ -117,6 +128,7 @@ struct expr *socket_expr_alloc(const struct location *loc, enum nft_socket_keys
 	expr = expr_alloc(loc, EXPR_SOCKET, tmpl->dtype,
 			  tmpl->byteorder, tmpl->len);
 	expr->socket.key = key;
+	expr->socket.level = level;
 
 	return expr;
 }
-- 
2.30.2

