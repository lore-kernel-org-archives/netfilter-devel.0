From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2] netfilter: ipset: refactor hash types to use address/cidr
 arrays.
Date: Wed, 4 Sep 2013 19:20:35 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309041915390.8534@blackhole.kfki.hu>
References: <1378232143-27406-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <alpine.DEB.2.00.1309032219430.4986@blackhole.kfki.hu> <alpine.DEB.2.00.1309040003360.5303@blackhole.kfki.hu> <24199506.ar3DiBo0cH@gentoovm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:52233 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab3IDRUh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:20:37 -0400
In-Reply-To: <24199506.ar3DiBo0cH@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 4 Sep 2013, Oliver wrote:

> On Wednesday 04 September 2013 00:06:01 Jozsef Kadlecsik wrote:
> > On Tue, 3 Sep 2013, Jozsef Kadlecsik wrote:
> > > On Tue, 3 Sep 2013, Oliver wrote:
> > [...]
> > 
> > > > -mtype_add_cidr(struct htype *h, u8 cidr, u8 nets_length)
> > > > +mtype_add_cidr(struct htype *h, const u8 cidr[], u8 nets_length)
> > > 
> > > I do remember you asked it and I confused you: no, the hash types need not
> > > be changed for this (see below), mtype_add_cidr requires just a new arg as
> > > to which member of the cidr/net array of struct htype to be updated.
> > 
> > I was thinking about something like this (untested, unchecked):
> 
> <snip>
> 
> > @@ -296,46 +300,46 @@ struct htype {
> >  /* Network cidr size book keeping when the hash stores different
> >   * sized networks */
> >  static void
> > -mtype_add_cidr(struct htype *h, u8 cidr, u8 nets_length)
> > +mtype_add_cidr(struct htype *h, u8 cidr, u8 nets_length, u8 n)
> 
> Ok, I see what you were envisioning now - I'm not entirely sure if the 
> benefit of not having to modify the existing hash structs outweighs the 
> cost of having to insert special cases in the generic header - 
> especially now considering each hash only consists of a single struct 
> for each address family.

I committed and pushed it to the ipset git tree. The special cases are 
going to be enabled by #ifdef conditions, so the common case is kept as 
simple as possible.
 
> Essentially, this is going to be something of a tradeoff; if it's left 
> like it is now, all the existing single calls to 
> mtype_add_cidr/mtype_del_cidr don't require any modification since the 
> loop inside them handles CIDR for N number of nets simply by virtue of 
> whatever you #define IPSET_NET_COUNT to be.
>
> On the other hand, if we want to avoid changing the existing *net* hashes to 
> conform to the array style, it'll require special cases that execute multiple 
> calls to mtype_add_cidr and mtype_del_cidr - the blow could be softened by 
> sticking a loop around it, but that's effectively going to be a small chunk of 
> code duplication in order to get there. Part of the confusion I would say was 
> that I figured you wanted to deduplicate the code as much as possible, so with 
> that I went all-out and refactored the entire lot of existing types 
> accordingly.
> 
> So, the way I see it... go with what we have right now, less code duplication, 
> smaller code in general or have special cases for IPSET_NET_COUNT > 1.
> 
> Let me know what you think, I'm not massively concerned either way, but my 
> vote would be for how it is now (quelle surprise?)
> 
> Thanks,
> Oliver.
> 
> P.S. I've made a bunch of corrections to the comments extension and 
> rebased it against all these general fixes and improvements, so I'll 
> give it another once- over and patch-bomb the mailing list with it 
> later.

Please wait a little bit with sending the comments extensions: I'm working 
on the extensions infratructure.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
