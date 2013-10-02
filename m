From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ANNOUNCE] ipset package kernel support changes
Date: Wed, 2 Oct 2013 23:35:02 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1310022322210.5975@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:37295 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547Ab3JBVfF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Oct 2013 17:35:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The ipset package still supports kernel versions back to 2.6.32. 
Unfortunately I have no resources to keep up this support.

The ipset package release 6.20 is the last one which supports the kernel 
versions below 3.2, the next releases will work with 3.2 and above. 

Bugfixes will be backported to the 6.20 tree for one year from now and 
will be released with version numbers 6.20.x.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
