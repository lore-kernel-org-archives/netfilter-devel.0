Return-Path: <SRS0=xTVu=B6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6939C433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Aug 2020 08:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C60DC21744
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Aug 2020 08:20:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="UgAJXqtP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgHTIUc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Aug 2020 04:20:32 -0400
Received: from mx1.riseup.net ([198.252.153.129]:39094 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbgHTIUZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Aug 2020 04:20:25 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4BXHdc6ZPqzFmbd;
        Thu, 20 Aug 2020 01:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1597911625; bh=TBxsX2osBzEN/yWLhlCz+EhOLlp8zPwlgj8pB21MzCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UgAJXqtPcRKoTzmpNbuh7TuXxoXRCyCFTFYT4zGupDJarO1nXw/qiJLvZwftY1ltg
         +Y/cpMhPc2gcuCwjomXS312GBpPMqhPKB3+HfaB3gUEIBuX8OnIbYKczbkGyxGZ9EK
         yZJsuTTDieZktPZI/wzMRGt1PeqrOsew4HApzyaU=
X-Riseup-User-ID: BD90736FFC70D62A91D7D21D565AA47D246E2AEDD74F1D0A85CF025E42606968
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4BXHdc09XCz8wCM;
        Thu, 20 Aug 2020 01:20:19 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org
Subject: [PATCH nftables 3/3] src: add comment support when adding tables
Date:   Thu, 20 Aug 2020 10:19:03 +0200
Message-Id: <20200820081903.36781-4-guigom@riseup.net>
In-Reply-To: <20200820081903.36781-1-guigom@riseup.net>
References: <20200820081903.36781-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Adds userdata building logic if a comment is specified when creating a
new table. Adds netlink userdata parsing callback function.

Relies on kernel supporting userdata for nft_table.

Example:

> nft add table ip x { comment "test"\; }
> nft list ruleset

table ip x {
	comment "test"
}

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 include/rule.h                                |  1 +
 src/mnl.c                                     | 19 +++++++++--
 src/netlink.c                                 | 32 +++++++++++++++++++
 src/parser_bison.y                            |  4 +++
 src/rule.c                                    |  5 +++
 .../testcases/optionals/comments_table_0      |  0
 .../testcases/optionals/comments_table_1      |  0
 .../optionals/dumps/comments_table_0.nft      |  0
 .../optionals/dumps/comments_table_1.nft      |  0
 9 files changed, 59 insertions(+), 2 deletions(-)
 create mode 100755 tests/shell/testcases/optionals/comments_table_0
 create mode 100755 tests/shell/testcases/optionals/comments_table_1
 create mode 100644 tests/shell/testcases/optionals/dumps/comments_table_0.nft
 create mode 100644 tests/shell/testcases/optionals/dumps/comments_table_1.nft

diff --git a/include/rule.h b/include/rule.h
index caca63d0..1167b1fb 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -159,6 +159,7 @@ struct table {
 	struct list_head	chain_bindings;
 	enum table_flags 	flags;
 	unsigned int		refcnt;
+	const char		*comment;
 };
 
 extern struct table *table_alloc(void);
diff --git a/src/mnl.c b/src/mnl.c
index 388eff8f..3bf13991 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -832,22 +832,37 @@ int mnl_nft_table_add(struct netlink_ctx *ctx, struct cmd *cmd,
 {
 	struct nftnl_table *nlt;
 	struct nlmsghdr *nlh;
+	struct nftnl_udata_buf *udbuf;
 
 	nlt = nftnl_table_alloc();
 	if (nlt == NULL)
 		memory_allocation_error();
 
 	nftnl_table_set_u32(nlt, NFTNL_TABLE_FAMILY, cmd->handle.family);
-	if (cmd->table)
+	if (cmd->table) {
 		nftnl_table_set_u32(nlt, NFTNL_TABLE_FLAGS, cmd->table->flags);
-	else
+
+		if (cmd->table->comment) {
+			udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
+			if (!udbuf)
+				memory_allocation_error();
+			if (!nftnl_udata_put_strz(udbuf, NFTNL_UDATA_TABLE_COMMENT, cmd->table->comment))
+				memory_allocation_error();
+			nftnl_table_set_data(nlt, NFTNL_TABLE_USERDATA, nftnl_udata_buf_data(udbuf),
+					     nftnl_udata_buf_len(udbuf));
+			nftnl_udata_buf_free(udbuf);
+		}
+	}
+	else {
 		nftnl_table_set_u32(nlt, NFTNL_TABLE_FLAGS, 0);
+	}
 
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
 				    NFT_MSG_NEWTABLE,
 				    cmd->handle.family,
 				    flags, ctx->seqnum);
 
+
 	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
 	mnl_attr_put_strz(nlh, NFTA_TABLE_NAME, cmd->handle.table.name);
 	nftnl_table_nlmsg_build_payload(nlh, nlt);
diff --git a/src/netlink.c b/src/netlink.c
index 20b3cdf5..813f33c1 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -583,10 +583,32 @@ int netlink_list_chains(struct netlink_ctx *ctx, const struct handle *h)
 	return 0;
 }
 
+static int table_parse_udata_cb(const struct nftnl_udata *attr, void *data)
+{
+	unsigned char *value = nftnl_udata_get(attr);
+	const struct nftnl_udata **tb = data;
+	uint8_t type = nftnl_udata_type(attr);
+	uint8_t len = nftnl_udata_len(attr);
+
+	switch (type) {
+		case NFTNL_UDATA_TABLE_COMMENT:
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
 struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
 					const struct nftnl_table *nlt)
 {
 	struct table *table;
+	const struct nftnl_udata *ud[NFTNL_UDATA_TABLE_MAX + 1] = {};
+	const char *udata;
+	uint32_t ulen;
 
 	table = table_alloc();
 	table->handle.family = nftnl_table_get_u32(nlt, NFTNL_TABLE_FAMILY);
@@ -594,6 +616,16 @@ struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
 	table->flags	     = nftnl_table_get_u32(nlt, NFTNL_TABLE_FLAGS);
 	table->handle.handle.id = nftnl_table_get_u64(nlt, NFTNL_TABLE_HANDLE);
 
+	if (nftnl_table_is_set(nlt, NFTNL_TABLE_USERDATA)) {
+		udata = nftnl_table_get_data(nlt, NFTNL_TABLE_USERDATA, &ulen);
+		if (nftnl_udata_parse(udata, ulen, table_parse_udata_cb, ud) < 0) {
+			netlink_io_error(ctx, NULL, "Cannot parse userdata");
+			return NULL;
+		}
+		if (ud[NFTNL_UDATA_TABLE_COMMENT])
+			table->comment = xstrdup(nftnl_udata_get(ud[NFTNL_UDATA_TABLE_COMMENT]));
+	}
+
 	return table;
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 7e094ff6..937468c1 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1533,6 +1533,10 @@ table_options		:	FLAGS		STRING
 					YYERROR;
 				}
 			}
+			|	comment_spec
+			{
+				$<table>0->comment = $1;
+			}
 			;
 
 table_block		:	/* empty */	{ $$ = $<table>-1; }
diff --git a/src/rule.c b/src/rule.c
index 2b5685c2..775e05c2 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1317,6 +1317,8 @@ void table_free(struct table *table)
 
 	if (--table->refcnt > 0)
 		return;
+	if (table->comment)
+		xfree(table->comment);
 	list_for_each_entry_safe(chain, next, &table->chains, list)
 		chain_free(chain);
 	list_for_each_entry_safe(chain, next, &table->chain_bindings, list)
@@ -1414,6 +1416,9 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 	nft_print(octx, "\n");
 	table_print_options(table, &delim, octx);
 
+	if (table->comment)
+		nft_print(octx, "\tcomment \"%s\"\n", table->comment);
+
 	list_for_each_entry(obj, &table->objs, list) {
 		nft_print(octx, "%s", delim);
 		obj_print(obj, octx);
diff --git a/tests/shell/testcases/optionals/comments_table_0 b/tests/shell/testcases/optionals/comments_table_0
new file mode 100755
index 00000000..e69de29b
diff --git a/tests/shell/testcases/optionals/comments_table_1 b/tests/shell/testcases/optionals/comments_table_1
new file mode 100755
index 00000000..e69de29b
diff --git a/tests/shell/testcases/optionals/dumps/comments_table_0.nft b/tests/shell/testcases/optionals/dumps/comments_table_0.nft
new file mode 100644
index 00000000..e69de29b
diff --git a/tests/shell/testcases/optionals/dumps/comments_table_1.nft b/tests/shell/testcases/optionals/dumps/comments_table_1.nft
new file mode 100644
index 00000000..e69de29b
-- 
2.27.0

