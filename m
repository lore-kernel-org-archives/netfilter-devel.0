Return-Path: <SRS0=vjpg=BV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32BC5C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Aug 2020 14:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A2442078E
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Aug 2020 14:29:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="QxgJc2GU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgHKO3p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Aug 2020 10:29:45 -0400
Received: from mx1.riseup.net ([198.252.153.129]:60100 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728737AbgHKO3p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Aug 2020 10:29:45 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4BQwG101MczDsYY;
        Tue, 11 Aug 2020 07:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1597156185; bh=c3nl5yyTBzteagXn8YShGm2MgnwY+m4YFbNwF5u4LRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QxgJc2GUjc1x3AqVEn1QrVwOhyYdIEwNKfePbpKFZ5fzkaiTO765I/zENsBRy1AbI
         NB7XckMGsx8XnAocoF2Ox+msEgWJfB1loyaEFsCTZChMsSy7t7B2W12diVq8ReFe0O
         INORQfQTRkvEblSkoauadDlp8tCtnajPQHLAgUkg=
X-Riseup-User-ID: 02C86595D7DCF51FF4753CE60B570935ADB9A15EA6F1FD254708113BE8AAF334
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4BQwG01SvFzJp3h;
        Tue, 11 Aug 2020 07:29:44 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org
Subject: [PATCH nft] src: add comment support for set declarations
Date:   Tue, 11 Aug 2020 16:27:20 +0200
Message-Id: <20200811142719.328237-2-guigom@riseup.net>
In-Reply-To: <20200811142719.328237-1-guigom@riseup.net>
References: <20200811142719.328237-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Allow users to add a comment when declaring a named set.

Adds set output handling the comment in both nftables and json
format.

$ nft add table ip x
$ nft add set ip x s {type ipv4_addr\; comment "some_addrs"\; elements = {1.1.1.1, 1.2.3.4}}

$ nft list ruleset
table ip x {
	set s {
		type ipv4_addr;
		comment "some_addrs"
		elements = { 1.1.1.1, 1.2.3.4 }
	}
}

$ nft --json list ruleset
{
    "nftables": [
        {
            "metainfo": {
                "json_schema_version": 1,
                "release_name": "Capital Idea #2",
                "version": "0.9.6"
            }
        },
        {
            "table": {
                "family": "ip",
                "handle": 4857,
                "name": "x"
            }
        },
        {
            "set": {
                "comment": "some_addrs",
                "elem": [
                    "1.1.1.1",
                    "1.2.3.4"
                ],
                "family": "ip",
                "handle": 1,
                "name": "s",
                "table": "x",
                "type": "ipv4_addr"
            }
        }
    ]
}

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 include/rule.h                                        |  2 ++
 src/json.c                                            |  3 +++
 src/mnl.c                                             |  5 +++++
 src/netlink.c                                         | 11 ++++++++++-
 src/parser_bison.y                                    |  5 +++++
 src/rule.c                                            |  9 +++++++++
 tests/shell/testcases/sets/0054comments_set_0         | 11 +++++++++++
 .../shell/testcases/sets/dumps/0054comments_set_0.nft |  7 +++++++
 8 files changed, 52 insertions(+), 1 deletion(-)
 create mode 100755 tests/shell/testcases/sets/0054comments_set_0
 create mode 100644 tests/shell/testcases/sets/dumps/0054comments_set_0.nft

diff --git a/include/rule.h b/include/rule.h
index 60eadfa3..caca63d0 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -309,6 +309,7 @@ void rule_stmt_insert_at(struct rule *rule, struct stmt *nstmt,
  * @rg_cache:	cached range element (left)
  * @policy:	set mechanism policy
  * @automerge:	merge adjacents and overlapping elements, if possible
+ * @comment:	comment
  * @desc.size:		count of set elements
  * @desc.field_len:	length of single concatenated fields, bytes
  * @desc.field_count:	count of concatenated fields
@@ -331,6 +332,7 @@ struct set {
 	bool			root;
 	bool			automerge;
 	bool			key_typeof_valid;
+	const char		*comment;
 	struct {
 		uint32_t	size;
 		uint8_t		field_len[NFT_REG32_COUNT];
diff --git a/src/json.c b/src/json.c
index 888cb371..a9f5000f 100644
--- a/src/json.c
+++ b/src/json.c
@@ -98,6 +98,9 @@ static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 			"table", set->handle.table.name,
 			"type", set_dtype_json(set->key),
 			"handle", set->handle.handle.id);
+
+	if (set->comment)
+		json_object_set_new(root, "comment", json_string(set->comment));
 	if (datatype_ext)
 		json_object_set_new(root, "map", json_string(datatype_ext));
 
diff --git a/src/mnl.c b/src/mnl.c
index e5e88f3b..5e2994c2 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1042,6 +1042,11 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, struct cmd *cmd,
 				   sizeof(set->desc.field_len[0]));
 	}
 
+	if (set->comment) {
+		if (!nftnl_udata_put_strz(udbuf, NFTNL_UDATA_SET_COMMENT, set->comment))
+				memory_allocation_error();
+	}
+
 	nftnl_set_set_data(nls, NFTNL_SET_USERDATA, nftnl_udata_buf_data(udbuf),
 			   nftnl_udata_buf_len(udbuf));
 	nftnl_udata_buf_free(udbuf);
diff --git a/src/netlink.c b/src/netlink.c
index 2f1dbe17..3afb3095 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -664,6 +664,7 @@ static int set_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 	const struct nftnl_udata **tb = data;
 	uint8_t type = nftnl_udata_type(attr);
 	uint8_t len = nftnl_udata_len(attr);
+	unsigned char *value = nftnl_udata_get(attr);
 
 	switch (type) {
 	case NFTNL_UDATA_SET_KEYBYTEORDER:
@@ -678,6 +679,10 @@ static int set_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 		if (len < 3)
 			return -1;
 		break;
+	case NFTNL_UDATA_SET_COMMENT:
+		if (value[len - 1] != '\0')
+			return -1;
+		break;
 	default:
 		return 0;
 	}
@@ -755,7 +760,7 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	const struct datatype *dtype;
 	uint32_t data_interval = 0;
 	bool automerge = false;
-	const char *udata;
+	const char *udata, *comment = NULL;
 	struct set *set;
 	uint32_t ulen;
 	uint32_t klen;
@@ -783,6 +788,8 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 		typeof_expr_key = set_make_key(ud[NFTNL_UDATA_SET_KEY_TYPEOF]);
 		if (ud[NFTNL_UDATA_SET_DATA_TYPEOF])
 			typeof_expr_data = set_make_key(ud[NFTNL_UDATA_SET_DATA_TYPEOF]);
+		if (ud[NFTNL_UDATA_SET_COMMENT])
+			comment = xstrdup(nftnl_udata_get(ud[NFTNL_UDATA_SET_COMMENT]));
 	}
 
 	key = nftnl_set_get_u32(nls, NFTNL_SET_KEY_TYPE);
@@ -819,6 +826,8 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	set->handle.table.name = xstrdup(nftnl_set_get_str(nls, NFTNL_SET_TABLE));
 	set->handle.set.name = xstrdup(nftnl_set_get_str(nls, NFTNL_SET_NAME));
 	set->automerge	   = automerge;
+	if (comment)
+		set->comment = comment;
 
 	if (nftnl_set_is_set(nls, NFTNL_SET_EXPR)) {
 		const struct nftnl_expr *nle;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 167c3158..7e094ff6 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1768,6 +1768,11 @@ set_block		:	/* empty */	{ $$ = $<set>-1; }
 				$$ = $1;
 			}
 			|	set_block	set_mechanism	stmt_separator
+			|	set_block	comment_spec	stmt_separator
+			{
+				$1->comment = $2;
+				$$ = $1;
+			}
 			;
 
 set_block_expr		:	set_expr
diff --git a/src/rule.c b/src/rule.c
index 6335aa21..e288c38c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -361,6 +361,8 @@ void set_free(struct set *set)
 		return;
 	if (set->init != NULL)
 		expr_free(set->init);
+	if (set->comment)
+		xfree(set->comment);
 	handle_free(&set->handle);
 	stmt_free(set->stmt);
 	expr_free(set->key);
@@ -578,6 +580,13 @@ static void set_print_declaration(const struct set *set,
 		time_print(set->gc_int, octx);
 		nft_print(octx, "%s", opts->stmt_separator);
 	}
+
+	if (set->comment) {
+		nft_print(octx, "%s%scomment \"%s\"%s",
+			  opts->tab, opts->tab,
+			  set->comment,
+			  opts->stmt_separator);
+	}
 }
 
 static void do_set_print(const struct set *set, struct print_fmt_options *opts,
diff --git a/tests/shell/testcases/sets/0054comments_set_0 b/tests/shell/testcases/sets/0054comments_set_0
new file mode 100755
index 00000000..93a73f0d
--- /dev/null
+++ b/tests/shell/testcases/sets/0054comments_set_0
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+# Test that comments are added to sets
+
+$NFT add table t
+$NFT add set t s {type ipv4_addr \; flags interval \; comment "test" \;}
+if ! $NFT list ruleset | grep test >/dev/null ; then
+	echo "E: missing comment in set" >&2
+	exit 1
+fi
+
diff --git a/tests/shell/testcases/sets/dumps/0054comments_set_0.nft b/tests/shell/testcases/sets/dumps/0054comments_set_0.nft
new file mode 100644
index 00000000..2ad84003
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/0054comments_set_0.nft
@@ -0,0 +1,7 @@
+table ip t {
+	set s {
+		type ipv4_addr
+		flags interval
+		comment "test"
+	}
+}
-- 
2.27.0

