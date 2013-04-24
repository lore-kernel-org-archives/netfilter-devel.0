From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 14/14] nfnetlink: add support for memory mapped netlink
Date: Wed, 24 Apr 2013 17:15:39 +0200
Message-ID: <20130424151539.GA32324@breakpoint.cc>
References: <1366217229-22705-1-git-send-email-kaber@trash.net>
 <1366217229-22705-15-git-send-email-kaber@trash.net>
 <CAED+v=bCkEa8gOO9pu62hmj_H9WXz4+OBiCeyxBUO10L9EdDkA@mail.gmail.com>
 <CAED+v=bdjZE=CKMvKfmE_Z=57K-K6xy_EeLMCU8xsokq4Kc6ZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Nishit Shah <nsshah.82@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42455 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756145Ab3DXPPl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Apr 2013 11:15:41 -0400
Content-Disposition: inline
In-Reply-To: <CAED+v=bdjZE=CKMvKfmE_Z=57K-K6xy_EeLMCU8xsokq4Kc6ZA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nishit Shah <nsshah.82@gmail.com> wrote:
> On Wed, Apr 17, 2013 at 10:17 PM, Patrick McHardy <kaber@trash.net> wrote:
> >
> > Signed-off-by: Patrick McHardy <kaber@trash.net>
[..]
> > diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
> > index 5e280b3..ef3cdb4 100644
> > --- a/net/netfilter/nfnetlink_queue_core.c
> > +++ b/net/netfilter/nfnetlink_queue_core.c
> > @@ -339,7 +339,8 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
> >         if (queue->flags & NFQA_CFG_F_CONNTRACK)
> >                 ct = nfqnl_ct_get(entskb, &size, &ctinfo);
> >
> > -       skb = alloc_skb(size, GFP_ATOMIC);
> > +       skb = nfnetlink_alloc_skb(&init_net, size, queue->peer_portid,
> > +                                 GFP_ATOMIC);
> >         if (!skb)
> >                 return NULL;
> >
> 
> does this mean that we have a true zero copy support with Eric D's
> patch (nfnetlink_queue: zero-copy support) and this patch ?

No.  In both socket and mmap case there is one copy involved.

Before Erics patch, there were two:
first copy: skb_copy_bits() that copies to packet payload into the
netlink message
second copy: copy to userspace when recv() is called

Patricks mmap patch removes the second copy; as the netlink
message is already allocated in userspace memory (the mmap ring).

Erics patch avoids the first copy by only copying fragments'
addresses instead of the payload.
