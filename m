Return-Path: <SRS0=Qpa8=CM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21608C433E2
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Sep 2020 09:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAA782071B
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Sep 2020 09:19:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="Mw+1ICf5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgICJTr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Sep 2020 05:19:47 -0400
Received: from mx1.riseup.net ([198.252.153.129]:45202 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbgICJTq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Sep 2020 05:19:46 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4BhwHj5RW7zFg8Z;
        Thu,  3 Sep 2020 02:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1599124785; bh=6hBxJEXHdwu8alRwCtDAtvbhLFDIgV+nWgAXHPSvYyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mw+1ICf5LxfRbsrMZ7vJgu3YVT5bYPc4QaP1U8GOXZ8fSTHQ1agBbcDaPYXTv0AnV
         vq7g7C6K8Btya418PTsgrTB4jKns1aDhpupMGnSMNcAA3iHXRG72Fbs98naGm7fldN
         aQaoN2X6S8dRBejSZM7t0YIpRjEuuX4zEQVqX62U=
X-Riseup-User-ID: F96F0B39F32B708716BD77B0C73C82275683EBE6EB31E701CBB447D7FA9AD1AD
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4BhwHh5hr5z8sZv;
        Thu,  3 Sep 2020 02:19:44 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables 3/3, v2] src: add comment support for objects
Date:   Thu,  3 Sep 2020 11:16:06 +0200
Message-Id: <20200903091605.1664-1-guigom@riseup.net>
In-Reply-To: <20200902091241.1379-4-guigom@riseup.net>
References: <20200902091241.1379-4-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Enables specifying an optional comment when declaring named objects. The
comment is to be specified inside the object's block ({} block)

Relies on libnftnl exporting nftnl_obj_get_data and kernel space support
to store the comments.

For consistency, this patch makes the comment be printed first when
listing objects.

Adds a testcase importing all commented named objects except for secmark,
although it's supported.

Example: Adding a quota with a comment

> add table inet filter
> nft add quota inet filter q { over 1200 bytes \; comment "test_comment"\; }
> list ruleset

table inet filter {
	quota q {
		comment "test_comment"
		over 1200 bytes
	}
}

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
Adds missing parser { *_block } for some objects in v1

 include/rule.h                                |  1 +
 src/mnl.c                                     | 12 +++++
 src/netlink.c                                 | 31 +++++++++++
 src/parser_bison.y                            | 52 +++++++++++++++++++
 src/rule.c                                    | 20 +++++++
 .../testcases/optionals/comments_objects_0    | 44 ++++++++++++++++
 .../optionals/dumps/comments_objects_0.nft    | 37 +++++++++++++
 7 files changed, 197 insertions(+)
 create mode 100755 tests/shell/testcases/optionals/comments_objects_0
 create mode 100644 tests/shell/testcases/optionals/dumps/comments_objects_0.nft

diff --git a/include/rule.h b/include/rule.h
index 56f1951f..837005b1 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -479,6 +479,7 @@ struct obj {
 	struct handle			handle;
 	uint32_t			type;
 	unsigned int			refcnt;
+	const char			*comment;
 	union {
 		struct counter		counter;
 		struct quota		quota;
diff --git a/src/mnl.c b/src/mnl.c
index cdcf9490..ca4f4b2a 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1189,6 +1189,7 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		    unsigned int flags)
 {
 	struct obj *obj = cmd->object;
+	struct nftnl_udata_buf *udbuf;
 	struct nftnl_obj *nlo;
 	struct nlmsghdr *nlh;
 
@@ -1199,6 +1200,17 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	nftnl_obj_set_u32(nlo, NFTNL_OBJ_FAMILY, cmd->handle.family);
 	nftnl_obj_set_u32(nlo, NFTNL_OBJ_TYPE, obj->type);
 
+	if (obj->comment) {
+		udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
+		if (!udbuf)
+			memory_allocation_error();
+		if (!nftnl_udata_put_strz(udbuf, NFTNL_UDATA_OBJ_COMMENT, obj->comment))
+			memory_allocation_error();
+		nftnl_obj_set_data(nlo, NFTNL_OBJ_USERDATA, nftnl_udata_buf_data(udbuf),
+				     nftnl_udata_buf_len(udbuf));
+		nftnl_udata_buf_free(udbuf);
+	}
+
 	switch (obj->type) {
 	case NFT_OBJECT_COUNTER:
 		nftnl_obj_set_u64(nlo, NFTNL_OBJ_CTR_PKTS,
diff --git a/src/netlink.c b/src/netlink.c
index a107f492..6912b018 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1314,11 +1314,33 @@ void netlink_dump_obj(struct nftnl_obj *nln, struct netlink_ctx *ctx)
 	fprintf(fp, "\n");
 }
 
+static int obj_parse_udata_cb(const struct nftnl_udata *attr, void *data)
+{
+	unsigned char *value = nftnl_udata_get(attr);
+	uint8_t type = nftnl_udata_type(attr);
+	const struct nftnl_udata **tb = data;
+	uint8_t len = nftnl_udata_len(attr);
+
+	switch (type) {
+		case NFTNL_UDATA_OBJ_COMMENT:
+			if (value[len - 1] != '\0')
+				return -1;
+			break;
+		default:
+			return 0;
+	}
+	tb[type] = attr;
+	return 0;
+}
+
 struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 				    struct nftnl_obj *nlo)
 {
+	const struct nftnl_udata *ud[NFTNL_UDATA_OBJ_MAX + 1] = {};
+	const char *udata;
 	struct obj *obj;
 	uint32_t type;
+	uint32_t ulen;
 
 	obj = obj_alloc(&netlink_location);
 	obj->handle.family = nftnl_obj_get_u32(nlo, NFTNL_OBJ_FAMILY);
@@ -1328,6 +1350,15 @@ struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 		xstrdup(nftnl_obj_get_str(nlo, NFTNL_OBJ_NAME));
 	obj->handle.handle.id =
 		nftnl_obj_get_u64(nlo, NFTNL_OBJ_HANDLE);
+	if (nftnl_obj_is_set(nlo, NFTNL_OBJ_USERDATA)) {
+		udata = nftnl_obj_get_data(nlo, NFTNL_OBJ_USERDATA, &ulen);
+		if (nftnl_udata_parse(udata, ulen, obj_parse_udata_cb, ud) < 0) {
+			netlink_io_error(ctx, NULL, "Cannot parse userdata");
+			return NULL;
+		}
+		if (ud[NFTNL_UDATA_OBJ_COMMENT])
+			obj->comment = xstrdup(nftnl_udata_get(ud[NFTNL_UDATA_OBJ_COMMENT]));
+	}
 
 	type = nftnl_obj_get_u32(nlo, NFTNL_OBJ_TYPE);
 	switch (type) {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index d938f566..7242c4c3 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1006,10 +1006,18 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_COUNTER, &$2, &@$, $3);
 			}
+			|	COUNTER		obj_spec	counter_obj	'{' counter_block '}'
+			{
+				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_COUNTER, &$2, &@$, $3);
+			}
 			|	QUOTA		obj_spec	quota_obj	quota_config
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
+			|	QUOTA		obj_spec	quota_obj	'{' quota_block	'}'
+			{
+				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_QUOTA, &$2, &@$, $3);
+			}
 			|	CT	HELPER	obj_spec	ct_obj_alloc	'{' ct_helper_block '}'
 			{
 				$$ = cmd_alloc_obj_ct(CMD_ADD, NFT_OBJECT_CT_HELPER, &$3, &@$, $4);
@@ -1026,14 +1034,26 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_LIMIT, &$2, &@$, $3);
 			}
+			|	LIMIT		obj_spec	limit_obj	'{' limit_block '}'
+			{
+				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_LIMIT, &$2, &@$, $3);
+			}
 			|	SECMARK		obj_spec	secmark_obj	secmark_config
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SECMARK, &$2, &@$, $3);
 			}
+			|	SECMARK		obj_spec	secmark_obj	'{' secmark_block '}'
+			{
+				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SECMARK, &$2, &@$, $3);
+			}
 			|	SYNPROXY	obj_spec	synproxy_obj	synproxy_config
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SYNPROXY, &$2, &@$, $3);
 			}
+			|	SYNPROXY	obj_spec	synproxy_obj	'{' synproxy_block '}'
+			{
+				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SYNPROXY, &$2, &@$, $3);
+			}
 			;
 
 replace_cmd		:	RULE		ruleid_spec	rule
@@ -2039,6 +2059,10 @@ counter_block		:	/* empty */	{ $$ = $<obj>-1; }
 			{
 				$$ = $1;
 			}
+			|	counter_block	  comment_spec
+			{
+				$<obj>1->comment = $2;
+			}
 			;
 
 quota_block		:	/* empty */	{ $$ = $<obj>-1; }
@@ -2048,6 +2072,10 @@ quota_block		:	/* empty */	{ $$ = $<obj>-1; }
 			{
 				$$ = $1;
 			}
+			|	quota_block	comment_spec
+			{
+				$<obj>1->comment = $2;
+			}
 			;
 
 ct_helper_block		:	/* empty */	{ $$ = $<obj>-1; }
@@ -2057,6 +2085,10 @@ ct_helper_block		:	/* empty */	{ $$ = $<obj>-1; }
 			{
 				$$ = $1;
 			}
+			|       ct_helper_block     comment_spec
+			{
+				$<obj>1->comment = $2;
+			}
 			;
 
 ct_timeout_block	:	/*empty */
@@ -2070,6 +2102,10 @@ ct_timeout_block	:	/*empty */
 			{
 				$$ = $1;
 			}
+			|       ct_timeout_block     comment_spec
+			{
+				$<obj>1->comment = $2;
+			}
 			;
 
 ct_expect_block		:	/*empty */	{ $$ = $<obj>-1; }
@@ -2079,6 +2115,10 @@ ct_expect_block		:	/*empty */	{ $$ = $<obj>-1; }
 			{
 				$$ = $1;
 			}
+			|       ct_expect_block     comment_spec
+			{
+				$<obj>1->comment = $2;
+			}
 			;
 
 limit_block		:	/* empty */	{ $$ = $<obj>-1; }
@@ -2088,6 +2128,10 @@ limit_block		:	/* empty */	{ $$ = $<obj>-1; }
 			{
 				$$ = $1;
 			}
+			|       limit_block     comment_spec
+			{
+				$<obj>1->comment = $2;
+			}
 			;
 
 secmark_block		:	/* empty */	{ $$ = $<obj>-1; }
@@ -2097,6 +2141,10 @@ secmark_block		:	/* empty */	{ $$ = $<obj>-1; }
 			{
 				$$ = $1;
 			}
+			|       secmark_block     comment_spec
+			{
+				$<obj>1->comment = $2;
+			}
 			;
 
 synproxy_block		:	/* empty */	{ $$ = $<obj>-1; }
@@ -2106,6 +2154,10 @@ synproxy_block		:	/* empty */	{ $$ = $<obj>-1; }
 			{
 				$$ = $1;
 			}
+			|       synproxy_block     comment_spec
+			{
+				$<obj>1->comment = $2;
+			}
 			;
 
 type_identifier		:	STRING	{ $$ = $1; }
diff --git a/src/rule.c b/src/rule.c
index 2c4b5dbe..4ebc8d81 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1893,6 +1893,7 @@ void obj_free(struct obj *obj)
 {
 	if (--obj->refcnt > 0)
 		return;
+	xfree(obj->comment);
 	handle_free(&obj->handle);
 	xfree(obj);
 }
@@ -1986,6 +1987,16 @@ static const char *synproxy_timestamp_to_str(const uint32_t flags)
         return "";
 }
 
+static void obj_print_comment(const struct obj *obj,
+			      struct print_fmt_options *opts,
+			      struct output_ctx *octx)
+{
+	if (obj->comment)
+		nft_print(octx, "%s%s%scomment \"%s\"",
+			  opts->nl, opts->tab, opts->tab,
+			  obj->comment);
+}
+
 static void obj_print_data(const struct obj *obj,
 			   struct print_fmt_options *opts,
 			   struct output_ctx *octx)
@@ -1995,6 +2006,7 @@ static void obj_print_data(const struct obj *obj,
 		nft_print(octx, " %s {", obj->handle.obj.name);
 		if (nft_output_handle(octx))
 			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
+		obj_print_comment(obj, opts, octx);
 		nft_print(octx, "%s%s%s", opts->nl, opts->tab, opts->tab);
 		if (nft_output_stateless(octx)) {
 			nft_print(octx, "packets 0 bytes 0");
@@ -2010,6 +2022,7 @@ static void obj_print_data(const struct obj *obj,
 		nft_print(octx, " %s {", obj->handle.obj.name);
 		if (nft_output_handle(octx))
 			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
+		obj_print_comment(obj, opts, octx);
 		nft_print(octx, "%s%s%s", opts->nl, opts->tab, opts->tab);
 		data_unit = get_rate(obj->quota.bytes, &bytes);
 		nft_print(octx, "%s%" PRIu64 " %s",
@@ -2027,6 +2040,7 @@ static void obj_print_data(const struct obj *obj,
 		nft_print(octx, " %s {", obj->handle.obj.name);
 		if (nft_output_handle(octx))
 			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
+		obj_print_comment(obj, opts, octx);
 		nft_print(octx, "%s%s%s", opts->nl, opts->tab, opts->tab);
 		nft_print(octx, "\"%s\"%s", obj->secmark.ctx, opts->nl);
 		break;
@@ -2034,6 +2048,7 @@ static void obj_print_data(const struct obj *obj,
 		nft_print(octx, " %s {", obj->handle.obj.name);
 		if (nft_output_handle(octx))
 			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
+		obj_print_comment(obj, opts, octx);
 		nft_print(octx, "%s", opts->nl);
 		nft_print(octx, "%s%stype \"%s\" protocol ",
 			  opts->tab, opts->tab, obj->ct_helper.name);
@@ -2048,6 +2063,7 @@ static void obj_print_data(const struct obj *obj,
 		nft_print(octx, " %s {", obj->handle.obj.name);
 		if (nft_output_handle(octx))
 			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
+		obj_print_comment(obj, opts, octx);
 		nft_print(octx, "%s", opts->nl);
 		nft_print(octx, "%s%sprotocol ", opts->tab, opts->tab);
 		print_proto_name_proto(obj->ct_timeout.l4proto, octx);
@@ -2063,6 +2079,7 @@ static void obj_print_data(const struct obj *obj,
 		nft_print(octx, " %s {", obj->handle.obj.name);
 		if (nft_output_handle(octx))
 			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
+		obj_print_comment(obj, opts, octx);
 		nft_print(octx, "%s", opts->nl);
 		nft_print(octx, "%s%sprotocol ", opts->tab, opts->tab);
 		print_proto_name_proto(obj->ct_expect.l4proto, octx);
@@ -2091,6 +2108,7 @@ static void obj_print_data(const struct obj *obj,
 		nft_print(octx, " %s {", obj->handle.obj.name);
 		if (nft_output_handle(octx))
 			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
+		obj_print_comment(obj, opts, octx);
 		nft_print(octx, "%s%s%s", opts->nl, opts->tab, opts->tab);
 		switch (obj->limit.type) {
 		case NFT_LIMIT_PKTS:
@@ -2128,6 +2146,8 @@ static void obj_print_data(const struct obj *obj,
 		if (nft_output_handle(octx))
 			nft_print(octx, " # handle %" PRIu64, obj->handle.handle.id);
 
+		obj_print_comment(obj, opts, octx);
+
 		if (flags & NF_SYNPROXY_OPT_MSS) {
 			nft_print(octx, "%s%s%s", opts->nl, opts->tab, opts->tab);
 			nft_print(octx, "mss %u", obj->synproxy.mss);
diff --git a/tests/shell/testcases/optionals/comments_objects_0 b/tests/shell/testcases/optionals/comments_objects_0
new file mode 100755
index 00000000..7437c77b
--- /dev/null
+++ b/tests/shell/testcases/optionals/comments_objects_0
@@ -0,0 +1,44 @@
+#!/bin/bash
+
+EXPECTED='table ip filter {
+	quota q {
+		over 1200 bytes
+		comment "test1"
+	}
+
+	counter c {
+		packets 0 bytes 0
+		comment "test2"
+	}
+
+	ct helper h {
+		type "sip" protocol tcp
+		l3proto ip
+		comment "test3"
+	}
+
+	ct expectation e {
+		protocol tcp
+		dport 666
+		timeout 100ms
+		size 96
+		l3proto ip
+		comment "test4"
+	}
+
+	limit l {
+		rate 400/hour
+		comment "test5"
+	}
+
+	synproxy s {
+		mss 1460
+		wscale 2
+		comment "test6"
+	}
+}
+'
+
+set -e
+
+$NFT -f - <<< "$EXPECTED"
diff --git a/tests/shell/testcases/optionals/dumps/comments_objects_0.nft b/tests/shell/testcases/optionals/dumps/comments_objects_0.nft
new file mode 100644
index 00000000..b760ced6
--- /dev/null
+++ b/tests/shell/testcases/optionals/dumps/comments_objects_0.nft
@@ -0,0 +1,37 @@
+table ip filter {
+	quota q {
+		comment "test1"
+		over 1200 bytes
+	}
+
+	counter c {
+		comment "test2"
+		packets 0 bytes 0
+	}
+
+	ct helper h {
+		comment "test3"
+		type "sip" protocol tcp
+		l3proto ip
+	}
+
+	ct expectation e {
+		comment "test4"
+		protocol tcp
+		dport 666
+		timeout 100ms
+		size 96
+		l3proto ip
+	}
+
+	limit l {
+		comment "test5"
+		rate 400/hour
+	}
+
+	synproxy s {
+		comment "test6"
+		mss 1460
+		wscale 2
+	}
+}
-- 
2.27.0

