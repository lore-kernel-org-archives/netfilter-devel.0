From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Problem with ipset on sparc64
Date: Thu, 5 Nov 2009 19:36:01 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0911051934400.14280@blackhole.kfki.hu>
References: <4513233BE7DF454BB62D30017EEE55436CFB9228E4@GVW1115EXC.americas.hpqcorp.net> <alpine.LSU.2.00.0911042258430.16456@obet.zrqbmnf.qr> <alpine.DEB.2.00.0911050924280.13373@blackhole.kfki.hu> <alpine.DEB.2.00.0911051134520.13373@blackhole.kfki.hu>
 <alpine.LSU.2.00.0911051202050.23132@obet.zrqbmnf.qr> <alpine.DEB.2.00.0911051220090.13373@blackhole.kfki.hu> <alpine.LSU.2.00.0911051229590.28909@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: davem@davemloft.net,
	"Chini, Georg (HP App Services)" <georg.chini@hp.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:33967 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758218AbZKESf5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:35:57 -0500
In-Reply-To: <alpine.LSU.2.00.0911051229590.28909@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 5 Nov 2009, Jan Engelhardt wrote:

> On Thursday 2009-11-05 12:21, Jozsef Kadlecsik wrote:
> >> >In a few days I'll be able to use an Ultra 10 for testing - that'll settle 
> >> >the validating on big endian hardware.
> >> 
> >> Does not Dave have some 64-bit sparks in the basement that may
> >> be shared and given remote access to?
> >> (It seems Netfilter is one of the subsystems most plagued by endianess, 
> >> aligning and sizeof(long) variances ;-)
> >
> >Dave don't need to dig into his SPARC collection :-) - I'll setup this 
> >machine as a testbed for netfilter/ipset.
> 
> But since the Ultra10 is just 32-bit IIRC, you would not have a
> chance to hit the rare 64-bit alignment problems (both in terms of
> SIGBUS and "invalid match size 16 != 12"), should there be any.

SUN Ultra 10 has got a 300, 333, 360, or 440-MHz UltraSPARC[tm]-IIi 
processor. So it's definitely a bigendian machine.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
