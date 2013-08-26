From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: allow to specify the base chain type
Date: Tue, 27 Aug 2013 00:37:32 +0200
Message-ID: <20130826223732.GA4031@localhost>
References: <1377185191-9961-1-git-send-email-pablo@netfilter.org>
 <52171199.5090700@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51836 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab3HZWhw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Aug 2013 18:37:52 -0400
Content-Disposition: inline
In-Reply-To: <52171199.5090700@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 23, 2013 at 10:39:05AM +0300, Tomasz Bursztyka wrote:
[...]
> >	add table mangle
> >	add chain mangle OUTPUT { type route hook NF_INET_LOCAL_OUT 0; }
> 
> Instead of NF_INET_LOCAL_OUT could we get OUT? (not literally ;) )

makes sense.

> IN, OUT, PRE-ROUTING, FORWARD, POST-ROUTING etc...

I prefer: input, output, prerouting, forward, postrouting.

> And depending on chain's family, nft would use the right value there
> (IN: is NF_INET_LOCAL_IN for ipv4, NF_ARP_IN for arp, etc...)
> 
> It would also make command line easier and more readable.
> 
> One more debatable:
> What about adding prio keyword? So it would be { type <string> hook
> <string> prio <num> }
> Or keeping both possibility <num> or prio <num>?

it also makes sense to me, but that should come in a separated patch.

> I can prepare a patch if you want,

Go ahead. Thanks.
