From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: TCP connection tracking timeout
Date: Tue, 29 Jul 2008 17:30:51 +0800
Message-ID: <20080729093051.GA18143@gondor.apana.org.au>
References: <20080729030104.GA15915@gondor.apana.org.au> <488EA0F1.2050906@trash.net> <488EA3FE.7050503@trash.net> <20080729060105.GA16797@gondor.apana.org.au> <488EB4F1.60806@trash.net> <20080729090737.GA18046@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:45701 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754260AbYG2Jay (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2008 05:30:54 -0400
Content-Disposition: inline
In-Reply-To: <20080729090737.GA18046@gondor.apana.org.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 29, 2008 at 05:07:37PM +0800, Herbert Xu wrote:
>
> 1) Zero-window receivers.  This is like not acking without actually
> doing it.  So we should treat zero windows in the same way as an
> unacknowledged packet (with each probe/zero-window extending its
> life time).

Oh and this should probably only be done after we detect the
first zero probe heading the other way and coming back with
a second zero window (just in case the zero window happens to
match the completion of data on the sending side).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
