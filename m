Return-Path: <SRS0=6lPY=BO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 561F2C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 10:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FFA220656
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 10:42:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="cgHhh7/+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbgHDKmM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Aug 2020 06:42:12 -0400
Received: from mx1.riseup.net ([198.252.153.129]:48488 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728170AbgHDKmK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Aug 2020 06:42:10 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4BLWXf39V4zFcrM;
        Tue,  4 Aug 2020 03:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1596537730; bh=DgoZv5hfx1JVahRot4ydYMMHYmL2zqAZwj1RZ+NLZHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cgHhh7/++4wUoOF64MB8r43s/KyasKRW/zokqOV/EzWXBZvq3EmMdg8v30T6gD1O8
         IuaseLCPnD/mKApsg9anRRdxnifUIZWpz6FuWsQ0RYWhReBYzuIzs5cxJ6fh24LVrR
         saJpif9cKOfBQ4QQANrxZIGBypV+zXrpwwAQDrXA=
X-Riseup-User-ID: 56B75B09631926997061D712DDF05EB46FFE5B86225BC3F6FFD666E834F0E623
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4BLWXd1wrTz8ty4;
        Tue,  4 Aug 2020 03:42:09 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, erig@erig.me, phil@nwl.cc
Subject: [PATCH nft v4] src: enable json echo output when reading native syntax
Date:   Tue,  4 Aug 2020 12:38:46 +0200
Message-Id: <20200804103846.58872-1-guigom@riseup.net>
In-Reply-To: <20200731104944.21384-1-guigom@riseup.net>
References: <20200731104944.21384-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch fixes a bug in which nft did not print any output when
specifying --echo and --json and reading nft native syntax.

This patch respects behavior when input is json, in which the output
would be the identical input plus the handles.

Adds a json_echo member inside struct nft_ctx to build and store the json object
containing the json command objects, the object is built using a mock
monitor to reuse monitor json code. This json object is only used when
we are sure we have not read json from input.

Fixes: https://bugzilla.netfilter.org/show_bug.cgi?id=1446

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
v4 respects previous behavior for json echo when reading json input too

 include/nftables.h |  1 +
 src/json.c         | 13 ++++++++++---
 src/monitor.c      | 37 +++++++++++++++++++++++++++++--------
 src/parser_json.c  | 24 +++++++++++++++++-------
 4 files changed, 57 insertions(+), 18 deletions(-)

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
index 888cb371..44b3b042 100644
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
+	if (nft_output_echo(&nft->output) && !nft->json_root) {
+		obj = json_pack("{s:o}", cmd, obj);
+		json_array_append_new(nft->json_echo, obj);
+	} else {
+		obj = json_pack("{s:o}", cmd, obj);
+		json_dumpf(obj, nft->output.output_fp, 0);
+		json_decref(obj);
+	}
 }
 
 void monitor_print_table_json(struct netlink_mon_handler *monh,
diff --git a/src/monitor.c b/src/monitor.c
index 3872ebcf..868e31b5 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -221,12 +221,14 @@ static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
 		if (nft_output_handle(&monh->ctx->nft->output))
 			nft_mon_print(monh, " # handle %" PRIu64 "",
 				      t->handle.handle.id);
+		nft_mon_print(monh, "\n");
 		break;
 	case NFTNL_OUTPUT_JSON:
 		monitor_print_table_json(monh, cmd, t);
+		if(!nft_output_echo(&monh->ctx->nft->output))
+			nft_mon_print(monh, "\n");
 		break;
 	}
-	nft_mon_print(monh, "\n");
 	table_free(t);
 	nftnl_table_free(nlt);
 	return MNL_CB_OK;
@@ -258,12 +260,14 @@ static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
 				      c->handle.chain.name);
 			break;
 		}
+		nft_mon_print(monh, "\n");
 		break;
 	case NFTNL_OUTPUT_JSON:
 		monitor_print_chain_json(monh, cmd, c);
+		if(!nft_output_echo(&monh->ctx->nft->output))
+			nft_mon_print(monh, "\n");
 		break;
 	}
-	nft_mon_print(monh, "\n");
 	chain_free(c);
 	nftnl_chain_free(nlc);
 	return MNL_CB_OK;
@@ -304,12 +308,14 @@ static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
 				      set->handle.set.name);
 			break;
 		}
+		nft_mon_print(monh, "\n");
 		break;
 	case NFTNL_OUTPUT_JSON:
 		monitor_print_set_json(monh, cmd, set);
+		if(!nft_output_echo(&monh->ctx->nft->output))
+			nft_mon_print(monh, "\n");
 		break;
 	}
-	nft_mon_print(monh, "\n");
 	set_free(set);
 out:
 	nftnl_set_free(nls);
@@ -441,6 +447,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 		nft_mon_print(monh, "%s element %s %s %s ",
 			      cmd, family2str(family), table, setname);
 		expr_print(dummyset->init, &monh->ctx->nft->output);
+		nft_mon_print(monh, "\n");
 		break;
 	case NFTNL_OUTPUT_JSON:
 		dummyset->handle.family = family;
@@ -450,9 +457,10 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 		/* prevent set_free() from trying to free those */
 		dummyset->handle.set.name = NULL;
 		dummyset->handle.table.name = NULL;
+		if(!nft_output_echo(&monh->ctx->nft->output))
+			nft_mon_print(monh, "\n");
 		break;
 	}
-	nft_mon_print(monh, "\n");
 	set_free(dummyset);
 out:
 	nftnl_set_free(nls);
@@ -492,12 +500,14 @@ static int netlink_events_obj_cb(const struct nlmsghdr *nlh, int type,
 			       obj->handle.obj.name);
 			break;
 		}
+		nft_mon_print(monh, "\n");
 		break;
 	case NFTNL_OUTPUT_JSON:
 		monitor_print_obj_json(monh, cmd, obj);
+		if(!nft_output_echo(&monh->ctx->nft->output))
+			nft_mon_print(monh, "\n");
 		break;
 	}
-	nft_mon_print(monh, "\n");
 	obj_free(obj);
 	nftnl_obj_free(nlo);
 	return MNL_CB_OK;
@@ -542,12 +552,14 @@ static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 				      r->handle.handle.id);
 			break;
 		}
+		nft_mon_print(monh, "\n");
 		break;
 	case NFTNL_OUTPUT_JSON:
 		monitor_print_rule_json(monh, cmd, r);
+		if(!nft_output_echo(&monh->ctx->nft->output))
+			nft_mon_print(monh, "\n");
 		break;
 	}
-	nft_mon_print(monh, "\n");
 	rule_free(r);
 	nftnl_rule_free(nlr);
 	return MNL_CB_OK;
@@ -912,6 +924,8 @@ int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
 {
 	struct netlink_cb_data *nl_cb_data = data;
 	struct netlink_ctx *ctx = nl_cb_data->nl_ctx;
+	struct nft_ctx *nft = ctx->nft;
+
 	struct netlink_mon_handler echo_monh = {
 		.format = NFTNL_OUTPUT_DEFAULT,
 		.ctx = ctx,
@@ -922,8 +936,15 @@ int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
 	if (!nft_output_echo(&echo_monh.ctx->nft->output))
 		return MNL_CB_OK;
 
-	if (nft_output_json(&ctx->nft->output))
-		return json_events_cb(nlh, &echo_monh);
+	if (nft_output_json(&nft->output)) {
+		if (!nft->json_root) {
+			nft->json_echo = json_array();
+			if (!nft->json_echo)
+				memory_allocation_error();
+			echo_monh.format = NFTNL_OUTPUT_JSON;
+		} else
+			return json_events_cb(nlh, &echo_monh);
+	}
 
 	return netlink_events_cb(nlh, &echo_monh);
 }
diff --git a/src/parser_json.c b/src/parser_json.c
index 59347168..ef33063d 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3884,11 +3884,21 @@ int json_events_cb(const struct nlmsghdr *nlh, struct netlink_mon_handler *monh)
 
 void json_print_echo(struct nft_ctx *ctx)
 {
-	if (!ctx->json_root)
-		return;
-
-	json_dumpf(ctx->json_root, ctx->output.output_fp, JSON_PRESERVE_ORDER);
-	json_cmd_assoc_free();
-	json_decref(ctx->json_root);
-	ctx->json_root = NULL;
+	if (!ctx->json_root) {
+		if (!ctx->json_echo)
+			return;
+		else {
+			ctx->json_echo = json_pack("{s:o}", "nftables", ctx->json_echo);
+			json_dumpf(ctx->json_echo, ctx->output.output_fp, JSON_PRESERVE_ORDER);
+			json_decref(ctx->json_echo);
+			ctx->json_echo = NULL;
+			fprintf(ctx->output.output_fp, "\n");
+			fflush(ctx->output.output_fp);
+		}
+	} else {
+		json_dumpf(ctx->json_root, ctx->output.output_fp, JSON_PRESERVE_ORDER);
+		json_cmd_assoc_free();
+		json_decref(ctx->json_root);
+		ctx->json_root = NULL;
+	}
 }
-- 
2.27.0

