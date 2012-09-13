From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Ipset Problem
Date: Thu, 13 Sep 2012 16:53:58 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1209131649290.11289@blackhole.kfki.hu>
References: <5051EB6F.2050406@metu.edu.tr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Lutfi ODUNCUOGLU <lutfio@metu.edu.tr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:39617 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab2IMOyA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:54:00 -0400
In-Reply-To: <5051EB6F.2050406@metu.edu.tr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 13 Sep 2012, Lutfi ODUNCUOGLU wrote:

> I have two iptables configuration, for inet4 and inet6. In order to stop the
> iptables;
> 
> ipset flush
> ipset destroy
> 
> and for ip6tables
> 
> ipset flush
> ipset destroy

Unnecessary, the sets are already flushed and destroyed above.

> Can we make them just to flush and destroy inet6 or inet4? Is there any way?

"ipset flush" flushes all sets, and "ipset destroy" destroys all sets, 
both inet and inet6. 

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
