Return-Path: <SRS0=6lPY=BO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8600C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 11:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFB022075D
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 11:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730221AbgHDLRX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Aug 2020 07:17:23 -0400
Received: from correo.us.es ([193.147.175.20]:50478 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728880AbgHDLQ4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Aug 2020 07:16:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7DED9F2DE8
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 13:05:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 69CC4DA78D
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 13:05:59 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5F4CCDA73D; Tue,  4 Aug 2020 13:05:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8DA9BDA73F;
        Tue,  4 Aug 2020 13:05:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 04 Aug 2020 13:05:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [213.143.49.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 17F0342EE38E;
        Tue,  4 Aug 2020 13:05:55 +0200 (CEST)
Date:   Tue, 4 Aug 2020 13:05:52 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Jose M. Guisado Gomez" <guigom@riseup.net>
Cc:     netfilter-devel@vger.kernel.org, erig@erig.me, phil@nwl.cc
Subject: Re: [PATCH nft v4] src: enable json echo output when reading native
 syntax
Message-ID: <20200804110552.GA18345@salvia>
References: <20200731104944.21384-1-guigom@riseup.net>
 <20200804103846.58872-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804103846.58872-1-guigom@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 04, 2020 at 12:38:46PM +0200, Jose M. Guisado Gomez wrote:
> This patch fixes a bug in which nft did not print any output when
> specifying --echo and --json and reading nft native syntax.
> 
> This patch respects behavior when input is json, in which the output
> would be the identical input plus the handles.
> 
> Adds a json_echo member inside struct nft_ctx to build and store the json object
> containing the json command objects, the object is built using a mock
> monitor to reuse monitor json code. This json object is only used when
> we are sure we have not read json from input.
> 
> Fixes: https://bugzilla.netfilter.org/show_bug.cgi?id=1446
> 
> Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
[...]
> diff --git a/src/monitor.c b/src/monitor.c
> index 3872ebcf..868e31b5 100644
> --- a/src/monitor.c
> +++ b/src/monitor.c
> @@ -221,12 +221,14 @@ static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
>  		if (nft_output_handle(&monh->ctx->nft->output))
>  			nft_mon_print(monh, " # handle %" PRIu64 "",
>  				      t->handle.handle.id);
> +		nft_mon_print(monh, "\n");
>  		break;
>  	case NFTNL_OUTPUT_JSON:
>  		monitor_print_table_json(monh, cmd, t);
> +		if(!nft_output_echo(&monh->ctx->nft->output))
> +			nft_mon_print(monh, "\n");
>  		break;
>  	}
> -	nft_mon_print(monh, "\n");
>  	table_free(t);
>  	nftnl_table_free(nlt);
>  	return MNL_CB_OK;
> @@ -258,12 +260,14 @@ static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
>  				      c->handle.chain.name);
>  			break;
>  		}
> +		nft_mon_print(monh, "\n");
>  		break;
>  	case NFTNL_OUTPUT_JSON:
>  		monitor_print_chain_json(monh, cmd, c);
> +		if(!nft_output_echo(&monh->ctx->nft->output))
> +			nft_mon_print(monh, "\n");
>  		break;
>  	}
> -	nft_mon_print(monh, "\n");
>  	chain_free(c);
>  	nftnl_chain_free(nlc);
>  	return MNL_CB_OK;
> @@ -304,12 +308,14 @@ static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
>  				      set->handle.set.name);
>  			break;
>  		}
> +		nft_mon_print(monh, "\n");
>  		break;
>  	case NFTNL_OUTPUT_JSON:
>  		monitor_print_set_json(monh, cmd, set);
> +		if(!nft_output_echo(&monh->ctx->nft->output))
> +			nft_mon_print(monh, "\n");
>  		break;
>  	}
> -	nft_mon_print(monh, "\n");
>  	set_free(set);
>  out:
>  	nftnl_set_free(nls);
> @@ -441,6 +447,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
>  		nft_mon_print(monh, "%s element %s %s %s ",
>  			      cmd, family2str(family), table, setname);
>  		expr_print(dummyset->init, &monh->ctx->nft->output);
> +		nft_mon_print(monh, "\n");
>  		break;
>  	case NFTNL_OUTPUT_JSON:
>  		dummyset->handle.family = family;
> @@ -450,9 +457,10 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
>  		/* prevent set_free() from trying to free those */
>  		dummyset->handle.set.name = NULL;
>  		dummyset->handle.table.name = NULL;
> +		if(!nft_output_echo(&monh->ctx->nft->output))
                  ^
nitpick: 'if' is not a function, add space between if and parens.

> +			nft_mon_print(monh, "\n");
>  		break;
>  	}
> -	nft_mon_print(monh, "\n");
>  	set_free(dummyset);
>  out:
>  	nftnl_set_free(nls);
> @@ -492,12 +500,14 @@ static int netlink_events_obj_cb(const struct nlmsghdr *nlh, int type,
>  			       obj->handle.obj.name);
>  			break;
>  		}
> +		nft_mon_print(monh, "\n");
>  		break;
>  	case NFTNL_OUTPUT_JSON:
>  		monitor_print_obj_json(monh, cmd, obj);
> +		if(!nft_output_echo(&monh->ctx->nft->output))
                  ^
same here and everywhere else.

> +			nft_mon_print(monh, "\n");
>  		break;
>  	}
> -	nft_mon_print(monh, "\n");
>  	obj_free(obj);
>  	nftnl_obj_free(nlo);
>  	return MNL_CB_OK;
> @@ -542,12 +552,14 @@ static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
>  				      r->handle.handle.id);
>  			break;
>  		}
> +		nft_mon_print(monh, "\n");
>  		break;
>  	case NFTNL_OUTPUT_JSON:
>  		monitor_print_rule_json(monh, cmd, r);
> +		if(!nft_output_echo(&monh->ctx->nft->output))
> +			nft_mon_print(monh, "\n");
>  		break;
>  	}
> -	nft_mon_print(monh, "\n");
>  	rule_free(r);
>  	nftnl_rule_free(nlr);
>  	return MNL_CB_OK;
> @@ -912,6 +924,8 @@ int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
>  {
>  	struct netlink_cb_data *nl_cb_data = data;
>  	struct netlink_ctx *ctx = nl_cb_data->nl_ctx;
> +	struct nft_ctx *nft = ctx->nft;
> +
>  	struct netlink_mon_handler echo_monh = {
>  		.format = NFTNL_OUTPUT_DEFAULT,
>  		.ctx = ctx,
> @@ -922,8 +936,15 @@ int netlink_echo_callback(const struct nlmsghdr *nlh, void *data)
>  	if (!nft_output_echo(&echo_monh.ctx->nft->output))
>  		return MNL_CB_OK;
>  
> -	if (nft_output_json(&ctx->nft->output))
> -		return json_events_cb(nlh, &echo_monh);
> +	if (nft_output_json(&nft->output)) {
> +		if (!nft->json_root) {
> +			nft->json_echo = json_array();
> +			if (!nft->json_echo)
> +				memory_allocation_error();
> +			echo_monh.format = NFTNL_OUTPUT_JSON;
> +		} else

Nitpick: Use curly brace '{' here in the else side of the branch for
consistency (even if it's only on single line).

> +			return json_events_cb(nlh, &echo_monh);
> +	}
>  
>  	return netlink_events_cb(nlh, &echo_monh);
>  }
> diff --git a/src/parser_json.c b/src/parser_json.c
> index 59347168..ef33063d 100644
> --- a/src/parser_json.c
> +++ b/src/parser_json.c
> @@ -3884,11 +3884,21 @@ int json_events_cb(const struct nlmsghdr *nlh, struct netlink_mon_handler *monh)
>  
>  void json_print_echo(struct nft_ctx *ctx)
>  {
> -	if (!ctx->json_root)
> -		return;
> -
> -	json_dumpf(ctx->json_root, ctx->output.output_fp, JSON_PRESERVE_ORDER);
> -	json_cmd_assoc_free();
> -	json_decref(ctx->json_root);
> -	ctx->json_root = NULL;
> +	if (!ctx->json_root) {
> +		if (!ctx->json_echo)
> +			return;
> +		else {
> +			ctx->json_echo = json_pack("{s:o}", "nftables", ctx->json_echo);
> +			json_dumpf(ctx->json_echo, ctx->output.output_fp, JSON_PRESERVE_ORDER);
> +			json_decref(ctx->json_echo);
> +			ctx->json_echo = NULL;
> +			fprintf(ctx->output.output_fp, "\n");
> +			fflush(ctx->output.output_fp);
> +		}
> +	} else {
> +		json_dumpf(ctx->json_root, ctx->output.output_fp, JSON_PRESERVE_ORDER);
> +		json_cmd_assoc_free();
> +		json_decref(ctx->json_root);
> +		ctx->json_root = NULL;
> +	}

I'd suggest:

void json_print_echo(struct nft_ctx *ctx)
{
	if (!ctx->json_root)
                return;

        if (ctx->json_echo) {
		ctx->json_echo = json_pack("{s:o}", "nftables", ctx->json_echo);
		json_dumpf(ctx->json_echo, ctx->output.output_fp, JSON_PRESERVE_ORDER);
		json_decref(ctx->json_echo);
		ctx->json_echo = NULL;
		fprintf(ctx->output.output_fp, "\n");
		fflush(ctx->output.output_fp);
	} else {
		json_dumpf(ctx->json_root, ctx->output.output_fp, JSON_PRESERVE_ORDER);
		json_cmd_assoc_free();
		json_decref(ctx->json_root);
		ctx->json_root = NULL;
	}
}

Thanks.
