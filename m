From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH nf] netfilter: conntrack: lower timeout to RETRANS seconds
 if window is 0
Date: Mon, 20 Nov 2017 08:41:28 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1711200841001.29166@blackhole.kfki.hu>
References: <20171119202728.13756-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:37798 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750932AbdKTHlc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Nov 2017 02:41:32 -0500
In-Reply-To: <20171119202728.13756-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 19 Nov 2017, Florian Westphal wrote:

> When zero window is announced we can get into a situation where
> connection stays around forever:
> 
> 1. One side announces zero window.
> 2. Other side closes.
> 
> In this case, no FIN is sent (stuck in send queue).
> 
> Unless other side opens the window up again conntrack
> stays in ESTABLISHED state for a very long time.
> 
> Lets alleviate this by lowering the timeout to RETRANS (5 minutes),
> the other end should be sending zero window probes to keep the
> connection established as long as a socket still exists.
> 
> Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Thanks, Florian!
Jozsef
> ---
>  net/netfilter/nf_conntrack_proto_tcp.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index c11b04d269ea..684cc29010a0 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -1039,6 +1039,9 @@ static int tcp_packet(struct nf_conn *ct,
>  		 IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&
>  		 timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
>  		timeout = timeouts[TCP_CONNTRACK_UNACK];
> +	else if (ct->proto.tcp.last_win == 0 &&
> +		 timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
> +		timeout = timeouts[TCP_CONNTRACK_RETRANS];
>  	else
>  		timeout = timeouts[new_state];
>  	spin_unlock_bh(&ct->lock);
> -- 
> 2.13.6
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
