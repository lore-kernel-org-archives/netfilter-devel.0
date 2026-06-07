Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7403890F1;
	Sun,  7 Jun 2026 09:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826131; cv=none; b=Bl1dC8Xcg8ztQDD3mbPTH9f0Rkrf5e/wVXozU1cU369gKMZuT1sCf9TTQjQFZ2ToGA+JdpSY4Jd7k8dzmZXFL5NrqPGxwFmtSk1/h9BOHThY3K2wkt42EFUjtRHHqpKu7bKzXTuKOjHdvFBjvlOl/gaczrqXS+ypBhQfkQHNwuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826131; c=relaxed/simple;
	bh=rm3s+wuYQ/bxne2+NqDXphAOsD3znMQg4FT1tTRd3pc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RGKmfsBq38ETv4IIUU33ffOIeZXUSsQnLhLwiyUUGNmfqAvgqfCwZMM4aKkO4pKU7VJuXJjkFSc750T5l0s1xNBuCRDRg/Naqe1WMsLAT6Zt6v9mTg1Ld7jnxozY3NFI7BcMJfYuPU9gRsAt8Hvqx6C1lHEGzoef1108x7JXChk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=i8IUfMym; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="i8IUfMym"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3AFD6601A1;
	Sun,  7 Jun 2026 11:55:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780826128;
	bh=os6NNiOZk0xeuYivLkV89UjzlTOROuz7qHU5o/Xbh5Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i8IUfMymsIq5kA6WEkjt8H3oyyWOtJeuLhvbqqEAGbz9sMKUXlC7nlSTAv0Q9IQSA
	 76igRozpLUrWpg0sGAys8VmN1AJkF9i6CHlNkIBZwfTWvcgQSf1agQdRWl87o8p8pI
	 USDOrrfzftJF5VHLNAr3+qUU3OQY3tSkC8CSjALmvMTB3DjXmIqUa2t2oGsq2vCjeN
	 tZqd3kSMKwk9ISZMuxIAe8emkInqMV9ZbjWs7IBz2cPRfZiN2cIm5mT3CrlwEjIDZ5
	 HsH4dnUmUkNEmzH5lLNH3esSXpGA6W5u46XWohXU4tCXu6jOe90Nj8zPc3HzgKBy2w
	 i43Ifisp0Bihg==
Date: Sun, 7 Jun 2026 11:55:25 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: flowtable: Validate iph->ihl in
 nf_flow_ip4_tunnel_proto()
Message-ID: <aiVADSnC6rBgpUnz@chamomile>
References: <20260605-nf_flow_ip4_tunnel_proto-update-v1-1-9de42230f080@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260605-nf_flow_ip4_tunnel_proto-update-v1-1-9de42230f080@kernel.org>

Hi Lorenzo,

Thanks for your patch, comments below.

On Fri, Jun 05, 2026 at 06:47:48PM +0200, Lorenzo Bianconi wrote:
> Add sanity check for iph->ihl field in nf_flow_ip4_tunnel_proto routine.
> Moreover, similar to nf_flow_ip6_tunnel_proto(), rely on
> skb_header_pointer() to validate skb header layout.
> 
> Fixes: ab427db178858 ("netfilter: flowtable: Add IPIP rx sw acceleration")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  net/netfilter/nf_flow_table_ip.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index 9c05a50d6013..9684c19da37a 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -319,15 +319,17 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
>  static bool nf_flow_ip4_tunnel_proto(struct nf_flowtable_ctx *ctx,
>  				     struct sk_buff *skb)
>  {
> -	struct iphdr *iph;
> +	struct iphdr *iph, _iph;
>  	u16 size;
>  
> -	if (!pskb_may_pull(skb, sizeof(*iph) + ctx->offset))
> +	iph = skb_header_pointer(skb, ctx->offset, sizeof(*iph), &_iph);

I think we have to update nf_flow_ip6_tunnel_proto() to call
pskb_may_pull() instead, given that this calls skb_pull() later on to
pull the tunnel header and this ensures that the IP header this will
pull will be in a linear area.

> +	if (!iph)
>  		return false;
>  
> -	iph = (struct iphdr *)(skb_network_header(skb) + ctx->offset);
> -	size = iph->ihl << 2;
> +	if (iph->ihl < 5)
> +		return false;
>  
> +	size = iph->ihl << 2;
>  	if (ip_is_fragment(iph) || unlikely(ip_has_options(size)))
>  		return false;
>  
> @@ -335,9 +337,9 @@ static bool nf_flow_ip4_tunnel_proto(struct nf_flowtable_ctx *ctx,
>  		return false;
>  
>  	if (iph->protocol == IPPROTO_IPIP) {
> -		ctx->tun.proto = IPPROTO_IPIP;
> +		ctx->tun.proto = iph->protocol;
>  		ctx->tun.hdr_size = size;
> -		ctx->offset += size;
> +		ctx->offset += ctx->tun.hdr_size;
>  	}
>  
>  	return true;
> 
> ---
> base-commit: 4aacf509e537a711fa71bca9f234e5eb6968850e
> change-id: 20260605-nf_flow_ip4_tunnel_proto-update-b31f7bff6fb9
> 
> Best regards,
> -- 
> Lorenzo Bianconi <lorenzo@kernel.org>
> 
