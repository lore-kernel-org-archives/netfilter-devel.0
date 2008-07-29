From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP connection tracking timeout
Date: Tue, 29 Jul 2008 14:30:14 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807291420590.1378@blackhole.kfki.hu>
References: <20080729030104.GA15915@gondor.apana.org.au> <488EA0F1.2050906@trash.net>
 <488EA3FE.7050503@trash.net> <20080729060105.GA16797@gondor.apana.org.au>
 <488EB4F1.60806@trash.net> <20080729090737.GA18046@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:35306 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbYG2MaP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2008 08:30:15 -0400
In-Reply-To: <20080729090737.GA18046@gondor.apana.org.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Tue, 29 Jul 2008, Herbert Xu wrote:

> On Tue, Jul 29, 2008 at 08:13:05AM +0200, Patrick McHardy wrote:
> > 
> > Thanks for this explanation. Unless Jozsef sees something wrong with this
> > patch, I'll queue it with a proper changelog. Its small enough, so perhaps
> > we can even put this in 2.6.27.
> 
> It killed 95% of the ghosts (if you can do such a thing :)
> 
> I've tried to determine the cause of the remaining spirits:
> 
> 1) Zero-window receivers.  This is like not acking without actually
> doing it.  So we should treat zero windows in the same way as an
> unacknowledged packet (with each probe/zero-window extending its
> life time).
> 
> 2) We've got a single state for each connection.  This doesn't
> work because each TCP connection really consists of two disparate
> streams.  Their states need to be tracked separately.
> 
> Otherwise we can for example enter TIME_WAIT when only one direction
> has been shut down.  This then causes the tracked connection to be
> pruned quickly, after which the other direction may reinstall
> it in the ESTABLISHED state with a pure ack and it could remain
> forever should that direction then die.

We always approximate the state of the sender from the packet it sends. As 
packets can be lost in transit (i.e we see a packet but it'll be lost), we 
cannot say for sure every time which is the actual state of *both* of the 
parties. Therefore we do not even attempt to track both states.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
