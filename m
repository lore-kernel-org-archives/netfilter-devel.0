From: Holger Eitzenberger <heitzenberger@astaro.com>
Subject: Re: [ULOGD RFC 08/30] NFCT: rework
Date: Fri, 01 Feb 2008 18:06:02 +0100
Message-ID: <47A3517A.40205@astaro.com>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>	<20080130190127.400747893@kruemel.intranet.astaro.de>	<47A27481.7080700@netfilter.org> <87r6fx14j1.fsf@kruemel.intranet.astaro.de> <47A2E256.6080600@trash.net> <47A320A4.3030203@netfilter.org> <47A34696.5070109@astaro.com> <47A34D28.2010303@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-23.dex002.intermedia.net ([64.78.21.99]:51286 "EHLO
	dhost002-23.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756423AbYBARGP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:06:15 -0500
In-Reply-To: <47A34D28.2010303@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:

> The point is that I don't understand why we have to apply these NFCT
> patches which IMO do a sloppy netlink handling and then wait until this
> is completely rewritten again properly... (continue below)

Well, those patches were done over time of about a year or so.  The 
initial NFCT code wasn't working for me when I initially tried it, so I 
started to hack on that myself.  Only the later patches turn it into the 
  well-working solution you should use.

Don't forget that this is a patchset with an RFC in mind.  With that 
series of patches you clearly see how NFCT evolved over time, with the 
possibility to get the rational of all those patches.

Another option would be to just provide the newest code, without a 
history at all.  Is that what you like more?

>> That patch was provided exactly to solve that issue.
> 
> ... because AFAICS if we check for ENOBUFS and then resync against the
> kernel table using GET_CONNTRACK we won't need the sequence cache later,
> will we?

You will on a busy site.  The sole purpose of checking ENOBUFS or 
NETLINK_OVERRUN is to check whether you need that logic during normal 
operation.  So, on a not-so-busy site you won't have those GET_CONNTRACK 
requests at all.

Of course the GET_CONNTRACK requests should be disabled if there wasn't 
any overrun for a certain period of time (e. g. one turnaround).

But still that's only an optimisation.

  /holger
