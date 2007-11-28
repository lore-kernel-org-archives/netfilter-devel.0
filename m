From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH] Per-conntrack timeout target v3
Date: Wed, 28 Nov 2007 10:06:16 +0100
Message-ID: <474D2F88.5050707@trash.net>
References: <20071127190745.GA2080@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40999 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbXK1JGW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Nov 2007 04:06:22 -0500
In-Reply-To: <20071127190745.GA2080@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Phil Oester wrote:
> Some further updates/optimizations to my original posting.  This version
> handles all protocols now.  Anyone besides me think this is useful?
> 
> ***
> 
> I use a fairly short 2 hour established timeout on firewalls I operate,
> which works fine for most purposes.  Occasionally, however, it would
> be nice to have a longer timeout for *certain* types of traffic
> such as SSH or telnet sessions.  
> 
> So, below find a TIMEOUT target to enable such per-conntrack timeouts.
> Syntax for SSH would be something like:
> 
>         iptables -A foo -p tcp --dport 22 -j TIMEOUT --timeout 123456
>         iptables -A foo -p tcp --dport 22 -j ACCEPT
> 
> It could of course also be used to lower the timeouts on some traffic,
> such as HTTP.


I think the patch is useful, but I wonder how long it will take until
people want to override timeouts for other connection states. I'm
also looking for a way to pass parameters for new connections to
helpers (most of the things that are currently module parameters),
so maybe we could generalize this to a conntrack parameter target?


