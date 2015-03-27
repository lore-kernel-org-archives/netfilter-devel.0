From: Sergey Popovich <popovich_sergei@mail.ua>
Subject: Re: ipset: Proposed improvements to the kernel code
Date: Fri, 27 Mar 2015 09:41:14 +0200
Message-ID: <6932701.ml7noqIVyU@tuxracer>
References: <2984705.dCFJb2qqrb@tuxracer> <14722035.jXe0WcxyPC@tuxracer> <alpine.DEB.2.10.1503262309450.870@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp39.i.mail.ru ([94.100.177.99]:40580 "EHLO smtp39.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595AbbC0HlX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2015 03:41:23 -0400
In-Reply-To: <alpine.DEB.2.10.1503262309450.870@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> On Wed, 25 Mar 2015, Sergey Popovich wrote:

> > Netlink dumping consistency was inspired by the recent ipset git tree
> > fixes
> > to this problem. However I think there are other problems with consistent
> > data dumping exists which my series tries to addess.
> > 
> > As the first series this is for nf-next git tree, not ipset git tree.
> > 
> > http://ftp.payport.com.ua/users/sergey/public/netfilter-devel-2015032501.t
> > ar
> I can review them but the patches need to be ported to the ipset git tree.
> 

I'm fully understand your point of view. And aggree with you as maintainer
and core developer of the ipset project.

However from my point of view this looks just horrible. I'm not happy with
taking much of time of making same work two times and rebase patches
against new tree.

So I decide to give my patch series status "works for me" and leave anything
as is. Without any rebase to the ipset git tree.

>From private mails I known about your plans about in kernel ipset tree 
(especially nf-next and mainline kernel therefore) and I'm compliment
these changes.

Thanks for interest and reviewing of my series.

> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
>           H-1525 Budapest 114, POB. 49, Hungary
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
SP5474-RIPE
Sergey Popovich

