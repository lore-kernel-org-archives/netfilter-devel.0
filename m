From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] Add bridged IPv6 packet filtering
Date: Thu, 02 Sep 2004 13:40:06 +0900 (JST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200409020440.i824e8Jl020613@toshiba.co.jp>
References: <200409012234.26310.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: davem@redhat.com, netfilter-devel@lists.netfilter.org,
	usagi-core@linux-ipv6.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: bdschuym@pandora.be
In-Reply-To: <200409012234.26310.bdschuym@pandora.be>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi,

From: Bart De Schuymer <bdschuym@pandora.be>
Date: Wed, 1 Sep 2004 22:34:26 +0200

> Hi Dave,
> 
> >From reading Yasuyuki's reply and the specific code, the IPv6 checks
> before giving a bridged packet to ip6tables should now be accurate.
> 
> These are the changes made to the original patch:
> 
> - *	Aug 28 2004: add IPv6 filtering (bdschuym)
> + *	Sep 01 2004: add IPv6 filtering (bdschuym)
> 
> @@ -321,11 +321,12 @@ static unsigned int br_nf_pre_routing_ip
>  			goto inhdr_error;
>  	}
>  	if (hdr->nexthdr == NEXTHDR_HOP) {
> -		skb->h.raw = (u8*)(hdr+1);
> -#if 0
> -		if (ipv6_parse_hopopts(skb, offsetof(struct ipv6hdr, nexthdr))<0)
> +		/* We only check the length. A bridge shouldn't do any
> +		 * hop-by-hop stuff anyway. */
> +		unsigned char *raw = (u8*)(skb->nh.ipv6h+1);
> +
> +		if ((raw + ((int)(raw[1]+1)<<3)) - skb->data > skb_headlen(skb))
>  			goto inhdr_error;
> -#endif

You forgot to find "Jumbo Payload Option" in Hop-by-Hop Options header.
Other options may exist in this header.

And please truncate packet if actual packet length is greater than
Jumbo Payload Length + IPv6 header length.

Maybe you need to write the function that finds "Jumbo Payload Option" by
parsing Hop-by-Hop Options header, checks the payload length, and truncates
packet if necessary.

I think it is not preferable to call ipv6_parse_hopopts() at this point.
Because Hop-by-Hop Options header may include other options and
ipv6_hop_jumbo() may send ICMPv6 error.

Regards,
