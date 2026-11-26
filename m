Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795653004;
	b=O73G0k9T57kVhQaRno/FAsBRljfwch5ljPBi+iHY7ZgBH9f0T9D1SoPj+yYTPVxmbN4J
	 VBJtK+LUUUysDvH4quY4De3TxVA/ADzOWkTIMzZH61OtfoM1FATXjdWTBCoko0b/yeNpO
	 SFl0WOZnuVFitfbboCZ/j41SQIp3N+3Jb6sscFM380cazlYw+YnZl+/ybQA3+WijA1NC2
	 D1PSaDQ/BjyLV3M7SumZrAcZZqzcZxZ5g4ntkc/wPgl5MOBdF6KUlqQNTE7k38Kn97+p+
	 ynXF741rOK+PfsXHWU9U4pB9Gk6//hCFLTL3nmRoC9YD3vT9A4+UydhdV4ej0RZKNXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795653004;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=EUm/LkC3y6aNyJgPXiAzr8Ej6L+SfXrNHTH4HEx0xMs=;
	b=glXsb5RogvStNgbTN2qV3LGEVwuDYO4l6ZMhPP/QiMqM3thM/iGQ+XhkBsNNAQzyfHei
	 VF2b7YgAX6OoQxEyXT7qGGj31dIRs0A/qJeQBG0K3aaCqFCmB9+RcPTvQU6vJzFbDpHDi
	 Ihuo/OkAfoeZuk0GD5TcOpWWQaMw6CgJ0gN3P5i+9xmKwXRod0K1bFukSEUMF1VRl/kSH
	 yXjtts+zNFPQ1mjObf1KmcVnHkKmc7RoxXv2s/67OuS2WHfuKPoQYxKUgc2fVhbkAlopW
	 1N9ah2/KJs2x/dErZ4BzZ2tMLd3ZpdLvONZBFf+I9Kh6M9soVLsrj9dxDGzxPeghJzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Izd6fL2m;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 9C0DD606A31E;
	Thu, 26 Nov 2026 00:30:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C0DD606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Izd6fL2m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795652995;
	bh=EUm/LkC3y6aNyJgPXiAzr8Ej6L+SfXrNHTH4HEx0xMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Izd6fL2mBUmuctoei67NbT31zbp+xSnNkNcm/T3qw9QCdyme7/d33jOV6LXzZJLTi
	 1Juf4i3FRgpu9VJon9Jmun5osfe9T/O/0FAgxXmOMm//up9mgu8+yjYTUl7BYmtOLi
	 W1WSjOj5c0Un8tkAkA/yYGlb6KpGwmTgsmb3BGQYAVNxNehKtZWS64/kg2JiBy4ry+
	 XCDRhLhAw1MXAUafrlkcLFQx9nMy6SWNiObqTueuV3bx6kpuhVUIbW9b93GWqUb0WS
	 I0sdVIPv+6AtokYUvQkdMZ27gUo+T8YmcgAwK5qUA8cYbHR3uJLxZOHLud8OYlqcoj
	 R7iR5P+hYxVig==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id D7E2660056;
	Thu, 26 Nov 2026 01:29:54 +0100 (CET)
Date: Thu, 26 Nov 2026 01:29:51 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Xiang Mei <xmei5@asu.edu>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	co+85229ab197510ca7@bugs.sh
Subject: Re: [PATCH nf] netfilter: nft_exthdr: pull the IPv6 header before
 ipv6_find_hdr()
Message-ID: <awd9f47inahmDWRP@chamomile>
References: <20261126001151.13793-1-xmei5@asu.edu>
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
In-Reply-To: <20261126001151.13793-1-xmei5@asu.edu>

On Wed, Nov 25, 2026 at 05:11:51PM -0700, Xiang Mei wrote:
> nft_exthdr_ipv6_eval() checks only skb->protocol before calling
> ipv6_find_hdr(), whose prologue reads ipv6_hdr(skb)->nexthdr from the
> linear area without a pull. The expression is usable from every family,
> and the netdev ingress hook does not normalise the skb: an 18-byte
> 802.1Q frame with an ETH_P_IPV6 inner type has no IPv6 header,

Are you referring to a skbuff with vlan offload or with the vlan tag
in the payload?

netdev calls pskb_may_pull() to ensure the IPv6 header is linear.

Then, this only works with the skb->protocol check on IPv6.

I find these text generated by LLM of very low quality for a human to
understand.

> so the read lands past skb_tail_pointer(), and an AF_PACKET frame
> larger than a page leaves the header in frags, so it lands past
> skb_headlen().
>
> With NFT_EXTHDR_F_PRESENT, it decides the result, and
> 256 "exthdr ipv6 type=T exists counter" rules hand it to an
> unprivileged user running in its own user and network namespace.
> 
> Raising the device headroom puts the skb head in kmalloc-1k. With freed
> struct net_bridge_port objects sprayed under it, a uid 1000 run on
> current mainline read back kernel-written data, byte 2 of
> WORK_STRUCT_NO_POOL in query_queue_work.data, and bits 16..23 of the
> query_queue.prev self-pointer, i.e. of direct-map heap addresses:
> 
>   read offset 570 = byte 2 of the 8-byte slot at 568
>     freed net_bridge_port (32 probes):
>       byte 0xe0 (224): 15/32
>   read offset 554 = byte 2 of the 8-byte slot at 552
>     freed net_bridge_port (32 probes):
>       byte 0x15 ( 21): 2/32
>       byte 0x21 ( 33): 2/32
>       byte 0x59 ( 89): 1/32
>       byte 0xb2 (178): 2/32
>       byte 0xc3 (195): 1/32
>       byte 0xd8 (216): 2/32
>       ...
> 
> Pull the header before the call, as act_ct, virtio_net_hdr_to_skb() and
> nft_set_pktinfo_ipv6_ingress() already do. For the ipv6 and inet
> families ipv6_rcv() has already pulled it, so this is a length check.
> 
> Cc: stable@vger.kernel.org
> Fixes: 96518518cc41 ("netfilter: add nftables")
> Reported-by: co+85229ab197510ca7@bugs.sh
> Signed-off-by: Xiang Mei <xmei5@asu.edu>
> ---
>  net/netfilter/nft_exthdr.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
> index 861bab93f435..a7c2f7553af8 100644
> --- a/net/netfilter/nft_exthdr.c
> +++ b/net/netfilter/nft_exthdr.c
> @@ -52,7 +52,8 @@ static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
>  	unsigned int offset = 0;
>  	int err;
>  
> -	if (pkt->skb->protocol != htons(ETH_P_IPV6))
> +	if (pkt->skb->protocol != htons(ETH_P_IPV6) ||
> +	    !pskb_network_may_pull(pkt->skb, sizeof(struct ipv6hdr)))
>  		goto err;
>  
>  	err = ipv6_find_hdr(pkt->skb, &offset, priv->type, NULL, NULL);
> -- 
> 2.43.0
> 
