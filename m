From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.28 released
Date: Sun, 13 Mar 2016 12:29:40 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1603131227140.18557@blackhole.kfki.hu>
References: <alpine.DEB.2.10.1603122210440.15491@blackhole.kfki.hu> <alpine.LSU.2.20.1603122259210.6559@nerf40.vanv.qr> <alpine.DEB.2.10.1603131133010.18557@blackhole.kfki.hu> <alpine.LSU.2.20.1603131212410.8784@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:37252 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932474AbcCML2z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Mar 2016 07:28:55 -0400
In-Reply-To: <alpine.LSU.2.20.1603131212410.8784@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 13 Mar 2016, Jan Engelhardt wrote:

> By the way, there is another issue. You are calling `modinfo` when make
> install, but you are not passing  -b ${DESTDIR}, so it, too, fails
> inside chroot buildroots. (because /lib/modules/V/kernel is empty;
> ipset is in $DESTDIR/lib/modules/V/...)

The variable DESTDIR is not defined by default, so some other trickery is 
required to get the chroot prefix dir path at that level, when `modinfo` 
is called. How do you call `configure` or `make`?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
