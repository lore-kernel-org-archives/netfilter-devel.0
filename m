From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.11 released
Date: Sat, 21 Jan 2012 15:07:49 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1201211506470.13129@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1201141542490.26282@blackhole.kfki.hu> <4F130A03.7080208@googlemail.com> <alpine.DEB.2.00.1201151825570.29134@blackhole.kfki.hu> <4F131551.2090608@googlemail.com> <alpine.DEB.2.00.1201152100050.29766@blackhole.kfki.hu>
 <4F135552.4070804@googlemail.com> <alpine.DEB.2.00.1201160914550.30763@blackhole.kfki.hu> <4F175B94.60001@googlemail.com> <alpine.DEB.2.00.1201191154330.7547@blackhole.kfki.hu> <4F189283.4000401@googlemail.com> <alpine.DEB.2.00.1201201342400.11124@blackhole.kfki.hu>
 <4F199A38.5070702@googlemail.com> <4F1A7377.5050301@treenet.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:42234 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594Ab2AUOHv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Jan 2012 09:07:51 -0500
In-Reply-To: <4F1A7377.5050301@treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 21 Jan 2012, Amos Jeffries wrote:

> On 21/01/2012 5:45 a.m., Mr Dash Four wrote:
> > 
> > > Doable, but needs time and would involve adding the logic to auto-merge
> > > smaller subnets into larger ones and to make possible to delete subnets
> > > from larger networks.
> > Merging of ip ranges would be very difficult - I am having the same problem
> > here as well. I use PostgreSQL as part of my setup and even though it has
[...] 
> Jozsef, have you had a look at how rbldnsd handles ranges? It has to 
> deal with the same issues as ipset seems to be facing now, also at some 
> high speed requirements. Maybe you could pull some inspiration out of 
> that.

Thanks for the tip, I'll look into it.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
