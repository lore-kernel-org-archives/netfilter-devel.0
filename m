From: Andreas Herz <andi@geekosphere.org>
Subject: Re: function for getting the source ip defined in the routing table
Date: Tue, 20 May 2014 16:18:28 +0200
Message-ID: <20140520141828.GO10939@kvmbude>
References: <20140520124634.GM10939@kvmbude>
 <alpine.LSU.2.11.1405201602100.9387@nerf08.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.geekosphere.org ([78.47.150.211]:59748 "EHLO
	mail.geekosphere.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaETOSa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 May 2014 10:18:30 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1405201602100.9387@nerf08.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On 20/05/14 at 16:03, Jan Engelhardt wrote:
> On Tuesday 2014-05-20 14:46, Andreas Herz wrote:
> >i was looking for a function to get the source ip that is defined in the
> >routing table. I looked into the MASQUERADE module but the
> >"inet_select_addr" function returns the source ip from the interface
> >(the first one, in most use cases).
>
> RTM_GETROUTE in netlink, `ip route get` on sh, and 
> ip6_route_output/ip_route_output_key in C.

Thanks for the hint to RTM_GETROUTE, but i'm wondering how i can receive
the src from ip_route_ouput_key, since with this commit the rt_src got
removed:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/net/ipv4/route.c?id=d6c0a4f609847d6e65658913f9ccbcb1c137cff3

Or did i miss the new variable for the src or misunderstand the change?

thanks so far!

-- 
Andreas Herz
