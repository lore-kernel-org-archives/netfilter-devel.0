From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 0/3] ipset fixes
Date: Sat, 22 Sep 2012 21:22:08 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1209221705440.18018@blackhole.kfki.hu>
References: <1348259901-16369-1-git-send-email-kadlec@blackhole.kfki.hu> <20120922103433.GA26572@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:38814 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab2IVTWM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Sep 2012 15:22:12 -0400
In-Reply-To: <20120922103433.GA26572@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Sat, 22 Sep 2012, Pablo Neira Ayuso wrote:

> On Fri, Sep 21, 2012 at 10:38:21PM +0200, Jozsef Kadlecsik wrote:
> > 
> > Here follows two important ipset fixes against your nf tree. (The first
> > patch is an old one somehow forgotten to send or apply and the other
> > ones depend on it.)
> > 
> > You can pull these changes from:
> > 
> > git://blackhole.kfki.hu/nf master
> > 
> > Jozsef Kadlecsik (3):
> >   netfilter: ipset: Fix sparse warnings "incorrect type in assignment"
> 
> This one above has to go through nf-next. I can manually applied, no
> need to resend the patch.

OK, thanks.
 
> >   netfilter: ipset: Check and reject crazy /0 input parameters
> >   netfilter: ipset: Fix cidr book keeping for hash:*net* types
> 
> Please, could you develop how critical are these above? We're fairly
> late in the release cycle, I'd prefer if we pass only really critical
> fixes.

> >   netfilter: ipset: Check and reject crazy /0 input parameters

This one is easy to trigger: bitmap:ip sets are allowed to be created from 
range 0/0, but with /16 subnets as elements:

ipset new foo bitmap:ip range 0/0 netmask 16

However if "netmask 16" is left out accidentally, the kernel does not 
reject it but creates a broken set and the system will crash when the 
first element is added.

If we are quite late in the release cycle, maybe it can wait and be added 
to nf-next only.

> >   netfilter: ipset: Fix cidr book keeping for hash:*net* types

You asked to check how critical the bug is, and it was just the perfect 
question :-). I have re-checked and I was mistaken. The new case (zero 
cidr size), which was not handled by the old code, somehow misled me. So 
the patch description should be rewritten - I'm going to send a new batch 
of the patches against nf-next tomorrow. Thanks!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
