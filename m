From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] expect: consider all expect attributes when comparing
Date: Wed, 5 Jun 2013 04:51:11 +0200
Message-ID: <20130605025111.GA17004@localhost>
References: <1370091571-23140-1-git-send-email-fw@strlen.de>
 <1370091571-23140-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58168 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab3FECvS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Jun 2013 22:51:18 -0400
Content-Disposition: inline
In-Reply-To: <1370091571-23140-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jun 01, 2013 at 02:59:31PM +0200, Florian Westphal wrote:
> The expect cmp function ignored most of the attributes.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/expect/compare.c | 95 ++++++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 85 insertions(+), 10 deletions(-)
> 
> diff --git a/src/expect/compare.c b/src/expect/compare.c
> index 484d7b1..6326706 100644
> --- a/src/expect/compare.c
> +++ b/src/expect/compare.c
> @@ -35,6 +35,45 @@ static int exp_cmp(int attr,
>  }
>  
>  static int
> +cmp_exp_master(const struct nf_expect *exp1, const struct nf_expect *exp2,
> +	       unsigned int flags)
> +{
> +	return __cmp_orig((struct nf_conntrack *)&exp1->master,
> +			  (struct nf_conntrack *)&exp2->master, flags);
> +}
> +
> +static int
> +cmp_exp_expected(const struct nf_expect *exp1, const struct nf_expect *exp2,
> +		 unsigned int flags)
> +{
> +	return __cmp_orig((struct nf_conntrack *)&exp1->expected,
> +			  (struct nf_conntrack *)&exp2->expected, flags);
> +}
> +
> +static int
> +cmp_exp_mask(const struct nf_expect *exp1, const struct nf_expect *exp2,
> +	     unsigned int flags)
> +{
> +	return __cmp_orig((struct nf_conntrack *)&exp1->mask,
> +			  (struct nf_conntrack *)&exp2->mask, flags);
> +
> +}
> +
> +static int
> +cmp_exp_timeout(const struct nf_expect *exp1, const struct nf_expect *exp2,
> +		unsigned int flags)
> +{
> +	return exp1->timeout == exp2->timeout;
> +}

The timeout comparison needs to implement the __NFCT_CMP_TIMEOUT
logic, similar to nfct_cmp. Otherwise nfexp_cmp will break in
conntrackd with expect sync mode.

> +
> +static int
> +cmp_exp_zone(const struct nf_expect *exp1, const struct nf_expect *exp2,
> +	     unsigned int flags)
> +{
> +	return exp1->zone == exp2->zone;
> +}
> +
> +static int
>  cmp_exp_flags(const struct nf_expect *exp1, const struct nf_expect *exp2,
>  	      unsigned int flags)
>  {
> @@ -42,32 +81,68 @@ cmp_exp_flags(const struct nf_expect *exp1, const struct nf_expect *exp2,
>  }
>  
>  static int
> +cmp_exp_hname(const struct nf_expect *exp1, const struct nf_expect *exp2,
> +	      unsigned int flags)
> +{
> +	return strcmp(exp1->helper_name, exp2->helper_name) == 0;
> +}
> +
> +static int
>  cmp_exp_class(const struct nf_expect *exp1, const struct nf_expect *exp2,
>  	      unsigned int flags)
>  {
>  	return (exp1->class == exp2->class);
>  }
>  
> +static int
> +cmp_exp_natt(const struct nf_expect *exp1, const struct nf_expect *exp2,
> +	     unsigned int flags)
> +{
> +	return __cmp_orig((struct nf_conntrack *)&exp1->nat,
> +			  (struct nf_conntrack *)&exp2->nat, flags);
> +
> +}
> +
> +static int
> +cmp_exp_natdir(const struct nf_expect *exp1, const struct nf_expect *exp2,
> +	       unsigned int flags)
> +{
> +	return exp1->nat_dir == exp2->nat_dir;
> +}
> +
> +static int
> +cmp_exp_expfn(const struct nf_expect *exp1, const struct nf_expect *exp2,
> +	      unsigned int flags)
> +{
> +	return strcmp(exp1->expectfn, exp2->expectfn) == 0;
> +}
> +
> +
>  int __cmp_expect(const struct nf_expect *exp1,
>  		 const struct nf_expect *exp2,
>  		 unsigned int flags)
>  {
> -	if (!__cmp_orig((struct nf_conntrack *)&exp1->master,
> -			(struct nf_conntrack *)&exp2->master, flags)) {
> +	if (!exp_cmp(ATTR_EXP_MASTER, exp1, exp2, flags, cmp_exp_master))
>  		return 0;
> -	}
> -	if (!__cmp_orig((struct nf_conntrack *)&exp1->expected,
> -			(struct nf_conntrack *)&exp2->expected, flags)) {
> +	if (!exp_cmp(ATTR_EXP_EXPECTED, exp1, exp2, flags, cmp_exp_expected))
>  		return 0;
> -	}
> -	if (!__cmp_orig((struct nf_conntrack *)&exp1->mask,
> -			(struct nf_conntrack *)&exp2->mask, flags)) {
> +	if (!exp_cmp(ATTR_EXP_MASK, exp1, exp2, flags, cmp_exp_mask))
> +		return 0;
> +	if (!exp_cmp(ATTR_EXP_TIMEOUT, exp1, exp2, flags, cmp_exp_timeout))
> +		return 0;
> +	if (!exp_cmp(ATTR_EXP_ZONE, exp1, exp2, flags, cmp_exp_zone))
>  		return 0;
> -	}
>  	if (!exp_cmp(ATTR_EXP_FLAGS, exp1, exp2, flags, cmp_exp_flags))
>  		return 0;
> +	if (!exp_cmp(ATTR_EXP_HELPER_NAME, exp1, exp2, flags, cmp_exp_hname))
> +		return 0;
>  	if (!exp_cmp(ATTR_EXP_CLASS, exp1, exp2, flags, cmp_exp_class))
>  		return 0;
> -
> +	if (!exp_cmp(ATTR_EXP_NAT_TUPLE, exp1, exp2, flags, cmp_exp_natt))
> +		return 0;
> +	if (!exp_cmp(ATTR_EXP_NAT_DIR, exp1, exp2, flags, cmp_exp_natdir))
> +		return 0;
> +	if (!exp_cmp(ATTR_EXP_FN, exp1, exp2, flags, cmp_exp_expfn))
> +		return 0;
>  	return 1;
>  }
> -- 
> 1.8.1.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
