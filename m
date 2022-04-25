Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B34C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Apr 2022 13:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbiDYNo0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Apr 2022 09:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242133AbiDYNoZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Apr 2022 09:44:25 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EC64990D
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2022 06:41:19 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id ADB45CC00FF;
        Mon, 25 Apr 2022 15:41:13 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon, 25 Apr 2022 15:41:11 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id C76F9CC00FC;
        Mon, 25 Apr 2022 15:41:10 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id BBC5B343156; Mon, 25 Apr 2022 15:41:10 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id BA443343155;
        Mon, 25 Apr 2022 15:41:10 +0200 (CEST)
Date:   Mon, 25 Apr 2022 15:41:10 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
cc:     netfilter-devel@vger.kernel.org, edumazet@google.com,
        ncardwell@google.com, Jaco Kroon <jaco@uls.co.za>
Subject: Re: [PATCH nf] netfilter: nf_conntrack_tcp: re-init for syn packets
 only
In-Reply-To: <20220425094711.6255-1-fw@strlen.de>
Message-ID: <b46b713f-6ba8-38ab-bb22-d3fd9c6c8ec9@netfilter.org>
References: <20220425094711.6255-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 25 Apr 2022, Florian Westphal wrote:

> Jaco Kroon reported tcp problems that Eric Dumazet and Neal Cardwell
> pinpointed to nf_conntrack tcp_in_window() bug.
> 
> tcp trace shows following sequence:
> 
> I > R Flags [S], seq 3451342529, win 62580, options [.. tfo [|tcp]>
> R > I Flags [S.], seq 2699962254, ack 3451342530, win 65535, options [..]
> R > I Flags [P.], seq 1:89, ack 1, [..]
> 
> Note 3rd ACK is from responder to initiator so following branch is taken:
>     } else if (((state->state == TCP_CONNTRACK_SYN_SENT
>                && dir == IP_CT_DIR_ORIGINAL)
>                || (state->state == TCP_CONNTRACK_SYN_RECV
>                && dir == IP_CT_DIR_REPLY))
>                && after(end, sender->td_end)) {
> 
> ... because state == TCP_CONNTRACK_SYN_RECV and dir is REPLY.
> This causes the scaling factor to be reset to 0: window scale option
> is only present in syn(ack) packets.  This in turn makes nf_conntrack
> mark valid packets as out-of-window.
> 
> This was always broken, it exists even in original commit where
> window tracking was added to ip_conntrack (nf_conntrack predecessor)
> in 2.6.9-rc1 kernel.
> 
> Restrict to 'tcph->syn', just like the 3rd condtional added in
> commit 82b72cb94666 ("netfilter: conntrack: re-init state for retransmitted syn-ack").
> 
> Upon closer look, those conditionals/branches can be merged:
> 
> Because earlier checks prevent syn-ack from showing up in
> original direction, the 'dir' checks in the conditional quoted above are
> redundant, remove them. Return early for pure syn retransmitted in reply
> direction (simultaneous open).
> 
> Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
> Reported-by: Jaco Kroon <jaco@uls.co.za>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

[Sorry, I was away whole last week as well.]

Best regards,
Jozsef

> ---
>  net/netfilter/nf_conntrack_proto_tcp.c | 21 ++++++---------------
>  1 file changed, 6 insertions(+), 15 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
> index 8ec55cd72572..204a5cdff5b1 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -556,24 +556,14 @@ static bool tcp_in_window(struct nf_conn *ct,
>  			}
>  
>  		}
> -	} else if (((state->state == TCP_CONNTRACK_SYN_SENT
> -		     && dir == IP_CT_DIR_ORIGINAL)
> -		   || (state->state == TCP_CONNTRACK_SYN_RECV
> -		     && dir == IP_CT_DIR_REPLY))
> -		   && after(end, sender->td_end)) {
> +	} else if (tcph->syn &&
> +		   after(end, sender->td_end) &&
> +		   (state->state == TCP_CONNTRACK_SYN_SENT ||
> +		    state->state == TCP_CONNTRACK_SYN_RECV)) {
>  		/*
>  		 * RFC 793: "if a TCP is reinitialized ... then it need
>  		 * not wait at all; it must only be sure to use sequence
>  		 * numbers larger than those recently used."
> -		 */
> -		sender->td_end =
> -		sender->td_maxend = end;
> -		sender->td_maxwin = (win == 0 ? 1 : win);
> -
> -		tcp_options(skb, dataoff, tcph, sender);
> -	} else if (tcph->syn && dir == IP_CT_DIR_REPLY &&
> -		   state->state == TCP_CONNTRACK_SYN_SENT) {
> -		/* Retransmitted syn-ack, or syn (simultaneous open).
>  		 *
>  		 * Re-init state for this direction, just like for the first
>  		 * syn(-ack) reply, it might differ in seq, ack or tcp options.
> @@ -581,7 +571,8 @@ static bool tcp_in_window(struct nf_conn *ct,
>  		tcp_init_sender(sender, receiver,
>  				skb, dataoff, tcph,
>  				end, win);
> -		if (!tcph->ack)
> +
> +		if (dir == IP_CT_DIR_REPLY && !tcph->ack)
>  			return true;
>  	}
>  
> -- 
> 2.35.1
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
