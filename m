Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E229C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 15:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235974AbiK2PiC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 10:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235945AbiK2Phv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 10:37:51 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528E0FAE5
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 07:37:46 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p02g4-0007Dj-KJ; Tue, 29 Nov 2022 16:37:44 +0100
Date:   Tue, 29 Nov 2022 16:37:44 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 iptables-nft 1/3] xlate: get rid of escape_quotes
Message-ID: <Y4YnSH99kWqtHGeI@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20221129140542.28311-1-fw@strlen.de>
 <20221129140542.28311-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129140542.28311-2-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 29, 2022 at 03:05:40PM +0100, Florian Westphal wrote:
[...]
> diff --git a/extensions/libxt_LOG.c b/extensions/libxt_LOG.c
> index e3f4290ba003..b6fe0b2edda1 100644
> --- a/extensions/libxt_LOG.c
> +++ b/extensions/libxt_LOG.c
> @@ -151,12 +151,8 @@ static int LOG_xlate(struct xt_xlate *xl,
>  	const char *pname = priority2name(loginfo->level);
>  
>  	xt_xlate_add(xl, "log");
> -	if (strcmp(loginfo->prefix, "") != 0) {
> -		if (params->escape_quotes)
> -			xt_xlate_add(xl, " prefix \\\"%s\\\"", loginfo->prefix);
> -		else
> -			xt_xlate_add(xl, " prefix \"%s\"", loginfo->prefix);
> -	}
> +	if (strcmp(loginfo->prefix, "") != 0)
> +		xt_xlate_add(xl, " prefix \"%s\"", loginfo->prefix);

Use the occasion and replace the strcmp() call with a check for first
array elem?

>  	if (loginfo->level != LOG_DEFAULT_LEVEL && pname)
>  		xt_xlate_add(xl, " level %s", pname);
> diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
> index 7a12e5aca40f..d12ef044f0ed 100644
> --- a/extensions/libxt_NFLOG.c
> +++ b/extensions/libxt_NFLOG.c
> @@ -112,16 +112,12 @@ static void NFLOG_save(const void *ip, const struct xt_entry_target *target)
>  }
>  
>  static void nflog_print_xlate(const struct xt_nflog_info *info,
> -			      struct xt_xlate *xl, bool escape_quotes)
> +			      struct xt_xlate *xl)
>  {
>  	xt_xlate_add(xl, "log ");
> -	if (info->prefix[0] != '\0') {
> -		if (escape_quotes)
> -			xt_xlate_add(xl, "prefix \\\"%s\\\" ", info->prefix);
> -		else
> -			xt_xlate_add(xl, "prefix \"%s\" ", info->prefix);
> +	if (info->prefix[0] != '\0')
> +		xt_xlate_add(xl, "prefix \"%s\" ", info->prefix);
>  
> -	}
>  	if (info->flags & XT_NFLOG_F_COPY_LEN)
>  		xt_xlate_add(xl, "snaplen %u ", info->len);
>  	if (info->threshold != XT_NFLOG_DEFAULT_THRESHOLD)
> @@ -135,7 +131,7 @@ static int NFLOG_xlate(struct xt_xlate *xl,
>  	const struct xt_nflog_info *info =
>  		(struct xt_nflog_info *)params->target->data;
>  
> -	nflog_print_xlate(info, xl, params->escape_quotes);
> +	nflog_print_xlate(info, xl);
>  
>  	return 1;
>  }
> diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
> index 69795b6c6ed5..e9c539f68ff3 100644
> --- a/extensions/libxt_comment.c
> +++ b/extensions/libxt_comment.c
> @@ -55,12 +55,7 @@ static int comment_xlate(struct xt_xlate *xl,
>  	char comment[XT_MAX_COMMENT_LEN + sizeof("\\\"\\\"")];
>  
>  	commentinfo->comment[XT_MAX_COMMENT_LEN - 1] = '\0';
> -	if (params->escape_quotes)
> -		snprintf(comment, sizeof(comment), "\\\"%s\\\"",
> -			 commentinfo->comment);
> -	else
> -		snprintf(comment, sizeof(comment), "\"%s\"",
> -			 commentinfo->comment);
> +	snprintf(comment, sizeof(comment), "\"%s\"", commentinfo->comment);
>  
>  	xt_xlate_add_comment(xl, comment);
>  
> diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
> index 2afbf996a699..0f72eec68264 100644
> --- a/extensions/libxt_helper.c
> +++ b/extensions/libxt_helper.c
> @@ -50,12 +50,8 @@ static int helper_xlate(struct xt_xlate *xl,
>  {
>  	const struct xt_helper_info *info = (const void *)params->match->data;
>  
> -	if (params->escape_quotes)
> -		xt_xlate_add(xl, "ct helper%s \\\"%s\\\"",
> -			   info->invert ? " !=" : "", info->name);
> -	else
> -		xt_xlate_add(xl, "ct helper%s \"%s\"",
> -			   info->invert ? " !=" : "", info->name);
> +	xt_xlate_add(xl, "ct helper%s \"%s\"",
> +		     info->invert ? " !=" : "", info->name);
>  
>  	return 1;
>  }
> diff --git a/include/xtables.h b/include/xtables.h
> index dad1949e5537..4ffc8ec5a17e 100644
> --- a/include/xtables.h
> +++ b/include/xtables.h
> @@ -211,14 +211,14 @@ struct xt_xlate_mt_params {
>  	const void			*ip;
>  	const struct xt_entry_match	*match;
>  	int				numeric;
> -	bool				escape_quotes;
> +	bool				escape_quotes;	/* not used anymore, retained for ABI */
>  };
>  
>  struct xt_xlate_tg_params {
>  	const void			*ip;
>  	const struct xt_entry_target	*target;
>  	int				numeric;
> -	bool				escape_quotes;
> +	bool				escape_quotes; /* not used anymore, retained for ABI */
>  };

We *could* rename the variable to intentionally break API so people
notice. OTOH, escape_quotes will always be false which is exactly what
we need.

[...]
> diff --git a/iptables/xtables-eb-translate.c b/iptables/xtables-eb-translate.c
> index f09883cd518c..7378c32b67bc 100644
> --- a/iptables/xtables-eb-translate.c
> +++ b/iptables/xtables-eb-translate.c
> @@ -156,17 +156,17 @@ static int nft_rule_eb_xlate_add(struct nft_handle *h, const struct xt_cmd_parse
>  				 const struct iptables_command_state *cs, bool append)
>  {
>  	struct xt_xlate *xl = xt_xlate_alloc(10240);
> +	const char *tick = cs->restore ? "" : "\'";

No need to escape the tick.

Apart from that, LGTM!

Thanks, Phil
