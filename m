From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/1] netfilter: nf_ct_tcp: extend CLOSE_WAIT timeout
Date: Mon, 3 Jun 2013 18:10:32 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1306031805480.2791@blackhole.kfki.hu>
References: <1370274129-15425-1-git-send-email-zealot0630@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Zang MingJie <zealot0630@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:44339 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758926Ab3FCQKe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:10:34 -0400
In-Reply-To: <1370274129-15425-1-git-send-email-zealot0630@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 3 Jun 2013, Zang MingJie wrote:

> According to TCP RFC, there is no timer of CLOSING or CLOSE_WAIT
> state, and the half closed connection is still stable, so the
> timeout value of CLOSE_WAIT state should equal to ESTABLISHED state.

We are neither the sender, nor the receiver, but a middle box as we regard 
conntrack in netfilter. Therefore we do not (and cannot) follow the RFCs 
by letter.

So unless you prove that this is both required in real-life cases and it 
does not hurt conntrack by opening up a possible DoS factor, I say NACK.

Best regards,
Jozsef

> Signed-off-by: Zang MingJie <zealot0630@gmail.com>
> ---
>  net/netfilter/nf_conntrack_proto_tcp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index 4d4d8f1..f9dd393 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -71,7 +71,7 @@ static unsigned int tcp_timeouts[TCP_CONNTRACK_TIMEOUT_MAX] __read_mostly = {
>  	[TCP_CONNTRACK_SYN_RECV]	= 60 SECS,
>  	[TCP_CONNTRACK_ESTABLISHED]	= 5 DAYS,
>  	[TCP_CONNTRACK_FIN_WAIT]	= 2 MINS,
> -	[TCP_CONNTRACK_CLOSE_WAIT]	= 60 SECS,
> +	[TCP_CONNTRACK_CLOSE_WAIT]	= 5 DAYS,
>  	[TCP_CONNTRACK_LAST_ACK]	= 30 SECS,
>  	[TCP_CONNTRACK_TIME_WAIT]	= 2 MINS,
>  	[TCP_CONNTRACK_CLOSE]		= 10 SECS,
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
