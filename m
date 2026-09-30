Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0657451990
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2026 20:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790801372; cv=none; b=Jhn94fIahH4aCovrs5O8Qig7x3SBZnpuWG+4BckZveciA2lM3td8Bxd0Vc/9eEw4DROjDZRfG+LupStUipIDCHgBmUZHwG6pZXiEe/Ku5Pe6LhbHYMxGsQPH6t8MXdnCo7og7hi/IGyPhequQTx9ucoCxiLwYjmvZATvV00DPWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790801372; c=relaxed/simple;
	bh=Or6gi/bNzGhyD8SZR4tr/7jt7EWtX6PN4KwofZ/Qago=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bpZ4CvrbnyVh9DytbGJHKUdSkHkb7g77sqv1o3py3kZNMmvrG+LsGuaHbEVm6yOtTgfyQp3/GWYFEfucV81dDQ8eFYK40fphPp+RZElq1hYXKA8PS9op9/bRVB1Kr2n4gt3Ijtsgi1G0gEGkuqO/cDPq8Mp93trwuQ5z2lbURnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Z+MEr5bc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Z+MEr5bc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790801365;
	bh=EVZvpQFYTs61dUK66B7iv/wmVcMJ+B6Y82NixjfW3r0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z+MEr5bcW0K9IAIlJfD/tYBKtpjoucbhW9nbUDluozYFtUM+etXVPLjE51S9M2NPT
	 qS7x1Xews7nczvs/A4XNyKjPqvPvimZox5xTgbiNEaIG+/kXbohBCr4g5xdwJX1stM
	 Adx6N94huJUZhNYhukBA0p3ta0UJVjpREux4Th7yEX/qazwO13NhtrdCGw1GxCtI/e
	 95UtP/BOCsUGbAXVgxWNETYTlC9RwUHqLkeepmSnJ/hIZPeWlT6SJRExRSmfFUN0o/
	 6DsZLWsgGwhVXNoK78j/JTm1o8GgNo9uHF+0x8AQ/cE5jOFPjHP05Fb2cERsimaytH
	 7a2KIc81LoASw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 6DAB26041C;
	Wed, 30 Sep 2026 22:49:25 +0200 (CEST)
Date: Wed, 30 Sep 2026 22:49:22 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Joas Antonio <joasantonio108@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, coreteam@netfilter.org
Subject: Re: [PATCH net] netfilter: ip6t_NPT: ensure skb is writable before
 header modification
Message-ID: <ar110uvm8qM1hGEp@chamomile>
References: <6abd5063.b622e075.2a379c.077a@mx.google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6abd5063.b622e075.2a379c.077a@mx.google.com>

Hi,

On Wed, Sep 30, 2026 at 11:09:39AM -0700, Joas Antonio wrote:
> ip6t_snpt_tg() and ip6t_dnpt_tg() modify the IPv6 source/destination
> address in-place via ip6t_npt_map_pfx() without first calling
> skb_ensure_writable().  When the skb is cloned (nflog, tee, multicast,
> tc mirred), the write hits shared data visible to other users of the
> same buffer:
> 
>   if (!ip6t_npt_map_pfx(npt, &ipv6_hdr(skb)->saddr))
>           ...
> 
> ip6t_npt_map_pfx() does the actual in-place modification:
> 
>   addr->s6_addr32[idx] &= mask;
>   addr->s6_addr32[idx] |= ~mask & npt->dst_pfx.in6.s6_addr32[idx];
> 
> Neither target checks writability first.  Every comparable target in
> the tree does: ipt_ECN (line 32), ebt_dnat (line 24), ebt_snat
> (line 25), xt_TCPOPTSTRIP (line 52).
> 
> Additionally, the ICMPv6 bounced header path uses
> skb_header_pointer(), which returns a pointer to a stack-local copy
> for nonlinear skbs.  ip6t_npt_map_pfx() then modifies the copy;
> changes are silently lost and the inner IPv6 header in ICMPv6 error
> messages is never translated.
> 
> Fix both by adding skb_ensure_writable() before each target function
> operates, and replacing the skb_header_pointer() + helper pattern
> with skb_ensure_writable() up to the inner header offset followed by
> a direct pointer.  Remove the now-unused icmpv6_bounced_ipv6hdr().
> 
> Fixes: 8a91bb0c304b ("netfilter: ip6tables: add stateless IPv6-to-IPv6 Network Prefix Translation target")
> Signed-off-by: Joas Antonio <joasantonio108@gmail.com>
> ---
> Testing: verified with NFLOG + SNPT/DNPT rules on a namespace pair
> that cloned skb data is no longer corrupted after translation.
> Nonlinear-skb path confirmed by forcing GRO aggregation on the
> ingress side; inner ICMPv6 header now carries the translated prefix.

This is nf-next material.

>  net/ipv6/netfilter/ip6t_NPT.c | 66 ++++++++++++++++++--------------
>  1 file changed, 37 insertions(+), 29 deletions(-)
> 
> diff --git a/net/ipv6/netfilter/ip6t_NPT.c b/net/ipv6/netfilter/ip6t_NPT.c
> index XXXXXXX..XXXXXXX 100644
> --- a/net/ipv6/netfilter/ip6t_NPT.c
> +++ b/net/ipv6/netfilter/ip6t_NPT.c
> @@ -78,57 +78,65 @@ static bool ip6t_npt_map_pfx(const struct ip6t_npt_tginfo *npt,
>  	return true;
>  }
> 
> -static struct ipv6hdr *icmpv6_bounced_ipv6hdr(struct sk_buff *skb,
> -					      struct ipv6hdr *_bounced_hdr)
> -{
> -	if (ipv6_hdr(skb)->nexthdr != IPPROTO_ICMPV6)
> -		return NULL;
> -
> -	if (!icmpv6_is_err(icmp6_hdr(skb)->icmp6_type))
> -		return NULL;
> -
> -	return skb_header_pointer(skb,
> -				  skb_transport_offset(skb) + sizeof(struct icmp6hdr),
> -				  sizeof(struct ipv6hdr),
> -				  _bounced_hdr);
> -}
> -
>  static unsigned int
>  ip6t_snpt_tg(struct sk_buff *skb, const struct xt_action_param *par)
>  {
>  	const struct ip6t_npt_tginfo *npt = par->targinfo;
> -	struct ipv6hdr _bounced_hdr;
> -	struct ipv6hdr *bounced_hdr;
>  	struct in6_addr bounced_pfx;
> +	struct ipv6hdr *bounced_hdr;
> +	unsigned int bounced_off;
> +
> +	if (skb_ensure_writable(skb, sizeof(struct ipv6hdr)))
> +		return NF_DROP;
> 
>  	if (!ip6t_npt_map_pfx(npt, &ipv6_hdr(skb)->saddr)) {
>  		icmpv6_send(skb, ICMPV6_PARAMPROB, ICMPV6_HDR_FIELD,
>  			    offsetof(struct ipv6hdr, saddr));
>  		return NF_DROP;
>  	}
> 
>  	/* rewrite dst addr of bounced packet which was sent to dst range */
> -	bounced_hdr = icmpv6_bounced_ipv6hdr(skb, &_bounced_hdr);
> -	if (bounced_hdr) {
> -		ipv6_addr_prefix(&bounced_pfx, &bounced_hdr->daddr, npt->src_pfx_len);
> -		if (ipv6_addr_cmp(&bounced_pfx, &npt->src_pfx.in6) == 0)
> -			ip6t_npt_map_pfx(npt, &bounced_hdr->daddr);
> -	}
> +	if (ipv6_hdr(skb)->nexthdr != IPPROTO_ICMPV6 ||
> +	    !icmpv6_is_err(icmp6_hdr(skb)->icmp6_type))
> +		return XT_CONTINUE;
> +
> +	bounced_off = skb_transport_offset(skb) + sizeof(struct icmp6hdr);
> +	if (skb_ensure_writable(skb, bounced_off + sizeof(struct ipv6hdr)))
> +		return XT_CONTINUE;
> +
> +	bounced_hdr = (struct ipv6hdr *)(skb_transport_header(skb) +
> +					  sizeof(struct icmp6hdr));
> +	ipv6_addr_prefix(&bounced_pfx, &bounced_hdr->daddr, npt->src_pfx_len);
> +	if (ipv6_addr_cmp(&bounced_pfx, &npt->src_pfx.in6) == 0)
> +		ip6t_npt_map_pfx(npt, &bounced_hdr->daddr);
> 
>  	return XT_CONTINUE;
>  }
> 
>  static unsigned int
>  ip6t_dnpt_tg(struct sk_buff *skb, const struct xt_action_param *par)
>  {
>  	const struct ip6t_npt_tginfo *npt = par->targinfo;
> -	struct ipv6hdr _bounced_hdr;
> -	struct ipv6hdr *bounced_hdr;
>  	struct in6_addr bounced_pfx;
> +	struct ipv6hdr *bounced_hdr;
> +	unsigned int bounced_off;
> +
> +	if (skb_ensure_writable(skb, sizeof(struct ipv6hdr)))
> +		return NF_DROP;
> 
>  	if (!ip6t_npt_map_pfx(npt, &ipv6_hdr(skb)->daddr)) {
>  		icmpv6_send(skb, ICMPV6_PARAMPROB, ICMPV6_HDR_FIELD,
>  			    offsetof(struct ipv6hdr, daddr));
>  		return NF_DROP;
>  	}
> 
>  	/* rewrite src addr of bounced packet which was sent from dst range */
> -	bounced_hdr = icmpv6_bounced_ipv6hdr(skb, &_bounced_hdr);
> -	if (bounced_hdr) {
> -		ipv6_addr_prefix(&bounced_pfx, &bounced_hdr->saddr, npt->src_pfx_len);
> -		if (ipv6_addr_cmp(&bounced_pfx, &npt->src_pfx.in6) == 0)
> -			ip6t_npt_map_pfx(npt, &bounced_hdr->saddr);
> -	}
> +	if (ipv6_hdr(skb)->nexthdr != IPPROTO_ICMPV6 ||
> +	    !icmpv6_is_err(icmp6_hdr(skb)->icmp6_type))
> +		return XT_CONTINUE;
> +
> +	bounced_off = skb_transport_offset(skb) + sizeof(struct icmp6hdr);
> +	if (skb_ensure_writable(skb, bounced_off + sizeof(struct ipv6hdr)))
> +		return XT_CONTINUE;
> +
> +	bounced_hdr = (struct ipv6hdr *)(skb_transport_header(skb) +
> +					  sizeof(struct icmp6hdr));
> +	ipv6_addr_prefix(&bounced_pfx, &bounced_hdr->saddr, npt->src_pfx_len);
> +	if (ipv6_addr_cmp(&bounced_pfx, &npt->src_pfx.in6) == 0)
> +		ip6t_npt_map_pfx(npt, &bounced_hdr->saddr);
> 
>  	return XT_CONTINUE;
>  }
> --
> 2.43.0
