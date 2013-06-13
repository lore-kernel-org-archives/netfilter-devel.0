From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Huge timeout with loose=1 pickup tcp connections
Date: Thu, 13 Jun 2013 15:49:10 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1306131547210.23451@blackhole.kfki.hu>
References: <20130613105138.GC21252@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:47706 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770Ab3FMNtN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:49:13 -0400
In-Reply-To: <20130613105138.GC21252@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 13 Jun 2013, Florian Westphal wrote:

> With nf_conntrack_tcp_loose = 1, stray packets will create
> conntrack with 5 days-timeout.  Is this necessary?
> 
> I ask, because I've got following tcp trace:
> 
> 192.168.x is initiator/origin, 10.184. is responder/reply, connection is establised by usual 3whs,
>  data was transmitted in both directions)
> 
> A 55:07 (id 12053, [DF], TCP, len 40) 192.168.x.52792 > 10.184.y.80: F, 426:426(0) ack 9237 win 255
> B 55:07 (id 6129, [DF], TCP, len 40) 10.184.y.80 > 192.168.x.52792: ., ack 427 win 123
> C 56:08 (id 6130, [DF], TCP, len 40) 10.184.y.80 > 192.168.x.52792: F, 9237:9237(0) ack 427 win 123
> D 56:08 (id 12159, [DF], TCP, len 40) 192.168.x.52792 > 10.184.y.80: ., ack 9238 win 255
> 
> D is last packet seen for that connection.  Notice 61 second pause between B and C.
> 
> >From conntrack POV, we have following state transitions:
>    [NEW] tcp   6 60 SYN_RECV ..
>  [UPDATE] tcp  6 432000 ESTABLISHED ..
>  [UPDATE] tcp  6 120 FIN_WAIT .. (triggered by packet A)
>  [UPDATE] tcp  6 60 CLOSE_WAIT .. (triggered by packet B)
> [DESTROY] tcp  6 (triggered by 60-second CLOSE_WAIT timeout)
>  [NEW] tcp  6 432034 ESTABLISHED .. [UNREPLIED] (triggered by packet D)
> 
> Result is that, after a couple of hours, conntrack table starts to fill up
> with UNREPLIED crud.
> 
> Follwing changes fix it:
> - set loose=0 (avoids bogus NEW connection), OR,
> - set net.ipv4.netfilter.ip_conntrack_tcp_timeout_close_wait=65
>   (avoids NEW connection, new state transitions are:
>   [UPDATE] tcp  6 60 CLOSE_WAIT .. (triggered by packet B)
>   [UPDATE] tcp  6 30 LAST_ACK .. (triggered by C)
>   [UPDATE] tcp  6 120 TIME_WAIT .. (triggered by D)
> 
> However, I think conntrack shouldn't insert a just-picked
> up connection with default ESTABLISHED timeout value.  Suggestion:
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index 4d4d8f1..33ca4f3 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -1043,6 +1043,11 @@ static int tcp_packet(struct nf_conn *ct,
>  			nf_ct_kill_acct(ct, ctinfo, skb);
>  			return NF_ACCEPT;
>  		}
> +		/* loose=1 picked up existing connection, avoid large timeout */
> +		if (old_state == TCP_CONNTRACK_NONE &&
> +		    new_state == TCP_CONNTRACK_ESTABLISHED &&
> +		    timeout > timeouts[TCP_CONNTRACK_UNACK])
> +			timeout = timeouts[TCP_CONNTRACK_UNACK];
>  	} else if (!test_bit(IPS_ASSURED_BIT, &ct->status)
>  		   && (old_state == TCP_CONNTRACK_SYN_RECV
>  		       || old_state == TCP_CONNTRACK_ESTABLISHED)
> 
> Jozsef, If you aggree I would make a formal submission.

I agree with it, it's better to set up a shorter timeout for the just 
picked up connections at the first packet.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
