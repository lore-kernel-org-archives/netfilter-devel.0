From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 2/2] netfilter: conntrack: optional reliable conntrack
 event delivery
Date: Wed, 10 Jun 2009 14:26:07 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906101356370.25631@blackhole.kfki.hu>
References: <20090604110307.6702.10147.stgit@Decadence> <20090604110841.6702.76228.stgit@Decadence> <4A292DB7.4000000@trash.net> <4A2EE3D2.1090007@netfilter.org> <4A2EE5A3.2000502@trash.net> <4A2EE610.9020207@trash.net> <4A2EE907.70609@netfilter.org>
 <4A2F09D9.7090507@gmail.com> <4A2F830C.9020403@trash.net> <4A2F8CC7.2010708@netfilter.org> <4A2F9120.9010904@trash.net> <4A2F9289.6000502@trash.net> <4A2F9BB8.8020701@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:39523 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437AbZFJM0H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:26:07 -0400
In-Reply-To: <4A2F9BB8.8020701@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 10 Jun 2009, Patrick McHardy wrote:

> Patrick McHardy wrote:
> > Patrick McHardy wrote:
> > > Pablo Neira Ayuso wrote:
> > > > Can you see any problem with this optimistic approach? I know, it can
> > > > potentially try to restore the cache, but this is very unlikely to
> > > > happen?
> > > 
> > > Its probably quite unlikely, so not a big issue. OTOH this is
> > > effectively doing something quite similar to a spinlock. Maybe
> > > its finally time to add per-conntrack locking.
> > > 
> > > Eric even had a patch for this IIRC :)
> > 
> > I'll take a quick stab at this, will let you know in 30-60 minutes.
> 
> This is a first attempt to replace some global locks by private
> per conntrack locks. On 64 bit, it fits into a hole and doesn't
> enlarge struct nf_conn.
[...] 
> Now is that really better - I'm not sure myself :) The per-conntrack
> locking would be an improvement though. What do you think?

I think it's cool and highly required, in order to add per hash bucket 
locks too :-). And hash bucket locking can even more improve performance. 
(We need the ordered locking of the buckets for both directions only when 
entries are added/deleted, otherwise a single read-lock of the given 
bucket is enough.)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
