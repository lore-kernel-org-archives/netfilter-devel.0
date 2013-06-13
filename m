From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH next] netfilter: conntrack: avoid large timeout for
 mid-stream pickup
Date: Thu, 13 Jun 2013 19:21:26 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1306131909490.24515@blackhole.kfki.hu>
References: <1371137488-16428-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:36799 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860Ab3FMRV2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Jun 2013 13:21:28 -0400
In-Reply-To: <1371137488-16428-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 13 Jun 2013, Florian Westphal wrote:

> When loose tracking is enabled (default), non-syn packets cause
> creation of new conntracks in established state with default timeout for
> established state (5 days).  This causes the table to fill up with UNREPLIED
> when the 'new ack' packet happened to be the last-ack of a previous,
> already timed-out connection.
> 
> Consider:
> 
> A 192.168.x.52792 > 10.184.y.80: F, 426:426(0) ack 9237 win 255
> B 10.184.y.80 > 192.168.x.52792: ., ack 427 win 123
> <61 second pause>
> C 10.184.y.80 > 192.168.x.52792: F, 9237:9237(0) ack 427 win 123
> D 192.168.x.52792 > 10.184.y.80: ., ack 9238 win 255
> 
> B moves conntrack to CLOSE_WAIT and will kill it after 60 second timeout,
> C is ignored (FIN set), but last packet (D) causes new ct with 5-days timeout.
> 
> Use UNACK timeout (5 minutes) instead to get rid of these entries sooner
> when in ESTABLISHED state without having seen traffic in both directions.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Best regards,
Jozsef

> ---
>  Warning; this is a bit different from the initial proposal in
>  that it no longer bothers with old_state (the branch is taken
>  for !SEEN_REPLY only).

It's all right and one condition is spared :-).

> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index 4d4d8f1..7dcc376 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -1043,6 +1043,12 @@ static int tcp_packet(struct nf_conn *ct,
>  			nf_ct_kill_acct(ct, ctinfo, skb);
>  			return NF_ACCEPT;
>  		}
> +		/* ESTABLISHED without SEEN_REPLY, i.e. mid-connection
> +		 * pickup with loose=1. Avoid large ESTABLISHED timeout.
> +		 */
> +		if (new_state == TCP_CONNTRACK_ESTABLISHED &&
> +		    timeout > timeouts[TCP_CONNTRACK_UNACK])
> +			timeout = timeouts[TCP_CONNTRACK_UNACK];
>  	} else if (!test_bit(IPS_ASSURED_BIT, &ct->status)
>  		   && (old_state == TCP_CONNTRACK_SYN_RECV
>  		       || old_state == TCP_CONNTRACK_ESTABLISHED)
> -- 
> 1.7.8.6
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
