From: Joe Pruett <joey@clean.q7.com>
Subject: Re: iptables, ipsec, and host2host
Date: Tue, 17 Feb 2009 11:07:42 -0800 (PST)
Message-ID: <alpine.LRH.2.00.0902171104530.25041@q7.q7.com>
References: <alpine.LRH.2.00.0902170903140.25041@q7.q7.com> <499B0097.4000505@trash.net> <alpine.LRH.2.00.0902171029560.25041@q7.q7.com> <alpine.LSU.2.00.0902171940330.999@fbirervta.pbzchgretzou.qr> <alpine.LRH.2.00.0902171044460.25041@q7.q7.com>
 <alpine.LSU.2.00.0902171946520.999@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from q7.q7.com ([207.173.201.42]:53505 "EHLO q7.q7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbZBQTHx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:07:53 -0500
In-Reply-To: <alpine.LSU.2.00.0902171946520.999@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 17 Feb 2009, Jan Engelhardt wrote:

> Still the ipip.ko module (used for creating an explicit tunnel
> interface) is not used nor required to be loaded.
>
> When an ESP packet with IPv4 outer address is received, the function
> ip_rcv() will eventually deal with it, moved to the xfrm decoder and
> then reinjected by calling netif_rx (see xfrm_input.c) on the skb
> with its decoded payload.
>
> Also, do not confuse IP-in-ESP-over-IPv4 with IP-(in/over)-IP.
> For about every router and subsystem other than xfrm, there
> is no way to look into ESP payload and hence, it's just
> ESP-on-IPv4 or ESP-on-IPv6.

i have to now beg forgivness.  i think i ended up doing some of my testing 
on a rhel/centos 4 box which is only 2.6.9 with ipsec backported.  now 
that i correctly tested on my version 5 box, everything is working as i 
expect.  follow that with a few minutes of code reading and i convinced 
myself that host2host just wasn't doing what i wanted.  i'll go crawl back 
under the rocks now :-).
