From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.21.1 released
Date: Fri, 7 Mar 2014 21:07:22 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1403072058470.3887@blackhole.kfki.hu>
References: <alpine.DEB.2.10.1403071328240.32311@blackhole.kfki.hu> <alpine.LSU.2.11.1403071705010.22956@nerf08.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:56134 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbaCGUH1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 15:07:27 -0500
In-Reply-To: <alpine.LSU.2.11.1403071705010.22956@nerf08.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 7 Mar 2014, Jan Engelhardt wrote:

> On Friday 2014-03-07 13:32, Jozsef Kadlecsik wrote:
> 
> >Userspace changes:
> >  - Fix libipset library release versioning (reported by Mathieu Bridon)
> 
> AFAICS, functions were only added, yet the SONAME was changed.
> (-version-info 7:0:4 should have been -version-info 7:0:5)

6.20.1 was released with LIBVERSION = 5:0:2 (libipset.so.3.2.0). The 
hash:ip,mark patch increased only age to 5:0:3, which was an unnoticed 
mistake. That was then incremented to 6:0:4 in the forceadd patch.

Now we have 7:0:4 which results libipset.so.3.4.0.

I'm going to add an extra warning text to Make_global.am about double 
checking LIBVERSION.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
