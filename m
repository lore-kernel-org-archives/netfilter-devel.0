Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA769352C4E;
	Mon,  8 Jun 2026 23:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780960322; cv=none; b=UdaRlmkBWoee7XB4RdvwEIdRV3hQnPoqIWsDJB5JcdZ7vkDz3WrYv7pVi77VEDejSDD9CpCwRVIgUkAhJb/b/U90eULnytJoyC1YGL1xDuP+bztS+z9pjpxkUdo+B6VxRnrv5JisFotntW8yKa5upZXkiJTO8SBEaAP38OH9vaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780960322; c=relaxed/simple;
	bh=CoYaC2kz1gOIUPLCzxgbigyZqMpM6GR136SQyU/5ZAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LE7WaoCbkclBh1Jx+IlVQIgewIRhVwuomvgYgYDDPc6rcx6nXYTL6VI4/PV+HtigLephS229LCcnCfxnm9hF0a+9OI/UFFynf2rdh0MjdgdpzwKtU1Z7JADIbggGg0OncoZvfxjgTUulcEHTDyHJGXULJtWInJHtVQPb7Rn/YaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=I6SihNt5; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="I6SihNt5"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 04A4C601A0;
	Tue,  9 Jun 2026 01:11:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780960319;
	bh=JV/A69zWPQuTQ2nGVP22LDX+MvZU7+jQ+x0+XtVi+NM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I6SihNt5Z6s83NNImMYqWKP+AlN68mHgSpT0kW1U80YuEMQJL7juyFRR839R+GkQa
	 cLRAd8B/eXwZBOXh++d1EkqevbytUcTG4pz3TO0RJe1+62yfMFrXN5pOfyhhGEYPlD
	 U0rpDW9dupS8Jk96IdiSHRaIMUv7lGkzSod7PxJ4j7B9RUeujaXgaz/MiLOg3mXa/o
	 1uENn7XVqMh7e8ABQfNhyrUojBldGvC1kQ6t941UblmPuV2LW7jNBJvJJFpXdgYxz2
	 8Kvw4+bTIiFqLBUm94NX9T0z3FlNaIwAM2xgUoNQOPMSDRJivczRkBojql3Hq+D9+v
	 XZfs0YEWDddsw==
Date: Tue, 9 Jun 2026 01:11:56 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: flowtable: use pskb_may_pull() in
 nf_flow_ip6_tunnel_proto()
Message-ID: <aidMPKrm9gOcPLW-@chamomile>
References: <20260608-b4-nf_flow_ip6_tunnel_proto-update-v1-1-782c7052c8fd@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260608-b4-nf_flow_ip6_tunnel_proto-update-v1-1-782c7052c8fd@kernel.org>

Hi Lorenzo,

On Mon, Jun 08, 2026 at 07:06:52PM +0200, Lorenzo Bianconi wrote:
> Switch nf_flow_ip6_tunnel_proto() from skb_header_pointer() to
> pskb_may_pull() for header validation, aligning it with the approach
> used in nf_flow_ip4_tunnel_proto().
> Move ctx->offset update inside the IPPROTO_IPV6 conditional block since
> it should only be adjusted when a tunnel is actually detected.
> While at it, use nexthdr instead of the hardcoded IPPROTO_IPV6 constant
> when setting ctx->tun.proto.
> 
> Fixes: d98103575dcdd ("netfilter: flowtable: Add IP6IP6 rx sw acceleration")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  net/netfilter/nf_flow_table_ip.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index 9c05a50d6013..2946399ab715 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -347,15 +347,15 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
>  				     struct sk_buff *skb)
>  {
>  #if IS_ENABLED(CONFIG_IPV6)
> -	struct ipv6hdr *ip6h, _ip6h;
> +	struct ipv6hdr *ip6h;
>  	__be16 frag_off;
>  	u8 nexthdr;
>  	int hdrlen;
>  
> -	ip6h = skb_header_pointer(skb, ctx->offset, sizeof(*ip6h), &_ip6h);
> -	if (!ip6h)
> +	if (!pskb_may_pull(skb, sizeof(*ip6h) + ctx->offset))
>  		return false;
>  
> +	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + ctx->offset);
>  	if (ip6h->hop_limit <= 1)
>  		return false;

Not shown in the patch, but is there still a corner case here that
needs to be covered?

ipv6_skip_exthdr() uses skb_header_pointer() internal, then another
pskb_may_pull() is needed to make sure no other IPv6 extension header
sits between the outer and the inner IPPROTO_IPV6 header, allowing to
be in a non-linear area of the skb?        

> @@ -367,9 +367,9 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
>  

I mean:

        if (!pskb_may_pull(skb, hdrlen))
                return false;

where hdrlen is what ipv6_skip_exthdr() returns.

Then, I think it should be safe to call skb_pull() on
ctx->tun.hdr_size.

Let me know, thanks.

>  	if (nexthdr == IPPROTO_IPV6) {
>  		ctx->tun.hdr_size = hdrlen;
> -		ctx->tun.proto = IPPROTO_IPV6;
> +		ctx->tun.proto = nexthdr;
> +		ctx->offset += ctx->tun.hdr_size;
>  	}
> -	ctx->offset += ctx->tun.hdr_size;
>  
>  	return true;
>  #else
> 
> ---
> base-commit: 9772589b57e44aedc240211c5c3f7a684a034d3a
> change-id: 20260608-b4-nf_flow_ip6_tunnel_proto-update-8b64903825b4
> 
> Best regards,
> -- 
> Lorenzo Bianconi <lorenzo@kernel.org>
> 
