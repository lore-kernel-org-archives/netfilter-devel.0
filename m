Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3DCDC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 May 2022 08:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiEXI3f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 May 2022 04:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiEXI3e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 May 2022 04:29:34 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D858368999
        for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2022 01:29:33 -0700 (PDT)
Date:   Tue, 24 May 2022 10:29:28 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Chander Govindarajan <mail@chandergovind.org>
Cc:     netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH] nft: update json output ordering to place rules after
 chains
Message-ID: <YoyXaPQa8JhXToMs@salvia>
References: <1dcae0aa-466d-41bf-b050-9684e4b043cc@chandergovind.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1dcae0aa-466d-41bf-b050-9684e4b043cc@chandergovind.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 23, 2022 at 03:37:11PM +0530, Chander Govindarajan wrote:
> Currently the json output of `nft -j list ruleset` interleaves rules
> with chains
> 
> As reported in this bug,
> https://bugzilla.netfilter.org/show_bug.cgi?id=1580
> the json cannot be fed into `nft -j -f <file>` since rules may
> reference chains that are created later
> 
> Instead create rules after all chains are output

Applied, thanks

> 
> Signed-off-by: ChanderG <mail@chandergovind.org>
> ---
>  src/json.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/src/json.c b/src/json.c
> index 0b7224c2..a525fd1b 100644
> --- a/src/json.c
> +++ b/src/json.c
> @@ -1587,7 +1587,7 @@ json_t *optstrip_stmt_json(const struct stmt *stmt,
> struct output_ctx *octx)
>  static json_t *table_print_json_full(struct netlink_ctx *ctx,
>  				     struct table *table)
>  {
> -	json_t *root = json_array(), *tmp;
> +	json_t *root = json_array(), *rules = json_array(), *tmp;
>  	struct flowtable *flowtable;
>  	struct chain *chain;
>  	struct rule *rule;
> @@ -1617,10 +1617,13 @@ static json_t *table_print_json_full(struct
> netlink_ctx *ctx,
> 
>  		list_for_each_entry(rule, &chain->rules, list) {
>  			tmp = rule_print_json(&ctx->nft->output, rule);
> -			json_array_append_new(root, tmp);
> +			json_array_append_new(rules, tmp);
>  		}
>  	}
> 
> +	json_array_extend(root, rules);
> +	json_decref(rules);
> +
>  	return root;
>  }
> 
> -- 
> 2.27.0
