From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: TCP connection tracking timeout
Date: Tue, 29 Jul 2008 21:34:44 +0800
Message-ID: <20080729133444.GA19876@gondor.apana.org.au>
References: <20080729030104.GA15915@gondor.apana.org.au> <488EA0F1.2050906@trash.net> <488EA3FE.7050503@trash.net> <20080729060105.GA16797@gondor.apana.org.au> <488EB4F1.60806@trash.net> <20080729090737.GA18046@gondor.apana.org.au> <Pine.LNX.4.64.0807291420590.1378@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:49880 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758576AbYG2New (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2008 09:34:52 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807291420590.1378@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 29, 2008 at 02:30:14PM +0200, Jozsef Kadlecsik wrote:
>
> We always approximate the state of the sender from the packet it sends. As 
> packets can be lost in transit (i.e we see a packet but it'll be lost), we 
> cannot say for sure every time which is the actual state of *both* of the 
> parties. Therefore we do not even attempt to track both states.

No I'm not suggesting that your state must be equal to that of
each side, what I'm saying is that the TCP state machine is
fundamentally divided into two directions.  If you're going
to track state at all you need to track both directions separately.
Otherwise the state transitions are simply bogus.

For example, TIME_WAIT is a state that only makes sense if
you look at a given direction.  The other direction may well
still be ESTABLISHED.  As it is netfilter will lower the timeout
when only a single direction has been shut down, thus causing
the connection to be prematurely killed.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
