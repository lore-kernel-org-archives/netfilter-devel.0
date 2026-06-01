Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C9A3955C7
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Jun 2026 10:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309771; cv=none; b=ObHKBOTqGAR3b9C5gFmdzHkP4yzlCn/+1KB0bixNOVDGZffwB6YFXJagoMussY0/GbiLlD6z0NI4shKjhPzfy4gEkNoQchNhbS40/wRJmNZ0w3VJMYZ5hvrPoHphNPj4OuSHyLTeA5bBmpHbFHI2bOgRN0q1ijxiHO/y2sK08Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309771; c=relaxed/simple;
	bh=fRMqCe8tnMgB4Ax5yI8s9QrIPh4Zo6Ottk//3i7c5iU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kIXdya48kJDXNtXqmm84Q9HmlR5HcGEd0n7c0qyTN7ZCVEF5mEkwztzwDo2EDjVrLykLraexiVIK6NEi9AJWa4KCQW6t36JDFHvCcSnxiwbYUrYtlOwMVRUYGy3m7/pRNrJOLhbzLxT6iZwE0cwCRaBJcXgmPnIRcX56bm+jt6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MC+awPPL; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MC+awPPL"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 2981260180;
	Mon,  1 Jun 2026 12:29:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780309767;
	bh=jVSNYJXDkLh5iIZgFtyL2xgN9r1CdB6bhtLo/viKkj0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MC+awPPLvfAL3Twgh39HswuCGahoWLC9N1pww083r4A59dkEfY77tcbNTb53mVk53
	 A7Zmmf/Pl8o1ZNhTkIv+jV5Id1YG/9O0eTgat5rFCqLx9HMnIRoa8s2nlZrZuTyPSn
	 BhtDH++aN/cha7Zm0ESI7FocPvzMutQf/6HaTe3662GhXtbfmCg8cf069icB7HvbE3
	 nS1gfP3Yh4yDthKTa+edCbfwUN3yhi3emdQfmfIbZfHvc2JwkYJe4fRQzprKm4yU2J
	 gGclXjECwexjl6xOV8ull/DVVAex+p1/mOIU4Mn4X1I48Jye0jBKdp1/zJR+gBRqFA
	 Zf6F3Iv9WbOfg==
Date: Mon, 1 Jun 2026 12:29:24 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Hacking <eilaimemedsnaimel@gmail.com>
Subject: Re: [PATCH nf] netfilter: bridge: ebt_redirect: don't assume bridge
 port exists
Message-ID: <ah1fBBvCPBOTQ93a@chamomile>
References: <20260601095000.595383-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260601095000.595383-1-fw@strlen.de>

Hi Florian,

On Mon, Jun 01, 2026 at 11:50:00AM +0200, Florian Westphal wrote:
> ebt_redirect_tg() dereferences br_port_get_rcu() return without a
> NULL check, causing a kernel panic when the bridge port has been
> removed between the original hook invocation and an NFQUEUE
> reinject.

Maybe more candidates for the same pattern?

net/bridge/netfilter/nft_reject_bridge.c:       br_forward(br_port_get_rcu(dev), nskb, false, true);
net/bridge/netfilter/nft_reject_bridge.c:       br_forward(br_port_get_rcu(dev), nskb, false, true);
net/bridge/netfilter/nft_reject_bridge.c:       br_forward(br_port_get_rcu(dev), nskb, false, true);
net/bridge/netfilter/nft_reject_bridge.c:       br_forward(br_port_get_rcu(dev), nskb, false, true);
net/netfilter/nfnetlink_log.c:                                   htonl(br_port_get_rcu(indev)->br->dev->ifindex)))
net/netfilter/nfnetlink_log.c:                                   htonl(br_port_get_rcu(outdev)->br->dev->ifindex)))
net/netfilter/nfnetlink_queue.c:                                         htonl(br_port_get_rcu(indev)->br->dev->ifindex)))
net/netfilter/nfnetlink_queue.c:                                         htonl(br_port_get_rcu(outdev)->br->dev->ifindex)))

So this can be fix in one patch?

Thanks

> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Hacking <eilaimemedsnaimel@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/bridge/netfilter/ebt_redirect.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
> index 307790562b49..379662961aeb 100644
> --- a/net/bridge/netfilter/ebt_redirect.c
> +++ b/net/bridge/netfilter/ebt_redirect.c
> @@ -20,16 +20,25 @@ static unsigned int
>  ebt_redirect_tg(struct sk_buff *skb, const struct xt_action_param *par)
>  {
>  	const struct ebt_redirect_info *info = par->targinfo;
> +	const unsigned char *dev_addr;
>  
>  	if (skb_ensure_writable(skb, 0))
>  		return EBT_DROP;
>  
> -	if (xt_hooknum(par) != NF_BR_BROUTING)
> -		/* rcu_read_lock()ed by nf_hook_thresh */
> -		ether_addr_copy(eth_hdr(skb)->h_dest,
> -				br_port_get_rcu(xt_in(par))->br->dev->dev_addr);
> -	else
> -		ether_addr_copy(eth_hdr(skb)->h_dest, xt_in(par)->dev_addr);
> +	if (xt_hooknum(par) != NF_BR_BROUTING) {
> +		const struct net_bridge_port *port;
> +
> +		port = br_port_get_rcu(xt_in(par));
> +		if (!port)
> +			return EBT_DROP;
> +
> +		dev_addr = port->br->dev->dev_addr;
> +	} else {
> +		dev_addr = xt_in(par)->dev_addr;
> +	}
> +
> +	ether_addr_copy(eth_hdr(skb)->h_dest, dev_addr);
> +
>  	skb->pkt_type = PACKET_HOST;
>  	return info->target;
>  }
> -- 
> 2.54.0
> 
> 
