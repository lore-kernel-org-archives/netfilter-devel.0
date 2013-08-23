From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [PATCH nft] src: allow to specify the base chain type
Date: Fri, 23 Aug 2013 10:39:05 +0300
Message-ID: <52171199.5090700@linux.intel.com>
References: <1377185191-9961-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:16349 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688Ab3HWHjI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Aug 2013 03:39:08 -0400
In-Reply-To: <1377185191-9961-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Nice extension. I just have small comments how we could improve the 
command line:

> This patch allows you to specify the type of the base chain, eg.
>
> 	add table mangle
> 	add chain mangle OUTPUT { type route hook NF_INET_LOCAL_OUT 0; }

Instead of NF_INET_LOCAL_OUT could we get OUT? (not literally ;) )

IN, OUT, PRE-ROUTING, FORWARD, POST-ROUTING etc...
And depending on chain's family, nft would use the right value there 
(IN: is NF_INET_LOCAL_IN for ipv4, NF_ARP_IN for arp, etc...)

It would also make command line easier and more readable.

One more debatable:
What about adding prio keyword? So it would be { type <string> hook 
<string> prio <num> }
Or keeping both possibility <num> or prio <num>?

I can prepare a patch if you want,

Cheers,

Tomasz
