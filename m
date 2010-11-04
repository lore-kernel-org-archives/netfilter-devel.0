From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: rules matching ipv6 prefix addrs
Date: Thu, 4 Nov 2010 12:53:59 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011041252410.17937@obet.zrqbmnf.qr>
References: <4CD12B8B.9090506@plouf.fr.eu.org> <20101103.051925.193703726.davem@davemloft.net> <alpine.LNX.2.01.1011031331170.19124@obet.zrqbmnf.qr> <20101103.145503.104044664.davem@davemloft.net> <5ca75042-e809-4439-856a-e3da43cb6c23@email.android.com>
 <alpine.LNX.2.01.1011032339220.29167@obet.zrqbmnf.qr> <4CD21679.2070508@zytor.com> <alpine.LNX.2.01.1011040943200.4050@obet.zrqbmnf.qr> <051c8c45-58d9-420c-aa86-41cb0c75a05a@email.android.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Miller <davem@davemloft.net>, pascal.mail@plouf.fr.eu.org,
	netfilter-devel@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54036 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739Ab0KDLyA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Nov 2010 07:54:00 -0400
In-Reply-To: <051c8c45-58d9-420c-aa86-41cb0c75a05a@email.android.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-11-04 12:36, H. Peter Anvin wrote:

>Guess what... other services like DNS needs to deal with this too, and 
>so far has not; this is part of what needs to happen before nontrivial 
>scale IPv6 deployment happens...

Despite what the RFCs say, IPv6 has big enough an address space that 
static addresses (prefixes) are much more likely to be handed out.

Nevertheless, did you consider

>> ip6tables -A FORWARD -d 0:0:0:1000::/0:0:0:ffff::
>>
>>to ignore the changing prefix part.
