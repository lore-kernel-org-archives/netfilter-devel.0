From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2 v2] New netfilter target to trigger LED devices
Date: Wed, 12 Nov 2008 12:17:37 +0100
Message-ID: <491ABB51.7010500@trash.net>
References: <49196D12.1030803@shikadi.net> <491AB303.7000500@netfilter.org> <491AB8B6.5080708@shikadi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38659 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbYKLLRk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2008 06:17:40 -0500
In-Reply-To: <491AB8B6.5080708@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adam Nielsen wrote:
>>> Add a new "LED" target to iptables, which allows LEDs to blink in
>>> response to matching rules.
>>
>> I did not have a look in deep into your patch but the first questions
>> that comes to my mind is, how many people can benefit from this LED
>> target? What is its real application?
> 
> Well granted its purpose is somewhat trivial, but if you do have
> devices on your system that appear in the LED class it could be quite
> useful.
> 
> Linux running on an embedded router for example, could blink specific
> LEDs on the device's front panel depending on the traffic being
> routed.  You wouldn't be limited to one LED per interface either, you
> could have an LED dedicated to OpenVPN traffic only for instance.  Or
> you could have a couple of LEDs for different classes of traffic,
> which would tell you at a glance whether your device is being hammered
> by HTTP traffic or BitTorrent transfers.
> 
> Hopefully once more devices start appearing in the LED class, having
> a target like this will help people put them to good use.

Well, its better than the patch from one or two years ago that
added LED-triggers to netif_receive_skb() or dev_queue_xmit() :)

I don't have a problem taking this patch if the LED-people agree
that this is a good approach.
