From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: kernel BUG at net/netfilter/ipset/ip_set_core.c:314
Date: Tue, 30 Aug 2011 13:52:49 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1108301351070.26239@blackhole.kfki.hu>
References: <4E5CA623.9000402@univ-nantes.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jean-Philippe Menil <jean-philippe.menil@univ-nantes.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:59304 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab1H3Lwv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:52:51 -0400
In-Reply-To: <4E5CA623.9000402@univ-nantes.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 30 Aug 2011, Jean-Philippe Menil wrote:

> With the set bitmap ipmac, if i had one, two hundred ip,mac in a set; and do
> an ipset list,
> i get an:
> ipset v6.8: Kernel error received: No buffer space available
> followed by a kernel panic (trace attached).

I'll check it, thanks the reporting.
 
> Maybe, in ip_set_core.c, can we modify the line 435 to this one:
> if (ip_set_list[index] != NULL && ip_set_list[index]->ref !=0)
> 
> This way, we avoid the kernel panic?

That'd be racy, so other solution is required.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
