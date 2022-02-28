Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49228C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Feb 2022 23:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbiB1Xm3 convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Feb 2022 18:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiB1Xm2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Feb 2022 18:42:28 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F023AEB31B
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Feb 2022 15:41:48 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nOpeB-0005Qp-U2; Tue, 01 Mar 2022 00:41:44 +0100
Date:   Tue, 1 Mar 2022 00:41:43 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Joe Stringer <joe@cilium.io>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_queue: be more careful with sk refcounts
Message-ID: <20220228234143.GB12167@breakpoint.cc>
References: <20220228162918.23327-1-fw@strlen.de>
 <CADa=Ryx0-A6TmXjSDUO0V-6arMjbOhO6MXV6emNhugAm+F_oLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CADa=Ryx0-A6TmXjSDUO0V-6arMjbOhO6MXV6emNhugAm+F_oLg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Joe Stringer <joe@cilium.io> wrote:
> On Mon, Feb 28, 2022 at 8:29 AM Florian Westphal <fw@strlen.de> wrote:
> >
> > Eric Dumazet says:
> >   The sock_hold() side seems suspect, because there is no guarantee
> >   that sk_refcnt is not already 0.
> >
> > Also, there is a way to wire up skb->sk in a way that skb doesn't hold
> > a reference on the socket, so we need to check for that as well.
> >
> > For refcount-less skb->sk case, try to increment the reference count
> > and then override the destructor.
> >
> > On failure, we cannot queue the packet and need to indicate an
> > error.  THe packet will be dropped by the caller.
> >
> > Cc: Joe Stringer <joe@cilium.io>
> > Fixes: 271b72c7fa82c ("udp: RCU handling for Unicast packets.")
> 
> Hi Florian, thanks for the fix.
> 
> skb_sk_is_prefetched() was introduced in commit cf7fbe660f2d ("bpf:
> Add socket assign support"). You may want to split the hunk below into
> a dedicated patch for this reason.

Yes, I see, that helps with backports, will do.

> > +       if (skb_sk_is_prefetched(skb)) {
> > +               struct sock *sk = skb->sk;
> > +
> > +               if (!sk_is_refcounted(sk)) {
> > +                       if (!refcount_inc_not_zero(&sk->sk_refcnt))
> > +                               return -ENOTCONN;
> > +
> > +                       /* drop refcount on skb_orphan */
> > +                       skb->destructor = sock_edemux;
> > +               }
> > +       }
> > +
> >         entry = kmalloc(sizeof(*entry) + route_key_size, GFP_ATOMIC);
> >         if (!entry)
> >                 return -ENOMEM;
> 
> I've never heard of someone trying to use socket prefetch /
> bpf_sk_assign in conjunction with nf_queue, bit of an unusual case.

Me neither, but if someone does it, skb->sk leaves rcu protection.

> Given that `skb_sk_is_prefetched()` relies on the skb->destructor
> pointing towards sock_pfree, and this code would change that to
> sock_edemux, the difference the patch would make is this: if the
> packet is queued and then accepted, the socket prefetch selection
> could be ignored.

Hmmm, wait a second, is that because of orphan in input path, i.e.,
that this preselect has to work even across veth/netns crossing?

> I looked closely at this hunk, I didn't look closely at the rest of
> the patch. Assuming you split just this hunk into a dedicated patch,
> you can add my Ack:
> 
> Acked-by: Joe Stringer <joe@cilium.io>

Thats what I'll do, thanks Joe!
