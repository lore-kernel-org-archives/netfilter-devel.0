From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Add seperated timeout for the connections that only receive
 packets in one direction
Date: Fri, 27 Nov 2009 10:25:36 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0911271020160.18988@blackhole.kfki.hu>
References: <4B0F9737.8050606@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:38145 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbZK0JZb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2009 04:25:31 -0500
In-Reply-To: <4B0F9737.8050606@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Fri, 27 Nov 2009, Changli Gao wrote:

> Add seperated timeout for the connections that only receive packets in 
> one direction.
> 
> If we use tcp_timeouts[TCP_CONNTRACK_ESTABLISHED] to timeout the 
> connections that only receive packets in one direction, ACK flood attack 
> with fake source address A will exhaust A's connection limit, and A is 
> DoSed. After the attack is stopped, A can't recover quickly due to the 
> large timeout value.
> 
> This patch adds a new timeout value: nf_ct_tcp_timeout_loose_unreply for 
> this kind of connections. It can help A to recover quickly after the 
> attack is over.
> 
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> ----
>  nf_conntrack_proto_tcp.c |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index 7eda8b8..471045a 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -70,6 +70,8 @@ static const char *const tcp_conntrack_names[] = {
>  static unsigned int nf_ct_tcp_timeout_max_retrans __read_mostly    =   5 MINS;
>  static unsigned int nf_ct_tcp_timeout_unacknowledged __read_mostly =   5 MINS;
>  
> +static unsigned int nf_ct_tcp_timeout_loose_unreply __read_mostly  =   30 SECS;
> +
>  static unsigned int tcp_timeouts[TCP_CONNTRACK_MAX] __read_mostly = {
>  	[TCP_CONNTRACK_SYN_SENT]	= 2 MINS,
>  	[TCP_CONNTRACK_SYN_RECV]	= 60 SECS,
> @@ -1006,6 +1008,9 @@ static int tcp_packet(struct nf_conn *ct,
>  			nf_ct_kill_acct(ct, ctinfo, skb);
>  			return NF_ACCEPT;
>  		}
> +		if (new_state == TCP_CONNTRACK_ESTABLISHED &&
> +		    timeout > nf_ct_tcp_timeout_loose_unreply)
> +			timeout = nf_ct_tcp_timeout_loose_unreply;

I don't see how can the condition be true. The first reply 
packet checked here and if that's a pure ACK, then the new_state cannot be 
TCP_CONNTRACK_ESTABLISHED (except for picked up connections).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
