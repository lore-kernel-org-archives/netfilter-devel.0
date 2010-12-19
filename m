From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sun, 19 Dec 2010 01:05:34 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012190100180.11753@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <1292657351.2371.73.camel@kushiel.sterenborg.info> <alpine.DEB.2.00.1012181149560.11002@blackhole.kfki.hu> <alpine.LNX.2.01.1012181635530.13544@obet.zrqbmnf.qr>
 <alpine.DEB.2.00.1012182024240.11577@blackhole.kfki.hu> <alpine.LNX.2.01.1012182136190.19284@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Rob Sterenborg (lists)" <lists@sterenborg.info>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:39155 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab0LSAFg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 19:05:36 -0500
In-Reply-To: <alpine.LNX.2.01.1012182136190.19284@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 18 Dec 2010, Jan Engelhardt wrote:

> >from other architectures, like Sparc or ARM too. (On Wednesday I'll be 
> >able to dust off a Sparc machine and run the compilation and testsuite.)
> 
> I already made this year's presents: a PPC64 is here,
> but it yet needs to be installed...
> 
> You can use my sparc. Pierre Chifflier already had his ulogd
> pieces tested here in pair programming with shared screen(1)
> sessions (great stuff that!).

Let us see the fixes worked, see below
 
> == sparcv9
> 
> 22:31 ares:~/code/ipset > make -k
> make  all-recursive
> make[1]: Entering directory `/home/jengelh/code/ipset'
> Making all in lib
> make[2]: Entering directory `/home/jengelh/code/ipset/lib'
>   CC     data.lo
>   CC     icmp.lo
>   CC     icmpv6.lo
>   CC     mnl.lo
>   CC     parse.lo
> cc1: warnings being treated as errors
> parse.c: In function ?get_addrinfo?:
> parse.c:637:11: error: cast increases required alignment of target type
> parse.c:640:11: error: cast increases required alignment of target type

Oh well, the good old Sparc issue. I put back the workaround and pushed.

> 22:43 ares:../ipset/kernel > make

Nobody is supposed to run `make' in the kernel/ subdir. You should have 
typed one level above:

ares:../ipset/ > make modules

I have added a check to Makefile, to prevent it. 

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
