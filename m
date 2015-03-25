From: Sergey Popovich <popovich_sergei@mail.ua>
Subject: Re: ipset: Proposed improvements to the kernel code
Date: Wed, 25 Mar 2015 16:54:54 +0200
Message-ID: <14722035.jXe0WcxyPC@tuxracer>
References: <2984705.dCFJb2qqrb@tuxracer> <alpine.DEB.2.10.1503171459340.25136@blackhole.kfki.hu> <4532245.8hNB4lJHyg@tuxracer>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fallback1.mail.ru ([94.100.181.184]:43031 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbbCYPbp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 11:31:45 -0400
Received: from smtp11.mail.ru (smtp11.mail.ru [94.100.179.252])
	by fallback1.mail.ru (mPOP.Fallback_MX) with ESMTP id C5B8153EDB69
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2015 17:55:03 +0300 (MSK)
In-Reply-To: <4532245.8hNB4lJHyg@tuxracer>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> > > I did not say that you should do anything, I just give an option (like
> > > branch) to let you quickly see changes I made if you wish. Maybe you
> > > find them totally useless:)
> > 
> > I see - a branch costs nothing, so that's no problem. Then create a
> > numbered list of the patches, put them in a tar file and let me know from
> > where I can download it.
> 
> Thanks Jozsef, I have prepare patches for you and put link to the series.
> 
> http://ftp.payport.com.ua/users/sergey/public/netfilter-devel-2015031701.tar
> 
> These patches will be against nf-next for simplicity and I'm already rebase
> them, so for first review just fresh nf-next will be needed.
> 

Fixes to the first series. One of the most important is the fixes to set and 
their data netlink dumping consistency. Just to complete series.

Netlink dumping consistency was inspired by the recent ipset git tree fixes
to this problem. However I think there are other problems with consistent
data dumping exists which my series tries to addess.

As the first series this is for nf-next git tree, not ipset git tree.

http://ftp.payport.com.ua/users/sergey/public/netfilter-devel-2015032501.tar

> Then new changes from the ipset-next could be backported into ipset git tree
> (say it would be named as ipset-stable to the analogy with linux-stable
> etc.).
> > Best regards,
> > Jozsef
> > -
> > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> > PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> > Address : Wigner Research Centre for Physics, Hungarian Academy of
> > Sciences
> > 
> >           H-1525 Budapest 114, POB. 49, Hungary

-- 
SP5474-RIPE
Sergey Popovich

