From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset-6.2 testsuite failure
Date: Mon, 11 Apr 2011 10:40:33 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1104111038350.6049@blackhole.kfki.hu>
References: <alpine.LNX.2.01.1104071453410.19048@obet.zrqbmnf.qr> <alpine.DEB.2.00.1104072059250.22730@blackhole.kfki.hu> <alpine.LNX.2.01.1104101937470.549@obet.zrqbmnf.qr> <alpine.DEB.2.00.1104102013230.3680@blackhole.kfki.hu>
 <alpine.LNX.2.01.1104110207210.2501@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:36804 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411Ab1DKIkf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Apr 2011 04:40:35 -0400
In-Reply-To: <alpine.LNX.2.01.1104110207210.2501@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 11 Apr 2011, Jan Engelhardt wrote:

> On Sunday 2011-04-10 20:18, Jozsef Kadlecsik wrote:
> >> >Also, the testsuite in ipset-6.2 contains the tests against the kernel in 
> >> >the package itself: the patches I have submitted today are missing from 
> >> >2.6.39-rc1+
> >> 
> >> Tried with ipset 6.3 and modules from ipset-6.3, and seems to work.
> >
> >Thanks! The kernel is a little bit behind the package.
> 
> The testsuite should use diff -u at least, the context numbers are not very
> telling.

I updated the testsuite in git tree, 'diff -u' is used at displaying the 
differences.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
