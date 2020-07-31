Return-Path: <SRS0=oAJK=BK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4004DC433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 10:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 024E020838
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 10:50:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="HmxJx7kf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732743AbgGaKu2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jul 2020 06:50:28 -0400
Received: from mx1.riseup.net ([198.252.153.129]:56930 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729141AbgGaKu2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jul 2020 06:50:28 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4BJ3vz09b1zFgrD
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 03:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1596192627; bh=s3XDgYrgoFseuZtX7P2qwKMPXvc/llA2rDlA/rh1Drw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=HmxJx7kf89CufsE+e/Vu2nqhTH27uipOm6eYJ6LvBfnm84OoVguqiEyQJGlsGndkN
         pd0EStQUMZ3DDdrIOGNRKef0LlvHhpXmQpBLnD9r08Ndq6YVa8FP3bkrTEL9apq1NK
         boQCdsKOIwA7qj4n4X4q5y08aakI7C8CfebGIJ+0=
X-Riseup-User-ID: D4E725CD7FF66750111CC062F72050E73A25F90DA44B2E59501824927FFF9765
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4BJ3vy2rxnzJnq5
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 03:50:22 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft v3] src: enable output with "nft --echo --json" and nftables syntax
Date:   Fri, 31 Jul 2020 12:49:44 +0200
Message-Id: <20200731104944.21384-1-guigom@riseup.net>
In-Reply-To: <20200731092212.GA1850@salvia>
References: <20200731092212.GA1850@salvia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch fixes a bug in which nft did not print any output when
specifying --echo and --json and reading nftables syntax.
This was because struct nft_ctx member json_root was only inizialized when
reading a json formatted file or buffer.

Create a json_echo member inside struct nft_ctx to build and store the json object
containing the json command objects when --json and --echo are passed to nft.

Removes cmd json assoc code which is no longer used at this point.

Fixes: https://bugzilla.netfilter.org/show_bug.cgi?id=1446

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
Adds proposed changes on top of v2

 include/nftables.h |   1 +
 src/json.c         |  13 +++-
 src/monitor.c      |  36 ++++++++---
 src/parser_json.c  | 152 +++------------------------------------------
 4 files changed, 49 insertions(+), 153 deletions(-)

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
index 3872ebcf..ea901c53 100644
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
@@ -922,8 +936,14 @@ int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
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
index 59347168..2453ac05 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3645,46 +3645,6 @@ static int json_verify_metainfo(struct json_ctx *ctx, json_t *root)
 	return 0;
 }
 
-struct json_cmd_assoc {
-	struct json_cmd_assoc *next;
-	const struct cmd *cmd;
-	json_t *json;
-};
-
-static struct json_cmd_assoc *json_cmd_list = NULL;
-
-static void json_cmd_assoc_free(void)
-{
-	struct json_cmd_assoc *cur;
-
-	while (json_cmd_list) {
-		cur = json_cmd_list;
-		json_cmd_list = cur->next;
-		free(cur);
-	}
-}
-
-static void json_cmd_assoc_add(json_t *json, const struct cmd *cmd)
-{
-	struct json_cmd_assoc *new = xzalloc(sizeof *new);
-
-	new->next	= json_cmd_list;
-	new->json	= json;
-	new->cmd	= cmd;
-	json_cmd_list	= new;
-}
-
-static json_t *seqnum_to_json(const uint32_t seqnum)
-{
-	const struct json_cmd_assoc *cur;
-
-	for (cur = json_cmd_list; cur; cur = cur->next) {
-		if (cur->cmd->seqnum == seqnum)
-			return cur->json;
-	}
-	return NULL;
-}
-
 static int __json_parse(struct json_ctx *ctx)
 {
 	json_t *tmp, *value;
@@ -3729,9 +3689,6 @@ static int __json_parse(struct json_ctx *ctx)
 		list_add_tail(&cmd->list, &list);
 
 		list_splice_tail(&list, ctx->cmds);
-
-		if (nft_output_echo(&ctx->nft->output))
-			json_cmd_assoc_add(value, cmd);
 	}
 
 	return 0;
@@ -3757,10 +3714,9 @@ int nft_parse_json_buffer(struct nft_ctx *nft, const char *buf,
 
 	ret = __json_parse(&ctx);
 
-	if (!nft_output_echo(&nft->output)) {
-		json_decref(nft->json_root);
-		nft->json_root = NULL;
-	}
+	json_decref(nft->json_root);
+	nft->json_root = NULL;
+
 	return ret;
 }
 
@@ -3792,103 +3748,15 @@ int nft_parse_json_filename(struct nft_ctx *nft, const char *filename,
 	return ret;
 }
 
-static int json_echo_error(struct netlink_mon_handler *monh,
-			   const char *fmt, ...)
-{
-	struct error_record *erec;
-	va_list ap;
-
-	va_start(ap, fmt);
-	erec = erec_vcreate(EREC_ERROR, int_loc, fmt, ap);
-	va_end(ap);
-	erec_queue(erec, monh->ctx->msgs);
-
-	return MNL_CB_ERROR;
-}
-
-static uint64_t handle_from_nlmsg(const struct nlmsghdr *nlh)
-{
-	struct nftnl_table *nlt;
-	struct nftnl_chain *nlc;
-	struct nftnl_rule *nlr;
-	struct nftnl_set *nls;
-	struct nftnl_obj *nlo;
-	uint64_t handle = 0;
-	uint32_t flags;
-
-	switch (NFNL_MSG_TYPE(nlh->nlmsg_type)) {
-	case NFT_MSG_NEWTABLE:
-		nlt = netlink_table_alloc(nlh);
-		handle = nftnl_table_get_u64(nlt, NFTNL_TABLE_HANDLE);
-		nftnl_table_free(nlt);
-		break;
-	case NFT_MSG_NEWCHAIN:
-		nlc = netlink_chain_alloc(nlh);
-		handle = nftnl_chain_get_u64(nlc, NFTNL_CHAIN_HANDLE);
-		nftnl_chain_free(nlc);
-		break;
-	case NFT_MSG_NEWRULE:
-		nlr = netlink_rule_alloc(nlh);
-		handle = nftnl_rule_get_u64(nlr, NFTNL_RULE_HANDLE);
-		nftnl_rule_free(nlr);
-		break;
-	case NFT_MSG_NEWSET:
-		nls = netlink_set_alloc(nlh);
-		flags = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
-		if (!set_is_anonymous(flags))
-			handle = nftnl_set_get_u64(nls, NFTNL_SET_HANDLE);
-		nftnl_set_free(nls);
-		break;
-	case NFT_MSG_NEWOBJ:
-		nlo = netlink_obj_alloc(nlh);
-		handle = nftnl_obj_get_u64(nlo, NFTNL_OBJ_HANDLE);
-		nftnl_obj_free(nlo);
-		break;
-	}
-	return handle;
-}
-int json_events_cb(const struct nlmsghdr *nlh, struct netlink_mon_handler *monh)
-{
-	uint64_t handle = handle_from_nlmsg(nlh);
-	json_t *tmp, *json;
-	void *iter;
-
-	if (!handle)
-		return MNL_CB_OK;
-
-	json = seqnum_to_json(nlh->nlmsg_seq);
-	if (!json)
-		return MNL_CB_OK;
-
-	tmp = json_object_get(json, "add");
-	if (!tmp)
-		tmp = json_object_get(json, "insert");
-	if (!tmp)
-		/* assume loading JSON dump */
-		tmp = json;
-
-	iter = json_object_iter(tmp);
-	if (!iter) {
-		json_echo_error(monh, "Empty JSON object in cmd list\n");
-		return MNL_CB_OK;
-	}
-	json = json_object_iter_value(iter);
-	if (!json_is_object(json) || json_object_iter_next(tmp, iter)) {
-		json_echo_error(monh, "Malformed JSON object in cmd list\n");
-		return MNL_CB_OK;
-	}
-
-	json_object_set_new(json, "handle", json_integer(handle));
-	return MNL_CB_OK;
-}
-
 void json_print_echo(struct nft_ctx *ctx)
 {
-	if (!ctx->json_root)
+	if (!ctx->json_echo)
 		return;
 
-	json_dumpf(ctx->json_root, ctx->output.output_fp, JSON_PRESERVE_ORDER);
-	json_cmd_assoc_free();
-	json_decref(ctx->json_root);
-	ctx->json_root = NULL;
+	ctx->json_echo = json_pack("{s:o}", "nftables", ctx->json_echo);
+	json_dumpf(ctx->json_echo, ctx->output.output_fp, JSON_PRESERVE_ORDER);
+	json_decref(ctx->json_echo);
+	ctx->json_echo = NULL;
+	fprintf(ctx->output.output_fp, "\n");
+	fflush(ctx->output.output_fp);
 }
-- 
2.27.0

