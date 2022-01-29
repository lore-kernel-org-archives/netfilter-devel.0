Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A116C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Jan 2022 20:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352702AbiA2UZO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Jan 2022 15:25:14 -0500
Received: from smtp-out.kfki.hu ([148.6.0.45]:56137 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352676AbiA2UZJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Jan 2022 15:25:09 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 8EC7567400F6;
        Sat, 29 Jan 2022 21:25:08 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sat, 29 Jan 2022 21:25:06 +0100 (CET)
Received: from localhost.kfki.hu (host-94-248-211-146.kabelnet.hu [94.248.211.146])
        (Authenticated sender: kadlecsik.jozsef@wigner.hu)
        by smtp0.kfki.hu (Postfix) with ESMTPSA id 4C21467400EE;
        Sat, 29 Jan 2022 21:25:06 +0100 (CET)
Received: by localhost.kfki.hu (Postfix, from userid 1000)
        id DD0F33C186A; Sat, 29 Jan 2022 21:25:05 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by localhost.kfki.hu (Postfix) with ESMTP id DB2A43C1651;
        Sat, 29 Jan 2022 21:25:05 +0100 (CET)
Date:   Sat, 29 Jan 2022 21:25:05 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 2/2] netfilter: conntrack: re-init state for retransmitted
 syn-ack
In-Reply-To: <20220129164701.175221-2-fw@strlen.de>
Message-ID: <8388b8bd-3c41-a8ec-c338-28be9491fa74@netfilter.org>
References: <20220129164701.175221-1-fw@strlen.de> <20220129164701.175221-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: dunno 24%
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Sat, 29 Jan 2022, Florian Westphal wrote:

> TCP conntrack assumes that a syn-ack retransmit is identical to the
> previous syn-ack.  This isn't correct and causes stuck 3whs in some more
> esoteric scenarios.  tcpdump to illustrate the problem:
> 
>  client > server: Flags [S] seq 1365731894, win 29200, [mss 1460,sackOK,TS val 2083035583 ecr 0,wscale 7]
>  server > client: Flags [S.] seq 145824453, ack 643160523, win 65535, [mss 8952,wscale 5,TS val 3215367629 ecr 2082921663]
> 
> Note the invalid/outdated synack ack number.
> Conntrack marks this syn-ack as out-of-window/invalid, but it did
> initialize the reply direction parameters based on this packets content.
> 
>  client > server: Flags [S] seq 1365731894, win 29200, [mss 1460,sackOK,TS val 2083036623 ecr 0,wscale 7]
> 
> ... retransmit...
> 
>  server > client: Flags [S.], seq 145824453, ack 643160523, win 65535, [mss 8952,wscale 5,TS val 3215368644 ecr 2082921663]
> 
> and another bogus synack. This repeats, then client re-uses for a new
> attempt:
> 
> client > server: Flags [S], seq 2375731741, win 29200, [mss 1460,sackOK,TS val 2083100223 ecr 0,wscale 7]
> server > client: Flags [S.], seq 145824453, ack 643160523, win 65535, [mss 8952,wscale 5,TS val 3215430754 ecr 2082921663]
> 
> ... but still gets a invalid syn-ack.
> 
> This repeats until:
> 
>  server > client: Flags [S.], seq 145824453, ack 643160523, win 65535, [mss 8952,wscale 5,TS val 3215437785 ecr 2082921663]
>  server > client: Flags [R.], seq 145824454, ack 643160523, win 65535, [mss 8952,wscale 5,TS val 3215443451 ecr 2082921663]
>  client > server: Flags [S], seq 2375731741, win 29200, [mss 1460,sackOK,TS val 2083115583 ecr 0,wscale 7]
>  server > client: Flags [S.], seq 162602410, ack 2375731742, win 65535, [mss 8952,wscale 5,TS val 3215445754 ecr 2083115583]
> 
> This syn-ack has the correct ack number, but conntrack flags it as
> invalid: The internal state was created from the first syn-ack seen
> so the sequence number of the syn-ack is treated as being outside of
> the announced window.

I can only assume that the client is/are behind like a carrier-grade NAT
and the bogus SYN-ACK sent by the server is replying a connection attempt 
from another client. Yes, the best thing to do is to reinit the state.

> Don't assume that retransmitted syn-ack is identical to previous one.
> Treat it like the first syn-ack and reinit state.
> 
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Best regards,
Jozsef

> ---
>  net/netfilter/nf_conntrack_proto_tcp.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index 88c89e97d8a2..d1582b888c0d 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -571,6 +571,18 @@ static bool tcp_in_window(struct nf_conn *ct,
>  		sender->td_maxwin = (win == 0 ? 1 : win);
>  
>  		tcp_options(skb, dataoff, tcph, sender);
> +	} else if (tcph->syn && dir == IP_CT_DIR_REPLY &&
> +		   state->state == TCP_CONNTRACK_SYN_SENT) {
> +		/* Retransmitted syn-ack, or syn (simultaneous open).
> +		 *
> +		 * Re-init state for this direction, just like for the first
> +		 * syn(-ack) reply, it might differ in seq, ack or tcp options.
> +		 */
> +		tcp_init_sender(sender, receiver,
> +				skb, dataoff, tcph,
> +				end, win);
> +		if (!tcph->ack)
> +			return true;
>  	}
>  
>  	if (!(tcph->ack)) {
> -- 
> 2.34.1
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
