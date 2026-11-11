Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794432840;
	b=ILqNxA6z48kdJmkvqAqsSUezmwAdfp002DECsQnssjSbH9PodaACk2O+AlMStmNrTDJa
	 SwhN5HF/TDEAsxrf9JCXY/ICIrO9H5gGpV3VQgPoRrenwKCqAPvkGCttsglmlh6EdvRg8
	 0GZK1PPrcGWBsCN1QnHYxu1Jie+o38yw/yzLYIQaJWR5sAfsDVNla6suNVUmcQfxufD9s
	 nmrRqJoS08wFqGz5bgtU3POmy9HwLN3u060wpVr9S2MA4KiBRMWe4fcTuScdj8ujsw7w1
	 Z5IBQWO0lRNO9k3oVxJQVlaIavPiHWPdsBx8RIicEHyeveseL3IriZd6KEDDpMmSIFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794432840;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=XsrLygMXUO8t6Dug7THlfgRGdAUk0g1VTR1xNcAcyYQ=;
	b=j/Yz9ErKaLEbyEjyw7MxkkME0jOrktxwEZzaPc827lk/101v4YPCKfcpghmYMAuZWVPh
	 oMMWUAEJE0n5Bg1qFspQi6vm9jRYW/1eidoCo03AO86T2HyZVaABXBjoCvdq/MXvfkmpz
	 hOvKRlzcAM66t/yuZLRJiReYJlgsGQR1XR0V11LV/raV58YZDGUYs4lIb/i9TZx/llMfj
	 tT2bDALHRIUepeQcX4E4hm+VJSMDXb78I8LJgnXNPjlGvXRANt+dPa69jgrTBV6xRNPoN
	 LPMib2iSLCrexA7zAOH3P8q2tu0h4azR9vrwGyXzV7glL0dhVD/qMnOdnK/nT9BVLgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=FiUqzxbo;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id F16C8606A31C;
	Wed, 11 Nov 2026 21:33:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F16C8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=FiUqzxbo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794432836;
	bh=XsrLygMXUO8t6Dug7THlfgRGdAUk0g1VTR1xNcAcyYQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FiUqzxbojTrjYQStNsMK4iPs7PDMTYrw1WVtRyWjKQgvgspoTYGhdDgKqKg3VXaR2
	 Z4xolKhdeZazfy/7IBx81+2Xk5TCYJJh/Iba/uGQX7iONDs9+sjyyOfep4uLrBANP4
	 m3nCD8V+YdNjciB4SDqbATGOhucXByeU5wMeMi6+y4S+n45/poO5wfAcvrrUIftMaT
	 TXLe4iaJA3BbiRk3fpBSOJ5hMZsCzKwazfUuYc9/RssB80mVT613VeRSPMjQJV029D
	 uoIWXLLeNF25O8hBDqiFkCG6uTlTzVyWFGxG13yvc4hFIrN2JsetnDmQmG826geWR9
	 +3I8CTizo/Uow==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 91FA260051;
	Wed, 11 Nov 2026 22:33:56 +0100 (CET)
Date: Wed, 11 Nov 2026 22:33:54 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, Victor Nogueira <victor@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>, sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 1/2] netfilter: nft_fwd_netdev: drop the stale
 dst when steering to a device
Message-ID: <avTfQjFQYR2NNdRg@chamomile>
References: <CORE-9NOG.v1.r0.20261111073528@mojatatu.com>
 <CORE-9NOG.v1.r0.20261111073528-1@mojatatu.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CORE-9NOG.v1.r0.20261111073528-1@mojatatu.com>

On Wed, Nov 11, 2026 at 09:16:37AM -0500, Jamal Hadi Salim wrote:
> This is a followup of the review of the teql arp-queue fix as reported
> by Sashiko.
> 
> The issue: the neighbour variant of fwd rewrites skb->dev to the
> configured output device and calls neigh_xmit(), but leaves the skb's
> dst untouched. If that device's neighbour for the configured nexthop is
> incomplete, the packet is parked on the neighbour's arp_queue while the
> stale dst still describes the device the packet was routed through.
> Draining the queue re-looks the neighbour up from that dst, so the frame
> is built with the routed device's link-layer header and then transmitted
> on the configured device. The packet leaves with another device's
> addresses.
> 
> The Fix: drop the dst before the device switch. Both lookup inputs the
> neighbour transmission needs, the device and the nexthop, are supplied
> by the rule, so the route dst is never consulted. Without it the queue
> drain keeps the parking neighbour and the frame carries the configured
> device's addresses.
> 
> Conditions to recreate the bug: two network namespaces, A (10.10.0.1/24)
> and B (10.1.0.1/24) in one, their veth peers in the other with only A's
> peer addressed (10.10.0.2/24) so B's nexthop cannot be resolved by ARP.
> Resolve A's neighbour for 10.10.0.2 as permanent, then load this ruleset
> on A:
> 
>     table netdev t {
>             chain c {
>                     type filter hook egress device va priority 0
>                     policy accept
>                     fwd ip to 10.1.0.2 device vb
>             }
>     }
> 
> Send one packet to 10.10.0.2. It is parked on B's incomplete neighbour
> for 10.1.0.2; once that neighbour becomes valid the frame leaves B
> carrying A's source address and A's neighbour as the destination.
> 
> Reported-by: Sashiko (nipa) <sashiko-bot@kernel.org>
> Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/QDISC-6HS9.v3.r0.20261103062649-2@mojatatu.com
> Link: https://lore.kernel.org/netdev/QDISC-6HS9.v3.r0.20261103062649-2@mojatatu.com/
> Reviewed-by: Victor Nogueira <victor@mojatatu.com>
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
> ---
>  net/netfilter/nft_fwd_netdev.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
> index a48c2f765bba..ad4d61d64cdd 100644
> --- a/net/netfilter/nft_fwd_netdev.c
> +++ b/net/netfilter/nft_fwd_netdev.c
> @@ -175,6 +175,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
>  		}
>  	}
>  

Does this need a check for skb_dst_valid()? I think it is valid to
attach a template dst here for tunneling?

> +	skb_dst_drop(skb);
>  	skb->dev = dev;
>  	skb_clear_tstamp(skb);
>  
> -- 
> 2.43.0
> 
