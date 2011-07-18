From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: Re: NAT66 : A first implementation
Date: Mon, 18 Jul 2011 11:05:29 +0900
Message-ID: <1310954729.3704.19.camel@takos>
References: <alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr>
	 <4E1F1902.9020605@student.ulg.ac.be>
	 <alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr>
	 <20110714.161717.1387261665409519132.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, jengelh@medozas.de, T.Moes@student.ulg.ac.be,
	yoshfuji@linux-ipv6.org, keiichi@iijlab.net, sekiya@wide.ad.jp
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:40094 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755949Ab1GRCOx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Jul 2011 22:14:53 -0400
In-Reply-To: <20110714.161717.1387261665409519132.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

David Miller wrote:
> From: Jan Engelhardt <jengelh@medozas.de>
> Date: Fri, 15 Jul 2011 01:15:47 +0200 (CEST)
> 
> > Of course yours is feature-richer. But the topic of IPv6 NAT has had 
> > come up a number of unrecollectable times, and the response has been the 
> > same everytime - NAT is still an ugly undesired hack whose recurrence 
> > wants to be avoided.
> 
> You can't avoid it.
> 
> People want to hide the details of the topology of their
> internal networks, therefore we will have NAT with ipv6
> no matter what we think or feel.
> 
> Everyone needs to stop being in denial, now.

I have to agree.

In fact, we have started using simple, static IPv6-NAT (implemented
in userspace) in our cloud environment.  I still think that IPv6-NAT
is NOT a "must to have," but I agree that some kind of IPv6-NAT will
give us more options from network and/or cloud operational point of
view.  So, I am okay to have it and let market to decide.

Two things:
- I am still against NAT for link-local addresses.
- "NAT" between IPv6 and IPv4 is, of course, needed, as well.

Regards,

--yoshfuji

