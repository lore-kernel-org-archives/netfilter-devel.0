Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B30ACE79D1
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 14:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbjITOFk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 10:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbjITOFj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 10:05:39 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE72B9
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 07:05:33 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qixpa-0003dl-H9; Wed, 20 Sep 2023 16:05:30 +0200
Date:   Wed, 20 Sep 2023 16:05:30 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/4] gmputil: add nft_gmp_free() to free strings from
 mpz_get_str()
Message-ID: <ZQr8KsFAXIT0mca9@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
References: <20230920131554.204899-1-thaller@redhat.com>
 <20230920131554.204899-3-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920131554.204899-3-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 20, 2023 at 03:13:39PM +0200, Thomas Haller wrote:
> mpz_get_str() (with NULL as first argument) will allocate a buffer using
> the allocator functions (mp_set_memory_functions()). We should free
> those buffers with the corresponding free function.
> 
> Add nft_gmp_free() for that and use it.
> 
> The name nft_gmp_free() is chosen because "mini-gmp.c" already has an
> internal define called gmp_free(). There wouldn't be a direct conflict,
> but using the same name is confusing. And maybe our own defines should
> have a clear nft prefix.
> 
> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
>  include/gmputil.h |  2 ++
>  src/evaluate.c    |  6 +++---
>  src/gmputil.c     | 21 ++++++++++++++++++++-
>  3 files changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/include/gmputil.h b/include/gmputil.h
> index c524aced16ac..d1f4dcd2f1c3 100644
> --- a/include/gmputil.h
> +++ b/include/gmputil.h
> @@ -77,4 +77,6 @@ extern void __mpz_switch_byteorder(mpz_t rop, unsigned int len);
>  	__mpz_switch_byteorder(rop, len);			\
>  }
>  
> +void nft_gmp_free(void *ptr);
> +
>  #endif /* NFTABLES_GMPUTIL_H */
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 03586922848a..e5c7e03a927f 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -401,7 +401,7 @@ static int expr_evaluate_integer(struct eval_ctx *ctx, struct expr **exprp)
>  		expr_error(ctx->msgs, expr,
>  			   "Value %s exceeds valid range 0-%u",
>  			   valstr, ctx->ectx.maxval);
> -		free(valstr);
> +		nft_gmp_free(valstr);
>  		return -1;
>  	}
>  
> @@ -417,8 +417,8 @@ static int expr_evaluate_integer(struct eval_ctx *ctx, struct expr **exprp)
>  		expr_error(ctx->msgs, expr,
>  			   "Value %s exceeds valid range 0-%s",
>  			   valstr, rangestr);
> -		free(valstr);
> -		free(rangestr);
> +		nft_gmp_free(valstr);
> +		nft_gmp_free(rangestr);
>  		mpz_clear(mask);
>  		return -1;
>  	}
> diff --git a/src/gmputil.c b/src/gmputil.c
> index bf472c65de48..550c141294a3 100644
> --- a/src/gmputil.c
> +++ b/src/gmputil.c
> @@ -185,7 +185,7 @@ int mpz_vfprintf(FILE *fp, const char *f, va_list args)
>  
>  			str = mpz_get_str(NULL, base, *value);
>  			ok = str && fwrite(str, 1, len, fp) == len;
> -			free(str);
> +			nft_gmp_free(str);
>  
>  			if (!ok)
>  				return -1;
> @@ -197,3 +197,22 @@ int mpz_vfprintf(FILE *fp, const char *f, va_list args)
>  	return n;
>  }
>  #endif
> +
> +void nft_gmp_free(void *ptr)
> +{
> +	void (*free_fcn)(void *, size_t);
> +
> +	/* When we get allocated memory from gmp, it was allocated via the
> +	 * allocator() from mp_set_memory_functions(). We should pair the free
> +	 * with the corresponding free function, which we get via
> +	 * mp_get_memory_functions().
> +	 *
> +	 * It's not clear what the correct blk_size is. The default allocator
> +	 * function of gmp just wraps free() and ignores the extra argument.
> +	 * Assume 0 is fine.
> +	 */
> +
> +	mp_get_memory_functions(NULL, NULL, &free_fcn);

Do we have to expect the returned pointer to change at run-time? Because
if not, couldn't one make free_fcn static and call
mp_get_memory_functions() only if it's NULL?

Cheers, Phil
