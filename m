Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE6651D51D;
	Mon,  7 Sep 2026 16:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788799186; cv=none; b=P5n3KNjX1I6npFTzq4a3izAq0an6/f1gTafrFW7E2Uxn6T2VEbGryVtnfSAY7qmCAyUpofGmPiQL7QaewArXEZcdLlDuKilE8TaCglF88/lxxX1+SlNKJtbXwtXw1UXTFF+V2oOU7AwY/nTn7SWTUMHifLQFW/K0tgBqbfM7CuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788799186; c=relaxed/simple;
	bh=I2/Pu/n3Ot241PzWj3Lu7otMzkTRPOVmRDBpl+KjAhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NO/fbNTRNFz5NacdKQSpm8UPk37DDHRvPBLYYZWdAnSvMC0a15/39zNHtdBdgpfuqDpOs7hVlh1lEsVJj7QUmVRJPYhrA6Pds2xYcffKkGafakTvBHUr8/Bj2tjgLiagkUn9RM2+kEY2zx9z9xi+8m36WjlWHqvJBrK7eNEloTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=m2mG2LWl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="m2mG2LWl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788799180;
	bh=pecX4PTwJVO1k/u3nyvqJANocQuoLCiiudhXRhOvrgo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m2mG2LWlfmGyy7mn7jPgrwlB9/AdRQlBEA8hahyTKQKPOGOEA0Juhlog2oAcbd0kJ
	 epEybWtPLEfkyL+HwkgJizykaTPZRn6LUyEeX1XuDYdIMLPbrr8H4xHNq7+VT0mwJ3
	 WRGovz9gFSBNDyu8mlbxfnow3AYMblAeowjqgtQK8LKOuUb+6/fmC+rNggmtaGOFTw
	 NUTsGslHgMoB3QvkdL2gDnEAtFtolUAhcetQa8ygDyqT6SluSJPP03zYPlDmTYI4FX
	 F7Iyew0NlCKHKfIZe4kbhHc2OsDPt+Yb1aMITafJGK+O8JbauDxdt0LhLn/dwRnSuC
	 T9/df2yKdPmbw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A936D607A3;
	Mon,  7 Sep 2026 18:39:40 +0200 (CEST)
Date: Mon, 7 Sep 2026 18:39:38 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: HACKE-RC <rc@rexion.ai>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/4] netfilter: nf_conntrack_amanda: use
 nf_ct_helper_parse_port()
Message-ID: <ap7oygJrnJ0YcE7V@chamomile>
References: <afSBzDE-caw3Dsr1@orbyte.nwl.cc>
 <20260503083220.630655-1-rc@rexion.ai>
 <20260503083220.630655-4-rc@rexion.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260503083220.630655-4-rc@rexion.ai>

Hi Raoul,

On Sun, May 03, 2026 at 02:02:19PM +0530, HACKE-RC wrote:
> Replace simple_strtoul() with the new nf_ct_helper_parse_port() helper.
> This removes the dependency on NUL-terminated strings and adds an
> explicit port range check, rejecting port 0 and values above 65535.
> 
> Fixes: 16958900578b ("netfilter: nf_conntrack_amanda: the match is called 'amanda', not 'AMANDA'")
> Signed-off-by: HACKE-RC <rc@rexion.ai>

We need a real name here, please target this to the nf/nf-next trees.

Thanks.
> ---
>  net/netfilter/nf_conntrack_amanda.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
> index d2c09e8dd..30b5c4b84 100644
> --- a/net/netfilter/nf_conntrack_amanda.c
> +++ b/net/netfilter/nf_conntrack_amanda.c
> @@ -88,11 +88,12 @@ static int amanda_help(struct sk_buff *skb,
>  	struct nf_conntrack_expect *exp;
>  	struct nf_conntrack_tuple *tuple;
>  	unsigned int dataoff, start, stop, off, i;
> +	nf_nat_amanda_hook_fn *nf_nat_amanda;
>  	char pbuf[sizeof("65535")], *tmp;
> +	int ret = NF_ACCEPT;
>  	u_int16_t len;
> +	u16 parsed_port;
>  	__be16 port;
> -	int ret = NF_ACCEPT;
> -	nf_nat_amanda_hook_fn *nf_nat_amanda;
>  
>  	/* Only look at packets from the Amanda server */
>  	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
> @@ -132,10 +133,10 @@ static int amanda_help(struct sk_buff *skb,
>  			break;
>  		pbuf[len] = '\0';
>  
> -		port = htons(simple_strtoul(pbuf, &tmp, 10));
> -		len = tmp - pbuf;
> -		if (port == 0 || len > 5)
> +		if (nf_ct_helper_parse_port(pbuf, len, &parsed_port, &tmp))
>  			break;
> +		port = htons(parsed_port);
> +		len = tmp - pbuf;
>  
>  		exp = nf_ct_expect_alloc(ct);
>  		if (exp == NULL) {
> -- 
> 2.54.0
> 
