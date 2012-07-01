From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] build: restore -version-info
Date: Sun, 1 Jul 2012 19:20:00 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207011838590.3212@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu> <1341082043-26584-1-git-send-email-jengelh@inai.de> <1341082043-26584-2-git-send-email-jengelh@inai.de> <alpine.DEB.2.00.1206302357430.1075@blackhole.kfki.hu> <alpine.LNX.2.01.1207010013340.4459@frira.zrqbmnf.qr>
 <alpine.DEB.2.00.1207010029300.1245@blackhole.kfki.hu> <alpine.LNX.2.01.1207010048210.6863@frira.zrqbmnf.qr> <alpine.DEB.2.00.1207011409470.2289@blackhole.kfki.hu> <alpine.LNX.2.01.1207011754110.17716@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:52274 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555Ab2GARUB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jul 2012 13:20:01 -0400
In-Reply-To: <alpine.LNX.2.01.1207011754110.17716@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 1 Jul 2012, Jan Engelhardt wrote:

> 
> On Sunday 2012-07-01 14:11, Jozsef Kadlecsik wrote:
> >> >> 
> >> >> Correct -- if you had stayed with "-version-info", which you did not.
> >> >
> >> >So if it's reverted back (second part of your patch), the the first part 
> >> >is to be skipped.
> >> 
> >> Since you already have made a release (ipset-6.13) emitting an .so.3
> >> file, I don't think you should go back to .so.2. Hence I am using 3:0:0.
> >
> >What I meant is to keep LIBVERSION = 3:0:1, because that's right from 
> >backward compatibility view, and restore back -version-info.
> 
> What part was unclear?
> 
> * 6.13 uses -version-number 3:0:1
> * that causes production of .so.3
> * it's set in stone
> * next incompatible change requires use of .so.4

Yes ,right.

[...] 
> * therefore the patch makes a clean restart,
>   using -version-info 3:0:0, to continue using .so.3
>   starting from ipset-6.13 until the next *real*
>   incompatible change.

What is still unclear for me, why a clean restart is required. Looking 
into "libtool", as I see, "-version-number 3:0:1" and "-version-info 
3:0:1" produces the same result. Why should the support of the previous 
interface be excluded?

> (If you care about the uninteresting third digit,
> -version-info 3:1:0 would be wanted.)

Now, you have confused me completely. -version-info 3:1:0 is converted 
directly into current, revision and age, in this order.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
