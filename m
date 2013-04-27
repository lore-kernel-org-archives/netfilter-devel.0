From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 00/13] ipset patches for nf-next
Date: Sat, 27 Apr 2013 22:15:58 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1304272208330.20098@blackhole.kfki.hu>
References: <1367067045-960-1-git-send-email-kadlec@blackhole.kfki.hu> <517BCA9A.3080602@googlemail.com> <alpine.DEB.2.00.1304272042070.1511@blackhole.kfki.hu> <517C3017.8090803@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:40356 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab3D0UP7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Apr 2013 16:15:59 -0400
In-Reply-To: <517C3017.8090803@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 27 Apr 2013, Dash Four wrote:

> Jozsef Kadlecsik wrote:
> > > Jozsef, are these features already supported in userspace or are you going
> > > to
> > > release a separate version?
> > 
> > It's already supported in userspace in the main branch of the git tree.
> Got it, thanks Jozsef, though I can't see any updates to the ipset branch of
> the netfilter.org tree (https://git.netfilter.org/ipset) - last update is
> showing 13 days ago.

It was committed there at that time - I has been waiting for net/nf-next 
to open up for new features since then.

> >  As the patch for the userspace part of the set match is committed in the
> > iptables git tree, there'll come the new ipset release.
> >   
> OK, good to know. I see that with the new patches you have expanded the 
> ipset data structure, which is also good - I could now fit all of my 
> "custom" changes without resorting to dark-art gimmicks as I did up 
> until now.

Yes, the new structure adds the possibilities for multiple extensions and 
that's also an important factor. Therefore the patchset is so big, but 
actually the whole code is smaller than the previous one.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
