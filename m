From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP connection tracking timeout
Date: Thu, 31 Jul 2008 21:26:40 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807312124240.4318@blackhole.kfki.hu>
References: <488EA0F1.2050906@trash.net> <488EA3FE.7050503@trash.net>
 <20080729060105.GA16797@gondor.apana.org.au> <488EB4F1.60806@trash.net>
 <20080729090737.GA18046@gondor.apana.org.au> <Pine.LNX.4.64.0807291420590.1378@blackhole.kfki.hu>
 <20080729133444.GA19876@gondor.apana.org.au> <Pine.LNX.4.64.0807292135290.1679@blackhole.kfki.hu>
 <20080730013554.GA25736@gondor.apana.org.au> <Pine.LNX.4.64.0807302208030.3210@blackhole.kfki.hu>
 <20080731121935.GA8324@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:39266 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbYGaT0m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:26:42 -0400
In-Reply-To: <20080731121935.GA8324@gondor.apana.org.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 31 Jul 2008, Herbert Xu wrote:

[...]
> This is slightly better but it is still fundamentally broken.
> Do we really need to establish a committee just to add a new
> state? :)
> 
> We can squeeze out the requisite number of bits (4) from the
> existing state variable.

So what do you suggest ;-)?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
