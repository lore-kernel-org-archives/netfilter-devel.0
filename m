From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 05/13] Handle TCP SYN+ACK/ACK/RST transparency
Date: Mon, 01 Oct 2007 00:23:14 +0200
Message-ID: <470021D2.7030002@trash.net>
References: <20070930205141.10969.27205.stgit@nessa.odu> <20070930205233.10969.32752.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49118 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbXI3W0z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:26:55 -0400
In-Reply-To: <20070930205233.10969.32752.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

KOVACS Krisztian wrote:
> The TCP stack sends out SYN+ACK/ACK/RST reply packets in response to
> incoming packets. The non-local source address check on output bites
> us again, as replies for transparently redirected traffic won't have a
> chance to leave the node.
>
> This patch selectively sets the FLOWI_FLAG_ANYSRC flag when doing
> the route lookup for those replies. Transparent replies are enabled if
> the listening socket has the transparent socket flag set.
>
> Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
> ---
>
> diff --git a/include/net/request_sock.h b/include/net/request_sock.h
> index 7aed02c..b9c8974 100644
> --- a/include/net/request_sock.h
> +++ b/include/net/request_sock.h
> @@ -34,7 +34,8 @@ struct request_sock_ops {
>  				       struct request_sock *req,
>  				       struct dst_entry *dst);
>  	void		(*send_ack)(struct sk_buff *skb,
> -				    struct request_sock *req);
> +				    struct request_sock *req,
> +				    int reply_flags);
>   

How about putting the flags in the request_sock?

> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index fbe7714..26b9dbe 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -321,6 +321,8 @@ struct dst_entry* inet_csk_route_req(struct sock *sk,
>  					.saddr = ireq->loc_addr,
>  					.tos = RT_CONN_FLAGS(sk) } },
>  			    .proto = sk->sk_protocol,
> +			    .flags = inet_sk(sk)->transparent ?
> +					FLOWI_FLAG_ANYSRC : 0,
>   

Introducing a function (sk_flowi_flags(sk) or something) might make
it a bit nicer to look at.

> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index e089a97..7ae47e6 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -625,7 +626,7 @@ static void tcp_v4_send_reset(struct sock *sk, struct sk_buff *skb)
>  
>  static void tcp_v4_send_ack(struct tcp_timewait_sock *twsk,
>  			    struct sk_buff *skb, u32 seq, u32 ack,
> -			    u32 win, u32 ts)
> +			    u32 win, u32 ts, int reply_flags)
>  {
>  	struct tcphdr *th = tcp_hdr(skb);
>  	struct {
> @@ -701,36 +702,37 @@ static void tcp_v4_send_ack(struct tcp_timewait_sock *twsk,
>  					arg.iov[0].iov_len);
>  	}
>  #endif
> +	arg.flags = reply_flags;
>   

Shouldn't this use twsk->transparent?
>  	arg.csum = csum_tcpudp_nofold(ip_hdr(skb)->daddr,
>  				      ip_hdr(skb)->saddr, /* XXX */
>  				      arg.iov[0].iov_len, IPPROTO_TCP, 0);
>  	arg.csumoffset = offsetof(struct tcphdr, check) / 2;
>  	if (twsk)
>  		arg.bound_dev_if = twsk->tw_sk.tw_bound_dev_if;
> -
>  	ip_send_reply(tcp_socket->sk, skb, &arg, arg.iov[0].iov_len);
Unrelated whitespace change

