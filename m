From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.2 released
Date: Tue, 29 Mar 2011 21:23:57 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1103292123001.8329@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1103272124170.3535@blackhole.kfki.hu> <4D91E7D7.3070000@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:38028 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab1C2TX7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Mar 2011 15:23:59 -0400
In-Reply-To: <4D91E7D7.3070000@msgid.tls.msk.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 29 Mar 2011, Michael Tokarev wrote:

> ipset-6.2/kernel/net/netfilter/ipset/Kconfig file
> appears to be some net/netfilter/Kconfig file from
> linux source tree (from one directory level up),
> patched with NETFILTER_XT_SET.  It gets included
> into itself recursively.

Yes, you are right, I fixed it in the ipset git tree. Thanks!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
