From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: NAT66 : A first implementation
Date: Fri, 15 Jul 2011 01:55:23 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1107150151390.20658@frira.zrqbmnf.qr>
References: <alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr> <4E1F1902.9020605@student.ulg.ac.be> <alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr> <20110714.161717.1387261665409519132.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: T.Moes@student.ulg.ac.be, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40218 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932483Ab1GNXzY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jul 2011 19:55:24 -0400
In-Reply-To: <20110714.161717.1387261665409519132.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-07-15 01:17, David Miller wrote:

>From: Jan Engelhardt <jengelh@medozas.de>
>Date: Fri, 15 Jul 2011 01:15:47 +0200 (CEST)
>
>> Of course yours is feature-richer. But the topic of IPv6 NAT has had 
>> come up a number of unrecollectable times, and the response has been the 
>> same everytime - NAT is still an ugly undesired hack whose recurrence 
>> wants to be avoided.
>
>People want to hide the details of the topology of their
>internal networks,

And IPv6 Privacy w.r.t. random address selection, combined with a 
firewall, won't do that?
