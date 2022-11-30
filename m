Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86142C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 12:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbiK3MfN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 07:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiK3MfM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 07:35:12 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441D77722C
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 04:35:11 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p0MIu-00022h-Dr; Wed, 30 Nov 2022 13:35:08 +0100
Date:   Wed, 30 Nov 2022 13:35:08 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH v3 iptables-nft 1/3] xlate: get rid of escape_quotes
Message-ID: <Y4dN/NLxE2miZaFZ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
References: <20221130093154.29004-1-fw@strlen.de>
 <20221130093154.29004-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130093154.29004-2-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 30, 2022 at 10:31:52AM +0100, Florian Westphal wrote:
> Its not necessary to escape " characters, we can let xtables-translate
> print the entire translation/command enclosed in '' chracters, i.e. nft
> 'add rule ...', this also takes care of [, { and other special characters
> that some shells might parse otherwise (when copy-pasting translated output).
> 
> The escape_quotes struct member is retained to avoid an ABI breakage.
> 
> This breaks all xlate test cases, fixup in followup patches.
> 
> v3: no need to escape ', replace strcmp(x, "") with x[0] (Phil Sutter)
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  extensions/libebt_log.c         |  8 ++------
>  extensions/libebt_nflog.c       |  8 ++------
>  extensions/libxt_LOG.c          | 10 +++-------
>  extensions/libxt_NFLOG.c        | 12 ++++--------
>  extensions/libxt_comment.c      |  7 +------
>  extensions/libxt_helper.c       |  8 ++------
>  include/xtables.h               |  4 ++--
>  iptables/nft-bridge.c           |  2 --
>  iptables/xtables-eb-translate.c | 12 ++++++------
>  iptables/xtables-translate.c    | 22 ++++++++++------------
>  10 files changed, 32 insertions(+), 61 deletions(-)
> 
> diff --git a/extensions/libebt_log.c b/extensions/libebt_log.c
> index 13c7fafecb11..045062196d20 100644
> --- a/extensions/libebt_log.c
> +++ b/extensions/libebt_log.c
> @@ -181,12 +181,8 @@ static int brlog_xlate(struct xt_xlate *xl,
>  	const struct ebt_log_info *loginfo = (const void *)params->target->data;
>  
>  	xt_xlate_add(xl, "log");
> -	if (loginfo->prefix[0]) {
> -		if (params->escape_quotes)
> -			xt_xlate_add(xl, " prefix \\\"%s\\\"", loginfo->prefix);
> -		else
> -			xt_xlate_add(xl, " prefix \"%s\"", loginfo->prefix);
> -	}
> +	if (loginfo->prefix[0])
> +		xt_xlate_add(xl, " prefix \"%s\"", loginfo->prefix);
>  
>  	if (loginfo->loglevel != LOG_DEFAULT_LEVEL)
>  		xt_xlate_add(xl, " level %s", eight_priority[loginfo->loglevel].c_name);
> diff --git a/extensions/libebt_nflog.c b/extensions/libebt_nflog.c
> index 9801f358c81b..115e15da4584 100644
> --- a/extensions/libebt_nflog.c
> +++ b/extensions/libebt_nflog.c
> @@ -130,12 +130,8 @@ static int brnflog_xlate(struct xt_xlate *xl,
>  	const struct ebt_nflog_info *info = (void *)params->target->data;
>  
>  	xt_xlate_add(xl, "log ");
> -	if (info->prefix[0] != '\0') {
> -		if (params->escape_quotes)
> -			xt_xlate_add(xl, "prefix \\\"%s\\\" ", info->prefix);
> -		else
> -			xt_xlate_add(xl, "prefix \"%s\" ", info->prefix);
> -	}
> +	if (info->prefix[0] != '\0')
> +		xt_xlate_add(xl, "prefix \"%s\" ", info->prefix);
>  
>  	xt_xlate_add(xl, "group %u ", info->group);
>  
> diff --git a/extensions/libxt_LOG.c b/extensions/libxt_LOG.c
> index e3f4290ba003..cfde0c7bca6a 100644
> --- a/extensions/libxt_LOG.c
> +++ b/extensions/libxt_LOG.c
> @@ -116,7 +116,7 @@ static void LOG_print(const void *ip, const struct xt_entry_target *target,
>  			printf(" unknown-flags");
>  	}
>  
> -	if (strcmp(loginfo->prefix, "") != 0)
> +	if (loginfo->prefix[0] != 0)
>  		printf(" prefix \"%s\"", loginfo->prefix);
>  }
>  

Wrong spot? Because:

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
>  
>  	if (loginfo->level != LOG_DEFAULT_LEVEL && pname)
>  		xt_xlate_add(xl, " level %s", pname);

Here's still strcmp(). Since it doesn't make a difference in the binary
though, I'm fine with leaving the strcmp() calls as-is.

[...]
> diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
> index 4e8db4bedff8..1f16e726d3a7 100644
> --- a/iptables/xtables-translate.c
> +++ b/iptables/xtables-translate.c
[...]
> @@ -150,6 +148,7 @@ static int nft_rule_xlate_add(struct nft_handle *h,
>  			      bool append)
>  {
>  	struct xt_xlate *xl = xt_xlate_alloc(10240);
> +	const char *tick = cs->restore ? "" : "\'";

Left-over tick escaping here.

Thanks, Phil
