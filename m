From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] netfilter: ipset: timeout values corrupted on set
 resize
Date: Wed, 20 Feb 2013 22:44:18 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302202238210.9720@blackhole.kfki.hu>
References: <1361302559-8657-1-git-send-email-johunt@akamai.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:47619 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab3BTVoT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:44:19 -0500
In-Reply-To: <1361302559-8657-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Josh,

On Tue, 19 Feb 2013, Josh Hunt wrote:

> If a resize is triggered on a set with timeouts enabled, the timeout
> values will get corrupted when copying them to the new set. This occured
> b/c the wrong timeout value is supplied to type_pf_elem_tadd().
> 
> This also adds simple debug statement similar to the one in type_pf_resize().

That's a good catch and perfect patch.

I'm just at the checking phase of the next release, which required a 
fairly large rewriting of the types - and which, as a side effect, fixed 
this bug. If I won't be able to release the rewritten version by the 
weekend, I'm going to apply your patch and release an interim version.

Best regards,
Jozsef
 
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>  include/linux/netfilter/ipset/ip_set_ahash.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/netfilter/ipset/ip_set_ahash.h b/include/linux/netfilter/ipset/ip_set_ahash.h
> index ef9acd3..01d25e6 100644
> --- a/include/linux/netfilter/ipset/ip_set_ahash.h
> +++ b/include/linux/netfilter/ipset/ip_set_ahash.h
> @@ -854,6 +854,8 @@ type_pf_tresize(struct ip_set *set, bool retried)
>  retry:
>  	ret = 0;
>  	htable_bits++;
> +	pr_debug("attempt to resize set %s from %u to %u, t %p\n",
> +		 set->name, orig->htable_bits, htable_bits, orig);
>  	if (!htable_bits) {
>  		/* In case we have plenty of memory :-) */
>  		pr_warning("Cannot increase the hashsize of set %s further\n",
> @@ -873,7 +875,7 @@ retry:
>  			data = ahash_tdata(n, j);
>  			m = hbucket(t, HKEY(data, h->initval, htable_bits));
>  			ret = type_pf_elem_tadd(m, data, AHASH_MAX(h), 0,
> -						type_pf_data_timeout(data));
> +						ip_set_timeout_get(type_pf_data_timeout(data)));
>  			if (ret < 0) {
>  				read_unlock_bh(&set->lock);
>  				ahash_destroy(t);
> -- 
> 1.7.0.4
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
