From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH nf] ipset: allow a 0 netmask with hash_netiface type
Date: Wed, 13 Jan 2016 09:33:23 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1601130930120.22698@blackhole.kfki.hu>
References: <1452614825-19749-1-git-send-email-fw@strlen.de> <alpine.DEB.2.10.1601122046240.19324@blackhole.kfki.hu> <20160112195323.GB17166@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:46813 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbcAMIdL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2016 03:33:11 -0500
In-Reply-To: <20160112195323.GB17166@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 12 Jan 2016, Florian Westphal wrote:

> Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > 
> > On Tue, 12 Jan 2016, Florian Westphal wrote:
> > 
> > > Jozsef says:
> > >  The correct behaviour is that if we have
> > >  ipset create test1 hash:net,iface
> > >  ipset add test1 0.0.0.0/0,eth0
> > >  iptables -A INPUT -m set --match-set test1 src,src
> > > 
> > >  then the rule should match for any traffic coming in through eth0.
> > > 
> > > This removes the -EINVAL runtime test to make matching work
> > > in case packet arrived via the specified interface.
> > 
> > No, the patch actually would break the set type. In order to support /0 
> > prefixes, cidr + 1 is stored internally. Zero value means "empty 
> > slot/bucket".
> 
> Hmm, but matching is broken currently, the rule quoted above never
> matches.  And its exaclty because of if (e.cidr == 0) is true.
> 
> Tested with nf-next tree.
> Before patch: never matches
> After patch: matches for all packets from eth0

I was wrong and the patch is correct, the removed condition is just 
unnecessary and breaks to match /0. I have already applied the patch in 
the ipset tree and added a new test to verify the case. Thanks, Florian!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
