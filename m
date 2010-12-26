From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sun, 26 Dec 2010 11:32:23 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012261130200.9618@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0CC3BB.8030801@googlemail.com> <alpine.DEB.2.00.1012182050280.11577@blackhole.kfki.hu> <4D0D2CF4.5070201@googlemail.com> <alpine.DEB.2.00.1012190105460.11753@blackhole.kfki.hu>
 <4D0E0E2A.3090604@googlemail.com> <4D0E22A5.8090808@conversis.de> <4D0E3B34.7090105@googlemail.com> <alpine.DEB.2.00.1012221146060.3482@blackhole.kfki.hu> <4D11F384.3070908@googlemail.com> <alpine.DEB.2.00.1012231558390.6044@blackhole.kfki.hu>
 <4D138C02.3050905@googlemail.com> <alpine.DEB.2.00.1012232008520.6582@blackhole.kfki.hu> <4D13CBD8.3090007@googlemail.com> <alpine.DEB.2.00.1012232337070.7027@blackhole.kfki.hu> <4D13D553.8050907@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dennis Jacobfeuerborn <dennisml@conversis.de>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:33437 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab0LZKcY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Dec 2010 05:32:24 -0500
In-Reply-To: <4D13D553.8050907@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 23 Dec 2010, Mr Dash Four wrote:

> > > > The implementation behind ipset looks up the  (ipaddr, proto, port)
> > > > triple
> > > > in one step. Such packing don't work there.
> > > >         
> > > If that's the case how do you lookup IP address and port ranges then?
> > >     
> > 
> > IP address and port ranges are exploded and the elements are inserted
> > one-by-one. And the exploded ranges are *not* converted back to ranges when
> > listing/saving the sets. At the bitmap types the ranges could be converted
> > back (not done yet), at the hash types it's not possible.
> >   
> If I understand you correctly, if I define hash:net,proto,port ipset and add a
> single element to it - 10.1.1.0/30,udp,80-83 - that translates (in primitive
> terms) to:
> 
> 10.1.1.0,udp,80
> 10.1.1.0,udp,81
> ...
> 10.1.1.0,udp,83
> 10.1.1.1,udp,80
> ...
> 10.1.1.1,udp,83
> ...
> ...
> 10.1.1.3,udp,83

No, "net" types are not exploded in the terms of networks.
 
> One other question - if I insert the above element in the set what is shown
> when I execute ipset -L: "10.1.1.0-10.1.1.3,udp,80-83" or the various
> permutations I listed above?

The protocol does not allow to list a subset of the elements in a set. 
Just the whole set can be listed.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
