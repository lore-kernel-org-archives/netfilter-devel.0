Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099E917C21C;
	Sun, 12 Apr 2026 12:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775998066; cv=none; b=douVZ8ZsXw3NKyRKc3DlkmJJS1tJYH1/AKy2mLUQn/e+PCa8tYwC+/E3LuGbT1hPYlBAxT5Im1y0uOi/VnLeC1CykANLqkzoImWlv6LUnnYu3yv3hVNvFiV369fed8UdqeuVJsOU+FboTYVgwB3sYv20rfLD+c+q8TI8CxfHAsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775998066; c=relaxed/simple;
	bh=FdH4zexPhqFY8dtxq69tNks3/MwjtwjeU80RC3u0gDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H1mj44RSlNn4rJseHbl3Cdmm4QL+/Go3H3SCdbkSFVxrixk8/QdtxB41V/bL8DRqChsx/9nz73q2LipDMzdumD+qD4rSJcPNftG6AhwOxSPlFkGDz7YPcSsGw8iBxkK100i1sa0NFd/WQ/TpF5SI3mJ8oYfEHdfm+N6x+vPrZuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mjZ5Kexb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mjZ5Kexb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0D7C19424;
	Sun, 12 Apr 2026 12:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775998065;
	bh=FdH4zexPhqFY8dtxq69tNks3/MwjtwjeU80RC3u0gDY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mjZ5KexbotRv0QbhzvfuiYdW2yxnT3KacxFk5VAePsBTZppYRK0zG64wK2x4730PL
	 FyQYw+VdHXJP5Aulj7lhmjHq/1JH3kN+e9JOQ2Z2v604n0O8Lv/R4Yt9gcUoyXyD6k
	 MvK6kS6CgzxrH+oSCg+klMmv2W3ctRpIrKuG7xmR6iaxHM+zzOCQ4asNzk/Abo9q5d
	 THuEv6imDbDelJcUoHb3CECB7lqtc08g3x0b8A3tjVujRxVI2adTfN+9CQCt1SXJfk
	 A1EvP0TKRXhbewarF2CZ6vmi8Ao257oFl6+yz5gGn8KtLzNEExjE/pztSa0i70NO+4
	 u5UmUDTwyceiQ==
Date: Sun, 12 Apr 2026 13:47:40 +0100
From: Simon Horman <horms@kernel.org>
To: Weiming Shi <bestswngs@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S . Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH nf] netfilter: arp_tables: fix IEEE1394 ARP payload
 parsing in arp_packet_match()
Message-ID: <20260412124740.GG469338@kernel.org>
References: <20260408073515.79296-2-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408073515.79296-2-bestswngs@gmail.com>

On Wed, Apr 08, 2026 at 03:35:16PM +0800, Weiming Shi wrote:
> arp_packet_match() unconditionally parses the ARP payload assuming two
> hardware addresses are present (source and target). However,
> IPv4-over-IEEE1394 ARP (RFC 2734) omits the target hardware address
> field, and arp_hdr_len() already accounts for this by returning a
> shorter length for ARPHRD_IEEE1394 devices.
> 
> As a result, on IEEE1394 interfaces arp_packet_match() advances past a
> nonexistent target hardware address and reads the wrong bytes for both
> the target device address comparison and the target IP address. This
> causes arptables rules to match against garbage data, leading to
> incorrect filtering decisions: packets that should be accepted may be
> dropped and vice versa.
> 
> The ARP stack in net/ipv4/arp.c (arp_create and arp_process) already
> handles this correctly by skipping the target hardware address for
> ARPHRD_IEEE1394. Apply the same pattern to arp_packet_match().
> 
> Fixes: 6752c8db8e0c ("firewire net, ipv4 arp: Extend hardware address and remove driver-level packet inspection.")
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
>  net/ipv4/netfilter/arp_tables.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
> index 1cdd9c28ab2da..4b2392bdcd0a6 100644
> --- a/net/ipv4/netfilter/arp_tables.c
> +++ b/net/ipv4/netfilter/arp_tables.c
> @@ -86,7 +86,7 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
>  				   const struct arpt_arp *arpinfo)
>  {
>  	const char *arpptr = (char *)(arphdr + 1);
> -	const char *src_devaddr, *tgt_devaddr;
> +	const char *src_devaddr, *tgt_devaddr = NULL;

I think that it's more in keeping with Kernel code practices
to set tgt_devaddr conditionally.

>  	__be32 src_ipaddr, tgt_ipaddr;
>  	long ret;
>  
> @@ -110,13 +110,23 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
>  	arpptr += dev->addr_len;
>  	memcpy(&src_ipaddr, arpptr, sizeof(u32));
>  	arpptr += sizeof(u32);
> -	tgt_devaddr = arpptr;
> -	arpptr += dev->addr_len;
> +	switch (dev->type) {
> +#if IS_ENABLED(CONFIG_FIREWIRE_NET)
> +	case ARPHRD_IEEE1394:
> +		break;
> +#endif
> +	default:
> +		tgt_devaddr = arpptr;
> +		arpptr += dev->addr_len;
> +		break;
> +	}

While I acknowledge this isn't the approach taken in arp_hdr_len()
I think it would be nicer to use the following construction
which will give build coverage to all paths regardless of if
CONFIG_FIREWIRE_NET is set or not.

	if (IS_ENABLED(CONFIG_FIREWIRE_NET) && dev->type == ARPHRD_IEEE1394) {
		tgt_devaddr = NULL;
	} else {
		tgt_devaddr = arpptr;
		arpptr += dev->addr_len;
	}

Also, I would include a blank line before the if condition.

>  	memcpy(&tgt_ipaddr, arpptr, sizeof(u32));
>  
>  	if (NF_INVF(arpinfo, ARPT_INV_SRCDEVADDR,
>  		    arp_devaddr_compare(&arpinfo->src_devaddr, src_devaddr,
> -					dev->addr_len)) ||
> +					dev->addr_len)))
> +		return 0;
> +	if (tgt_devaddr &&
>  	    NF_INVF(arpinfo, ARPT_INV_TGTDEVADDR,
>  		    arp_devaddr_compare(&arpinfo->tgt_devaddr, tgt_devaddr,
>  					dev->addr_len)))
> -- 
> 2.43.0
> 
