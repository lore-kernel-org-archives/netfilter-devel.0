Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3F53F5BE5
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jun 2026 11:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782473213; cv=none; b=oXcmrPVQT6wjqtUmmqMMCE89SEelq45Bp5crOshn8BZTAv6vc4nmj3Fr6rXyeyOaQza6a4WSaqJRioKmw7wObhd7B1pnjbxFIagy6kDilbC+i/qgip+mc8J8CqODub7VewvbAbNQNliVITgV1qo0FnMCyzJj+qmDWPZP4ghUKsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782473213; c=relaxed/simple;
	bh=LLVsdeOgN1IqYLTb3jVqgKRk/IxO3iI65J82wzqHUSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ph6Tca9PwVV90QkKnEHyBCUFb6IgIowpIs+EVJ+DNYFmrR4xVJoJW6xfjnoWTK3dWX98e86NVAVzsIiXcQkDkKSnZNDtHbqzYq2FhUhntFUb85nEBLz1UrwpT2XgMqgZ3pYhzJ//Do4Ryft4O9pMrdcAiSv0kWCxwxiZUWYkXhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=quZSTjGk; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="quZSTjGk"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3009E60590;
	Fri, 26 Jun 2026 13:26:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782473208;
	bh=4H3DrQoZCMQGXBYpI4jPzgqaCaO2TjdfAHvEtp1roFI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=quZSTjGkNpHd9ay+jHRpSw2Y8fDl/STnJu8+D6O5+zX76LH9V/hWILilbC/Q8kHR8
	 jDp+0qTLm/CiLukNoHp+wigy/4HyLqziKVOJl7P2pCC5Rv/vxGez31PODr37vk1wd8
	 nHiXicO0Qw1xqgQzLMxAjJ1zfAxt5f5oxGKHnt4B7otgMaaHWQXIaHAtJ/AofCxh5B
	 2DbWBqFstuUBEVx0cgRsFK+Ex4IO5D3bltqHop02sHXttL+nCQWLBgbzSLsdyeBacM
	 yxes9JgGly4ZjqLVZS+ZEz/JBV7Ik4qVpAAyWpSS5XsYLewHxDpROyyee1GDTm8PwF
	 C5Ldi8QHZq1bg==
Date: Fri, 26 Jun 2026 13:26:45 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_conntrack_expect: zero at allocation
 time
Message-ID: <aj5h9eFJE1glpYfz@chamomile>
References: <20260625001356.16478-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260625001356.16478-1-fw@strlen.de>

On Thu, Jun 25, 2026 at 02:13:53AM +0200, Florian Westphal wrote:
> There are occasional LLM hints wrt. leaking uninitialized data to
> userspace via ctnetlink.  Just zero at allocation time, expectations are
> not frequently used these days.

Fine with me. IIRC hints came because of real issue, ie. paths where
I was missing to initial something.

> Intentionally keeps _init as-is because we could theoretically support
> re-init, so add the missing exp->dir there.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_conntrack_expect.c  |  3 ++-
>  net/netfilter/nf_conntrack_netlink.c | 11 +----------
>  2 files changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
> index 49e18eda037e..0b213ffc0378 100644
> --- a/net/netfilter/nf_conntrack_expect.c
> +++ b/net/netfilter/nf_conntrack_expect.c
> @@ -306,7 +306,7 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
>  {
>  	struct nf_conntrack_expect *new;
>  
> -	new = kmem_cache_alloc(nf_ct_expect_cachep, GFP_ATOMIC);
> +	new = kmem_cache_zalloc(nf_ct_expect_cachep, GFP_ATOMIC);
>  	if (!new)
>  		return NULL;
>  
> @@ -389,6 +389,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
>  #if IS_ENABLED(CONFIG_NF_NAT)
>  	memset(&exp->saved_addr, 0, sizeof(exp->saved_addr));
>  	memset(&exp->saved_proto, 0, sizeof(exp->saved_proto));
> +	exp->dir = 0;

Hm. But now area is expect is zeroed, right?

Maybe nf_ct_expect_init() needs to be updated to remove needless
zeroing too?

Thanks!

>  #endif
>  }
>  EXPORT_SYMBOL_GPL(nf_ct_expect_init);
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index 4e78d2482989..c6daeea35044 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -3565,8 +3565,6 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
>  	if (cda[CTA_EXPECT_FLAGS]) {
>  		exp->flags = ntohl(nla_get_be32(cda[CTA_EXPECT_FLAGS]));
>  		exp->flags &= ~NF_CT_EXPECT_USERSPACE;
> -	} else {
> -		exp->flags = 0;
>  	}
>  	if (cda[CTA_EXPECT_FN]) {
>  		const char *name = nla_data(cda[CTA_EXPECT_FN]);
> @@ -3578,8 +3576,7 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
>  			goto err_out;
>  		}
>  		exp->expectfn = expfn->expectfn;
> -	} else
> -		exp->expectfn = NULL;
> +	}
>  
>  	exp->class = class;
>  	exp->master = ct;
> @@ -3598,12 +3595,6 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
>  						 exp, nf_ct_l3num(ct));
>  		if (err < 0)
>  			goto err_out;
> -#if IS_ENABLED(CONFIG_NF_NAT)
> -	} else {
> -		memset(&exp->saved_addr, 0, sizeof(exp->saved_addr));
> -		memset(&exp->saved_proto, 0, sizeof(exp->saved_proto));
> -		exp->dir = 0;
> -#endif
>  	}
>  	return exp;
>  err_out:
> -- 
> 2.53.0
> 
> 
