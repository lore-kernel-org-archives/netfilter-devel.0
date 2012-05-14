From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] netfilter: nf_ct_tcp: extend log message for invalid
 ignored packets
Date: Mon, 14 May 2012 15:06:48 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1205141505550.26263@blackhole.kfki.hu>
References: <1336999959-20480-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:50941 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335Ab2ENNGu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 May 2012 09:06:50 -0400
In-Reply-To: <1336999959-20480-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 14 May 2012, pablo@netfilter.org wrote:

> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Extend log message if packets are ignored to include the TCP state, ie.
> replace:
> 
> [ 3968.070196] nf_ct_tcp: invalid packet ignored IN= OUT= SRC=...
> 
> by:
> 
> [ 3968.070196] nf_ct_tcp: invalid packet ignored in state ESTABLISHED IN= OUT= SRC=...
> 
> This information is useful to know in what state we were while ignoring the
> packet.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_conntrack_proto_tcp.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index 4dfbfa8..21ff1a9 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -952,7 +952,8 @@ static int tcp_packet(struct nf_conn *ct,
>  		spin_unlock_bh(&ct->lock);
>  		if (LOG_INVALID(net, IPPROTO_TCP))
>  			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
> -				  "nf_ct_tcp: invalid packet ignored ");
> +				  "nf_ct_tcp: invalid packet ignored in "
> +				  "state %s ", tcp_conntrack_names[old_state]);
>  		return NF_ACCEPT;
>  	case TCP_CONNTRACK_MAX:
>  		/* Invalid packet */
> -- 
> 1.7.10
> 

Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
