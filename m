Return-Path: <SRS0=tgdo=C6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E25BEC43469
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Sep 2020 13:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8B6F206A4
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Sep 2020 13:35:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="FxQsg6ix"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgIUNfw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Sep 2020 09:35:52 -0400
Received: from mx1.riseup.net ([198.252.153.129]:40574 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726643AbgIUNfu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Sep 2020 09:35:50 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4Bw4zL5ssCzFmGN;
        Mon, 21 Sep 2020 06:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1600694958; bh=jicbrPG1WFYWcPTfZgdaqrkkRRw86ojtm0OM3U1XR3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FxQsg6ix2FHkd3T8pztFf3CSLyHpuYkZmRddOI2VVgtKCzt6OBYfvk/SeYLCIYBIc
         xOC+QbNk9E93VO3TPVJZl06ZMMLaEw0Z6TDg/a16WRx+P1t7VSxxMbj3kw541qXeMw
         z0CfEuVfckreZpwvLaGNIrRUV1EWa+GD4K/FXCyQ=
X-Riseup-User-ID: 5CA7DE47523E68D40FAC86730F5A915B13BF4B242810F8DA2544503F9493FA58
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4Bw4zK71LvzJnD0;
        Mon, 21 Sep 2020 06:29:17 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables 3/3] src: add comment support for chains
Date:   Mon, 21 Sep 2020 15:28:23 +0200
Message-Id: <20200921132822.55231-4-guigom@riseup.net>
In-Reply-To: <20200921132822.55231-1-guigom@riseup.net>
References: <20200921132822.55231-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch enables the user to specify a comment when adding a chain.

Relies on kernel space supporting userdata for chains.

> nft add table ip filter
> nft add chain ip filter input { comment "test"\; type filter hook input priority 0\; policy accept\; }
> list ruleset

table ip filter {
	chain input {
		comment "test"
		type filter hook input priority filter; policy accept;
	}
}

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 include/rule.h                                |  1 +
 src/mnl.c                                     | 11 +++++++
 src/netlink.c                                 | 32 +++++++++++++++++++
 src/parser_bison.y                            |  8 +++++
 src/rule.c                                    |  3 ++
 .../testcases/optionals/comments_chain_0      | 12 +++++++
 .../optionals/dumps/comments_chain_0.nft      |  5 +++
 7 files changed, 72 insertions(+)
 create mode 100755 tests/shell/testcases/optionals/comments_chain_0
 create mode 100644 tests/shell/testcases/optionals/dumps/comments_chain_0.nft

diff --git a/include/rule.h b/include/rule.h
index 837005b1..ffe8daab 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -225,6 +225,7 @@ struct chain {
 	struct location		location;
 	unsigned int		refcnt;
 	uint32_t		flags;
+	const char		*comment;
 	struct {
 		struct location		loc;
 		struct prio_spec	priority;
diff --git a/src/mnl.c b/src/mnl.c
index ca4f4b2a..3e0de103 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -612,6 +612,7 @@ err:
 int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		      unsigned int flags)
 {
+	struct nftnl_udata_buf *udbuf;
 	int priority, policy, i = 0;
 	struct nftnl_chain *nlc;
 	unsigned int ifname_len;
@@ -672,6 +673,16 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 
 			xfree(dev_array);
 		}
+		if (cmd->chain->comment) {
+			udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
+			if (!udbuf)
+				memory_allocation_error();
+			if (!nftnl_udata_put_strz(udbuf, NFTNL_UDATA_CHAIN_COMMENT, cmd->chain->comment))
+				memory_allocation_error();
+			nftnl_chain_set_data(nlc, NFTNL_CHAIN_USERDATA, nftnl_udata_buf_data(udbuf),
+					     nftnl_udata_buf_len(udbuf));
+			nftnl_udata_buf_free(udbuf);
+		}
 	}
 	netlink_dump_chain(nlc, ctx);
 
diff --git a/src/netlink.c b/src/netlink.c
index 6912b018..f8ac2b9e 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -472,12 +472,34 @@ void netlink_dump_chain(const struct nftnl_chain *nlc, struct netlink_ctx *ctx)
 	fprintf(fp, "\n");
 }
 
+static int chain_parse_udata_cb(const struct nftnl_udata *attr, void *data)
+{
+	unsigned char *value = nftnl_udata_get(attr);
+	uint8_t type = nftnl_udata_type(attr);
+	const struct nftnl_udata **tb = data;
+	uint8_t len = nftnl_udata_len(attr);
+
+	switch (type) {
+		case NFTNL_UDATA_CHAIN_COMMENT:
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
 struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 					const struct nftnl_chain *nlc)
 {
+	const struct nftnl_udata *ud[NFTNL_UDATA_OBJ_MAX + 1] = {};
 	int priority, policy, len = 0, i;
 	const char * const *dev_array;
 	struct chain *chain;
+	const char *udata;
+	uint32_t ulen;
 
 	chain = chain_alloc(nftnl_chain_get_str(nlc, NFTNL_CHAIN_NAME));
 	chain->handle.family =
@@ -534,6 +556,16 @@ struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 		chain->flags        |= CHAIN_F_BASECHAIN;
 	}
 
+	if (nftnl_chain_is_set(nlc, NFTNL_CHAIN_USERDATA)) {
+		udata = nftnl_chain_get_data(nlc, NFTNL_CHAIN_USERDATA, &ulen);
+		if (nftnl_udata_parse(udata, ulen, chain_parse_udata_cb, ud) < 0) {
+			netlink_io_error(ctx, NULL, "Cannot parse userdata");
+			return NULL;
+		}
+		if (ud[NFTNL_UDATA_CHAIN_COMMENT])
+			chain->comment = xstrdup(nftnl_udata_get(ud[NFTNL_UDATA_CHAIN_COMMENT]));
+	}
+
 	return chain;
 }
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index c7ea520c..4c71cd61 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1724,6 +1724,14 @@ chain_block		:	/* empty */	{ $$ = $<chain>-1; }
 				list_add_tail(&$2->list, &$1->rules);
 				$$ = $1;
 			}
+			|	chain_block	comment_spec	stmt_separator
+			{
+				if (already_set($1->comment, &@2, state)) {
+					xfree($2);
+					YYERROR;
+				}
+				$1->comment = $2;
+			}
 			;
 
 subchain_block		:	/* empty */	{ $$ = $<chain>-1; }
diff --git a/src/rule.c b/src/rule.c
index dabb3579..d75b36c4 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -929,6 +929,7 @@ void chain_free(struct chain *chain)
 	xfree(chain->dev_array);
 	expr_free(chain->priority.expr);
 	expr_free(chain->policy);
+	xfree(chain->comment);
 	xfree(chain);
 }
 
@@ -1220,6 +1221,8 @@ static void chain_print_declaration(const struct chain *chain,
 	nft_print(octx, "\tchain %s {", chain->handle.chain.name);
 	if (nft_output_handle(octx))
 		nft_print(octx, " # handle %" PRIu64, chain->handle.handle.id);
+	if (chain->comment)
+		nft_print(octx, "\n\t\tcomment \"%s\"", chain->comment);
 	nft_print(octx, "\n");
 	if (chain->flags & CHAIN_F_BASECHAIN) {
 		nft_print(octx, "\t\ttype %s hook %s", chain->type,
diff --git a/tests/shell/testcases/optionals/comments_chain_0 b/tests/shell/testcases/optionals/comments_chain_0
new file mode 100755
index 00000000..fba961c7
--- /dev/null
+++ b/tests/shell/testcases/optionals/comments_chain_0
@@ -0,0 +1,12 @@
+#!/bin/bash
+
+EXPECTED='table ip test_table {
+	chain test_chain {
+		comment "test"
+	}
+}
+'
+
+set -e
+
+$NFT -f - <<< "$EXPECTED"
diff --git a/tests/shell/testcases/optionals/dumps/comments_chain_0.nft b/tests/shell/testcases/optionals/dumps/comments_chain_0.nft
new file mode 100644
index 00000000..be3d8f33
--- /dev/null
+++ b/tests/shell/testcases/optionals/dumps/comments_chain_0.nft
@@ -0,0 +1,5 @@
+table ip test_table {
+	chain test_chain {
+		comment "test"
+	}
+}
-- 
2.27.0

