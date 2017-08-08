From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf-next 4/4] netfilter: rt: add support to fetch path mss
Date: Tue, 08 Aug 2017 06:37:30 -0700
Message-ID: <1502199450.4487.15.camel@edumazet-glaptop3.roam.corp.google.com>
References: <20170808131530.29194-1-fw@strlen.de>
         <20170808131530.29194-5-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36471 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752075AbdHHNhe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2017 09:37:34 -0400
Received: by mail-wm0-f68.google.com with SMTP id d40so3765004wma.3
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Aug 2017 06:37:34 -0700 (PDT)
In-Reply-To: <20170808131530.29194-5-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2017-08-08 at 15:15 +0200, Florian Westphal wrote:
> to be used in combination with tcp option set support to mimic
> iptables TCPMSS --clamp-mss-to-pmtu.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  2 +
>  net/netfilter/nft_rt.c                   | 65 ++++++++++++++++++++++++++++++++
>  2 files changed, 67 insertions(+)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 40fd199f7531..b49da72efa68 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -811,11 +811,13 @@ enum nft_meta_keys {
>   * @NFT_RT_CLASSID: realm value of packet's route (skb->dst->tclassid)
>   * @NFT_RT_NEXTHOP4: routing nexthop for IPv4
>   * @NFT_RT_NEXTHOP6: routing nexthop for IPv6
> + * @NFT_RT_TCPMSS: fetch current path tcp mss
>   */
>  enum nft_rt_keys {
>  	NFT_RT_CLASSID,
>  	NFT_RT_NEXTHOP4,
>  	NFT_RT_NEXTHOP6,
> +	NFT_RT_TCPMSS,
>  };
>  
>  /**
> diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
> index c7383d8f88d0..69ed601d6fc6 100644
> --- a/net/netfilter/nft_rt.c
> +++ b/net/netfilter/nft_rt.c
> @@ -23,6 +23,41 @@ struct nft_rt {
>  	enum nft_registers	dreg:8;
>  };
>  
> +static u16 get_tcpmss(const struct nft_pktinfo *pkt, const struct dst_entry *skbdst)
> +{
> +	u32 minlen = sizeof(struct ipv6hdr), mtu = dst_mtu(skbdst);
> +	const struct sk_buff *skb = pkt->skb;
> +	const struct nf_afinfo *ai;
> +	struct dst_entry *dst;
> +	struct flowi fl;
> +
> +	memset(&fl, 0, sizeof(fl));
> +
> +	switch (nft_pf(pkt)) {
> +	case NFPROTO_IPV4:
> +		fl.u.ip4.daddr = ip_hdr(skb)->saddr;
> +		minlen = sizeof(struct iphdr);
> +		break;
> +	case NFPROTO_IPV6:
> +		fl.u.ip6.daddr = ipv6_hdr(skb)->saddr;
> +		break;
> +	}
> +
> +	ai = nf_get_afinfo(nft_pf(pkt));
> +	if (ai)
> +		ai->route(nft_net(pkt), &dst, &fl, false);
> +

if ai is NULL,

dst is not initialized and might contain garbage.

> +	if (dst) {
> +		mtu = min(mtu, dst_mtu(dst));
> +		dst_release(dst);
> +	}
> +
> +	if (mtu <= minlen || mtu > 0xffff)
> +		return TCP_MSS_DEFAULT;
> +
> +	return mtu - minlen;




