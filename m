From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 06/13] Port redirection support for TCP
Date: Mon, 01 Oct 2007 00:26:33 +0200
Message-ID: <47002299.9040400@trash.net>
References: <20070930205141.10969.27205.stgit@nessa.odu> <20070930205243.10969.90629.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49183 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbXI3WaO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:30:14 -0400
In-Reply-To: <20070930205243.10969.90629.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

KOVACS Krisztian wrote:
> Current TCP code relies on the local port of the listening socket
> being the same as the destination address of the incoming
> connection. Port redirection used by many transparent proxying
> techniques obviously breaks this, so we have to store the original
> destination port address.
>
> This patch extends struct inet_request_sock and stores the incoming
> destination port value there. It also modifies the handshake code to
> use that value as the source port when sending reply packets.
>
> Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
> ---
>
> diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
> index e86832d..5339089 100644
> --- a/include/net/inet_sock.h
> +++ b/include/net/inet_sock.h
> @@ -65,6 +65,9 @@ struct inet_request_sock {
>  #endif
>  	__be32			loc_addr;
>  	__be32			rmt_addr;
> +#if defined(CONFIG_NETFILTER_TPROXY) || defined(CONFIG_NETFILTER_TPROXY_MODULE)
> +	__be16			loc_port;
> +#endif
>  	__be16			rmt_port;
>  	u16			snd_wscale : 4, 
>  				rcv_wscale : 4, 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 54053de..927d235 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -980,6 +980,9 @@ static inline void tcp_openreq_init(struct request_sock *req,
>  	ireq->acked = 0;
>  	ireq->ecn_ok = 0;
>  	ireq->rmt_port = tcp_hdr(skb)->source;
> +#if defined(CONFIG_NETFILTER_TPROXY) || defined(CONFIG_NETFILTER_TPROXY_MODULE)
> +	ireq->loc_port = tcp_hdr(skb)->dest;
> +#endif
>  }
>  
>  extern void tcp_enter_memory_pressure(void);
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index 26b9dbe..f47d966 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -502,6 +502,10 @@ struct sock *inet_csk_clone(struct sock *sk, const struct request_sock *req,
>  		newicsk->icsk_bind_hash = NULL;
>  
>  		inet_sk(newsk)->dport = inet_rsk(req)->rmt_port;
> +#if defined(CONFIG_IP_NF_TPROXY) || defined(CONFIG_IP_NF_TPROXY_MODULE)
> +		inet_sk(newsk)->num = ntohs(inet_rsk(req)->loc_port);
>   
> +		inet_sk(newsk)->sport = inet_rsk(req)->loc_port;
>   

Why do you store the port twice here?
> ipv4/tcp_output.c
> index 666d8a5..69dd230 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -2153,7 +2153,11 @@ struct sk_buff * tcp_make_synack(struct sock *sk, struct dst_entry *dst,
>  	th->syn = 1;
>  	th->ack = 1;
>  	TCP_ECN_make_synack(req, th);
> +#if defined(CONFIG_IP_NF_TPROXY) || defined(CONFIG_IP_NF_TPROXY_MODULE)
> +	th->source = ireq->loc_port;
> +#else
>  	th->source = inet_sk(sk)->sport;
> +#endif
>   
I think this should simply use loc_port unconditionally.

