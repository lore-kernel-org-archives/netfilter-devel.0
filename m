From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [NETFILTER 00/64]: Netfilter update
Date: Tue, 18 Dec 2007 12:32:24 +0100
Message-ID: <4767AFC8.2050906@netfilter.org>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain> <20071217.225126.26533748.davem@davemloft.net> <4767A199.3040308@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50541 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753871AbXLRLbB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Dec 2007 06:31:01 -0500
In-Reply-To: <4767A199.3040308@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> David Miller wrote:
>> Some of those default=m cases are marked EXPERIMENTAL.  Either the
>> default=m or the EXPERIMENTAL are bogus, in each case.  Most of the
>> time it's the latter, and if you could fix these I'd appreciate it.
> 
> Sure, I'll include a patch in my next update. Its a good opportunity
> to go through all netfilter EXPERIMENTAL marks, I bet there are
> more that could be removed.

maybe ctnetlink? :-)
