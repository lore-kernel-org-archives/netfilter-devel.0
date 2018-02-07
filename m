From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [nft PATCH] Enable automerge feature for anonymous sets
Date: Wed, 7 Feb 2018 10:51:05 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1802071045130.1525@blackhole.kfki.hu>
References: <20180206181847.14434-1-phil@nwl.cc> <20180206233943.6shg7qeg2mg6u2gg@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Jeff Kletsky <netfilter@allycomm.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:55493 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751269AbeBGJvN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 04:51:13 -0500
In-Reply-To: <20180206233943.6shg7qeg2mg6u2gg@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 7 Feb 2018, Pablo Neira Ayuso wrote:

> On Tue, Feb 06, 2018 at 07:18:47PM +0100, Phil Sutter wrote:
> > Automatic merging of adjacent/overlapping ranges upon insertion has
> > clear benefits performance- and readability-wise. The drawbacks which
> > led to disabling it by default don't apply to anonymous sets since they
> > are read-only anyway, so enable this feature for them again.
> 
> Question is, why someone would be adding elements with overlapping 
> ranges in an anonymous set? Then, when listing the ruleset you will get 
> something different to what you've added. This would also be 
> inconsistent with regards to the existing behaviour in named sets, where 
> this is turned off by default.
> 
> For named sets, that are useful to maintain white/blacklists, I 
> understand this simplifies complexity for people dealing with them. But 
> not sure for anonymous sets.
> 
> @Jeff: Is this also useful to you in the anonymous set use-case? IIRC we 
> agreed that this was good for named sets, but not for anonymous sets.

In my opinion the consistent behaviour is the most desired one. Such 
subleties that by default there's no automerge in named sets but it's on 
for anonymous sets are easily overlooked by users. Better have a flag, 
option to turn it on explicitly for a given anonymous set.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
