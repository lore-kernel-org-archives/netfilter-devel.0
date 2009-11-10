From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Another issue with ipset on sparc64
Date: Tue, 10 Nov 2009 22:17:49 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0911102217060.23130@blackhole.kfki.hu>
References: <4513233BE7DF454BB62D30017EEE55436CFB992FEF@GVW1115EXC.americas.hpqcorp.net> <alpine.DEB.2.00.0911051936080.14280@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Chini, Georg (HP App Services)" <georg.chini@hp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:44170 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbZKJVRp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:17:45 -0500
In-Reply-To: <alpine.DEB.2.00.0911051936080.14280@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 5 Nov 2009, Jozsef Kadlecsik wrote:

> On Thu, 5 Nov 2009, Chini, Georg (HP App Services) wrote:
> 
> > I found another issue with ipset on sparc64 (Ultra2, 2 CPU, 2.6.31.5,
> > Debian5).
> > When I flush an iptreemap, one (of two) ksoftirqd goes up to 25% CPU
> > load and remains there until I delete the set. I don't have to place
> > anything in the map, just doing "ipset -N abc iptreemap; ipset -F abc" is
> > enough. Doing that again with another map will add 25% load to the
> > second ksoftirqd. Adding more maps will not change things further.
> 
> Thanks the reports! 
> 
> Tomorrow I'll setup the testbed and I'll be able to run the full test 
> suite in ipset. Then I can work on cleaning up all bigendian issues.

Please give a try to the new ipset release - it should fix all of the 
issues you reported.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
