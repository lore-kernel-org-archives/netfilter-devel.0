From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next,RFC 08/10] netfilter: move NF_QUEUE handling away
 from core
Date: Fri, 14 Oct 2016 11:53:30 +0200
Message-ID: <20161014095330.GA4444@salvia>
References: <1476360171-2991-1-git-send-email-pablo@netfilter.org>
 <1476360171-2991-9-git-send-email-pablo@netfilter.org>
 <CAML_gOd99wfVxM6ZNi95U+Ddee3AzAH=N6s2N0eMpzU0wRg=2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59012 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751529AbcJNJxm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Oct 2016 05:53:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 656A733B0
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2016 11:53:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50A47DA854
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2016 11:53:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 24938DA81C
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2016 11:53:35 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAML_gOd99wfVxM6ZNi95U+Ddee3AzAH=N6s2N0eMpzU0wRg=2g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 14, 2016 at 04:06:15PM +0800, Liping Zhang wrote:
> Hi Pablo,
>
> 2016-10-13 20:02 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> > +int nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
> > +            unsigned int queuenum, bool bypass)
> > +{
> > +       int ret;
> > +
> > +       ret = __nf_queue(skb, state, queuenum);
> > +       if (ret < 0) {
> > +               if (ret == -ESRCH && bypass)
> > +                       return NF_ACCEPT;
> > +               kfree_skb(skb);
> > +               return NF_DROP;
> > +       }
> > +
> > +       return NF_STOLEN;
>
> I think this will break something ... Imagine such situation:
> # ip route add default dev eth0
> # ip rule add fwmark 0x1/0xf lookup eth1
> # ip rule add fwmark 0x2/0xf lookup eth2
> # iptables -t mangle -A OUTPUT -d 1.1.1.1 -j MARK --set-mark 0x1
> # iptables -t mangle -A OUTPUT -d 2.2.2.2 -j MARK --set-mark 0x2
> # iptables -t mangle -A OUTPUT -j NFQUEUE
>
> So ip packets with dst 1.1.1.1 will be sent via eth1, ip packets with
> dst 2.2.2.2 will be sent via eth2 ...
>
> But apply this patch, after queue the packet with dst 1.1.1.1 to the
> userspace and reinject it to the kernel, the packet will be sent via
> the wrong interface, i.e. eth0 not eth1.
>
> Because ret is *NF_STOLEN* so we will not call ip_route_me_harder
> to do re-route in ipt_mangle_out().

Good point. Then, we can just return NF_QUEUE here instead, which
would become sort of an alias of NF_STOLEN, but this now just signals
the core that the packet was enqueued to userspace. I mean:

int nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
            unsigned int queuenum, bool bypass)
{
       int ret;

       ret = __nf_queue(skb, state, queuenum);
       if (ret < 0) {
               if (ret == -ESRCH && bypass)
                       return NF_ACCEPT;
               kfree_skb(skb);
               return NF_DROP;
       }

       return NF_QUEUE; <--- this.
}

BTW, looking at ipt_mangle_out():

        ret = ipt_do_table(skb, state, state->net->ipv4.iptable_mangle);
        /* Reroute for ANY change. */
        if (ret != NF_DROP && ret != NF_STOLEN) {
                iph = ip_hdr(skb);

                if (iph->saddr != saddr ||
                    iph->daddr != daddr ||
                    skb->mark != mark ||
                    iph->tos != tos) {
                        err = ip_route_me_harder(state->net, skb, RTN_UNSPEC);
                        if (err < 0)
                                ret = NF_DROP_ERR(err);
                }
        }

It seems that we're triggering an expensive re-reroute for dropped
packets from the mangle table, since ret != NF_DROP evaluates false
given the errno number is encoded in the most significant 16 bits.

> > diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
> > index f596a1614daa..015053a2643d 100644
> > --- a/net/netfilter/nft_queue.c
> > +++ b/net/netfilter/nft_queue.c
> > @@ -48,10 +48,8 @@ static void nft_queue_eval(const struct nft_expr *expr,
> >                 }
> >         }
> >
> > -       ret = NF_QUEUE_NR(queue);
> > -       if (priv->flags & NFT_QUEUE_FLAG_BYPASS)
> > -               ret |= NF_VERDICT_FLAG_QUEUE_BYPASS;
> > -
> > +       ret = nf_queue(pkt->skb, pkt->xt.state, NF_QUEUE_NR(queue),
> > +                      priv->flags & NFT_QUEUE_FLAG_BYPASS);
> >         regs->verdict.code = ret;
> >  }
>
> I think here we forget to use nf_queue() in nft_queue_sreg_eval().
>
> And in nfnl_userspace_cthelper(), such conversion was missed also.

Right, thanks, will fix up this spot too.
