From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: nomatch in bitmap:* sets
Date: Mon, 9 Apr 2012 20:33:15 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1204092031110.6233@blackhole.kfki.hu>
References: <4F81A7E5.3040400@googlemail.com> <alpine.DEB.2.00.1204082006190.4765@blackhole.kfki.hu> <4F82110E.70100@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:55654 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab2DISdT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Apr 2012 14:33:19 -0400
In-Reply-To: <4F82110E.70100@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 8 Apr 2012, Mr Dash Four wrote:

> > > Currently only hash:* sets have the "nomatch" feature. Could this be
> > > extended to bitmap:* sets as well?
> > >     
> > 
> > Actually, hash:*net* types have the "nomatch" feature. How would it make
> > sense to add it to the bitmap:* types too?
> >   
> I was thinking along the lines of this:
> 
> 1. bitmap:port - currently, if I want to exclude specific ports from a given
> range (say ports 21,80,119,443 from ports range 1-1023) then I have to do the
> following:
> n test-ports bitmap:port range 1-1023 timeout 0
> a test-ports 1-20
> a test-ports 22-79
> a test-ports 81-118
> a test-ports 120-442
> a test-ports 444-1023
> 
> Very inconvenient and it is not immediately obvious which ports have been
> excluded from that range. By doing something like this:
> n test-ports bitmap:port range 1-1023 timeout 0
> a test-ports 1-1023
> a test-ports 21 nomatch
> a test-ports 80 nomatch
> a test-ports 119 nomatch
> a test-ports 443 nomatch
> 
> it is much more clearer what is going on.

That's equivalent with

n test-ports bitmap:port range 1-1023 timeout 0
a test-ports 1-1023
d test-ports 21
d test-ports 80
d test-ports 119
d test-ports 443

Therefore I don't see the point of the "nomatch" flag for the bitmap:*
types.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
