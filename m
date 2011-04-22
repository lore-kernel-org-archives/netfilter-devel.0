From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: RE: [ANNOUNCE] ipset 6.4 released
Date: Fri, 22 Apr 2011 09:27:25 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1104220916020.29563@blackhole.kfki.hu>
References: <1303418583.3310.18.camel@tmb-laptop.supernet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Thomas Backlund <tmb@mageia.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:34036 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab1DVH10 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Apr 2011 03:27:26 -0400
In-Reply-To: <1303418583.3310.18.camel@tmb-laptop.supernet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 21 Apr 2011, Thomas Backlund wrote:

> What is the preferred version of ipset utils to be used with 2.6.39
> series kernels?
> 
> If I understand correctly, the ipset kernel part that got merged is 6.2
> 
> Does that mean I should use the same version on userspace part, or will
> the newer one cope with the version difference ?

All bugfixes are submitted into the kernel and will be available in 
the next 2.6.39-rc5 release. Hopefully the improvements will be available 
in the next-next kernel release.

If you need the new functionalities, you should use the kernel modules 
from the ipset package. The protocol did not change, so the userspace can 
cope with the different kernel versions, of course except missing new 
functionalities, like listing only setnames. The same applies to the SET 
target.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
