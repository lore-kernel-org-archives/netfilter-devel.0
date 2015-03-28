From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset: Proposed improvements to the kernel code
Date: Sat, 28 Mar 2015 21:44:07 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1503282138470.16315@blackhole.kfki.hu>
References: <2984705.dCFJb2qqrb@tuxracer> <14722035.jXe0WcxyPC@tuxracer> <alpine.DEB.2.10.1503262309450.870@blackhole.kfki.hu> <6932701.ml7noqIVyU@tuxracer>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sergey Popovich <popovich_sergei@mail.ua>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:43666 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbbC1UmN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Mar 2015 16:42:13 -0400
In-Reply-To: <6932701.ml7noqIVyU@tuxracer>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 27 Mar 2015, Sergey Popovich wrote:

> > I can review them but the patches need to be ported to the ipset git 
> > tree.
> 
> I'm fully understand your point of view. And aggree with you as 
> maintainer and core developer of the ipset project.
> 
> However from my point of view this looks just horrible. I'm not happy 
> with taking much of time of making same work two times and rebase 
> patches against new tree.
> 
> So I decide to give my patch series status "works for me" and leave anything
> as is. Without any rebase to the ipset git tree.
> 
> >From private mails I known about your plans about in kernel ipset tree 
> (especially nf-next and mainline kernel therefore) and I'm compliment
> these changes.
> 
> Thanks for interest and reviewing of my series.

I do appreciate your work. However I cannot undo your decision not to base 
your patches on the ipset git tree.

I'll review your patches and apply what can be or logically fit, keeping 
your credits.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
