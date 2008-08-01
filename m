From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: TCP connection tracking timeout
Date: Fri, 1 Aug 2008 19:58:19 +0800
Message-ID: <20080801115819.GA19375@gondor.apana.org.au>
References: <20080729060105.GA16797@gondor.apana.org.au> <488EB4F1.60806@trash.net> <20080729090737.GA18046@gondor.apana.org.au> <Pine.LNX.4.64.0807291420590.1378@blackhole.kfki.hu> <20080729133444.GA19876@gondor.apana.org.au> <Pine.LNX.4.64.0807292135290.1679@blackhole.kfki.hu> <20080730013554.GA25736@gondor.apana.org.au> <Pine.LNX.4.64.0807302208030.3210@blackhole.kfki.hu> <20080731121935.GA8324@gondor.apana.org.au> <Pine.LNX.4.64.0807312124240.4318@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:41110 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753955AbYHAL60 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Aug 2008 07:58:26 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807312124240.4318@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 31, 2008 at 09:26:40PM +0200, Jozsef Kadlecsik wrote:
>
> So what do you suggest ;-)?

Out of a nutshell, let's divide the existing u8 state into two
separate states, each 4 bits wide.  They should be used to track
the two directions separately using the same logic that we currently
have.

The timout should then be computed as the maximum of that of each
state.  However, the overall timeout should be the minimum of this
and that given by the retransmit logic (This is because the logic
for retransmits is to detect the death of the connection at the
sender, in which case both directions evaporate).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
