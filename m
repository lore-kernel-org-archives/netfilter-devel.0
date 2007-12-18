From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 00/64]: Netfilter update
Date: Tue, 18 Dec 2007 11:31:53 +0100
Message-ID: <4767A199.3040308@trash.net>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain> <20071217.225126.26533748.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51420 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbXLRKcE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Dec 2007 05:32:04 -0500
In-Reply-To: <20071217.225126.26533748.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller wrote:
> I applied everthing to net-2.6.25 and pushed it all out, including
> the NETFILTER_ADVANCED thing.  It was definitely an improvement.

Thanks Dave.

> Can you do something for me Patrick?  Go from a config with
> NETFILTER disabled, then turn it on, use NETFILTER_ADVANCED=n
> and walk through the options presented to the user.
> 
> Some of those default=m cases are marked EXPERIMENTAL.  Either the
> default=m or the EXPERIMENTAL are bogus, in each case.  Most of the
> time it's the latter, and if you could fix these I'd appreciate it.

Sure, I'll include a patch in my next update. Its a good opportunity
to go through all netfilter EXPERIMENTAL marks, I bet there are
more that could be removed.
