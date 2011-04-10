From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset-6.2 testsuite failure
Date: Sun, 10 Apr 2011 20:18:49 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1104102013230.3680@blackhole.kfki.hu>
References: <alpine.LNX.2.01.1104071453410.19048@obet.zrqbmnf.qr> <alpine.DEB.2.00.1104072059250.22730@blackhole.kfki.hu> <alpine.LNX.2.01.1104101937470.549@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:41015 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470Ab1DJSSu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Apr 2011 14:18:50 -0400
In-Reply-To: <alpine.LNX.2.01.1104101937470.549@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 10 Apr 2011, Jan Engelhardt wrote:

> On Thursday 2011-04-07 21:10, Jozsef Kadlecsik wrote:
> >On Thu, 7 Apr 2011, Jan Engelhardt wrote:
> >
> >> Using 2.6.39-rc1+ (kaber/nf-next) with ipset-6.2 (plain, nfnetlink):
> >> 
> >> jng-0:/home/jengelh/code/ipset/tests # ./runtest.sh 
> >> hash:ip6: Network: Check listing: passed
> >> hash:ip6: Sleep 5s so that elements can time out: passed
> >> hash:ip6: Network: List set: passed
> >> hash:ip6: Network: Check listing: 6a7
> >> > 200:100:10:: timeout 0
> >> FAILED
> >> Failed test: diff -I 'Size in memory.*' .foo hash:ip6.t.list1 && rm .foo
> >> jng-0:/home/jengelh/code/ipset/tests # 
> >
> >I was unable to reproduce this with the kernel from Patrick's tree and 
> >with ipset-6.2.
> >
> >However, in the testsuite of ipset-6.2 the hash:ip6 tests are not executed 
> >just after the ipmap tests: there are missing tests in the listing above.
> >
> >Also, the testsuite in ipset-6.2 contains the tests against the kernel in 
> >the package itself: the patches I have submitted today are missing from 
> >2.6.39-rc1+
> 
> Tried with ipset 6.3 and modules from ipset-6.3, and seems to work.

Thanks! The kernel is a little bit behind the package.

I could add some conditions to the testsuite to check versions 
specifically, but that'd need patchlevel reporting from kernel and set 
match/target extension versioning in iptables. And that seems a too high 
burden.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
