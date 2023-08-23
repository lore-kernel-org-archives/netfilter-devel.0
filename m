Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE4CEE49AE
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Aug 2023 09:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbjHWJnN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Aug 2023 05:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbjHWJlo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2023 05:41:44 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10C659D7
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2023 02:11:00 -0700 (PDT)
Received: from [78.30.34.192] (port=38394 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qYjt9-0044MV-C1; Wed, 23 Aug 2023 11:10:57 +0200
Date:   Wed, 23 Aug 2023 11:10:54 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [PATCH nf] netfilter: nft_set_pipapo: fix out of memory error
 handling
Message-ID: <ZOXNHp3U5o1pSTno@calendula>
References: <20230823072752.16361-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230823072752.16361-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 23, 2023 at 09:27:47AM +0200, Florian Westphal wrote:
> Several instances of pipapo_resize() don't propagate allocation failures,
> this causes a crash when fault injection is used with
> 
>  echo Y > /sys/kernel/debug/failslab/ignore-gfp-wait
> 
> Cc: Stefano Brivio <sbrivio@redhat.com>

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nft_set_pipapo.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> index 3757fcc55723..6af9c9ed4b5c 100644
> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -902,12 +902,14 @@ static void pipapo_lt_bits_adjust(struct nft_pipapo_field *f)
>  static int pipapo_insert(struct nft_pipapo_field *f, const uint8_t *k,
>  			 int mask_bits)
>  {
> -	int rule = f->rules++, group, ret, bit_offset = 0;
> +	int rule = f->rules, group, ret, bit_offset = 0;
>  
> -	ret = pipapo_resize(f, f->rules - 1, f->rules);
> +	ret = pipapo_resize(f, f->rules, f->rules + 1);
>  	if (ret)
>  		return ret;
>  
> +	f->rules++;
> +
>  	for (group = 0; group < f->groups; group++) {
>  		int i, v;
>  		u8 mask;
> @@ -1052,7 +1054,9 @@ static int pipapo_expand(struct nft_pipapo_field *f,
>  			step++;
>  			if (step >= len) {
>  				if (!masks) {
> -					pipapo_insert(f, base, 0);
> +					err = pipapo_insert(f, base, 0);
> +					if (err < 0)
> +						return err;
>  					masks = 1;
>  				}
>  				goto out;
> @@ -1235,6 +1239,9 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
>  		else
>  			ret = pipapo_expand(f, start, end, f->groups * f->bb);
>  
> +		if (ret < 0)
> +			return ret;
> +
>  		if (f->bsize > bsize_max)
>  			bsize_max = f->bsize;
>  
> -- 
> 2.41.0
> 
