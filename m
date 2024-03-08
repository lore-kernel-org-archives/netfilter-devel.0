Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F87456762
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2024 11:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709899061; cv=none; b=XgCivC8Ds7cwvfxvjg3Zs2Y9N32Tsb3jd7xLaoeLGpjbiMYvajQYiBqcLAXaFtelMaAv9hotVM4ougk9gmU5wRGGmso0xAbHsiTHLYLGntriLrbOSwtexyhsnZDulGs+vQYpT0nQoA3EL3J++iYlzRsPZwHz903J5PQDYlK3nIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709899061; c=relaxed/simple;
	bh=q2SVD04b7WWweNB0tNopXbCjz/tAaKb8Eh7BRTc4d2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q7hUyvG7ZdasqmCOwsgNd2v4HRDfHaUjsjGWuCdYaYRn0Lv1gH7A1jN7ii0Lazwk/x8mLf4LQhvvgLMrmTlFTFxoAG/o7s+xkhMmHAV1ZCgEJ8BJNHIa3e747HBk7BE4T2rm1fvQ93290wEhlSqd7D46xwoY+UIVlKJWNwZsIcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=UYfLvOwV; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="UYfLvOwV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HYKjWU9HnpEsOKSvckmgctLjL58VwWhsIqGvfEicyfk=; b=UYfLvOwV+PMpN0STNb9yiL4YH2
	OnGX29Du3Tsj7yRjYOXsPX6f89qTAUtcj+mVDM52q4zRXQXjMxYn9oXREm4qWbhi5+mvK6t1EjEok
	N+zFVQ9jfRsIriFtWtywpFvp9C7qV2yiRC0sezbtPO/WAvNUF+m3b/V9c2AkymYVaaQt3HlX5d4Qs
	7Evs62Wo9H8kWIvoWSLrTtxtMfPx2Ub+3uLibHRju2eY0uSTFGK1MyIdhkKfPj+958SXiktU7IVLl
	vHgYzJ/jiwzh0pr0NDVEsXLegL9N3uZo5Qt6lOc1uE6XHbZVQPryGvvWFHpbdkI+eI7V3Jk+z7Y9Z
	5kO13X+g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1riYr1-000000002Nq-3HTy;
	Fri, 08 Mar 2024 12:57:35 +0100
Date: Fri, 8 Mar 2024 12:57:35 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH xtables] extensions: xt_TPROXY: add txlate support
Message-ID: <Zer9L_EgbICxBu0m@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20240307140531.9822-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307140531.9822-1-fw@strlen.de>

On Thu, Mar 07, 2024 at 03:05:28PM +0100, Florian Westphal wrote:
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  extensions/libxt_TPROXY.c      | 59 ++++++++++++++++++++++++++++++++++
>  extensions/libxt_TPROXY.txlate | 17 ++++++++++
>  2 files changed, 76 insertions(+)
>  create mode 100644 extensions/libxt_TPROXY.txlate
> 
> diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
> index d13ec85f92d0..4d2d7961ca2c 100644
> --- a/extensions/libxt_TPROXY.c
> +++ b/extensions/libxt_TPROXY.c
> @@ -147,6 +147,62 @@ static void tproxy_tg1_parse(struct xt_option_call *cb)
>  	}
>  }
>  
> +static int tproxy_tg_xlate(struct xt_xlate *xl,
> +			   const struct xt_tproxy_target_info_v1 *info)
> +{
> +	int family = xt_xlate_get_family(xl);
> +	uint32_t mask = info->mark_mask;
> +	bool port_mandatory = false;
> +	char buf[INET6_ADDRSTRLEN];
> +
> +	xt_xlate_add(xl, "tproxy to");
> +
> +	inet_ntop(family, &info->laddr, buf, sizeof(buf));
> +
> +	if (family == AF_INET6 && !IN6_IS_ADDR_UNSPECIFIED(&info->laddr.in6))
> +		xt_xlate_add(xl, "[%s]", buf);

Could you please add a testcase involving an IPv6 address? Just so we
exercise this code path.

> +	else if (family == AF_INET && info->laddr.ip)
> +		xt_xlate_add(xl, "%s", buf);
> +	else
> +		port_mandatory = true;
> +
> +	if (port_mandatory)
> +		xt_xlate_add(xl, " :%d", ntohs(info->lport));
> +	else if (info->lport)
> +		xt_xlate_add(xl, ":%d", ntohs(info->lport));
> +
> +	/* xt_TPROXY.c does: skb->mark = (skb->mark & ~mark_mask) ^ mark_value */
> +	if (mask == 0xffffffff)
> +		xt_xlate_add(xl, "meta mark set 0x%x", info->mark_value);
> +	else if (mask || info->mark_value)
> +		xt_xlate_add(xl, "meta mark set meta mark & 0x%x or 0x%x",
> +			     ~mask, info->mark_value);

Shouldn't this be 'xor' instead of 'or' in translated output? I wanted
to suggest "meta mark set meta mark and not <mask> xor <mark_value>",
but it seems nft supports only boolean negations.

Thanks, Phil
