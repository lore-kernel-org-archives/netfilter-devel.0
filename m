From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: TCP connection tracking timeout
Date: Tue, 29 Jul 2008 17:07:37 +0800
Message-ID: <20080729090737.GA18046@gondor.apana.org.au>
References: <20080729030104.GA15915@gondor.apana.org.au> <488EA0F1.2050906@trash.net> <488EA3FE.7050503@trash.net> <20080729060105.GA16797@gondor.apana.org.au> <488EB4F1.60806@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:33648 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752824AbYG2JHn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2008 05:07:43 -0400
Content-Disposition: inline
In-Reply-To: <488EB4F1.60806@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 29, 2008 at 08:13:05AM +0200, Patrick McHardy wrote:
> 
> Thanks for this explanation. Unless Jozsef sees something wrong with this
> patch, I'll queue it with a proper changelog. Its small enough, so perhaps
> we can even put this in 2.6.27.

It killed 95% of the ghosts (if you can do such a thing :)

I've tried to determine the cause of the remaining spirits:

1) Zero-window receivers.  This is like not acking without actually
doing it.  So we should treat zero windows in the same way as an
unacknowledged packet (with each probe/zero-window extending its
life time).

2) We've got a single state for each connection.  This doesn't
work because each TCP connection really consists of two disparate
streams.  Their states need to be tracked separately.

Otherwise we can for example enter TIME_WAIT when only one direction
has been shut down.  This then causes the tracked connection to be
pruned quickly, after which the other direction may reinstall
it in the ESTABLISHED state with a pure ack and it could remain
forever should that direction then die.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
