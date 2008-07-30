From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: TCP connection tracking timeout
Date: Wed, 30 Jul 2008 09:35:54 +0800
Message-ID: <20080730013554.GA25736@gondor.apana.org.au>
References: <20080729030104.GA15915@gondor.apana.org.au> <488EA0F1.2050906@trash.net> <488EA3FE.7050503@trash.net> <20080729060105.GA16797@gondor.apana.org.au> <488EB4F1.60806@trash.net> <20080729090737.GA18046@gondor.apana.org.au> <Pine.LNX.4.64.0807291420590.1378@blackhole.kfki.hu> <20080729133444.GA19876@gondor.apana.org.au> <Pine.LNX.4.64.0807292135290.1679@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59069 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752852AbYG3BgD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2008 21:36:03 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807292135290.1679@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 29, 2008 at 10:34:51PM +0200, Jozsef Kadlecsik wrote:
>
> > For example, TIME_WAIT is a state that only makes sense if
> > you look at a given direction.  The other direction may well
> > still be ESTABLISHED.  As it is netfilter will lower the timeout
> > when only a single direction has been shut down, thus causing
> > the connection to be prematurely killed.
> 
> Hm, I might be completely outdated: how come that in one direction the 
> state is TIME_WAIT and the other's ESTABLISHED? If one side is in the 
> TIME_WAIT state, the other one cannot be in the ESTABLISHED state - at 
> least according to RFC793, RFC1122. What do I miss here?

OK that was a stupid example.  All I'm trying say is that the
state transition as it stands is bogus.  Here is why:

If you see receive a FIN in one direction but no ack in the other,
you go from sES to sFW.  If that isn't acked and a FIN retransmit
occurs you go from sFW to sLA.  Now if the other direction is still
transmitting and you get an ACK in the direction being shut down,
it goes from sLA to sTW.  However, in reality the side that's still
transmitting may still be in ESTABLISHED because it never received
those FINs.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
