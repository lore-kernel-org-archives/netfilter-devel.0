Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E62B341AC7;
	Wed,  8 Jul 2026 09:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783504449; cv=none; b=D/6ZF+4ydepFV9k28NkwYkXhgwLHrP9HxMQAuZqmO+eB7qyi+EjMW0wR7q8U3tncKNLp3v0af40iXyUwWBDdVvDLl7Jtmea4j0IcTlTUDH5bdwfYOO5lQiPj1jFskpQrcuoSXbNbnUbL5d13i8kfZv+2BZ57CGlXunpuX+xR4GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783504449; c=relaxed/simple;
	bh=tejKlr+zjfgFQNzsPsXyc48IioicGULxBugjvND1sf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EUlEiopC2dFfWrdjETsk4AikQTz3dvZlkO92ZyEzNVsOQpVBcL3D/kN2PA2fW9jdJuM+QcdenN4jyoyRqJz0UtF0qQTtoUAvPqD95b5YKMEy5skhJz+rGY4qTQLIeV+fL2ZtFIjL1m0L+I/y+SC0BOMaG7Khu2Tlj2Q+7H26kw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SPE2gCQl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SPE2gCQl"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 0863E60575;
	Wed,  8 Jul 2026 11:54:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783504447;
	bh=YasKGxXLIOr9y9/MbIC9v5B/sSJ0xIIqIKu8b6MBGk4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SPE2gCQln/UhOwu+P/j9D7VL59EyliZX9aC9tklGPTrWWTxjLvM+UBk6G9VZJQrgN
	 Mmm8Q4ygyazKnYJ6Qai9ftuf29rKobEr9Y1Wb32JMKdktbX66UoCWc0iThg+LOFOHy
	 VL3EWvsTJbPdfohf9SISsxozy1Y+tahUf97giGCh7AmFov5Abs1cWbOu1H7ocbuXeP
	 JQ9FK2dPDGsMNkRjMyxYfGuaWktbaU8AnpzwjoVQRZCS0t+3tsckHGUzeDEe+9wjkH
	 ISCUeswW77eNDK7HVKj/l1KDbTPrxo8eabZGAe7ztHUjv/XRWfpIm6qzwuzItnDxLB
	 RrbLihWGxJzXA==
Date: Wed, 8 Jul 2026 11:54:03 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Stanislav Fomichev <sdf.kernel@gmail.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Krishna Kumar <krikku@gmail.com>,
	Martin Karsten <mkarsten@uwaterloo.ca>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, bridge@lists.linux.dev
Subject: Re: [PATCH v12 nf-next 5/7] netfilter: nft_flow_offload:
 nft_flow_offload_eval: check thoff==0
Message-ID: <ak4eO3V3f7MEOSEU@chamomile>
References: <20260707091045.967678-1-ericwouds@gmail.com>
 <20260707091045.967678-6-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260707091045.967678-6-ericwouds@gmail.com>

Hi,

On Tue, Jul 07, 2026 at 11:10:43AM +0200, Eric Woudstra wrote:
> In case of flow through bridge, when evaluating traffic with double vlan,
> pppoe and pppoe-in-q. In this case thoff will be valid only when meta has
> been processed. If meta was not processed in nftables, thoff is zero.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  net/netfilter/nft_flow_offload.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index f8c7f9f631e48..4f68fb64f1657 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -59,7 +59,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>  	struct flow_offload *flow;
>  	enum ip_conntrack_dir dir;
>  	struct nf_conn *ct;
> -	int ret;
> +	int ret, thoff;
>  
>  	if (nft_flow_offload_skip(pkt->skb, nft_pf(pkt)))
>  		goto out;
> @@ -70,8 +70,11 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>  
>  	switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
>  	case IPPROTO_TCP:
> -		tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
> -					  sizeof(_tcph), &_tcph);
> +		thoff = nft_thoff(pkt);
> +		if (thoff == 0)
> +			goto out;

I addressed this by checking pkt->flags. I promised a helper to
Florian to improve readability here, but I still have to come back
with such patch. Basically, my assumption is that pkt->flags is unset
if no IP packet has been parsed.

> +		tcph = skb_header_pointer(pkt->skb, thoff, sizeof(_tcph),
> +					  &_tcph);
>  		if (unlikely(!tcph || tcph->fin || tcph->rst ||
>  			     !nf_conntrack_tcp_established(ct)))
>  			goto out;
> -- 
> 2.53.0
> 
