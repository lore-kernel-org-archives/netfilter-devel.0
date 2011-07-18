From: Patrick McHardy <kaber@trash.net>
Subject: Re: NAT66 : A first implementation
Date: Mon, 18 Jul 2011 17:50:46 +0200
Message-ID: <4E245656.8020605@trash.net>
References: <alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr>	<4E1F1902.9020605@student.ulg.ac.be>	<alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr> <20110714.161717.1387261665409519132.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, T.Moes@student.ulg.ac.be,
	netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46066 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab1GRPus (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jul 2011 11:50:48 -0400
In-Reply-To: <20110714.161717.1387261665409519132.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15.07.2011 01:17, David Miller wrote:
> From: Jan Engelhardt <jengelh@medozas.de>
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

I agree, the multiple existing implementations are proof of that.

> Everyone needs to stop being in denial, now.
