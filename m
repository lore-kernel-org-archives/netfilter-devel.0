From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/8] ipset patches
Date: Mon, 16 Jan 2012 16:52:21 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1201161650330.32599@blackhole.kfki.hu>
References: <1326559141-26783-1-git-send-email-kadlec@blackhole.kfki.hu> <20120116124559.GB13131@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:54124 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab2APPwX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jan 2012 10:52:23 -0500
In-Reply-To: <20120116124559.GB13131@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 16 Jan 2012, Pablo Neira Ayuso wrote:

> On Sat, Jan 14, 2012 at 05:38:53PM +0100, Jozsef Kadlecsik wrote:
> > 
> > Here follow the patches which bring the kernel in sync with the current
> > ipset release. I included the patches which was sent in September but was
> > forgotten due to the kernel.org issues. Please consider applying them.
> > 
> > Jan Engelhardt (3):
> >   netfilter: ipset: use NFPROTO_ constants
> >   netfilter: ipset: avoid use of kernel-only types
> >   netfilter: ipset: expose userspace-relevant parts in ip_set.h
> > 
> > Jozsef Kadlecsik (5):
> >   netfilter: ipset: Autoload set type modules safely
> >   netfilter: ipset: Dumping error triggered removing references twice
> >   netfilter: ipset: Log warning when a hash type of set gets full
> >   netfilter: ipset: Exceptions support added to hash:*net* types
> >   netfilter: ipset: hash:net,iface timeout bug fixed
> 
> Thanks Jozsef. I'll take this once. net-next becomes active again
> (after -rc1 is released).
> 
> It would *really* great if you can set some git tree I can pull
> your changes from.

Here you are, you can pull the changes from

	git://blackhole.kfki.hu/git/net-next ipset

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
