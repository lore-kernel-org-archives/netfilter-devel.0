From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/1] Conntrack event generation control, kernel part
Date: Fri, 15 May 2009 21:07:30 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0905152059080.1804@blackhole.kfki.hu>
References: <alpine.DEB.2.00.0905121348460.28379@blackhole.kfki.hu> <4A097752.4030303@netfilter.org> <alpine.DEB.2.00.0905121524020.28379@blackhole.kfki.hu> <4A098B7F.6050605@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:57947 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbZEOTHa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 May 2009 15:07:30 -0400
In-Reply-To: <4A098B7F.6050605@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Tue, 12 May 2009, Pablo Neira Ayuso wrote:

> >> BTW, I don't like using connmark for this.
> > 
> > You mean the CONNMARK target? I deliberately avoided using the connection 
> > marks. Or "marking" the connections by the eventmask? But that is the most 
> > effective way to filter the events.
> 
> I see, but something similar to nfnetlink_queue/NFQUEUE (per-process)
> together with an extended version of the `conntrack match' for events
> would be more flexible.

The match solution cannot cover cases when the actual event happens at 
confirmation while the target can "see" all. But I agree, that "matching" 
events would be more natural for the users than marking.

> > Another very simple choice can be to add more multicast groups 
> > according to the sort of events. We can get more fine grain event 
> > selection while keeping it per-process. Currently, there's only three 
> > sort of events: NEW, UPDATE and DESTROY. We can add more netlink 
> > multicast groups to allow user-space to select what kind of events 
> > they are interested.
> 
> netlink doesn't seem to support overlapping event groups, and UPDATE and 
> ASSURED groups would overlap. Thus, we'll need to call 
> netlink_broadcast() twice. I still don't find a non-intrusive way to do 
> some non-BPF-based filtering :(

Why don't we introduce groups like nflog and nfqueue? res_id is unused in 
ctnetlink, so we could use it to pair the application and the event flow.

The CONNMARK target with the approach I suggest could easily be extended 
to cover the res_id too and store it in the conntrack entry. That'd still 
just amount 32 bits (eventmask + res_id) in nf_conn which is required.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
