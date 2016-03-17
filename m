From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.29 released
Date: Thu, 17 Mar 2016 14:00:52 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1603171357330.17324@blackhole.kfki.hu>
References: <alpine.DEB.2.10.1603162136130.7414@blackhole.kfki.hu> <56EA4462.6010106@fastest.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: AllKind <AllKind@fastest.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:38105 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935577AbcCQNAH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Mar 2016 09:00:07 -0400
In-Reply-To: <56EA4462.6010106@fastest.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 17 Mar 2016, AllKind wrote:

> On 16.03.2016 21:40, Jozsef Kadlecsik wrote:
> > 
> > ipset 6.29 is released, because the configure script was broken and a
> > race condition was fixed in concurrent save-swap and then delete
> > operations.
> [...]
> 
> No more utils update? why?

I'm travelling with surprisingly bad network access and I was happy to 
push out the release to solve the configure issue. Utils is not forgotten 
:-)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
