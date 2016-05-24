From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: xtables-addons: Kernel 4.4.0 OOPS with xt_CHAOS
Date: Tue, 24 May 2016 19:15:52 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1605241910190.19042@nerf40.vanv.qr>
References: <CAOxNAe+PUyGO3GkZDP1BMxnXpSjv4KZq7ArB0+aU-N8AK0KTvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Feliksas <computershik@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:38504 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbcEXRPz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2016 13:15:55 -0400
In-Reply-To: <CAOxNAe+PUyGO3GkZDP1BMxnXpSjv4KZq7ArB0+aU-N8AK0KTvA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2016-05-10 17:15, Feliksas wrote:
>After upgrading from Wily to Xenial, my server started being frequently
>rebooted by an HP iLO watchdog. I turned it off, and installed kdump
>tools, and managed to capture a kernel crashdump. Turned out to be a
>network-related OOPS, looks like a bug with xtables modules and kernel
>4.4.0 (the issue doesn't seem to occur with 4.2.0).
>The offending iptables rule, now removed:
>
>iptables -A INPUT -j CHAOS --tarpit

    [exception RIP: __ip_route_output_key_hash+1184]
 #9 [ffff8803fa4436e8] __kmalloc_node_track_caller at ffffffff811eed95
#10 [ffff8803fa443770] ip_route_output_flow at ffffffff81757a11
#11 [ffff8803fa443798] ip_route_me_harder at ffffffff817ace31
#12 [ffff8803fa443810] tarpit_tg4 at ffffffffc065bb83 [xt_TARPIT]

The presence of __kmalloc_node_track_caller suggests that +1184 might be near
the fib_lookup call in the __ip_route_output_key_hash function. However, that
looks quite outside xtables-addons.

I will make the bold assumption that xt_TARPIT's call of 
ip_route_me_harder has a valid netns passed. The flowi structure though,
is ip_route_me_harder's territory.

>Kernel version 4.4.0-22-generic #39-Ubuntu SMP Thu May 5 16:53:32 UTC
>2016 x86_64 x86_64 x86_64 GNU/Linux
