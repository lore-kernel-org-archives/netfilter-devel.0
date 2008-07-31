From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: TCP connection tracking timeout
Date: Thu, 31 Jul 2008 20:19:35 +0800
Message-ID: <20080731121935.GA8324@gondor.apana.org.au>
References: <488EA0F1.2050906@trash.net> <488EA3FE.7050503@trash.net> <20080729060105.GA16797@gondor.apana.org.au> <488EB4F1.60806@trash.net> <20080729090737.GA18046@gondor.apana.org.au> <Pine.LNX.4.64.0807291420590.1378@blackhole.kfki.hu> <20080729133444.GA19876@gondor.apana.org.au> <Pine.LNX.4.64.0807292135290.1679@blackhole.kfki.hu> <20080730013554.GA25736@gondor.apana.org.au> <Pine.LNX.4.64.0807302208030.3210@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:38030 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750828AbYGaMTq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 08:19:46 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807302208030.3210@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 30, 2008 at 11:18:42PM +0200, Jozsef Kadlecsik wrote:
>
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index 6f61261..a9b3b8f 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -911,6 +911,15 @@ static int tcp_packet(struct nf_conn *ct,
>  			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
>  				  "nf_ct_tcp: invalid state ");
>  		return -NF_ACCEPT;
> +	case TCP_CONNTRACK_LAST_ACK:
> +	case TCP_CONNTRACK_CLOSE_WAIT:
> +		/* Check and compensate retransmitted FIN or
> +		 * reordered ACK packets */
> +		if (old_state == TCP_CONNTRACK_FIN_WAIT
> +		    && (ct->proto.tcp.seen[dir].flags
> +		        & IP_CT_TCP_FLAG_CLOSE_INIT))
> +		        new_state = TCP_CONNTRACK_FIN_WAIT;

This is slightly better but it is still fundamentally broken.
Do we really need to establish a committee just to add a new
state? :)

We can squeeze out the requisite number of bits (4) from the
existing state variable.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
