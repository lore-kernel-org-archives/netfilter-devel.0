From: Patrick McHardy <kaber@trash.net>
Subject: Re: CONFIG_NETFILTER_ADVANCED
Date: Fri, 16 Nov 2007 01:06:42 +0100
Message-ID: <473CDF12.9080206@trash.net>
References: <20071115.160110.12856737.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59959 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584AbXKPAHB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2007 19:07:01 -0500
In-Reply-To: <20071115.160110.12856737.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

David Miller wrote:
> Patrick I would like to propose that we do something similar to how we
> handle all the non-trivial routing and TCP congestion control
> settings.
>
> And that is to have an "ADVANCED" guard that simply doesn't present
> the myriad of netfilter modules and options we have.
>
> Basically, if the user doesn't set CONFIG_NETFILTER_ADVANCED he gets
> basic NAT and connection tracking support, that's it.
>
> Or at least something along those lines.
>
> Let me know what you think about this.  Linus has asked me for
> something like this several times :)

That sounds good, I believe we already talked at the workshop about
this. Additionally I'd like something that selects all modules at
once if it doesn't get too ugly since its a PITA to go through all
the options, and I usually do enable them :). I'll look into these
two things tommorrow.


