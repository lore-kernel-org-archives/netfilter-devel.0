Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B20834D4CC;
	Thu, 30 Apr 2026 16:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777566090; cv=none; b=QaflLQO9SMTvwR6EdXskiqT+e7WI8vzGPsyFa7d1gR0LAm2F/2J9txHMIRZt8bYc6josEu8Py9nLBen+77fuq9ePqL1AcQqhJ39yH6FvoyS9TPFiOZoLxh5TpvyoeDC/GScTQvgx4jXJJcX8dumUx5rua/oTcKOj5+AKU2/V2XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777566090; c=relaxed/simple;
	bh=ai6+QVjyr+hlKt887iNpLWeIMLjufD7i076g2yHFK6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TP/Lu5J1aD/0/pJZPs+TnEORvt24Y6ZB5Wwz3xBDxMdfat+2ykFo1xBIQotU+RteZg/Dpqdh4vU+PYiUiTHqhiPWorABxq1ceJHVXBkW2cO+4Ip5Fnv/2NqO0NBPGh1SjoSDRVgrp1QVdHeHQKr/tNy8bs4poiXbdNqL4YQoHuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Dhc0qfwc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Dhc0qfwc"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 24C1460265;
	Thu, 30 Apr 2026 18:21:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777566087;
	bh=Mfb7idhAW77GRVWo14Dge1zqfEz94ADSCClG6QGYrks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dhc0qfwc9o+8SlyGPFA59cNGDTXu1D+rO/uLDn+KBFAKIZbB7yho60O6ELKIabmtA
	 zMfNXyRxtMtKsvOI7cWYtDhVkqMUnnn0VLOF0mGr9SB5MR2gMWR1/fiBr+4nFyn6tA
	 al65FDDAQqZhSKMSfl3YSCC3kd9mXahZD0CUcRXr5kLi9q6Jo8yDORheVNUjwE+nNM
	 q+Y1YbVOUDTh98dkuHhzet+2KrKnpUW6Qm1CnEwODVkfgF+O3bpmGm9dsFjSvgBzQF
	 V+IQyTb2nIJtCvYtCvoc93Rak0xVzZ/0WzVdY+gwtTyl9fShvAF9fKT0PEfdmQ66ye
	 GE7nmIxSBSvfQ==
Date: Thu, 30 Apr 2026 18:21:24 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: HACKE-RC <rc@rexion.ai>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] netfilter: nf_conntrack_amanda: reject port
 values above 65535
Message-ID: <afOBhH9Ef7z-QqxL@chamomile>
References: <20260430161515.3449513-3-rc@rexion.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260430161515.3449513-3-rc@rexion.ai>

Hi,

On Thu, Apr 30, 2026 at 09:45:15PM +0530, HACKE-RC wrote:
> amanda_help() converts the result of simple_strtoul() to __be16 via
> htons() without checking the parsed value fits in 16 bits. The
> existing len > 5 guard limits strings to five digits, capping the
> parseable range at 99999, but values 65536-99999 still silently
> truncate on the htons() conversion.
> 
> Use an intermediate unsigned long and reject out-of-range values
> before converting to network byte order.
> 
> Fixes: 16958900578b ("[NETFILTER]: nf_conntrack/nf_nat: add amanda helper port")
> Signed-off-by: HACKE-RC <rc@rexion.ai>
> ---
>  net/netfilter/nf_conntrack_amanda.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
> index d2c09e8dd..58d6c9f29 100644
> --- a/net/netfilter/nf_conntrack_amanda.c
> +++ b/net/netfilter/nf_conntrack_amanda.c
> @@ -88,11 +88,12 @@ static int amanda_help(struct sk_buff *skb,
>  	struct nf_conntrack_expect *exp;
>  	struct nf_conntrack_tuple *tuple;
>  	unsigned int dataoff, start, stop, off, i;
> +	nf_nat_amanda_hook_fn *nf_nat_amanda;
>  	char pbuf[sizeof("65535")], *tmp;
> +	unsigned long parsed_port;
> +	int ret = NF_ACCEPT;
>  	u_int16_t len;
>  	__be16 port;
> -	int ret = NF_ACCEPT;
> -	nf_nat_amanda_hook_fn *nf_nat_amanda;
>  
>  	/* Only look at packets from the Amanda server */
>  	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
> @@ -132,10 +133,11 @@ static int amanda_help(struct sk_buff *skb,
>  			break;
>  		pbuf[len] = '\0';
>  
> -		port = htons(simple_strtoul(pbuf, &tmp, 10));
> +		parsed_port = simple_strtoul(pbuf, &tmp, 10);

While being here, I would replace this simple_strtoul by a parser
which does not rely on nul-terminated strings.

A similar patch went in for the sip helper recently, maybe you can
just take such function to parse ports, move it to the
nf_conntrack_helper core so it can be shared by helpers.

>  		len = tmp - pbuf;
> -		if (port == 0 || len > 5)
> +		if (parsed_port == 0 || parsed_port > 65535 || len > 5)
>  			break;
> +		port = htons(parsed_port);
>  
>  		exp = nf_ct_expect_alloc(ct);
>  		if (exp == NULL) {
> -- 
> 2.54.0
> 
