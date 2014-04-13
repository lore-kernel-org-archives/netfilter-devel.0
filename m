From: Florian Westphal <fw@strlen.de>
Subject: Re: [libnftnl PATCH] target: Fix an invalid read.
Date: Sun, 13 Apr 2014 20:21:08 +0200
Message-ID: <20140413182108.GK31953@breakpoint.cc>
References: <3a6157fa2be7124bafa2b681acb65eea9be432d2.1397411873.git.anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40225 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754190AbaDMSVK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2014 14:21:10 -0400
Content-Disposition: inline
In-Reply-To: <3a6157fa2be7124bafa2b681acb65eea9be432d2.1397411873.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ana Rey <anarey@gmail.com> wrote:
> --- a/src/expr/target.c
> +++ b/src/expr/target.c
> @@ -42,8 +42,8 @@ nft_rule_expr_target_set(struct nft_rule_expr *e, uint16_t type,
>  
>  	switch(type) {
>  	case NFT_EXPR_TG_NAME:
> -		memcpy(tg->name, data, XT_EXTENSION_MAXNAMELEN);
> -		tg->name[XT_EXTENSION_MAXNAMELEN-1] = '\0';
> +		memcpy(tg->name, data, strlen(data));

This can overflow tg->name, since the size of the source
is tested instead of destination.

What about:

snprintf(tg->name, sizeof(tg->name), "%.*s", data_len, (const char *) data);

?
