Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794563274;
	b=uG8/2Om4iP6C/4AWdFPaYVmmssYFdTeQXFN9y7RpZfYNZVLIFhDC0qJSdZz4q82GQTJA
	 +1O+Qk5qu10GeJfexgsKl3WcQHeuVMA8NrTmZaB/X8ePmoML5a++JqkR5pxnKkkGKD7e5
	 eyHMPKKO3KT83u7o1gh9Tzhk4lWacNlf6YDUde/rcPgW3Sw94hTJXv7ztYmJ8hdaODDvE
	 YtpmCV8gDuUHDLya1g+iy+OQvEO8+NVkCqXzFcnpgNZN6UMeM5zawKtmxHPdkMXB6rU3J
	 TBrsqS8CVtLhfQD17kxHwCD9jakMvkRGquYBcRp9dyaTN0dWwPQ9Z8BJ0MrxIOO//lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794563274;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=Lye2VWkcbOLJPzpCzSxr8rD8nzn28pSDZgqknwmL318=;
	b=JOja/IJJ7thQ/r/kLkxGoetclTJ4jSRD8Cb01W/EiBZgc6V26ni+Q0eKtEHe49sMa6Uk
	 lHLLaVA/KW0axijlLKc1X62ICz+TvPKBuJsmmhZc5ysN6GVFGYoP20/+Yu9pdavEwx2XQ
	 JH0XIyWy8O9Et4mLgyAc5aa7RUZ04e4uOs6XaiGNB35UXaA2hF0oksjLo5vOFi/JNsZwx
	 cy+inPUzlFq+c2r4Ig74bZA0L/3LCeZg19Tsu7MieX9sZmyPmlMMooKo2YYEurXWpxsC6
	 9jvNIXPjBukaoqarBDpUp7chr2w1EzDEgUvfCdG2l3vEcWgTFS+XNYYZShleEU9LxZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=AId2hsdH;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id A1FFD606A321;
	Fri, 13 Nov 2026 09:47:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1FFD606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=AId2hsdH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794563270;
	bh=Lye2VWkcbOLJPzpCzSxr8rD8nzn28pSDZgqknwmL318=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AId2hsdHBhcIphzpyggWxENo/TtfqEjtT30C2fjiMJPnxhzPu/zQQWdi8QlONXLb7
	 mtd4AZ6jQ1SOkeVFUSyr3q1Dfrs83iguOQ1Cc/T+6bHL/OZTpbGWynWMwWjV6jXzB/
	 Yoev+1qo8lrQxUZZbKkgI0TVuO4lWN4SRoLMv0EVt3FQRaJczRYZ2mpjZQl4M4HVzq
	 PTVYnuZzMbn4ve8nx/l7AUKoiFm8OWiTL/yisTq5gdSwkL4XA9TYlU8T2Jt6srfBxb
	 mNkMW4NDjgLyJOWTTDFT9P2n1zm9a+2TzDgzBfRcvX/yicOoxW3iB9e1bOacg5+xkF
	 MxspB6nxh7pEQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id BF04E6007A;
	Fri, 13 Nov 2026 10:47:50 +0100 (CET)
Date: Fri, 13 Nov 2026 10:47:47 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, Jiri Pirko <jiri@resnulli.us>,
	Victor Nogueira <victor@mojatatu.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH net-next v2 3/4] netfilter: nft_fwd_netdev: drop the
 stale dst when steering to a device
Message-ID: <avbcwzUuzp3ZnjCM@chamomile>
References: <CORE-9NOG.v2.r0.20261112151659@mojatatu.com>
 <CORE-9NOG.v2.r0.20261112151659-3@mojatatu.com>
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
In-Reply-To: <CORE-9NOG.v2.r0.20261112151659-3@mojatatu.com>

On Thu, Nov 12, 2026 at 03:40:48PM -0500, Jamal Hadi Salim wrote:
> This is a followup of the review of the teql arp-queue fix as reported
> by Sashiko.
> 
> The issue:
> The neighbour variant of fwd rewrites skb->dev to the configured output
> device and calls neigh_xmit(), but leaves the skb's dst untouched. If that
> device's neighbour for the configured nexthop is incomplete, the packet is
> parked on the neighbour's arp_queue while the stale dst still describes the
> device the packet was routed through. Draining the queue re-looks the
> neighbour up from that dst, so the frame is built with the routed device's
> link-layer header and then transmitted on the configured device. The packet
> leaves with another device's addresses.
> 
> The Fix:
> Release the dst before the device switch. Both lookup inputs the neighbour
> transmission needs, the device and the nexthop, are supplied by the rule,
> so the route dst is never consulted. Without it the queue drain keeps the
> parking neighbour and the frame carries the configured device's addresses.
> 
> The release goes through skb_dst_drop_keep_metadata(), so encapsulation
> parameters a route carries are handed over to a metadata dst instead of
> being lost, and a metadata dst already on the packet is left in place. If
> that copy cannot be allocated the packet is dropped, never sent with the
> stale route.
> 
> Conditions to recreate the bug:
> Two network namespaces, A (10.10.0.1/24) and B (10.1.0.1/24) in one, their
> veth peers in the other with only A's peer addressed (10.10.0.2/24) so B's
> nexthop cannot be resolved by ARP. Resolve A's neighbour for 10.10.0.2 as
> permanent, then load this ruleset on A:
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
> Link: https://lore.kernel.org/netdev/avTfQjFQYR2NNdRg@chamomile/
> Reviewed-by: Victor Nogueira <victor@mojatatu.com>
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
