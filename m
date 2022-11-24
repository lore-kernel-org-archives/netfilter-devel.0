Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 607ECC433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Nov 2022 14:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiKXOGA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Nov 2022 09:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiKXOGA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2022 09:06:00 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC9821E11
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2022 06:05:58 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1oyCrU-0007Xb-Km; Thu, 24 Nov 2022 15:05:56 +0100
Date:   Thu, 24 Nov 2022 15:05:56 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables-nft 1/3] xlate: get rid of escape_quotes
Message-ID: <Y396RKuevTLC7f4+@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20221124134939.8245-1-fw@strlen.de>
 <20221124134939.8245-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124134939.8245-2-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 24, 2022 at 02:49:37PM +0100, Florian Westphal wrote:
> Its not necessary to escape " characters, we can simply
> let xtables-translate print the entire translation/command
> enclosed in '' chracters, i.e. nft 'add rule ...', this also takes
> care of [, { and other special characters that some shells might
> parse otherwise (when copy-pasting translated output).
> 
> This breaks all xlate test cases, fixup in followup patches.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
[...]
> diff --git a/include/xtables.h b/include/xtables.h
> index 9eba4f619d35..150d40bfafd9 100644
> --- a/include/xtables.h
> +++ b/include/xtables.h
> @@ -211,14 +211,12 @@ struct xt_xlate_mt_params {
>  	const void			*ip;
>  	const struct xt_entry_match	*match;
>  	int				numeric;
> -	bool				escape_quotes;
>  };
>  
>  struct xt_xlate_tg_params {
>  	const void			*ip;
>  	const struct xt_entry_target	*target;
>  	int				numeric;
> -	bool				escape_quotes;
>  };

Does this break ABI compatibility?

[...]
> diff --git a/iptables/xtables-eb-translate.c b/iptables/xtables-eb-translate.c
> index f09883cd518c..0cf215b9c6b6 100644
> --- a/iptables/xtables-eb-translate.c
> +++ b/iptables/xtables-eb-translate.c
> @@ -159,15 +159,16 @@ static int nft_rule_eb_xlate_add(struct nft_handle *h, const struct xt_cmd_parse
>  	int ret;
>  
>  	if (append) {
> -		xt_xlate_add(xl, "add rule bridge %s %s ", p->table, p->chain);
> +		xt_xlate_add(xl, "'add rule bridge %s %s ", p->table, p->chain);
>  	} else {
> -		xt_xlate_add(xl, "insert rule bridge %s %s ", p->table, p->chain);
> +		xt_xlate_add(xl, "'insert rule bridge %s %s ", p->table, p->chain);
>  	}
>  
>  	ret = h->ops->xlate(cs, xl);
>  	if (ret)
> -		printf("%s\n", xt_xlate_get(xl));
> +		printf("%s", xt_xlate_get(xl));
>  
> +	puts("'");
>  	xt_xlate_free(xl);
>  	return ret;
>  }

If h->ops->xlate() fails, the code prints "'\n". How about:

| if (ret)
| 	printf("%s'\n", xt_xlate_get(xl));

Or am I missing something?

> diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
> index d1e87f167df7..0589ac229746 100644
> --- a/iptables/xtables-translate.c
> +++ b/iptables/xtables-translate.c
[...]
> @@ -165,13 +163,16 @@ static int nft_rule_xlate_add(struct nft_handle *h,
>  
>  	set = xt_xlate_set_get(xl);
>  	if (set[0]) {
> -		printf("add set %s %s %s\n", family2str[h->family], p->table,
> +		printf("'add set %s %s %s'\n", family2str[h->family], p->table,
>  		       xt_xlate_set_get(xl));

Quoting needs to respect cs->restore value, no? Maybe simpler to
introduce 'const char *tick = cs->restore ? "" : "'";' and just insert
it everywhere needed.

>  		if (!cs->restore && p->command != CMD_NONE)
>  			printf("nft ");
>  	}
>  
> +	if (!cs->restore)
> +		printf("%c", '\'');
> +
>  	if (append) {
>  		printf("add rule %s %s %s ",
>  		       family2str[h->family], p->table, p->chain);
> @@ -179,7 +180,12 @@ static int nft_rule_xlate_add(struct nft_handle *h,
>  		printf("insert rule %s %s %s ",
>  		       family2str[h->family], p->table, p->chain);
>  	}
> -	printf("%s\n", xt_xlate_rule_get(xl));
> +	printf("%s", xt_xlate_rule_get(xl));
> +
> +	if (!cs->restore)
> +		printf("%c", '\'');
> +
> +	puts("");
>  
>  err_out:
>  	xt_xlate_free(xl);

Cheers, Phil
