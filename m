From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/8] ipset patches
Date: Tue, 17 Jan 2012 09:18:51 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1201170913450.2015@blackhole.kfki.hu>
References: <1326559141-26783-1-git-send-email-kadlec@blackhole.kfki.hu> <20120116124559.GB13131@1984> <20120116231601.GA18087@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:58318 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab2AQISy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:18:54 -0500
In-Reply-To: <20120116231601.GA18087@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 17 Jan 2012, Pablo Neira Ayuso wrote:

> On Mon, Jan 16, 2012 at 01:45:59PM +0100, Pablo Neira Ayuso wrote:
> > > Jan Engelhardt (3):
> > >   netfilter: ipset: use NFPROTO_ constants
> > >   netfilter: ipset: avoid use of kernel-only types
> > >   netfilter: ipset: expose userspace-relevant parts in ip_set.h
> > > 
> > > Jozsef Kadlecsik (5):
> > >   netfilter: ipset: Autoload set type modules safely
> > >   netfilter: ipset: Dumping error triggered removing references twice
> > >   netfilter: ipset: Log warning when a hash type of set gets full
> > >   netfilter: ipset: Exceptions support added to hash:*net* types
> > >   netfilter: ipset: hash:net,iface timeout bug fixed
> 
> If you tell me what patches are bugfixes, we can still pass them to
> get them included into 3.3-rc.

Then please cherry-pick at least these two patches:

netfilter: ipset: Autoload set type modules safely
netfilter: ipset: Dumping error triggered removing references twice

The third bugfix

netfilter: ipset: hash:net,iface timeout bug fixed

was committed (the issue discovered) after adding the exceptions support 
and unfortunately the two patches are dependent.

> Enhancements will have to go to net-next.

Thanks!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
