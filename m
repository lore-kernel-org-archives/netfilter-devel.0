From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: TCP connection tracking timeout
Date: Tue, 29 Jul 2008 14:01:05 +0800
Message-ID: <20080729060105.GA16797@gondor.apana.org.au>
References: <20080729030104.GA15915@gondor.apana.org.au> <488EA0F1.2050906@trash.net> <488EA3FE.7050503@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43035 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751561AbYG2GBJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2008 02:01:09 -0400
Content-Disposition: inline
In-Reply-To: <488EA3FE.7050503@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 29, 2008 at 07:00:46AM +0200, Patrick McHardy wrote:
> Patrick McHardy wrote:
> >[List address fixed - I assume netfilter-devel@lists.debian.org 
> >doesn't exist :)]

Heh my fingers were doing the thinking :)

> >That sounds like a pretty neat idea. I'm testing a patch now, I'll
> >send it over in a few minutes if it survives :)

Awesome! I'll try this out on my router.

> This seems to work. I'm wondering however if this will really help.
> We already track retransmissions and decrease the timeout on the
> 3rd retransmission, so this should only help if both the sender and
> the receiver went down.

The problem with requiring a 3rd retransmit is that once a socket
is orphaned (closed) on Linux, we fast-track the retransmit timeout
process.  In particular, if it's already maxed out the RTO prior
to closing, we'll kill it straight away.

This is in violation of the RFCs but it's an important optimisation.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
