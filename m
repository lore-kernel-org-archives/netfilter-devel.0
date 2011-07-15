From: "Jeff Haran" <jharan@bytemobile.com>
Subject: RE: NAT66 : A first implementation
Date: Thu, 14 Jul 2011 17:48:54 -0700
Message-ID: <6F5DE7538AFCDA45A114F5E7510424A7028D1BBE@hq-exchange01.bytemobile.com>
References: <alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr><4E1F1902.9020605@student.ulg.ac.be><alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr> <20110714.161717.1387261665409519132.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <T.Moes@student.ulg.ac.be>, <netfilter-devel@vger.kernel.org>
To: "David Miller" <davem@davemloft.net>, <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ironport.bytemobile.com ([12.153.136.13]:41734 "EHLO
	ironport.bytemobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab1GOBEy convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jul 2011 21:04:54 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20110714.161717.1387261665409519132.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> -----Original Message-----
> From: netfilter-devel-owner@vger.kernel.org [mailto:netfilter-devel-
> owner@vger.kernel.org] On Behalf Of David Miller
> Sent: Thursday, July 14, 2011 4:17 PM
> To: jengelh@medozas.de
> Cc: T.Moes@student.ulg.ac.be; netfilter-devel@vger.kernel.org
> Subject: Re: NAT66 : A first implementation
> 
> From: Jan Engelhardt <jengelh@medozas.de>
> Date: Fri, 15 Jul 2011 01:15:47 +0200 (CEST)
> 
> > Of course yours is feature-richer. But the topic of IPv6 NAT has had
> > come up a number of unrecollectable times, and the response has been
> the
> > same everytime - NAT is still an ugly undesired hack whose
recurrence
> > wants to be avoided.
> 
> You can't avoid it.
> 
> People want to hide the details of the topology of their
> internal networks, therefore we will have NAT with ipv6
> no matter what we think or feel.
> 
> Everyone needs to stop being in denial, now.

People will use IPv6 NAT if they perceive its benefits outweigh its
costs.

Its costs will be significant. All that connection state tracking will
translate to more hardware. Managing multiple, possibly overlapping,
private network address spaces will mean more administrative headaches.

The benefit, hiding IPv6 address of hosts and routers in internal
networks, is I suspect less tangible. NAT in of itself doesn't provide
enough security to be relied upon solely, so you need firewalls in any
case. And unlike IPv4, you can't argue that you have to use NAT because
of lack of address space.

I think maybe we will get lucky. The bean counters may well keep the
specter of IPv6 NAT at bay. 8^)



