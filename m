From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH nf] netfilter: nat: remove incorrect debug assert
Date: Fri, 3 Mar 2017 20:40:47 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1703032035220.15461@blackhole.kfki.hu>
References: <20170208221429.3555-1-fw@strlen.de> <20170221140909.GA3286@salvia> <20170221144019.GD9708@breakpoint.cc> <20170303115534.GA13931@salvia> <20170303124404.GB29213@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:42260 "EHLO smtp0.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751602AbdCCTme (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 14:42:34 -0500
In-Reply-To: <20170303124404.GB29213@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 3 Mar 2017, Florian Westphal wrote:

> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > However, changing test to if (iph->frag_off) return -NF_ACCEPT seems
> > > wrong too because we have enough info to track. OTOH, this only happens
> > > with HDRINCL+raw socket so perhaps we shouldn't care about this and
> > > just change ipv4 l3 tracker to ignore all packets w. iph->frag_off set.
> > 
> > Florian, unless you rise your hand, I'm going to take this patch so we
> > at least fix splats here. I still have the impression that this
> > setsockopt() option and its interaction with netfilter is broken at
> > many levels.
> 
> Hmmm, I think we should disable tracking of all fragmented packets,
> or at least disable NAT of all fragmented packets.

I think that is the safest solution, i.e. disable tracking and NAT for all 
fragmented packets.

> If we NAT 1st packet only then frag reasm won't complete anyway.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
