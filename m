Return-Path: <SRS0=oAJK=BK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E9FC433E3
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 09:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1970622B40
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 09:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732136AbgGaJWV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jul 2020 05:22:21 -0400
Received: from correo.us.es ([193.147.175.20]:57876 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732037AbgGaJWU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jul 2020 05:22:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 80BF3154E85
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 11:22:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6EA69DA792
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 11:22:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 641CBDA78F; Fri, 31 Jul 2020 11:22:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E9857DA73D;
        Fri, 31 Jul 2020 11:22:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 Jul 2020 11:22:12 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CA0AB4265A2F;
        Fri, 31 Jul 2020 11:22:12 +0200 (CEST)
Date:   Fri, 31 Jul 2020 11:22:12 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Jose M. Guisado Gomez" <guigom@riseup.net>
Cc:     netfilter-devel@vger.kernel.org, phil@nwl.cc
Subject: Re: [PATCH nft v2 1/1] src: enable output with "nft --echo --json"
 and nftables syntax
Message-ID: <20200731092212.GA1850@salvia>
References: <20200730195337.3627-1-guigom@riseup.net>
 <20200731000020.4230-2-guigom@riseup.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <20200731000020.4230-2-guigom@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Cc'ing Phil.

On Fri, Jul 31, 2020 at 02:00:22AM +0200, Jose M. Guisado Gomez wrote:
> diff --git a/src/parser_json.c b/src/parser_json.c
> index 59347168..237b6f3e 100644
> --- a/src/parser_json.c
> +++ b/src/parser_json.c
> @@ -3884,11 +3884,15 @@ int json_events_cb(const struct nlmsghdr *nlh, struct netlink_mon_handler *monh)
>
>  void json_print_echo(struct nft_ctx *ctx)
>  {
> -	if (!ctx->json_root)
> +	if (!ctx->json_echo)
>		return;
>
> -	json_dumpf(ctx->json_root, ctx->output.output_fp, JSON_PRESERVE_ORDER);
> +	ctx->json_echo = json_pack("{s:o}", "nftables", ctx->json_echo);
> +	json_dumpf(ctx->json_echo, ctx->output.output_fp, JSON_PRESERVE_ORDER);
> +	printf("\n");
>	json_cmd_assoc_free();
> -	json_decref(ctx->json_root);
> -	ctx->json_root = NULL;
> +	if (ctx->json_echo) {
> +		json_decref(ctx->json_echo);
> +		ctx->json_echo = NULL;
> +	}

I think json_print_echo() should look like this - note I replaced the
printf("\n"); by fprintf. Also remove the if (ctx->json_echo) branch.

void json_print_echo(struct nft_ctx *ctx)
{
	if (!ctx->json_echo)
		return;

	ctx->json_echo = json_pack("{s:o}", "nftables", ctx->json_echo);
	json_dumpf(ctx->json_echo, ctx->output.output_fp, JSON_PRESERVE_ORDER);
	json_decref(ctx->json_echo);
	ctx->json_echo = NULL;
	fprintf(ctx->output.output_fp, "\n");
	fflush(ctx->output.output_fp);
}

Please, include this update. I'm also attaching a patch that you can
squash to your v3 patch.

@Phil, I think the entire assoc code can just go away? Maybe you can also
run firewalld tests to make sure v3 works fine?  IIRC that is a heavy user
of --echo and --json.

Thanks.

--EVF5PPMfhYS0aIcm
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="remove-json-assoc-code.patch"

diff --git a/src/parser_json.c b/src/parser_json.c
index 237b6f3e1732..66539ef5c13b 100644
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
 
@@ -3792,96 +3748,6 @@ int nft_parse_json_filename(struct nft_ctx *nft, const char *filename,
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
 	if (!ctx->json_echo)
@@ -3890,7 +3756,6 @@ void json_print_echo(struct nft_ctx *ctx)
 	ctx->json_echo = json_pack("{s:o}", "nftables", ctx->json_echo);
 	json_dumpf(ctx->json_echo, ctx->output.output_fp, JSON_PRESERVE_ORDER);
 	printf("\n");
-	json_cmd_assoc_free();
 	if (ctx->json_echo) {
 		json_decref(ctx->json_echo);
 		ctx->json_echo = NULL;

--EVF5PPMfhYS0aIcm--
