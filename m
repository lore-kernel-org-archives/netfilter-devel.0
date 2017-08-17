From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATH 15/16] libnftables: add error handling
Date: Thu, 17 Aug 2017 12:32:52 +0200
Message-ID: <20170817103252.GZ16375@orbyte.nwl.cc>
References: <20170816204310.3371-1-eric@regit.org>
 <20170816204310.3371-16-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:34763 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752306AbdHQKcx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2017 06:32:53 -0400
Content-Disposition: inline
In-Reply-To: <20170816204310.3371-16-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 16, 2017 at 10:43:09PM +0200, Eric Leblond wrote:
[...]
> diff --git a/src/libnftables.c b/src/libnftables.c
> index c50c068..a42e8f1 100644
> --- a/src/libnftables.c
> +++ b/src/libnftables.c
> @@ -86,6 +86,7 @@ struct nft_ctx *nft_context_new(void)
>  	ctx->nf_sock = netlink_open_sock();
>  
>  	init_list_head(&ctx->cache.list);
> +	init_list_head(&ctx->output.msgs);
>  
>  	ctx->output.ctx = ctx;
>  	ctx->output.print = nft_print;
> @@ -108,6 +109,7 @@ void nft_context_free(struct nft_ctx *nft)
>  		return;
>  	netlink_close_sock(nft->nf_sock);
>  	cache_release(&nft->cache);
> +	erec_free_list(&nft->output.msgs);
>  	xfree(nft);
>  }
>  
> @@ -116,23 +118,30 @@ static const struct input_descriptor indesc_cmdline = {
>  	.name	= "<cmdline>",
>  };
>  
> +int nft_get_error(struct nft_ctx *nft, char *err_buf, size_t err_buf_len)
> +{
> +	FILE *errfile = fmemopen(err_buf, err_buf_len, "w");
> +	erec_print_list(errfile, &nft->output.msgs);
> +	fclose(errfile);
> +	return 0;	
> +}
> +
>  int nft_run_command_from_buffer(struct nft_ctx *nft,
>  				char *buf, size_t buflen)
>  {
>  	int rc = NFT_EXIT_SUCCESS;
>  	struct parser_state state;
> -	LIST_HEAD(msgs);
>  	void *scanner;
>  
> -	parser_init(nft->nf_sock, &nft->cache, &state, &msgs);
> +	parser_init(nft->nf_sock, &nft->cache, &state, &nft->output.msgs);

Change signature to take struct nft_ctx as first parameter and get rid
of everything but struct parser_state?

>  	scanner = scanner_init(&state);
>  	scanner_push_buffer(scanner, &indesc_cmdline, buf);
>  		
> -	if (nft_run(nft, nft->nf_sock, &nft->cache, scanner, &state, &msgs) != 0)
> +	if (nft_run(nft, nft->nf_sock, &nft->cache, scanner,
> +		    &state, &nft->output.msgs) != 0)

Just use nft->output.msg directly in nft_run() and drop the parameter?

Cheers, Phil
