Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4127C04FD0
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 18:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjITSN3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 14:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjITSN2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 14:13:28 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6D4C9
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 11:13:22 -0700 (PDT)
Received: from [78.30.34.192] (port=43944 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qj1hO-0055Q7-V4; Wed, 20 Sep 2023 20:13:21 +0200
Date:   Wed, 20 Sep 2023 20:13:18 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 7/9] expression: cleanup expr_ops_by_type() and
 handle u32 input
Message-ID: <ZQs2Pmq6J5ZdXDQb@calendula>
References: <20230920142958.566615-1-thaller@redhat.com>
 <20230920142958.566615-8-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230920142958.566615-8-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 20, 2023 at 04:26:08PM +0200, Thomas Haller wrote:
> Be more careful about casting an uint32_t value to "enum expr_types" and
> make fewer assumptions about the underlying integer type of the enum.
> Instead, be clear about where we have an untrusted uint32_t from netlink
> and an enum. Rename expr_ops_by_type() to expr_ops_by_type_u32() to make
> this clearer. Later we might make the enum as packed, when this starts
> to matter more.
> 
> Also, only the code path expr_ops() wants strict validation and assert
> against valid enum values. Move the assertion out of
> __expr_ops_by_type(). Then expr_ops_by_type_u32() does not need to
> duplicate the handling of EXPR_INVALID. We still need to duplicate the
> check against EXPR_MAX, to ensure that the uint32_t value can be cast to
> an enum value.
> 
> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
>  include/expression.h |  2 +-
>  src/expression.c     | 23 +++++++++++------------
>  src/netlink.c        |  4 ++--
>  3 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/include/expression.h b/include/expression.h
> index 469f41ecd613..aede223db741 100644
> --- a/include/expression.h
> +++ b/include/expression.h
> @@ -189,7 +189,7 @@ struct expr_ops {
>  };
>  
>  const struct expr_ops *expr_ops(const struct expr *e);
> -const struct expr_ops *expr_ops_by_type(enum expr_types etype);
> +const struct expr_ops *expr_ops_by_type_u32(uint32_t value);
>  
>  /**
>   * enum expr_flags
> diff --git a/src/expression.c b/src/expression.c
> index 87d5a9fcbe09..320c02be522c 100644
> --- a/src/expression.c
> +++ b/src/expression.c
> @@ -995,7 +995,7 @@ static struct expr *concat_expr_parse_udata(const struct nftnl_udata *attr)
>  			goto err_free;
>  
>  		etype = nftnl_udata_get_u32(nest_ud[NFTNL_UDATA_SET_KEY_CONCAT_SUB_TYPE]);
> -		ops = expr_ops_by_type(etype);
> +		ops = expr_ops_by_type_u32(etype);
>  		if (!ops || !ops->parse_udata)
>  			goto err_free;
>  
> @@ -1509,9 +1509,7 @@ void range_expr_value_high(mpz_t rop, const struct expr *expr)
>  static const struct expr_ops *__expr_ops_by_type(enum expr_types etype)
>  {
>  	switch (etype) {
> -	case EXPR_INVALID:
> -		BUG("Invalid expression ops requested");
> -		break;
> +	case EXPR_INVALID: break;
>  	case EXPR_VERDICT: return &verdict_expr_ops;
>  	case EXPR_SYMBOL: return &symbol_expr_ops;
>  	case EXPR_VARIABLE: return &variable_expr_ops;
> @@ -1543,21 +1541,22 @@ static const struct expr_ops *__expr_ops_by_type(enum expr_types etype)
>  	case EXPR_FLAGCMP: return &flagcmp_expr_ops;
>  	}
>  
> -	BUG("Unknown expression type %d\n", etype);
> +	return NULL;
>  }
>  
>  const struct expr_ops *expr_ops(const struct expr *e)
>  {
> -	return __expr_ops_by_type(e->etype);
> +	const struct expr_ops *ops;
> +
> +	ops = __expr_ops_by_type(e->etype);
> +	if (!ops)
> +		BUG("Unknown expression type %d\n", e->etype);
> +	return ops;
>  }
>  
> -const struct expr_ops *expr_ops_by_type(enum expr_types value)
> +const struct expr_ops *expr_ops_by_type_u32(uint32_t value)
>  {
> -	/* value might come from unreliable source, such as "udata"
> -	 * annotation of set keys.  Avoid BUG() assertion.
> -	 */
> -	if (value == EXPR_INVALID || value > EXPR_MAX)
> +	if (value > (uint32_t) EXPR_MAX)

I think this still allows a third party to set EXPR_INVALID in the
netlink userdata attribute, right?

>  		return NULL;
> -
>  	return __expr_ops_by_type(value);
>  }
> diff --git a/src/netlink.c b/src/netlink.c
> index 70ebf382b14f..8af579c7b778 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -878,8 +878,8 @@ static struct expr *set_make_key(const struct nftnl_udata *attr)
>  {
>  	const struct nftnl_udata *ud[NFTNL_UDATA_SET_TYPEOF_MAX + 1] = {};
>  	const struct expr_ops *ops;
> -	enum expr_types etype;
>  	struct expr *expr;
> +	uint32_t etype;
>  	int err;
>  
>  	if (!attr)
> @@ -895,7 +895,7 @@ static struct expr *set_make_key(const struct nftnl_udata *attr)
>  		return NULL;
>  
>  	etype = nftnl_udata_get_u32(ud[NFTNL_UDATA_SET_TYPEOF_EXPR]);
> -	ops = expr_ops_by_type(etype);
> +	ops = expr_ops_by_type_u32(etype);
>  	if (!ops)
>  		return NULL;
>  
> -- 
> 2.41.0
> 
