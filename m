From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next,RFC 08/10] netfilter: move NF_QUEUE handling away
 from core
Date: Fri, 14 Oct 2016 18:47:20 +0200
Message-ID: <20161014164720.GA6903@salvia>
References: <1476360171-2991-1-git-send-email-pablo@netfilter.org>
 <1476360171-2991-9-git-send-email-pablo@netfilter.org>
 <CAML_gOd99wfVxM6ZNi95U+Ddee3AzAH=N6s2N0eMpzU0wRg=2g@mail.gmail.com>
 <20161014095330.GA4444@salvia>
 <20161014153812.GA16039@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@gmail.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42282 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750922AbcJNQrc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Oct 2016 12:47:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 643BA62D07
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2016 18:47:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 53C6FDA818
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2016 18:47:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50E02DA819
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2016 18:47:25 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20161014153812.GA16039@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 14, 2016 at 05:38:12PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, Oct 14, 2016 at 04:06:15PM +0800, Liping Zhang wrote:
> > > Hi Pablo,
> > >
> > > 2016-10-13 20:02 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> > > > +int nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
> > > > +            unsigned int queuenum, bool bypass)
> > > > +{
> > > > +       int ret;
> > > > +
> > > > +       ret = __nf_queue(skb, state, queuenum);
> > > > +       if (ret < 0) {
> > > > +               if (ret == -ESRCH && bypass)
> > > > +                       return NF_ACCEPT;
> > > > +               kfree_skb(skb);
> > > > +               return NF_DROP;
> > > > +       }
> > > > +
> > > > +       return NF_STOLEN;
> > >
> > > I think this will break something ... Imagine such situation:
> > > # ip route add default dev eth0
> > > # ip rule add fwmark 0x1/0xf lookup eth1
> > > # ip rule add fwmark 0x2/0xf lookup eth2
> > > # iptables -t mangle -A OUTPUT -d 1.1.1.1 -j MARK --set-mark 0x1
> > > # iptables -t mangle -A OUTPUT -d 2.2.2.2 -j MARK --set-mark 0x2
> > > # iptables -t mangle -A OUTPUT -j NFQUEUE
> > >
> > > So ip packets with dst 1.1.1.1 will be sent via eth1, ip packets with
> > > dst 2.2.2.2 will be sent via eth2 ...
> > >
> > > But apply this patch, after queue the packet with dst 1.1.1.1 to the
> > > userspace and reinject it to the kernel, the packet will be sent via
> > > the wrong interface, i.e. eth0 not eth1.
> > >
> > > Because ret is *NF_STOLEN* so we will not call ip_route_me_harder
> > > to do re-route in ipt_mangle_out().
> > 
> > Good point. Then, we can just return NF_QUEUE here instead, which
> > would become sort of an alias of NF_STOLEN, but this now just signals
> > the core that the packet was enqueued to userspace. I mean:
> > 
> > int nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
> >             unsigned int queuenum, bool bypass)
> > {
> >        int ret;
> > 
> >        ret = __nf_queue(skb, state, queuenum);
> >        if (ret < 0) {
> >                if (ret == -ESRCH && bypass)
> >                        return NF_ACCEPT;
> >                kfree_skb(skb);
> >                return NF_DROP;
> >        }
> > 
> >        return NF_QUEUE; <--- this.
> > }
> 
> I'm afraid that won't fly.  When This NF_QUEUE is returned here, we're
> in a race as skb is already on its way to userspace (or perhaps already
> being reinjected/dropped on other cpu).
> 
> I think the simplest way out is to always re-route from nf_reinject
> in case we were queued from mangle output.
> 
> For nft, we might be able to make a note of 'route' chain type in the
> nf_hook_state and then have nf_reinject check for that.

Hm, we already have afinfo->saveroute() and afinfo->reroute() handling
from nf_queue() and nf_reinject() respectively, so returning NF_STOLEN
(as originally proposed) should be fine.
