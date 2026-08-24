Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AC4137750
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 12:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787574088; cv=none; b=p/o1JJGymt+03OWglI4KSLGGz2YeogDFL9rRk3NB15NqDlXJMd5hp/7bQM019QvRmT9h/Lfk/5Ome3uuY3YefruXbKa4XtrlpYr9CcZpJZeT0JgcZv2uBHfuoYGJgXBSOuZVgNFLjoSa9shA9bdGTsuOGuLIF8mp/6j+pwx1dbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787574088; c=relaxed/simple;
	bh=XYczBtnNRphOZiXtghT4E2mx9tCNyqUjmVM37UIJG3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IC9HQc44PDxyA7mlFEE/OzIxepT4dMa9NR0u0fHLJIhFJuJ7TsIl5IlKY1l7TNN28CU50lN9EKJzcCFULrSBWK4N7QkjwlbEE8I/Ptv+v6aH4rydJDzAEiXoF9mbJoKYmc5ojcc0nIizErUkg6Wbi/telmyQeLZds2D2oAdS99s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bLppsCqk; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bLppsCqk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787574084;
	bh=Dmxa69mm+rXoorBjB81vdqyPiDY/jryFkgGzluMtW3o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bLppsCqkk/PPxPSX8v3+KwVkzhLDQy+dkWijqQtodu5vyH+b2b0d2t4R2OnLyWcRk
	 b6CLOWs6KE4su3Ejn2ePWvFrzakNYpx4jodA48goDnFrZx0msq0r2PF8agNEgmvEKa
	 Hve4DE8VIiVM54YR78r067EXzOAaaYX+MOScOoxv+CbYsThQZml0IgcPkng5f0ZTKi
	 u0znKsFG/5PxuztAnDuqzL3jj/LMJDrsPgCFi0ovYQXvD+buGx3A+aGf4RD+uhWUJ4
	 mQomGhQnxTHT8isvgHGaaooPR0wxvMlNE48OP9xLDC7ibT6Anc1kl/vRsA7Ceau9Y8
	 0FgtUge5oOlAA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 6D97F601C4;
	Mon, 24 Aug 2026 14:21:24 +0200 (CEST)
Date: Mon, 24 Aug 2026 14:21:21 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de,
	phil@nwl.cc, Wei Fang <void0red@gmail.com>
Subject: Re: [PATCH nf v2] netfilter: nf_tables: fix device name and prefix
 match in hook lookup
Message-ID: <aow3QRgFONC_OYnw@chamomile>
References: <20260824092805.4940-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260824092805.4940-1-fmancera@suse.de>

Hi Fernando,

On Mon, Aug 24, 2026 at 11:28:05AM +0200, Fernando Fernandez Mancera wrote:
> Currently, a netdev chain or flowtable hooked to a device prefix can be
> unintentionally deleted by a control-plane request targeting an exact
> device name or even a shorter one due to the usage of min() to calculate
> the length to match.
> 
> Fix this by making sure an exact device match never matches a prefix and
> that both the target and the candidate have the same length during
> delete operation. The add and update paths retain the existing overlap
> matching to prevent a single device from matching multiple hooks.

netdev maintainers prefer follow ups for LLM reported issues.

Please, provide an incremental patch for your v1 that we can take in
the next PR round.

Thanks!

> Reported-by: Wei Fang <void0red@gmail.com>
> Closes: https://lore.kernel.org/netfilter-devel/CANE+tVrDeNCHQVmsqkV2ozeBqyE3GtRDMhZgsg1bhw10yGNTRQ@mail.gmail.com/
> Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> ---
>  net/netfilter/nf_tables_api.c | 27 ++++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index c112ecc4fca3..3ad9a5e88c5b 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1978,7 +1978,7 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
>  	return -ENOSPC;
>  }
>  
> -static bool hook_is_prefix(struct nft_hook *hook)
> +static bool hook_is_prefix(const struct nft_hook *hook)
>  {
>  	return strlen(hook->ifname) >= hook->ifnamelen;
>  }
> @@ -2457,6 +2457,27 @@ static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
>  	return NULL;
>  }
>  
> +static struct nft_hook *nft_hook_list_find_strict(struct list_head *hook_list,
> +						  const struct nft_hook *this)
> +{
> +	struct nft_hook *hook;
> +
> +	list_for_each_entry(hook, hook_list, list) {
> +		if (hook_is_prefix(hook) != hook_is_prefix(this))
> +			continue;
> +		if (hook->ifnamelen != this->ifnamelen)
> +			continue;
> +		if (!strncmp(hook->ifname, this->ifname, hook->ifnamelen)) {
> +			if (hook->flags & NFT_HOOK_REMOVE)
> +				continue;
> +
> +			return hook;
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
>  static int nf_tables_parse_netdev_hooks(struct net *net,
>  					const struct nlattr *attr,
>  					struct list_head *hook_list,
> @@ -3257,7 +3278,7 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
>  		return err;
>  
>  	list_for_each_entry(this, &chain_hook.list, list) {
> -		hook = nft_hook_list_find(&basechain->hook_list, this);
> +		hook = nft_hook_list_find_strict(&basechain->hook_list, this);
>  		if (!hook) {
>  			err = -ENOENT;
>  			goto err_chain_del_hook;
> @@ -9383,7 +9404,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
>  		return err;
>  
>  	list_for_each_entry(this, &flowtable_hook.list, list) {
> -		hook = nft_hook_list_find(&flowtable->hook_list, this);
> +		hook = nft_hook_list_find_strict(&flowtable->hook_list, this);
>  		if (!hook) {
>  			err = -ENOENT;
>  			goto err_flowtable_del_hook;
> -- 
> 2.55.0
> 
