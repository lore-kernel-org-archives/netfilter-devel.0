Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE58C4361B
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 17:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F7F62389F
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 17:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgLQRNJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 12:13:09 -0500
Received: from smtp-out.kfki.hu ([148.6.0.45]:44151 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgLQRNJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 12:13:09 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id B94D567401F9;
        Thu, 17 Dec 2020 18:12:06 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 17 Dec 2020 18:12:04 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id 90CC067401D5;
        Thu, 17 Dec 2020 18:12:03 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 47E4F340D5D; Thu, 17 Dec 2020 18:12:03 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 43C2F340D5C;
        Thu, 17 Dec 2020 18:12:03 +0100 (CET)
Date:   Thu, 17 Dec 2020 18:12:03 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Vasily Averin <vvs@virtuozzo.com>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH] netfilter: ipset: fixes possible oops in mtype_resize
In-Reply-To: <bfeee41d-65f0-40b2-1139-b888627e34ef@virtuozzo.com>
Message-ID: <alpine.DEB.2.23.453.2012171810580.2216@blackhole.kfki.hu>
References: <bfeee41d-65f0-40b2-1139-b888627e34ef@virtuozzo.com>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Vasily, Pablo,

On Thu, 17 Dec 2020, Vasily Averin wrote:

> currently mtype_resize() can cause oops
> 
>         t = ip_set_alloc(htable_size(htable_bits));
>         if (!t) {
>                 ret = -ENOMEM;
>                 goto out;
>         }
>         t->hregion = ip_set_alloc(ahash_sizeof_regions(htable_bits));
> 
> Increased htable_bits can force htable_size() to return 0.
> In own turn ip_set_alloc(0) returns not 0 but ZERO_SIZE_PTR,
> so follwoing access to t->hregion should trigger an OOPS.
> 
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Good catch, thank you Vasily.

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Best regards,
Jozsef

> ---
>  net/netfilter/ipset/ip_set_hash_gen.h | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 7d01086..7cd1d31 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -630,7 +630,7 @@ struct mtype_resize_ad {
>  	struct htype *h = set->data;
>  	struct htable *t, *orig;
>  	u8 htable_bits;
> -	size_t dsize = set->dsize;
> +	size_t hsize, dsize = set->dsize;
>  #ifdef IP_SET_HASH_WITH_NETS
>  	u8 flags;
>  	struct mtype_elem *tmp;
> @@ -654,14 +654,12 @@ struct mtype_resize_ad {
>  retry:
>  	ret = 0;
>  	htable_bits++;
> -	if (!htable_bits) {
> -		/* In case we have plenty of memory :-) */
> -		pr_warn("Cannot increase the hashsize of set %s further\n",
> -			set->name);
> -		ret = -IPSET_ERR_HASH_FULL;
> -		goto out;
> -	}
> -	t = ip_set_alloc(htable_size(htable_bits));
> +	if (!htable_bits)
> +		goto hbwarn;
> +	hsize = htable_size(htable_bits);
> +	if (!hsize)
> +		goto hbwarn;
> +	t = ip_set_alloc(hsize);
>  	if (!t) {
>  		ret = -ENOMEM;
>  		goto out;
> @@ -803,6 +801,12 @@ struct mtype_resize_ad {
>  	if (ret == -EAGAIN)
>  		goto retry;
>  	goto out;
> +
> +hbwarn:
> +	/* In case we have plenty of memory :-) */
> +	pr_warn("Cannot increase the hashsize of set %s further\n", set->name);
> +	ret = -IPSET_ERR_HASH_FULL;
> +	goto out;
>  }
>  
>  /* Get the current number of elements and ext_size in the set  */
> -- 
> 1.8.3.1
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
