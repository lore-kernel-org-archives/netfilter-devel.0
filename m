From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf-next,RFC 08/10] netfilter: move NF_QUEUE handling away
 from core
Date: Fri, 14 Oct 2016 16:06:15 +0800
Message-ID: <CAML_gOd99wfVxM6ZNi95U+Ddee3AzAH=N6s2N0eMpzU0wRg=2g@mail.gmail.com>
References: <1476360171-2991-1-git-send-email-pablo@netfilter.org> <1476360171-2991-9-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:36176 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753364AbcJNIGQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Oct 2016 04:06:16 -0400
Received: by mail-vk0-f67.google.com with SMTP id b186so4673160vkb.3
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2016 01:06:16 -0700 (PDT)
In-Reply-To: <1476360171-2991-9-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2016-10-13 20:02 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> +int nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
> +            unsigned int queuenum, bool bypass)
> +{
> +       int ret;
> +
> +       ret = __nf_queue(skb, state, queuenum);
> +       if (ret < 0) {
> +               if (ret == -ESRCH && bypass)
> +                       return NF_ACCEPT;
> +               kfree_skb(skb);
> +               return NF_DROP;
> +       }
> +
> +       return NF_STOLEN;

I think this will break something ... Imagine such situation:
# ip route add default dev eth0
# ip rule add fwmark 0x1/0xf lookup eth1
# ip rule add fwmark 0x2/0xf lookup eth2
# iptables -t mangle -A OUTPUT -d 1.1.1.1 -j MARK --set-mark 0x1
# iptables -t mangle -A OUTPUT -d 2.2.2.2 -j MARK --set-mark 0x2
# iptables -t mangle -A OUTPUT -j NFQUEUE

So ip packets with dst 1.1.1.1 will be sent via eth1, ip packets with
dst 2.2.2.2 will be sent via eth2 ...

But apply this patch, after queue the packet with dst 1.1.1.1 to the
userspace and reinject it to the kernel, the packet will be sent via
the wrong interface, i.e. eth0 not eth1.

Because ret is *NF_STOLEN* so we will not call ip_route_me_harder
to do re-route in ipt_mangle_out().

> diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
> index f596a1614daa..015053a2643d 100644
> --- a/net/netfilter/nft_queue.c
> +++ b/net/netfilter/nft_queue.c
> @@ -48,10 +48,8 @@ static void nft_queue_eval(const struct nft_expr *expr,
>                 }
>         }
>
> -       ret = NF_QUEUE_NR(queue);
> -       if (priv->flags & NFT_QUEUE_FLAG_BYPASS)
> -               ret |= NF_VERDICT_FLAG_QUEUE_BYPASS;
> -
> +       ret = nf_queue(pkt->skb, pkt->xt.state, NF_QUEUE_NR(queue),
> +                      priv->flags & NFT_QUEUE_FLAG_BYPASS);
>         regs->verdict.code = ret;
>  }

I think here we forget to use nf_queue() in nft_queue_sreg_eval().

And in nfnl_userspace_cthelper(), such conversion was missed also.
