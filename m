From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.15 released
Date: Mon, 19 Nov 2012 20:57:30 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211192056520.23128@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1211191356240.21756@blackhole.kfki.hu> <CADuigkXXwhGkjYVCo68BmOGSbe95DzSYcM6u-YQmrjKSD5VWaQ@mail.gmail.com> <alpine.LNX.2.01.1211191927160.9275@nerf07.vanv.qr>
 <CADuigkV+d=xvKvKODTyA8avp21ZcL0pY0TjhxAehQi975wkwdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Ricardo Klein <klein.rfk@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:54052 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041Ab2KST5c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Nov 2012 14:57:32 -0500
In-Reply-To: <CADuigkV+d=xvKvKODTyA8avp21ZcL0pY0TjhxAehQi975wkwdQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 19 Nov 2012, Ricardo Klein wrote:

> if  you need, I can deploy a clean CentOS 6.3 64bits and test it again
> running autogen with pkg-config installed....

Yes, please. A double check does not hurt.

Best regards,
Jozsef
 
> On Mon, Nov 19, 2012 at 4:28 PM, Jan Engelhardt <jengelh@inai.de> wrote:
> > On Monday 2012-11-19 18:39, Ricardo Klein wrote:
> >
> >>It fails on ./configure on CentOS 6.3 x84_64 with the message:
> >>./configure: line 14702: syntax error near unexpected token `libmnl,'
> >>./configure: line 14702: `PKG_CHECK_MODULES(libmnl, libmnl >= 1)'
> >
> > This means you ran autoreconf (which you normally don't need to, because
> > there already is a configure script), while at the same time did not
> > have pkg-config installed.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
