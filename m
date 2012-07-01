From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] build: restore -version-info
Date: Sun, 1 Jul 2012 14:11:28 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207011409470.2289@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu> <1341082043-26584-1-git-send-email-jengelh@inai.de> <1341082043-26584-2-git-send-email-jengelh@inai.de> <alpine.DEB.2.00.1206302357430.1075@blackhole.kfki.hu> <alpine.LNX.2.01.1207010013340.4459@frira.zrqbmnf.qr>
 <alpine.DEB.2.00.1207010029300.1245@blackhole.kfki.hu> <alpine.LNX.2.01.1207010048210.6863@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:53495 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295Ab2GAML3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jul 2012 08:11:29 -0400
In-Reply-To: <alpine.LNX.2.01.1207010048210.6863@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 1 Jul 2012, Jan Engelhardt wrote:

> On Sunday 2012-07-01 00:31, Jozsef Kadlecsik wrote:
> 
> >On Sun, 1 Jul 2012, Jan Engelhardt wrote:
> >
> >> On Sunday 2012-07-01 00:05, Jozsef Kadlecsik wrote:
> >> >> 
> >> >> diff --git a/Make_global.am b/Make_global.am
> >> >> index 4a8f61a..446c4de 100644
> >> >> --- a/Make_global.am
> >> >> +++ b/Make_global.am
> >> >> @@ -69,7 +69,7 @@
> >> >>  # interface. 
> >> >>  
> >> >>  #            curr:rev:age
> >> >> -LIBVERSION = 3:0:1
> >> >> +LIBVERSION = 3:0:0
> >> >
> >> >The new library release is backward compatible with the previous one, so 
> >> >age must be incremented. That's why I set LIBVERSION to 3:0:1 from 2:1:0. 
> >> 
> >> Correct -- if you had stayed with "-version-info", which you did not.
> >
> >So if it's reverted back (second part of your patch), the the first part 
> >is to be skipped.
> 
> Since you already have made a release (ipset-6.13) emitting an .so.3
> file, I don't think you should go back to .so.2. Hence I am using 3:0:0.

What I meant is to keep LIBVERSION = 3:0:1, because that's right from 
backward compatibility view, and restore back -version-info.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
