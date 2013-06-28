From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Checksum of an IPv6 UDP packet is mandatory
Date: Fri, 28 Jun 2013 19:10:20 +0200
Message-ID: <20130628171020.GA18080@localhost>
References: <1372436119-61481-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57862 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964Ab3F1RKZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Jun 2013 13:10:25 -0400
Content-Disposition: inline
In-Reply-To: <1372436119-61481-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jun 29, 2013 at 12:15:19AM +0800, Changli Gao wrote:
> Checksum of an IPv6 UDP packet is mandatory.

There is some discussion on this:

http://tools.ietf.org/html/rfc6936

"The inability to use an IPv6 datagram with a zero UDP checksum has
 been found to be a real problem for certain classes of application,
 primarily tunnel applications."

> ---
>  net/netfilter/nf_conntrack_proto_udp.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
> index 9d7721c..31dc854 100644
> --- a/net/netfilter/nf_conntrack_proto_udp.c
> +++ b/net/netfilter/nf_conntrack_proto_udp.c
> @@ -134,8 +134,15 @@ static int udp_error(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
>  	}
>  
>  	/* Packet with no checksum */
> -	if (!hdr->check)
> +	if (!hdr->check) {
> +		if (pf == PF_INET6) {
> +			if (LOG_INVALID(net, IPPROTO_UDP))
> +				nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
> +					       "nf_ct_udp: bad UDP checksum ");
> +			return -NF_ACCEPT;
> +		}
>  		return NF_ACCEPT;
> +	}
>  
>  	/* Checksum invalid? Ignore.
>  	 * We skip checking packets on the outgoing path
> -- 
> 1.7.9.5
> 
