From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] build: restore -version-info
Date: Sun, 1 Jul 2012 22:45:27 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207012232420.3510@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu> <1341082043-26584-1-git-send-email-jengelh@inai.de> <1341082043-26584-2-git-send-email-jengelh@inai.de> <alpine.DEB.2.00.1206302357430.1075@blackhole.kfki.hu> <alpine.LNX.2.01.1207010013340.4459@frira.zrqbmnf.qr>
 <alpine.DEB.2.00.1207010029300.1245@blackhole.kfki.hu> <alpine.LNX.2.01.1207010048210.6863@frira.zrqbmnf.qr> <alpine.DEB.2.00.1207011409470.2289@blackhole.kfki.hu> <alpine.LNX.2.01.1207011754110.17716@frira.zrqbmnf.qr> <alpine.DEB.2.00.1207011838590.3212@blackhole.kfki.hu>
 <alpine.LNX.2.01.1207011953290.21627@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:55122 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab2GAUp3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jul 2012 16:45:29 -0400
In-Reply-To: <alpine.LNX.2.01.1207011953290.21627@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 1 Jul 2012, Jan Engelhardt wrote:

> On Sunday 2012-07-01 19:20, Jozsef Kadlecsik wrote:
> >[...] 
> >> * therefore the patch makes a clean restart,
> >>   using -version-info 3:0:0, to continue using .so.3
> >>   starting from ipset-6.13 until the next *real*
> >>   incompatible change.
> >
> >What is still unclear for me, why a clean restart is required. Looking 
> >into "libtool", as I see, "-version-number 3:0:1" and "-version-info 
> >3:0:1" produces the same result.
> 
> They don't. The libtool manual goes on attempting to explain
> "-version-number" with C:R:A, though it could have been a lot easier
> to just say "it copies the values as-is to the file suffix".
> 
> ---8<---
> location git://git.inai.de/ipset (updated)
> 
> parent 7c7b022a18ea2bae11d889b345caef87f3bf145e (v6.13)
> commit 2b145f0794de6f56eaded0a6403be995be98c93b
> Author: Jan Engelhardt <jengelh@inai.de>
> Date:   Sat Jun 30 20:39:27 2012 +0200
> 
> build: restore -version-info
> 
> Commit v6.13~7 accidentally swapped "-version-info" with
> "-version-number". Because "-version-number" takes the values
> "FIRST:AGE:REV", which is different from "-version-info
> CURRENT:REV:AGE", libipset.so.3 was emitted.

Ohh, I got it - thanks, really. Somehow I stopped at how CURR is 
calculated from FIRST and AGE. 

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
