From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: rules matching ipv6 prefix addrs
Date: Wed, 03 Nov 2010 18:36:12 -0400
Message-ID: <5ca75042-e809-4439-856a-e3da43cb6c23@email.android.com>
References: <4CD12B8B.9090506@plouf.fr.eu.org> <20101103.051925.193703726.davem@davemloft.net> <alpine.LNX.2.01.1011031331170.19124@obet.zrqbmnf.qr> <20101103.145503.104044664.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: pascal.mail@plouf.fr.eu.org, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>, jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:43739 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab0KCWiH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Nov 2010 18:38:07 -0400
In-Reply-To: <20101103.145503.104044664.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The prefix is set by the ISP and can change at any time.  In IPv4 this is generally masked by NAT, but in IPv6 it affects every host.

What changes (in the normal case) is the common prefix of the network, i.e. the fraction delegated by the ISP.  If your ISP gives you a /56, for example, those 56 bits can change at any time, and that will affect all the hosts on your network.


"David Miller" <davem@davemloft.net> wrote:

>From: Jan Engelhardt <jengelh@medozas.de>
>Date: Wed, 3 Nov 2010 13:32:42 +0100 (CET)
>
>> On Wednesday 2010-11-03 13:19, David Miller wrote:
>>>
>>>> What would be a use case ?
>>>
>>>I thought it was painfully obvious but...  the use case is setting up
>>>a rule that matches the prefix addresses and having such rules still
>>>work properly when the link flaps onto a link with a different prefix
>> 
>> A link moving to another link.. you lost me there.
>> Links usually don't move, packets do. Can you provide `ip addr`-style
>
>> output of Before and After, to better see what's being meant?
>
>This issue was expressed to me by H. Peter Anvin, let's CC: him
>to get some specific examples.
>
>HPA?

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
