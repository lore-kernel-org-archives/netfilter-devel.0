Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1565E7E650
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Sep 2023 16:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjIZQzp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Sep 2023 12:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235208AbjIZQzo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2023 12:55:44 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AAE9DE
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2023 09:55:37 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qlBLT-0005No-B2; Tue, 26 Sep 2023 18:55:35 +0200
Date:   Tue, 26 Sep 2023 18:55:35 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 3/3,v2] netlink_linearize: skip set element
 expression in map statement key
Message-ID: <ZRMNB+3/4rzYb08p@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230926160216.152549-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230926160216.152549-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 26, 2023 at 06:02:16PM +0200, Pablo Neira Ayuso wrote:
[...]
> diff --git a/src/parser_json.c b/src/parser_json.c
> index 16961d6013af..78895befbc6c 100644
> --- a/src/parser_json.c
> +++ b/src/parser_json.c
> @@ -2416,6 +2416,63 @@ static struct stmt *json_parse_set_stmt(struct json_ctx *ctx,
>  	return stmt;
>  }
>  
> +static struct stmt *json_parse_map_stmt(struct json_ctx *ctx,
> +					const char *key, json_t *value)
> +{
> +	struct expr *expr, *expr2, *expr_data;
> +	json_t *elem, *data, *stmt_json;
> +	const char *opstr, *set;
> +	struct stmt *stmt;
> +	int op;
> +
> +	if (json_unpack_err(ctx, value, "{s:s, s:o, s:o, s:s}",
> +			    "op", &opstr, "elem", &elem, "data", &data, "map", &set))
> +		return NULL;
> +
> +	if (!strcmp(opstr, "add")) {
> +		op = NFT_DYNSET_OP_ADD;
> +	} else if (!strcmp(opstr, "update")) {
> +		op = NFT_DYNSET_OP_UPDATE;
> +	} else if (!strcmp(opstr, "delete")) {
> +		op = NFT_DYNSET_OP_DELETE;
> +	} else {
> +		json_error(ctx, "Unknown set statement op '%s'.", opstr);

s/set/map/

> +		return NULL;
> +	}
> +
> +	expr = json_parse_set_elem_expr_stmt(ctx, elem);
> +	if (!expr) {
> +		json_error(ctx, "Illegal set statement element.");

s/set/map/

> +		return NULL;
> +	}
> +
> +	expr_data = json_parse_set_elem_expr_stmt(ctx, data);
> +	if (!expr_data) {
> +		json_error(ctx, "Illegal map expression data.");
> +		expr_free(expr);
> +		return NULL;
> +	}
> +
> +	if (set[0] != '@') {
> +		json_error(ctx, "Illegal set reference in set statement.");

s/set/map/g

Cheers, Phil
