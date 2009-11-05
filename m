From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Problem with ipset on sparc64
Date: Thu, 5 Nov 2009 12:21:58 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0911051220090.13373@blackhole.kfki.hu>
References: <4513233BE7DF454BB62D30017EEE55436CFB9228E4@GVW1115EXC.americas.hpqcorp.net> <alpine.LSU.2.00.0911042258430.16456@obet.zrqbmnf.qr> <alpine.DEB.2.00.0911050924280.13373@blackhole.kfki.hu> <alpine.DEB.2.00.0911051134520.13373@blackhole.kfki.hu>
 <alpine.LSU.2.00.0911051202050.23132@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: davem@davemloft.net,
	"Chini, Georg (HP App Services)" <georg.chini@hp.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:40900 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbZKELVx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2009 06:21:53 -0500
In-Reply-To: <alpine.LSU.2.00.0911051202050.23132@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 5 Nov 2009, Jan Engelhardt wrote:

> On Thursday 2009-11-05 11:36, Jozsef Kadlecsik wrote:
> >> > The lack of cheap access to big-endian, alignment-sensitive hardware
> >> > means many codes do not get the testing they deserve :-/
> >> 
> >> Yes, that's exaxtly. Funnily enough a few years ago I toyed the idea to 
> >> buy a thrown out SPARCCenter2000 but I didn't have enough power in my 
> >> place to boot up such a machine...
> >
> >In a few days I'll be able to use an Ultra 10 for testing - that'll settle 
> >the validating on big endian hardware.
> 
> Does not Dave have some 64-bit sparks in the basement that may
> be shared and given remote access to?
> (It seems Netfilter is one of the subsystems most plagued by endianess, 
> aligning and sizeof(long) variances ;-)

Dave don't need to dig into his SPARC collection :-) - I'll setup this 
machine as a testbed for netfilter/ipset.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
