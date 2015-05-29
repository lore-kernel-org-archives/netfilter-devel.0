From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv6 2/4] netfilter: bridge: forward IPv6 fragmented packets
Date: Fri, 29 May 2015 02:15:57 +0200
Message-ID: <20150529001557.GB705@salvia>
References: <1432801473-11867-1-git-send-email-bernhard.thaler@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
	fw@strlen.de
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42404 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732AbbE2AK5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 May 2015 20:10:57 -0400
Content-Disposition: inline
In-Reply-To: <1432801473-11867-1-git-send-email-bernhard.thaler@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 28, 2015 at 10:24:33AM +0200, Bernhard Thaler wrote:
[...]
> @@ -264,6 +265,109 @@ drop:
>  	return -1;
>  }
>  
> +/* We only check the length. A bridge shouldn't do hop-by-hop stuff anyway */
> +static int check_hbh_len(struct sk_buff *skb)
> +{
> +	unsigned char *raw = (u8 *)(ipv6_hdr(skb) + 1);
> +	u32 pkt_len;
> +	const unsigned char *nh = skb_network_header(skb);
> +	int off = raw - nh;
> +	int len = (raw[1] + 1) << 3;
> +
> +	if ((raw + len) - skb->data > skb_headlen(skb))
> +		goto bad;
> +
> +	off += 2;
> +	len -= 2;
> +
> +	while (len > 0) {
> +		int optlen = nh[off + 1] + 2;
> +
> +		switch (nh[off]) {
> +		case IPV6_TLV_PAD1:
> +			optlen = 1;
> +			break;
> +
> +		case IPV6_TLV_PADN:
> +			break;
> +
> +		case IPV6_TLV_JUMBO:
> +			if (nh[off + 1] != 4 || (off & 3) != 2)
> +				goto bad;
> +			pkt_len = ntohl(*(__be32 *)(nh + off + 2));
> +			if (pkt_len <= IPV6_MAXPLEN ||
> +			    ipv6_hdr(skb)->payload_len)
> +				goto bad;
> +			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
> +				goto bad;
> +			if (pskb_trim_rcsum(skb,
> +					    pkt_len + sizeof(struct ipv6hdr)))
> +				goto bad;
> +			nh = skb_network_header(skb);
> +			break;
> +		default:
> +			if (optlen > len)
> +				goto bad;
> +			break;
> +		}
> +		off += optlen;
> +		len -= optlen;
> +	}
> +	if (len == 0)
> +		return 0;
> +bad:
> +	return -1;
> +}
[...]
> @@ -554,91 +662,17 @@ static struct net_device *setup_pre_routing(struct sk_buff *skb)
>  	return skb->dev;
>  }
>  
> -/* We only check the length. A bridge shouldn't do any hop-by-hop stuff anyway */
> -static int check_hbh_len(struct sk_buff *skb)
> -{
> -	unsigned char *raw = (u8 *)(ipv6_hdr(skb) + 1);
> -	u32 pkt_len;
> -	const unsigned char *nh = skb_network_header(skb);
> -	int off = raw - nh;
> -	int len = (raw[1] + 1) << 3;
> -
> -	if ((raw + len) - skb->data > skb_headlen(skb))
> -		goto bad;
> -
> -	off += 2;
> -	len -= 2;
> -
> -	while (len > 0) {
> -		int optlen = nh[off + 1] + 2;
> -
> -		switch (nh[off]) {
> -		case IPV6_TLV_PAD1:
> -			optlen = 1;
> -			break;
> -
> -		case IPV6_TLV_PADN:
> -			break;
> -
> -		case IPV6_TLV_JUMBO:
> -			if (nh[off + 1] != 4 || (off & 3) != 2)
> -				goto bad;
> -			pkt_len = ntohl(*(__be32 *) (nh + off + 2));
> -			if (pkt_len <= IPV6_MAXPLEN ||
> -			    ipv6_hdr(skb)->payload_len)
> -				goto bad;
> -			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
> -				goto bad;
> -			if (pskb_trim_rcsum(skb,
> -					    pkt_len + sizeof(struct ipv6hdr)))
> -				goto bad;
> -			nh = skb_network_header(skb);
> -			break;
> -		default:
> -			if (optlen > len)
> -				goto bad;
> -			break;
> -		}
> -		off += optlen;
> -		len -= optlen;
> -	}
> -	if (len == 0)
> -		return 0;
> -bad:
> -	return -1;
> -
> -}

Please, if you need to move this code at the top of the file, do this
in a separated patch in first place as preparation.  Then, it should
follow the patch that makes real changes on the code.

This helps us to review your changes.

Thanks.
