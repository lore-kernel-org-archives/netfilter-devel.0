From: Thomas Jacob <jacob@internet24.de>
Subject: Re: mac-redirect
Date: Mon, 16 Feb 2009 15:33:22 +0100
Message-ID: <1234794802.3052.10.camel@enterprise.ims-firmen.de>
References: <ab4346860902160549ld55576gbcd6316817f5f198@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Victoria Muntean <vikimun@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout01.ims-firmen.de ([213.174.32.96]:48051 "EHLO
	mailout01.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbZBPO5u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 09:57:50 -0500
In-Reply-To: <ab4346860902160549ld55576gbcd6316817f5f198@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2009-02-16 at 15:49 +0200, Victoria Muntean wrote:
> Which rule/module of iptable 1.4.3 can change dest mac of the packet ?
> (in PreRouting)

Since the destination MAC address is only determined by arp table
lookups after the routing decision has been taken, at least when you're
using you Linux box as a router, you can't do much about it in the pre
routing table. I am also not aware of a standard target that let's
you modify the destination mac in the post_routing table.

But if you are using your box as a bridge, you could you ebtables to do
some sort of MAC NAT. => http://ebtables.sourceforge.net/

The question is: what are you trying to achieve?


> Thanks
> Viki
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

