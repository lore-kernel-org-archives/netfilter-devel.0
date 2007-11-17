From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] Per-conntrack timeout target
Date: Sat, 17 Nov 2007 20:48:12 +0100
Message-ID: <473F457C.1000708@trash.net>
References: <20071117181123.GA15156@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48675 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758285AbXKQTsd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Nov 2007 14:48:33 -0500
In-Reply-To: <20071117181123.GA15156@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Phil Oester wrote:
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
> 
> Please review, comment, criticize, etc.  Note that at present it only
> handles TCP/UDP traffic.  If deemed "merge-worthy", support for other
> protos will be added.


The only downside I see is that it adds another 4 bytes to the conntrack
structure and distributions are probably going to enable it, like
everything else. It would be nice if we could put this in a ct_extend
structure, but that would mean you're only able to set it for new
connections. What do you think about this?
