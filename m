From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 00/09]: netfilter: CT target/conntrack zones
Date: Tue, 26 Jan 2010 19:44:32 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1001261600200.24370@blackhole.kfki.hu>
References: <20100125153732.15305.68011.sendpatchset@x2.localnet> <4B5EF6A4.6000201@netfilter.org> <4B5F0283.4030401@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:60476 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab0AZSod (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jan 2010 13:44:33 -0500
In-Reply-To: <4B5F0283.4030401@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 26 Jan 2010, Patrick McHardy wrote:

> Pablo Neira Ayuso wrote:
> >> - Patch 3 adds selective conntrack event delivery by adding two masks
> >>   for conntrack and expectation events to struct nf_conntrack_ecache,
> >>   which are used to filter out events.
> > 
> > This feature is something that I wanted since time ago. We can reduce
> > the CPU consumption by reducing the amount of events. This is
> > particularly good for ulogd2 and conntrackd.
> > 
> > My experiments showed that the BSF-based filtering does not provide any
> > significant gain from filtering Netlink message in user-space. The
> > problem is that we have to spend cycles building the message which seems
> > to be costly.
> > 
> > AFAICS, this approach has one minor threat since it applies to all
> > processes (I'm sure you're aware of it). I'm fine with this anyway, but
> > maybe we should think of some way to make it per-process at some point?
> > Some netlink unicast-based reporting similar to what NFLOG and NFQUEUE
> > would solve this issue although they are implementing multicast over
> > netlink unicast.
> 
> The question is whether that would really reduce overhead
> since we'd like would have to construct messages multiple
> times ourselves in that case. But yes, it might help.

I think the current way is one of the best: the interesting events are 
selected by CT, sent to userspace and the userspace processes pick the 
ones they are interested in. Or do I miss something?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
