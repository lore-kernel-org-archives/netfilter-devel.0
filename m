From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset: Proposed improvements to the kernel code
Date: Thu, 26 Mar 2015 23:10:51 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1503262309450.870@blackhole.kfki.hu>
References: <2984705.dCFJb2qqrb@tuxracer> <alpine.DEB.2.10.1503171459340.25136@blackhole.kfki.hu> <4532245.8hNB4lJHyg@tuxracer> <14722035.jXe0WcxyPC@tuxracer>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sergey Popovich <popovich_sergei@mail.ua>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:38008 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbbCZWI6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2015 18:08:58 -0400
In-Reply-To: <14722035.jXe0WcxyPC@tuxracer>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 25 Mar 2015, Sergey Popovich wrote:

> > > > I did not say that you should do anything, I just give an option (like
> > > > branch) to let you quickly see changes I made if you wish. Maybe you
> > > > find them totally useless:)
> > > 
> > > I see - a branch costs nothing, so that's no problem. Then create a
> > > numbered list of the patches, put them in a tar file and let me know from
> > > where I can download it.
> > 
> > Thanks Jozsef, I have prepare patches for you and put link to the series.
> > 
> > http://ftp.payport.com.ua/users/sergey/public/netfilter-devel-2015031701.tar
> > 
> > These patches will be against nf-next for simplicity and I'm already rebase
> > them, so for first review just fresh nf-next will be needed.
> 
> Fixes to the first series. One of the most important is the fixes to set and 
> their data netlink dumping consistency. Just to complete series.
> 
> Netlink dumping consistency was inspired by the recent ipset git tree fixes
> to this problem. However I think there are other problems with consistent
> data dumping exists which my series tries to addess.
> 
> As the first series this is for nf-next git tree, not ipset git tree.
> 
> http://ftp.payport.com.ua/users/sergey/public/netfilter-devel-2015032501.tar

I can review them but the patches need to be ported to the ipset git tree.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
