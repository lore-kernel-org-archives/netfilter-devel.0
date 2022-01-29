Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6FEBC433FE
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Jan 2022 20:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352566AbiA2UYX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Jan 2022 15:24:23 -0500
Received: from smtp-out.kfki.hu ([148.6.0.45]:58911 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234289AbiA2UYW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Jan 2022 15:24:22 -0500
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Jan 2022 15:24:22 EST
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id A304D67400F6;
        Sat, 29 Jan 2022 21:18:57 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sat, 29 Jan 2022 21:18:55 +0100 (CET)
Received: from localhost.kfki.hu (host-94-248-211-146.kabelnet.hu [94.248.211.146])
        (Authenticated sender: kadlecsik.jozsef@wigner.hu)
        by smtp0.kfki.hu (Postfix) with ESMTPSA id 5A6EA67400EE;
        Sat, 29 Jan 2022 21:18:55 +0100 (CET)
Received: by localhost.kfki.hu (Postfix, from userid 1000)
        id E0F183C186A; Sat, 29 Jan 2022 21:18:54 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by localhost.kfki.hu (Postfix) with ESMTP id DF0083C1651;
        Sat, 29 Jan 2022 21:18:54 +0100 (CET)
Date:   Sat, 29 Jan 2022 21:18:54 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 1/2] netfilter: conntrack: move synack init code to
 helper
In-Reply-To: <20220129164701.175221-1-fw@strlen.de>
Message-ID: <903cfb5c-693c-e085-aa3b-9a3fb4401a51@netfilter.org>
References: <20220129164701.175221-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: ham 0%
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, 29 Jan 2022, Florian Westphal wrote:

> It seems more readable to use a common helper in the followup fix rather
> than copypaste or goto.
> 
> No functional change intended.  The function is only called for syn-ack
> or syn in repy direction in case of simultaneous open.
> 
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

> ---
>  net/netfilter/nf_conntrack_proto_tcp.c | 47 ++++++++++++++++----------
>  1 file changed, 29 insertions(+), 18 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index af5115e127cf..88c89e97d8a2 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -446,6 +446,32 @@ static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
>  	}
>  }
>  
> +static void tcp_init_sender(struct ip_ct_tcp_state *sender,
> +			    struct ip_ct_tcp_state *receiver,
> +			    const struct sk_buff *skb,
> +			    unsigned int dataoff,
> +			    const struct tcphdr *tcph,
> +			    u32 end, u32 win)
> +{
> +	/* SYN-ACK in reply to a SYN
> +	 * or SYN from reply direction in simultaneous open.
> +	 */
> +	sender->td_end =
> +	sender->td_maxend = end;
> +	sender->td_maxwin = (win == 0 ? 1 : win);
> +
> +	tcp_options(skb, dataoff, tcph, sender);
> +	/* RFC 1323:
> +	 * Both sides must send the Window Scale option
> +	 * to enable window scaling in either direction.
> +	 */
> +	if (!(sender->flags & IP_CT_TCP_FLAG_WINDOW_SCALE &&
> +	      receiver->flags & IP_CT_TCP_FLAG_WINDOW_SCALE)) {
> +		sender->td_scale = 0;
> +		receiver->td_scale = 0;
> +	}
> +}
> +
>  static bool tcp_in_window(struct nf_conn *ct,
>  			  enum ip_conntrack_dir dir,
>  			  unsigned int index,
> @@ -499,24 +525,9 @@ static bool tcp_in_window(struct nf_conn *ct,
>  		 * Initialize sender data.
>  		 */
>  		if (tcph->syn) {
> -			/*
> -			 * SYN-ACK in reply to a SYN
> -			 * or SYN from reply direction in simultaneous open.
> -			 */
> -			sender->td_end =
> -			sender->td_maxend = end;
> -			sender->td_maxwin = (win == 0 ? 1 : win);
> -
> -			tcp_options(skb, dataoff, tcph, sender);
> -			/*
> -			 * RFC 1323:
> -			 * Both sides must send the Window Scale option
> -			 * to enable window scaling in either direction.
> -			 */
> -			if (!(sender->flags & IP_CT_TCP_FLAG_WINDOW_SCALE
> -			      && receiver->flags & IP_CT_TCP_FLAG_WINDOW_SCALE))
> -				sender->td_scale =
> -				receiver->td_scale = 0;
> +			tcp_init_sender(sender, receiver,
> +					skb, dataoff, tcph,
> +					end, win);
>  			if (!tcph->ack)
>  				/* Simultaneous open */
>  				return true;
> -- 
> 2.34.1
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
