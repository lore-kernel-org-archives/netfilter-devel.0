From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 4/4 v2] test: update json/xml tests to the new
 syntax
Date: Fri, 30 Jan 2015 19:38:56 +0100
Message-ID: <20150130183856.GC22598@salvia>
References: <1422628525-28109-1-git-send-email-alvaroneay@gmail.com>
 <1422628525-28109-4-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43839 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933026AbbA3Sfy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Jan 2015 13:35:54 -0500
Content-Disposition: inline
In-Reply-To: <1422628525-28109-4-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 30, 2015 at 03:35:25PM +0100, Alvaro Neira Ayuso wrote:
> diff --git a/examples/nft-ruleset-parse-file.c b/examples/nft-ruleset-parse-file.c
> index a78e454..e6a78b4 100644
> --- a/examples/nft-ruleset-parse-file.c
> +++ b/examples/nft-ruleset-parse-file.c
> @@ -250,7 +250,8 @@ static int nft_ruleset_table(const struct nft_parse_ctx *ctx, uint32_t ctx_cmd,
>  					type,
>  					seq++);
>  
> -	nft_table_nlmsg_build_payload(nlh, table);
> +	if (table != NULL)
> +		nft_table_nlmsg_build_payload(nlh, table);
>  	mnl_nlmsg_batch_next(batch);
>  	nft_table_free(table);
>  	return 0;

This chunk doesn't belong here.
