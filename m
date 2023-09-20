Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CCC9C04AA7
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 16:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235578AbjITQCy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 12:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235586AbjITQCx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 12:02:53 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F85E0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 09:02:45 -0700 (PDT)
Received: from [78.30.34.192] (port=36024 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qizez-004a1X-B9; Wed, 20 Sep 2023 18:02:43 +0200
Date:   Wed, 20 Sep 2023 18:02:40 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 8/9] datatype: use __attribute__((packed)) instead of
 enum bitfields
Message-ID: <ZQsXoASbR1+aimMt@calendula>
References: <20230920142958.566615-1-thaller@redhat.com>
 <20230920142958.566615-9-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230920142958.566615-9-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 20, 2023 at 04:26:09PM +0200, Thomas Haller wrote:
> At some places we use bitfields of those enums, to save space inside the
> structure. We can achieve that in a better way, by using GCC's
> __attribute__((packed)) on the enum type.
> 
> It's better because a :8 bitfield makes the assumption that all enum
> values (valid or invalid) fit into that field. With packed enums, we
> don't need that assumption as the field can hold all possible numbers
> that the enum type can hold. This reduces the places we need to worry
> about truncating a value to casts between other types and the enum.
> Those places already require us to be careful.
> 
> On the other hand, previously casting an int (or uint32_t) likely didn't
> cause a truncation as the underlying type was large enough. So we could
> check for invalid enum values after the cast. We might do that at
> places. For example, we do
> 
> 	key  = nftnl_expr_get_u32(nle, NFTNL_EXPR_META_KEY);
> 	expr = meta_expr_alloc(loc, key);
> 
> where we cast from an uint32_t to an enum without checking. Note that
> `enum nft_meta_keys` is not packed by this patch. But this is an example
> how things could be wrong. But the bug already exits before: don't make
> assumption about the underlying enum type and take care of truncation
> during casts.
> 
> This makes the change potentially dangerous, and it's hard to be sure
> that it doesn't uncover bugs (due tow rong assumptions about enum types).
> 
> Note that we were already using the GCC-ism __attribute__((packed))
> previously, however on a struct and not on an enum. Anyway. It seems
> unlikely that we support any other compilers than GCC/Clang. Those both
> support this attribute.  We should not worry about portability towards
> hypothetical compilers (the C standard), unless there is a real compiler
> that we can use and test and shows a problem with this. Especially when
> we support both GCC and Clang, which themselves are ubiquitous and
> accessible to all users (as they also need to build the kernel in the
> first place).
> 
> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
>  include/datatype.h   |  1 +
>  include/expression.h |  8 +++++---
>  include/proto.h      | 11 +++++++----
>  3 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/include/datatype.h b/include/datatype.h
> index 202935bd322f..c8b3b77ad0c0 100644
> --- a/include/datatype.h
> +++ b/include/datatype.h
> @@ -112,6 +112,7 @@ enum datatypes {
>   * @BYTEORDER_HOST_ENDIAN:	host endian
>   * @BYTEORDER_BIG_ENDIAN:	big endian
>   */
> +__attribute__((packed))
>  enum byteorder {
>  	BYTEORDER_INVALID,
>  	BYTEORDER_HOST_ENDIAN,
> diff --git a/include/expression.h b/include/expression.h
> index aede223db741..11a1dbf00b8c 100644
> --- a/include/expression.h
> +++ b/include/expression.h
> @@ -45,6 +45,7 @@
>   * @EXPR_SET_ELEM_CATCHALL catchall element expression
>   * @EXPR_FLAGCMP	flagcmp expression
>   */
> +__attribute__((packed))

No need for ((packed)) here, we never send this over the wire.

>  enum expr_types {
>  	EXPR_INVALID,
>  	EXPR_VERDICT,
> @@ -80,6 +81,7 @@ enum expr_types {
>  	EXPR_MAX = EXPR_FLAGCMP
>  };
>  
> +__attribute__((packed))
>  enum ops {
>  	OP_INVALID,
>  	OP_IMPLICIT,
> @@ -247,9 +249,9 @@ struct expr {
>  	unsigned int		flags;
>  
>  	const struct datatype	*dtype;
> -	enum byteorder		byteorder:8;
> -	enum expr_types		etype:8;
> -	enum ops		op:8;
> +	enum byteorder		byteorder;
> +	enum expr_types		etype;
> +	enum ops		op;

This is saving _a lot of space_ for us, we currently have a problem
with memory consumption, this is going in the opposite direction.

I prefer to ditch this patch.
