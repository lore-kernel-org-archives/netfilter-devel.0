From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH] netfilter: ipv4: defrag: set local_df flag on
 defragmented skb
Date: Sat, 3 May 2014 21:45:04 -0700
Message-ID: <CAHo-OoybYa2xiEmCnpgDWnRztL3PBunBzeMnY+N4MkLT7-T2-w@mail.gmail.com>
References: <1399037536-5294-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:60726 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaEDEpF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 May 2014 00:45:05 -0400
Received: by mail-qc0-f178.google.com with SMTP id l6so1669650qcy.23
        for <netfilter-devel@vger.kernel.org>; Sat, 03 May 2014 21:45:04 -0700 (PDT)
In-Reply-To: <1399037536-5294-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Are you deleting the comment because it is incorrect?

On Fri, May 2, 2014 at 6:32 AM, Florian Westphal <fw@strlen.de> wrote:
> else we may fail to forward skb even if original fragments do fit
> outgoing link mtu:
>
> 1. remote sends 2k packets in two 1000 byte frags, DF set
> 2. we want to forward but only see '2k > mtu and DF set'
> 3. we then send icmp error saying that outgoing link is 1500
>
> But original sender never sent a packet that would not fit
> the outgoing link.
>
> Setting local_df makes outgoing path test size vs.
> IPCB(skb)->frag_max_size, so we will still send the correct
> error in case the largest original size did not fit
> outgoing link mtu.
>
> Reported-by: Maxime Bizon <mbizon@freebox.fr>
> Suggested-by: Maxime Bizon <mbizon@freebox.fr>
> Fixes: 5f2d04f1f9 (ipv4: fix path MTU discovery with connection tracking)
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
> index 12e13bd..f40f321 100644
> --- a/net/ipv4/netfilter/nf_defrag_ipv4.c
> +++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
> @@ -22,7 +22,6 @@
>  #endif
>  #include <net/netfilter/nf_conntrack_zones.h>
>
> -/* Returns new sk_buff, or NULL */
>  static int nf_ct_ipv4_gather_frags(struct sk_buff *skb, u_int32_t user)
>  {
>         int err;
> @@ -33,8 +32,10 @@ static int nf_ct_ipv4_gather_frags(struct sk_buff *skb, u_int32_t user)
>         err = ip_defrag(skb, user);
>         local_bh_enable();
>
> -       if (!err)
> +       if (!err) {
>                 ip_send_check(ip_hdr(skb));
> +               skb->local_df = 1;
> +       }
>
>         return err;
>  }
> --
> 1.8.1.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
