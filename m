From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/8][CONNTRACK] Introduce the pickup facilities to take
 over TCP connections
Date: Tue, 08 Aug 2006 12:33:51 +0200
Message-ID: <44D8688F.6030207@trash.net>
References: <44C61BDA.7050505@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <44C61BDA.7050505@netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira Ayuso wrote:
> This patch introduces a new flag called IPS_PICKUP that forces the
> protocol handler to pick up the required information in order to ensure
> that the connection will reach a successful state.
> 
> Two new ctnetlink attributes are also introduced to inject the window
> scale factor since TCP window tracking could need it to take over the
> connection properly.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> 
> ------------------------------------------------------------------------
> 
> [CONNTRACK] Introduce the pickup facilities to take over TCP connections
> 
> This patch introduces a new flag called IPS_PICKUP that forces the protocol
> handler to pick up the required information in order to ensure that the
> connection will reach a successful state.
> 
> Two new ctnetlink attributes are also introduced to inject the window scale
> factor since TCP window tracking could need it to take over the connection
> properly.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Index: net-2.6/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
> ===================================================================
> --- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2006-07-14 17:01:02.000000000 +0200
> +++ net-2.6/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2006-07-14 17:46:59.000000000 +0200
> @@ -346,6 +346,12 @@ static int tcp_to_nfattr(struct sk_buff 
>  	nest_parms = NFA_NEST(skb, CTA_PROTOINFO_TCP);
>  	NFA_PUT(skb, CTA_PROTOINFO_TCP_STATE, sizeof(u_int8_t),
>  		&ct->proto.tcp.state);
> +	/* window scale factor: original direction (SYN) */
> +	NFA_PUT(skb, CTA_PROTOINFO_TCP_WSCALE_ORIGINAL, sizeof(u_int8_t),
> +		&ct->proto.tcp.seen[0].td_scale);
> +	/* window scale factor: reply direction (SYN+ACK) */
> +	NFA_PUT(skb, CTA_PROTOINFO_TCP_WSCALE_REPLY, sizeof(u_int8_t),
> +		&ct->proto.tcp.seen[1].td_scale);
>  	read_unlock_bh(&tcp_lock);
>  
>  	NFA_NEST_END(skb, nest_parms);
> @@ -358,7 +364,9 @@ nfattr_failure:
>  }
>  
>  static const size_t cta_min_tcp[CTA_PROTOINFO_TCP_MAX] = {
> -	[CTA_PROTOINFO_TCP_STATE-1]	= sizeof(u_int8_t),
> +	[CTA_PROTOINFO_TCP_STATE-1]		= sizeof(u_int8_t),
> +	[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1]	= sizeof(u_int8_t),
> +	[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]	= sizeof(u_int8_t),
>  };
>  
>  static int nfattr_to_tcp(struct nfattr *cda[], struct ip_conntrack *ct)
> @@ -382,6 +390,24 @@ static int nfattr_to_tcp(struct nfattr *
>  	write_lock_bh(&tcp_lock);
>  	ct->proto.tcp.state = 
>  		*(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_STATE-1]);
> +	/* window scale factor: original direction (SYN) */
> +	if (tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1])
> +		ct->proto.tcp.seen[0].td_scale = 
> +		*(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1]);
> +	/* window scale factor: reply direction (SYN+ACK) */
> +	if (tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1])
> +		ct->proto.tcp.seen[1].td_scale = 
> +		*(u_int8_t *)NFA_DATA(tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]);
> +	/* set WINDOW_SCALE flag */
> +	if (tb[CTA_PROTOINFO_TCP_WSCALE_ORIGINAL-1] ||
> +	    tb[CTA_PROTOINFO_TCP_WSCALE_REPLY-1]) {
> +		/*
> +		 * we have to assume that both sides have
> +		 * sent Window Scale options (RFC 1323)
> +		 */
> +		ct->proto.tcp.seen[0].flags |=
> +		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_WINDOW_SCALE;


This will also set all other flags from seen[1] in seen[0]. RFC 1323
also says quite the opposite, both sides must send a wscale option to
enable it. For unreplied connections this will do the wrong thing.
And we should have an option to unset it, also for the case where
we're synchronizing the state of an unreplied connection. I also
think it would be better to add netlink attributes for the entire
flags mask, for example IP_CT_TCP_FLAG_SACK_PERM also wants to be
synchronized I guess.
