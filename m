From: Andre Tomt <andre@tomt.net>
Subject: Re: [PATCH 00/19] netfilter: IPv6 NAT
Date: Sat, 25 Aug 2012 02:58:39 +0200
Message-ID: <5038233F.7000202@tomt.net>
References: <1344542943-11588-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from catastrophix.ugh.no ([178.79.162.34]:56508 "EHLO
	catastrophix.ugh.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab2HYBFM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Aug 2012 21:05:12 -0400
In-Reply-To: <1344542943-11588-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09. aug. 2012 22:08, kaber@trash.net wrote:
> The following patches contain an updated version of IPv6 NAT against
> Linus' current tree.

Hmmm. Looking in my crystal ball (hi #ipv6!), I predict that if this 
lands in mainline - and thus in consumer CPE/routers eventually - many 
ISP's will have little incentive to actually implement assigning of 
blocks to their consumer users like they "have to" today.

We have this wonderful chance of fixing a major problem with todays 
internet, but now we are going down this very slippery slope.

I do need this code for a experimental project myself, and acknowledge 
there may be some valid use cases, but I do not like the global 
implications one bit.

At least some big fat warnings please?

:-(
