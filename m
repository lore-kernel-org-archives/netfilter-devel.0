From: Rick Jones <rick.jones2@hp.com>
Subject: Re: NAT66 : A first implementation
Date: Thu, 14 Jul 2011 16:37:39 -0700
Message-ID: <4E1F7DC3.5000407@hp.com>
References: <alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr>	<4E1F1902.9020605@student.ulg.ac.be>	<alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr> <20110714.161717.1387261665409519132.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, T.Moes@student.ulg.ac.be,
	netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:27030 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590Ab1GNXhm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jul 2011 19:37:42 -0400
In-Reply-To: <20110714.161717.1387261665409519132.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07/14/2011 04:17 PM, David Miller wrote:
> From: Jan Engelhardt<jengelh@medozas.de>
> Date: Fri, 15 Jul 2011 01:15:47 +0200 (CEST)
>
>> Of course yours is feature-richer. But the topic of IPv6 NAT has had
>> come up a number of unrecollectable times, and the response has been the
>> same everytime - NAT is still an ugly undesired hack whose recurrence
>> wants to be avoided.
>
> You can't avoid it.
>
> People want to hide the details of the topology of their
> internal networks, therefore we will have NAT with ipv6
> no matter what we think or feel.
>
> Everyone needs to stop being in denial, now.

So, does that imply there will be systems with only link-scope IP's 
reaching-out to global-scope IPs, getting their link-scope's adjusted by 
an IPv6 NAT?

rick jones
