From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP connection tracking timeout
Date: Tue, 29 Jul 2008 14:20:41 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807291413350.1378@blackhole.kfki.hu>
References: <20080729030104.GA15915@gondor.apana.org.au> <488EA0F1.2050906@trash.net>
 <488EA3FE.7050503@trash.net> <20080729060105.GA16797@gondor.apana.org.au>
 <488EB4F1.60806@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:33176 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499AbYG2MUn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2008 08:20:43 -0400
In-Reply-To: <488EB4F1.60806@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Tue, 29 Jul 2008, Patrick McHardy wrote:

> Herbert Xu wrote:
> > On Tue, Jul 29, 2008 at 07:00:46AM +0200, Patrick McHardy wrote:
> > > > That sounds like a pretty neat idea. I'm testing a patch now, I'll
> > > > send it over in a few minutes if it survives :)
> >   
> > > This seems to work. I'm wondering however if this will really help.
> > > We already track retransmissions and decrease the timeout on the
> > > 3rd retransmission, so this should only help if both the sender and
> > > the receiver went down.
> > 
> > The problem with requiring a 3rd retransmit is that once a socket
> > is orphaned (closed) on Linux, we fast-track the retransmit timeout
> > process.  In particular, if it's already maxed out the RTO prior
> > to closing, we'll kill it straight away.
> > 
> > This is in violation of the RFCs but it's an important optimisation.
> 
> Thanks for this explanation. Unless Jozsef sees something wrong with this
> patch, I'll queue it with a proper changelog. Its small enough, so perhaps
> we can even put this in 2.6.27.

Seems to be fine - as we cannot assume everything runs Linux (;-), the 
only risk is that we may kill the conntrack entry too early and then it'll 
mark packets as INVALID unnecessarily. But 5min timeout when there are 
unacknowledged data should be enough to avoid it.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
