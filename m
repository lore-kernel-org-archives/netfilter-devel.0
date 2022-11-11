Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D9FC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Nov 2022 17:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbiKKRcp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 12:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233998AbiKKRcn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 12:32:43 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996B7FAEA
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Nov 2022 09:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZBBIgZTgt4LF91qr3Qu8XEu27ykYiRfoH9T3O3H8cu0=; b=S1jI7LwiZaFJl19shxOCYzevd/
        E7ww6GQ47Mnv8/JKyuus9O+kemOxqrhJ4hR0YwZLRitiUsKxBv6rodnfmHKPBe6ncSMeKXmKgIpOO
        ufZiaZ2ez3Iobuehx6XKieIeDkhybUVXpyvFIy5blMqJOMmMmZjXxwBXtQPk2XpE++DkudHge0LpS
        gaf7PvLZF5YBgK3/kFUK8O0EAHHAGvrmNSuguuikhNKuiOK0ZQR4JpfvlCyVL2GY1WESnTH1L/Apo
        R+cJ1UXlb/5myG7GNxpQp2koua70lB8qc/3JeoN/1W5D/TxxqWVK8im4Td0fb8qXTPc+MlG7wgOdk
        Q4FQ4Pqw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1otXtL-0006FC-SP; Fri, 11 Nov 2022 18:32:36 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/3] xt: Implement dump and restore support
Date:   Fri, 11 Nov 2022 18:32:20 +0100
Message-Id: <20221111173221.23631-3-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221111173221.23631-1-phil@nwl.cc>
References: <20221111173221.23631-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When listing a rule with compat expressions, fall back to a textual
representation which does not require knowledge of the underlying data
structures (i.e. libxtables support), preserves information and gives
some clue to users what it is.

The statement is printed with its type and name in clear text, the
remaining private data and revision encoded as base64 string. To prevent
listings from becoming a total mess, the data is zipped before encoding
(if zlib is available).

Base64 en-/decoding implementation copied from FreeBSD and slightly
adjusted to fit our needs.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 configure.ac              |  12 ++-
 doc/libnftables-json.adoc |  15 +++-
 doc/statements.txt        |  17 ++++
 include/base64.h          |  17 ++++
 include/json.h            |   2 +
 include/parser.h          |   1 +
 include/xt.h              |   4 +
 src/Makefile.am           |   3 +-
 src/base64.c              | 170 ++++++++++++++++++++++++++++++++++++++
 src/evaluate.c            |   1 +
 src/json.c                |  25 ++++--
 src/netlink_linearize.c   |  32 +++++++
 src/parser_bison.y        |  28 +++++++
 src/parser_json.c         |  36 ++++++++
 src/scanner.l             |  14 ++++
 src/statement.c           |   1 +
 src/xt.c                  |  99 ++++++++++++++++++++--
 17 files changed, 458 insertions(+), 19 deletions(-)
 create mode 100644 include/base64.h
 create mode 100644 src/base64.c

diff --git a/configure.ac b/configure.ac
index eb1882dd828e8..268255cfeb39e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -98,6 +98,15 @@ AC_DEFINE([HAVE_LIBXTABLES], [1], [0])
 ])
 AM_CONDITIONAL([BUILD_XTABLES], [test "x$with_xtables" = xyes])
 
+AC_ARG_WITH([zlib], [AS_HELP_STRING([--without-zlib],
+            [Disable payload compression of xt compat expressions when listing])],
+	    [], [with_zlib=yes])
+AS_IF([test "x$with_zlib" != xno], [
+AC_CHECK_LIB([z], [compress], ,
+	     AC_MSG_ERROR([No suitable version of zlib found]))
+AC_DEFINE([HAVE_ZLIB], [1], [Define if you have zlib])
+])
+
 AC_ARG_WITH([json], [AS_HELP_STRING([--with-json],
             [Enable JSON output support])],
 	    [], [with_json=no])
@@ -156,7 +165,8 @@ echo "
   use mini-gmp:			${with_mini_gmp}
   enable man page:              ${enable_man_doc}
   libxtables support:		${with_xtables}
-  json output support:          ${with_json}"
+  json output support:          ${with_json}
+  compress xt compat payloads:  ${with_zlib}"
 
 AS_IF([test "$enable_python" != "no"], [
 	echo "  enable Python:		yes (with $PYTHON_BIN)"
diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index bb59945fc510d..6d75a9b6ed5d3 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -1059,10 +1059,19 @@ Assign connection tracking expectation.
 
 === XT
 [verse]
-*{ "xt": null }*
+____
+*{ "xt": [* 'TYPE' *,* 'STRING' *,* 'STRING' *] }*
+
+'TYPE' := *match* | *target* | *watcher*
+____
+
+This represents an xt statement from xtables compat interface. It merely exists
+to support saving and restoring a ruleset containing these statements without
+losing data.
 
-This represents an xt statement from xtables compat interface. Sadly, at this
-point, it is not possible to provide any further information about its content.
+The textual representation was chosen to give users a rough idea of what it is
+by explicitly stating the extension's 'TYPE' and name in the first two array
+fields. The third one embeds the extension's data in compressed base64 format.
 
 == EXPRESSIONS
 Expressions are the building blocks of (most) statements. In their most basic
diff --git a/doc/statements.txt b/doc/statements.txt
index 8076c21cded41..19ea23d1129f3 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -783,3 +783,20 @@ ____
 # jump to different chains depending on layer 4 protocol type:
 nft add rule ip filter input ip protocol vmap { tcp : jump tcp-chain, udp : jump udp-chain , icmp : jump icmp-chain }
 ------------------------
+
+XT STATEMENT
+~~~~~~~~~~~~
+This represents an xt statement from xtables compat interface. It merely exists
+to support saving and restoring a ruleset containing these statements without
+losing data.
+
+[verse]
+____
+*xt* 'TYPE' 'NAME' 'BASE64'
+
+'TYPE' := *match* | *target* | *watcher*
+____
+
+The textual representation was chosen to give users a rough idea of what it is
+by explicitly stating the extension's 'TYPE' and 'NAME' followed by the
+extension's data in compressed 'BASE64' format.
diff --git a/include/base64.h b/include/base64.h
new file mode 100644
index 0000000000000..aa21fd0fc1b76
--- /dev/null
+++ b/include/base64.h
@@ -0,0 +1,17 @@
+/*
+ * Base64 encoding/decoding (RFC1341)
+ * Copyright (c) 2005, Jouni Malinen <j@w1.fi>
+ *
+ * This software may be distributed under the terms of the BSD license.
+ * See README for more details.
+ */
+
+#ifndef BASE64_H
+#define BASE64_H
+
+unsigned char * base64_encode(const unsigned char *src, size_t len,
+			      size_t *out_len);
+unsigned char * base64_decode(const unsigned char *src, size_t len,
+			      size_t *out_len);
+
+#endif /* BASE64_H */
diff --git a/include/json.h b/include/json.h
index b0d78eb84987e..f691678d4d726 100644
--- a/include/json.h
+++ b/include/json.h
@@ -92,6 +92,7 @@ json_t *connlimit_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *tproxy_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *synproxy_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *optstrip_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
+json_t *xt_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 
 int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd);
 
@@ -194,6 +195,7 @@ STMT_PRINT_STUB(connlimit)
 STMT_PRINT_STUB(tproxy)
 STMT_PRINT_STUB(synproxy)
 STMT_PRINT_STUB(optstrip)
+STMT_PRINT_STUB(xt)
 
 #undef STMT_PRINT_STUB
 #undef EXPR_PRINT_STUB
diff --git a/include/parser.h b/include/parser.h
index 2fb037cb84702..da90e5a0fdf3d 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -82,6 +82,7 @@ enum startcond_type {
 	PARSER_SC_STMT_REJECT,
 	PARSER_SC_STMT_SYNPROXY,
 	PARSER_SC_STMT_TPROXY,
+	PARSER_SC_STMT_XT,
 
 	__SC_MAX
 };
diff --git a/include/xt.h b/include/xt.h
index 9fc515084d597..d365c58479e94 100644
--- a/include/xt.h
+++ b/include/xt.h
@@ -26,4 +26,8 @@ static inline void stmt_xt_postprocess(struct rule_pp_ctx *rctx,
 
 #endif
 
+unsigned char *xt_stmt_blob_encode(const struct stmt *stmt);
+int xt_stmt_blob_decode(struct stmt *stmt, const char *b64_string,
+			const struct location *b64_loc, struct list_head *msgs);
+
 #endif /* _NFT_XT_H_ */
diff --git a/src/Makefile.am b/src/Makefile.am
index 264d981e20c7f..cea5b8df20a51 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -36,6 +36,7 @@ BUILT_SOURCES = parser_bison.h
 lib_LTLIBRARIES = libnftables.la
 
 libnftables_la_SOURCES =			\
+		base64.c			\
 		rule.c				\
 		statement.c			\
 		cache.c				\
@@ -89,7 +90,7 @@ libparser_la_CFLAGS = ${AM_CFLAGS} \
 		      -Wno-undef \
 		      -Wno-redundant-decls
 
-libnftables_la_LIBADD = ${LIBMNL_LIBS} ${LIBNFTNL_LIBS} libparser.la
+libnftables_la_LIBADD = ${LIBMNL_LIBS} ${LIBNFTNL_LIBS} ${Z_LIBS} libparser.la
 libnftables_la_LDFLAGS = -version-info ${libnftables_LIBVERSION} \
 			 -Wl,--version-script=$(srcdir)/libnftables.map
 
diff --git a/src/base64.c b/src/base64.c
new file mode 100644
index 0000000000000..c8abb1e5c3fca
--- /dev/null
+++ b/src/base64.c
@@ -0,0 +1,170 @@
+/*
+ * Base64 encoding/decoding (RFC1341)
+ * Copyright (c) 2005-2011, Jouni Malinen <j@w1.fi>
+ *
+ * This software may be distributed under the terms of the BSD license.
+ * See README for more details.
+ *
+ * Adjustments for nftables:
+ * - headers updated
+ * - dropped code to break long lines
+ */
+
+//#include "includes.h"
+#include <stddef.h>
+#include <string.h>
+#include <utils.h>
+
+//#include "os.h"
+#define os_malloc	xmalloc
+#define os_memset	memset
+#define os_free		free
+
+#include "base64.h"
+
+static const unsigned char base64_table[65] =
+	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
+
+/**
+ * base64_encode - Base64 encode
+ * @src: Data to be encoded
+ * @len: Length of the data to be encoded
+ * @out_len: Pointer to output length variable, or %NULL if not used
+ * Returns: Allocated buffer of out_len bytes of encoded data,
+ * or %NULL on failure
+ *
+ * Caller is responsible for freeing the returned buffer. Returned buffer is
+ * nul terminated to make it easier to use as a C string. The nul terminator is
+ * not included in out_len.
+ */
+unsigned char * base64_encode(const unsigned char *src, size_t len,
+			      size_t *out_len)
+{
+	unsigned char *out, *pos;
+	const unsigned char *end, *in;
+	size_t olen;
+	int line_len;
+
+	olen = len * 4 / 3 + 4; /* 3-byte blocks to 4-byte */
+	olen += olen / 72; /* line feeds */
+	olen++; /* nul termination */
+	if (olen < len)
+		return NULL; /* integer overflow */
+	out = os_malloc(olen);
+	if (out == NULL)
+		return NULL;
+
+	end = src + len;
+	in = src;
+	pos = out;
+	line_len = 0;
+	while (end - in >= 3) {
+		*pos++ = base64_table[in[0] >> 2];
+		*pos++ = base64_table[((in[0] & 0x03) << 4) | (in[1] >> 4)];
+		*pos++ = base64_table[((in[1] & 0x0f) << 2) | (in[2] >> 6)];
+		*pos++ = base64_table[in[2] & 0x3f];
+		in += 3;
+		line_len += 4;
+#if 0
+		if (line_len >= 72) {
+			*pos++ = '\n';
+			line_len = 0;
+		}
+#endif
+	}
+
+	if (end - in) {
+		*pos++ = base64_table[in[0] >> 2];
+		if (end - in == 1) {
+			*pos++ = base64_table[(in[0] & 0x03) << 4];
+			*pos++ = '=';
+		} else {
+			*pos++ = base64_table[((in[0] & 0x03) << 4) |
+					      (in[1] >> 4)];
+			*pos++ = base64_table[(in[1] & 0x0f) << 2];
+		}
+		*pos++ = '=';
+		line_len += 4;
+	}
+
+#if 0
+	if (line_len)
+		*pos++ = '\n';
+#endif
+
+	*pos = '\0';
+	if (out_len)
+		*out_len = pos - out;
+	return out;
+}
+
+
+/**
+ * base64_decode - Base64 decode
+ * @src: Data to be decoded
+ * @len: Length of the data to be decoded
+ * @out_len: Pointer to output length variable
+ * Returns: Allocated buffer of out_len bytes of decoded data,
+ * or %NULL on failure
+ *
+ * Caller is responsible for freeing the returned buffer.
+ */
+unsigned char * base64_decode(const unsigned char *src, size_t len,
+			      size_t *out_len)
+{
+	unsigned char dtable[256], *out, *pos, block[4], tmp;
+	size_t i, count, olen;
+	int pad = 0;
+
+	os_memset(dtable, 0x80, 256);
+	for (i = 0; i < sizeof(base64_table) - 1; i++)
+		dtable[base64_table[i]] = (unsigned char) i;
+	dtable['='] = 0;
+
+	count = 0;
+	for (i = 0; i < len; i++) {
+		if (dtable[src[i]] != 0x80)
+			count++;
+	}
+
+	if (count == 0 || count % 4)
+		return NULL;
+
+	olen = count / 4 * 3;
+	pos = out = os_malloc(olen);
+	if (out == NULL)
+		return NULL;
+
+	count = 0;
+	for (i = 0; i < len; i++) {
+		tmp = dtable[src[i]];
+		if (tmp == 0x80)
+			continue;
+
+		if (src[i] == '=')
+			pad++;
+		block[count] = tmp;
+		count++;
+		if (count == 4) {
+			*pos++ = (block[0] << 2) | (block[1] >> 4);
+			*pos++ = (block[1] << 4) | (block[2] >> 2);
+			*pos++ = (block[2] << 6) | block[3];
+			count = 0;
+			if (pad) {
+				if (pad == 1)
+					pos--;
+				else if (pad == 2)
+					pos -= 2;
+				else {
+					/* Invalid padding */
+					os_free(out);
+					return NULL;
+				}
+				break;
+			}
+		}
+	}
+
+	*out_len = pos - out;
+	return out;
+}
diff --git a/src/evaluate.c b/src/evaluate.c
index a52867b33be01..c46db142b2357 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3990,6 +3990,7 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 	case STMT_QUOTA:
 	case STMT_NOTRACK:
 	case STMT_FLOW_OFFLOAD:
+	case STMT_XT:
 		return 0;
 	case STMT_EXPRESSION:
 		return stmt_evaluate_expr(ctx, stmt);
diff --git a/src/json.c b/src/json.c
index 6662f8087736a..1242ab04058bb 100644
--- a/src/json.c
+++ b/src/json.c
@@ -7,6 +7,7 @@
 #include <netlink.h>
 #include <rule.h>
 #include <rt.h>
+#include <xt.h>
 
 #include <netdb.h>
 #include <netinet/icmp6.h>
@@ -82,12 +83,6 @@ static json_t *stmt_print_json(const struct stmt *stmt, struct output_ctx *octx)
 	char buf[1024];
 	FILE *fp;
 
-	/* XXX: Can't be supported at this point:
-	 * xt_stmt_xlate() ignores output_fp.
-	 */
-	if (stmt->ops->type == STMT_XT)
-		return json_pack("{s:n}", "xt");
-
 	if (stmt->ops->json)
 		return stmt->ops->json(stmt, octx);
 
@@ -1624,6 +1619,24 @@ json_t *optstrip_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 			 expr_print_json(stmt->optstrip.expr, octx));
 }
 
+json_t *xt_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
+{
+	static const char *xt_typename[] = {
+		[NFT_XT_MATCH]		= "match",
+		[NFT_XT_TARGET]		= "target",
+		[NFT_XT_WATCHER]	= "watcher",
+		[NFT_XT_MAX]		= "unknown"
+	};
+	unsigned char *b64_buf;
+	json_t *json;
+
+	b64_buf = xt_stmt_blob_encode(stmt);
+	json = json_pack("[s, s, s]", xt_typename[stmt->xt.type],
+			 stmt->xt.name, b64_buf);
+	xfree(b64_buf);
+	return json;
+}
+
 static json_t *table_print_json_full(struct netlink_ctx *ctx,
 				     struct table *table)
 {
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index c8bbcb7452b05..d372919662578 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -20,6 +20,7 @@
 #include <gmputil.h>
 #include <utils.h>
 #include <netinet/in.h>
+#include <zlib.h>
 
 #include <linux/netfilter.h>
 #include <libnftnl/udata.h>
@@ -1365,6 +1366,35 @@ static void netlink_gen_optstrip_stmt(struct netlink_linearize_ctx *ctx,
 	nft_rule_add_expr(ctx, nle, &expr->location);
 }
 
+static void netlink_gen_xt_stmt(struct netlink_linearize_ctx *ctx,
+				const struct stmt *stmt)
+{
+	void *data = xmalloc(stmt->xt.infolen);
+	struct nftnl_expr *nle;
+
+	memcpy(data, stmt->xt.info, stmt->xt.infolen);
+
+	switch(stmt->xt.type) {
+	case NFT_XT_MATCH:
+		nle = alloc_nft_expr("match");
+		nftnl_expr_set_str(nle, NFTNL_EXPR_MT_NAME, stmt->xt.name);
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_MT_REV, stmt->xt.rev);
+		nftnl_expr_set(nle, NFTNL_EXPR_MT_INFO, data, stmt->xt.infolen);
+		break;
+	case NFT_XT_TARGET:
+	case NFT_XT_WATCHER:
+		nle = alloc_nft_expr("target");
+		nftnl_expr_set_str(nle, NFTNL_EXPR_TG_NAME, stmt->xt.name);
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_TG_REV, stmt->xt.rev);
+		nftnl_expr_set(nle, NFTNL_EXPR_TG_INFO, data, stmt->xt.infolen);
+		break;
+	default:
+		free(data);
+		return;
+	}
+	nft_rule_add_expr(ctx, nle, &stmt->location);
+}
+
 static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
 				 const struct stmt *stmt)
 {
@@ -1630,6 +1660,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_chain_stmt(ctx, stmt);
 	case STMT_OPTSTRIP:
 		return netlink_gen_optstrip_stmt(ctx, stmt);
+	case STMT_XT:
+		return netlink_gen_xt_stmt(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 0266819a779b6..c67be5e1e7e0c 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -615,6 +615,13 @@ int nft_lex(void *, void *, void *);
 %token IN			"in"
 %token OUT			"out"
 
+%token XT			"xt"
+%token MATCH			"match"
+%token TARGET			"target"
+%token WATCHER			"watcher"
+%type <stmt>			xt_stmt
+%type <val>			xt_stmt_type
+
 %type <limit_rate>		limit_rate_pkts
 %type <limit_rate>		limit_rate_bytes
 
@@ -980,6 +987,7 @@ close_scope_udplite	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_EXPR_UDPL
 
 close_scope_log		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_LOG); }
 close_scope_synproxy	: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_SYNPROXY); }
+close_scope_xt		: { scanner_pop_start_cond(nft->scanner, PARSER_SC_STMT_XT); }
 
 common_block		:	INCLUDE		QUOTED_STRING	stmt_separator
 			{
@@ -2860,6 +2868,26 @@ stmt			:	verdict_stmt
 			|	synproxy_stmt	close_scope_synproxy
 			|	chain_stmt
 			|	optstrip_stmt
+			|	xt_stmt
+			;
+
+xt_stmt_type		:	MATCH	{ $$ = NFT_XT_MATCH; }
+			|	TARGET	{ $$ = NFT_XT_TARGET; }
+			|	WATCHER	{ $$ = NFT_XT_WATCHER; }
+			;
+
+xt_stmt			:	XT	xt_stmt_type	STRING	STRING	close_scope_xt
+			{
+				$$ = xt_stmt_alloc(&@$);
+				$$->xt.type = $2;
+				$$->xt.name = $3;
+				if (xt_stmt_blob_decode($$, $4, &@4, state->msgs)) {
+					xfree($$);
+					xfree($4);
+					YYERROR;
+				}
+				xfree($4);
+			}
 			;
 
 chain_stmt_type		:	JUMP	{ $$ = NFT_JUMP; }
diff --git a/src/parser_json.c b/src/parser_json.c
index 76c268f857202..c4e4ef4f9e1f6 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -13,6 +13,7 @@
 #include <rule.h>
 #include <sctp_chunk.h>
 #include <socket.h>
+#include <xt.h>
 
 #include <netdb.h>
 #include <netinet/icmp6.h>
@@ -2707,6 +2708,40 @@ static struct stmt *json_parse_optstrip_stmt(struct json_ctx *ctx,
 	return expr ? optstrip_stmt_alloc(int_loc, expr) : NULL;
 }
 
+static enum nft_xt_type xt_stmt_typeval(const char *type)
+{
+	if (!strcmp(type, "match"))
+		return NFT_XT_MATCH;
+	if (!strcmp(type, "target"))
+		return NFT_XT_TARGET;
+	if (!strcmp(type, "watcher"))
+		return NFT_XT_WATCHER;
+	return NFT_XT_MAX;
+}
+
+static struct stmt *json_parse_xt_stmt(struct json_ctx *ctx,
+				       const char *key, json_t *value)
+{
+	char *type, *name, *blob;
+	struct stmt *stmt;
+
+	if (json_unpack_err(ctx, value, "[s, s, s]", &type, &name, &blob))
+		return NULL;
+
+	stmt = xt_stmt_alloc(int_loc);
+	stmt->xt.type = xt_stmt_typeval(type);
+	if (stmt->xt.type == NFT_XT_MAX) {
+		json_error(ctx, "Invalid xt type name '%s'.", type);
+		return NULL;
+	}
+	stmt->xt.name = xstrdup(name);
+	if (xt_stmt_blob_decode(stmt, blob, int_loc, ctx->msgs)) {
+		json_error(ctx, "Invalid base64 data in '%s'.", blob);
+		return NULL;
+	}
+	return stmt;
+}
+
 static struct stmt *json_parse_stmt(struct json_ctx *ctx, json_t *root)
 {
 	struct {
@@ -2745,6 +2780,7 @@ static struct stmt *json_parse_stmt(struct json_ctx *ctx, json_t *root)
 		{ "synproxy", json_parse_synproxy_stmt },
 		{ "reset", json_parse_optstrip_stmt },
 		{ "secmark", json_parse_secmark_stmt },
+		{ "xt", json_parse_xt_stmt },
 	};
 	const char *type;
 	unsigned int i;
diff --git a/src/scanner.l b/src/scanner.l
index 1371cd044b65a..e933d32f13d1a 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -125,6 +125,7 @@ quotedstring	\"[^"]*\"
 asteriskstring	({string}\*|{string}\\\*|\\\*|{string}\\\*{string})
 comment		#.*$
 slash		\/
+base64string	({letter}|{digit}|\+|{slash})*=*
 
 timestring	([0-9]+d)?([0-9]+h)?([0-9]+m)?([0-9]+s)?([0-9]+ms)?
 
@@ -247,6 +248,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 %s SCANSTATE_STMT_REJECT
 %s SCANSTATE_STMT_SYNPROXY
 %s SCANSTATE_STMT_TPROXY
+%s SCANSTATE_STMT_XT
 
 %%
 
@@ -411,6 +413,13 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 	"group"			{ return GROUP; }
 }
 
+"xt"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_XT); return XT; }
+<SCANSTATE_STMT_XT>{
+	"match"		{ return MATCH; }
+	"target"	{ return TARGET; }
+	"watcher"	{ return WATCHER; }
+}
+
 "queue"			{ scanner_push_start_cond(yyscanner, SCANSTATE_EXPR_QUEUE); return QUEUE;}
 <SCANSTATE_EXPR_QUEUE>{
 	"num"		{ return QUEUENUM;}
@@ -846,6 +855,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 				return STRING;
 			}
 
+{base64string}		{
+				yylval->string = xstrdup(yytext);
+				return STRING;
+			}
+
 \\{newline}		{
 				reset_pos(yyget_extra(yyscanner), yylloc);
 			}
diff --git a/src/statement.c b/src/statement.c
index 327d00f99200a..eafc51c484de9 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -997,6 +997,7 @@ static const struct stmt_ops xt_stmt_ops = {
 	.name		= "xt",
 	.print		= xt_stmt_print,
 	.destroy	= xt_stmt_destroy,
+	.json		= xt_stmt_json,
 };
 
 struct stmt *xt_stmt_alloc(const struct location *loc)
diff --git a/src/xt.c b/src/xt.c
index f14f40157ba10..9a326fd313233 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -17,6 +17,7 @@
 #include <netlink.h>
 #include <xt.h>
 #include <erec.h>
+#include <base64.h>
 
 #include <libmnl/libmnl.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -31,9 +32,87 @@
 
 static void *xt_entry_alloc(const struct xt_stmt *xt, uint32_t af);
 #endif
+#ifdef HAVE_ZLIB
+#include <zlib.h>
+#endif
+
+struct xt_stmt_blob {
+	uint32_t	orig_len;
+	uint8_t		rev;
+	unsigned char	data[];
+};
+
+unsigned char *xt_stmt_blob_encode(const struct stmt *stmt)
+{
+#ifdef HAVE_ZLIB
+	size_t complen = compressBound(stmt->xt.infolen);
+#else
+	size_t complen = stmt->xt.infolen;
+#endif
+	struct xt_stmt_blob *blob;
+	unsigned char *b64_buf;
+
+	blob = xzalloc(sizeof(*blob) + complen);
+	blob->rev = stmt->xt.rev;
+	blob->orig_len = stmt->xt.infolen;
+#ifdef HAVE_ZLIB
+	compress(blob->data, &complen,
+		 (const Bytef *)stmt->xt.info, stmt->xt.infolen);
+#else
+	memcpy(blob->data, stmt->xt.info, stmt->xt.infolen);
+#endif
+
+	b64_buf = base64_encode((const unsigned char *)blob,
+				complen + sizeof(*blob), NULL);
+	xfree(blob);
+	return b64_buf;
+}
+
+int xt_stmt_blob_decode(struct stmt *stmt, const char *b64_string,
+			const struct location *b64_loc, struct list_head *msgs)
+{
+	struct xt_stmt_blob *blob;
+	size_t bloblen;
+	int ret = 0;
+
+	blob = (void *)base64_decode((const unsigned char *)b64_string,
+				     strlen(b64_string), &bloblen);
+	if (!blob) {
+		erec_queue(error(b64_loc, "invalid base64 string"), msgs);
+		return 1;
+	}
+
+	bloblen -= sizeof(*blob);
+
+	stmt->xt.rev = blob->rev;
+	stmt->xt.info = xmalloc(blob->orig_len);
+	stmt->xt.infolen = blob->orig_len;
+	if (blob->orig_len == bloblen) {
+		memcpy(stmt->xt.info, blob->data, stmt->xt.infolen);
+#ifdef HAVE_ZLIB
+	} else if (uncompress(stmt->xt.info, &stmt->xt.infolen,
+			      blob->data, bloblen) != Z_OK) {
+		erec_queue(error(b64_loc, "blob decompression failed"), msgs);
+#else
+	} else {
+		erec_queue(error(b64_loc,
+				 "compressed blobs not supported"), msgs);
+#endif
+		ret = 1;
+	}
+	free(blob);
+	return ret;
+}
 
 void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 {
+	static const char *xt_typename[] = {
+		[NFT_XT_MATCH]		= "match",
+		[NFT_XT_TARGET]		= "target",
+		[NFT_XT_WATCHER]	= "watcher",
+		[NFT_XT_MAX]		= "unknown"
+	};
+	unsigned char *b64_buf;
 #ifdef HAVE_LIBXTABLES
 	struct xt_xlate *xl = xt_xlate_alloc(10240);
 	struct xtables_target *tg;
@@ -71,9 +150,10 @@ void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 
 			mt->xlate(xl, &params);
 			nft_print(octx, "%s", xt_xlate_get(xl));
-		} else if (mt->print) {
-			printf("#");
-			mt->print(&entry, m, 0);
+			xfree(m);
+			xfree(entry);
+			xt_xlate_free(xl);
+			return;
 		}
 		xfree(m);
 		break;
@@ -104,9 +184,10 @@ void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 
 			tg->xlate(xl, &params);
 			nft_print(octx, "%s", xt_xlate_get(xl));
-		} else if (tg->print) {
-			printf("#");
-			tg->print(NULL, t, 0);
+			xfree(t);
+			xfree(entry);
+			xt_xlate_free(xl);
+			return;
 		}
 		xfree(t);
 		break;
@@ -116,9 +197,11 @@ void xt_stmt_xlate(const struct stmt *stmt, struct output_ctx *octx)
 
 	xt_xlate_free(xl);
 	xfree(entry);
-#else
-	nft_print(octx, "# xt_%s", stmt->xt.name);
 #endif
+	b64_buf = xt_stmt_blob_encode(stmt);
+	nft_print(octx, "xt %s %s %s",
+		  xt_typename[stmt->xt.type], stmt->xt.name, b64_buf);
+	xfree(b64_buf);
 }
 
 void xt_stmt_destroy(struct stmt *stmt)
-- 
2.38.0

