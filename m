From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 1/2] src: add nft_ruleset_ctx_free
Date: Tue, 10 Mar 2015 11:19:24 +0100
Message-ID: <20150310101924.GA27395@salvia>
References: <1425981797-10280-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35603 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbbCJKPm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Mar 2015 06:15:42 -0400
Content-Disposition: inline
In-Reply-To: <1425981797-10280-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 10, 2015 at 11:03:17AM +0100, Alvaro Neira Ayuso wrote:
> This function release the ruleset objects attached in the parser context
> (nft_parse_ctx).
> 
> Moreover, this patch update the nft_parse_ruleset_file to use it.
> 
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  examples/nft-ruleset-parse-file.c |    8 +-------
>  include/libnftnl/ruleset.h        |    1 +
>  src/libnftnl.map                  |    1 +
>  src/ruleset.c                     |   23 +++++++++++++++++++++++
>  4 files changed, 26 insertions(+), 7 deletions(-)
> 
> diff --git a/examples/nft-ruleset-parse-file.c b/examples/nft-ruleset-parse-file.c
> index 7d9086b..1b7c8d2 100644
> --- a/examples/nft-ruleset-parse-file.c
> +++ b/examples/nft-ruleset-parse-file.c
> @@ -77,10 +77,8 @@ static int nft_ruleset_set_elems(const struct nft_parse_ctx *ctx)
>  	mnl_nlmsg_batch_next(batch);
>  
>  	nft_set_elems_iter_destroy(iter_elems);
> -	nft_set_free(set);
>  	return 0;
>  err:
> -	nft_set_free(set);
>  	return -1;
>  }
>  
> @@ -125,7 +123,6 @@ static int nft_ruleset_set(const struct nft_parse_ctx *ctx)
>  	ret = nft_ruleset_set_elems(ctx);
>  	return ret;
>  err:
> -	nft_set_free(set);
>  	return -1;
>  }
>  
> @@ -184,7 +181,6 @@ static int nft_ruleset_rule(const struct nft_parse_ctx *ctx)
>  		return -1;
>  
>  	ret = nft_ruleset_rule_build_msg(ctx, cmd, rule);
> -	nft_rule_free(rule);
>  
>  	return ret;
>  }
> @@ -273,10 +269,8 @@ static int nft_ruleset_chain(const struct nft_parse_ctx *ctx)
>  	nft_chain_nlmsg_build_payload(nlh, chain);
>  	mnl_nlmsg_batch_next(batch);
>  
> -	nft_chain_free(chain);
>  	return 0;
>  err:
> -	nft_chain_free(chain);
>  	return -1;
>  }
>  
> @@ -327,7 +321,6 @@ static int nft_ruleset_table(const struct nft_parse_ctx *ctx)
>  		return -1;
>  
>  	ret = nft_ruleset_table_build_msg(ctx, cmd, table);
> -	nft_table_free(table);
>  
>  	return ret;
>  }
> @@ -377,6 +370,7 @@ static int ruleset_elems_cb(const struct nft_parse_ctx *ctx)
>  		return -1;
>  	}
>  
> +	nft_ruleset_ctx_free((struct nft_parse_ctx *)ctx);

Please, better do this casting inside nft_ruleset_ctx_free().

>  	return ret;
>  }
>  
> diff --git a/include/libnftnl/ruleset.h b/include/libnftnl/ruleset.h
> index aa1d92d..12c617d 100644
> --- a/include/libnftnl/ruleset.h
> +++ b/include/libnftnl/ruleset.h
> @@ -51,6 +51,7 @@ enum {
>  };
>  
>  struct nft_parse_ctx;
> +void nft_ruleset_ctx_free(struct nft_parse_ctx *ctx);
>  bool nft_ruleset_ctx_is_set(const struct nft_parse_ctx *ctx, uint16_t attr);
>  void *nft_ruleset_ctx_get(const struct nft_parse_ctx *ctx, uint16_t attr);
>  uint32_t nft_ruleset_ctx_get_u32(const struct nft_parse_ctx *ctx,
> diff --git a/src/libnftnl.map b/src/libnftnl.map
> index 7c74fbc..04d2ccb 100644
> --- a/src/libnftnl.map
> +++ b/src/libnftnl.map
> @@ -229,6 +229,7 @@ LIBNFTNL_1.2 {
>  } LIBNFTNL_1.1;
>  
>  LIBNFTNL_1.2.0 {
> +  nft_ruleset_ctx_free;

Place this at the bottom of the previous ones.

>    nft_ruleset_ctx_is_set;
>    nft_ruleset_ctx_get;
>    nft_ruleset_ctx_get_u32;
