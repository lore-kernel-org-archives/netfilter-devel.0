Return-Path: <SRS0=aLv2=BJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D4FDC433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jul 2020 19:53:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEAF52070B
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jul 2020 19:53:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="DYpc/856"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730595AbgG3Tx5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Jul 2020 15:53:57 -0400
Received: from mx1.riseup.net ([198.252.153.129]:54764 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730583AbgG3Tx5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Jul 2020 15:53:57 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4BHh1c5BckzFgZB
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2020 12:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1596138836; bh=IsFGooUB5cQebYNjQX7/QsGUkU9Vk1d1nqg+tkpwNnc=;
        h=From:To:Subject:Date:From;
        b=DYpc/856srHx/D7F0IDj/r0/YpMT4ZwpwBQv0ebVrSzez7SmL/X15ibNk4cFwSiyD
         xTHriLw+6jTWVSbDVLz0K2HbeGweOmtgRHYv7Jm5GM1xtxmhYBnyruQg/+7RKINaSP
         UAreARlZpt+3krF6RifTbpY+TjWxGIJcPjiIiNAA=
X-Riseup-User-ID: 92534FD79BF66141A61E8B68D1011916F8073284C8BA7513D2C08E1922697B38
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4BHh1c0qwqzJmhL
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2020 12:53:55 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: enable output with "nft --echo --json" and nftables syntax
Date:   Thu, 30 Jul 2020 21:53:37 +0200
Message-Id: <20200730195337.3627-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch fixes a bug in which nft did not print any output when
specifying --echo and --json and reading nftables syntax.
This was because struct nft_ctx member json_root is not inizialized when
reading a json formatted file or buffer.

Create a json_echo member inside struct nft_ctx to build and store the json object
containing the command objects when --json and --echo are passed to nft.

Fixes: https://bugzilla.netfilter.org/show_bug.cgi?id=1446

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 include/nftables.h |  1 +
 src/json.c         | 13 ++++++++++---
 src/monitor.c      | 24 ++++++++++++++++--------
 src/parser_json.c  | 12 ++++++++----
 4 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index 3556728d..9095ff3d 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -122,6 +122,7 @@ struct nft_ctx {
 	void			*scanner;
 	struct scope		*top_scope;
 	void			*json_root;
+	json_t			*json_echo;
 };
 
 enum nftables_exit_codes {
diff --git a/src/json.c b/src/json.c
index 888cb371..ffe0e57d 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1857,9 +1857,16 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
 static void monitor_print_json(struct netlink_mon_handler *monh,
 			       const char *cmd, json_t *obj)
 {
-	obj = json_pack("{s:o}", cmd, obj);
-	json_dumpf(obj, monh->ctx->nft->output.output_fp, 0);
-	json_decref(obj);
+	struct nft_ctx *nft = monh->ctx->nft;
+
+	if (nft_output_echo(&nft->output)) {
+		obj = json_pack("{s:o}", cmd, obj);
+		json_array_append_new(nft->json_echo, obj);
+	} else {
+		obj = json_pack("{s:o}", cmd, obj);
+		json_dumpf(obj, monh->ctx->nft->output.output_fp, 0);
+		json_decref(obj);
+	}
 }
 
 void monitor_print_table_json(struct netlink_mon_handler *monh,
diff --git a/src/monitor.c b/src/monitor.c
index 3872ebcf..27406906 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -221,12 +221,12 @@ static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
 		if (nft_output_handle(&monh->ctx->nft->output))
 			nft_mon_print(monh, " # handle %" PRIu64 "",
 				      t->handle.handle.id);
+		nft_mon_print(monh, "\n");
 		break;
 	case NFTNL_OUTPUT_JSON:
 		monitor_print_table_json(monh, cmd, t);
 		break;
 	}
-	nft_mon_print(monh, "\n");
 	table_free(t);
 	nftnl_table_free(nlt);
 	return MNL_CB_OK;
@@ -258,12 +258,12 @@ static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
 				      c->handle.chain.name);
 			break;
 		}
+		nft_mon_print(monh, "\n");
 		break;
 	case NFTNL_OUTPUT_JSON:
 		monitor_print_chain_json(monh, cmd, c);
 		break;
 	}
-	nft_mon_print(monh, "\n");
 	chain_free(c);
 	nftnl_chain_free(nlc);
 	return MNL_CB_OK;
@@ -304,12 +304,12 @@ static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
 				      set->handle.set.name);
 			break;
 		}
+		nft_mon_print(monh, "\n");
 		break;
 	case NFTNL_OUTPUT_JSON:
 		monitor_print_set_json(monh, cmd, set);
 		break;
 	}
-	nft_mon_print(monh, "\n");
 	set_free(set);
 out:
 	nftnl_set_free(nls);
@@ -441,6 +441,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 		nft_mon_print(monh, "%s element %s %s %s ",
 			      cmd, family2str(family), table, setname);
 		expr_print(dummyset->init, &monh->ctx->nft->output);
+		nft_mon_print(monh, "\n");
 		break;
 	case NFTNL_OUTPUT_JSON:
 		dummyset->handle.family = family;
@@ -452,7 +453,6 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 		dummyset->handle.table.name = NULL;
 		break;
 	}
-	nft_mon_print(monh, "\n");
 	set_free(dummyset);
 out:
 	nftnl_set_free(nls);
@@ -492,12 +492,12 @@ static int netlink_events_obj_cb(const struct nlmsghdr *nlh, int type,
 			       obj->handle.obj.name);
 			break;
 		}
+		nft_mon_print(monh, "\n");
 		break;
 	case NFTNL_OUTPUT_JSON:
 		monitor_print_obj_json(monh, cmd, obj);
 		break;
 	}
-	nft_mon_print(monh, "\n");
 	obj_free(obj);
 	nftnl_obj_free(nlo);
 	return MNL_CB_OK;
@@ -542,12 +542,12 @@ static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 				      r->handle.handle.id);
 			break;
 		}
+		nft_mon_print(monh, "\n");
 		break;
 	case NFTNL_OUTPUT_JSON:
 		monitor_print_rule_json(monh, cmd, r);
 		break;
 	}
-	nft_mon_print(monh, "\n");
 	rule_free(r);
 	nftnl_rule_free(nlr);
 	return MNL_CB_OK;
@@ -912,6 +912,8 @@ int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
 {
 	struct netlink_cb_data *nl_cb_data = data;
 	struct netlink_ctx *ctx = nl_cb_data->nl_ctx;
+	struct nft_ctx *nft = ctx->nft;
+
 	struct netlink_mon_handler echo_monh = {
 		.format = NFTNL_OUTPUT_DEFAULT,
 		.ctx = ctx,
@@ -922,8 +924,14 @@ int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
 	if (!nft_output_echo(&echo_monh.ctx->nft->output))
 		return MNL_CB_OK;
 
-	if (nft_output_json(&ctx->nft->output))
-		return json_events_cb(nlh, &echo_monh);
+	if (nft_output_json(&nft->output)) {
+		if (!nft->json_echo) {
+			nft->json_echo = json_array();
+			if (!nft->json_echo)
+				memory_allocation_error();
+		}
+		echo_monh.format = NFTNL_OUTPUT_JSON;
+	}
 
 	return netlink_events_cb(nlh, &echo_monh);
 }
diff --git a/src/parser_json.c b/src/parser_json.c
index 59347168..237b6f3e 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3884,11 +3884,15 @@ int json_events_cb(const struct nlmsghdr *nlh, struct netlink_mon_handler *monh)
 
 void json_print_echo(struct nft_ctx *ctx)
 {
-	if (!ctx->json_root)
+	if (!ctx->json_echo)
 		return;
 
-	json_dumpf(ctx->json_root, ctx->output.output_fp, JSON_PRESERVE_ORDER);
+	ctx->json_echo = json_pack("{s:o}", "nftables", ctx->json_echo);
+	json_dumpf(ctx->json_echo, ctx->output.output_fp, JSON_PRESERVE_ORDER);
+	printf("\n");
 	json_cmd_assoc_free();
-	json_decref(ctx->json_root);
-	ctx->json_root = NULL;
+	if (ctx->json_echo) {
+		json_decref(ctx->json_echo);
+		ctx->json_echo = NULL;
+	}
 }
-- 
2.27.0

