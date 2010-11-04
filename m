From: Patrick McHardy <kaber@trash.net>
Subject: Re: rules matching ipv6 prefix addrs
Date: Thu, 04 Nov 2010 05:14:57 +0100
Message-ID: <4CD23341.8040000@trash.net>
References: <4CD12B8B.9090506@plouf.fr.eu.org> <20101103.051925.193703726.davem@davemloft.net> <alpine.LNX.2.01.1011031331170.19124@obet.zrqbmnf.qr> <20101103.145503.104044664.davem@davemloft.net> <5ca75042-e809-4439-856a-e3da43cb6c23@email.android.com> <alpine.LNX.2.01.1011032339220.29167@obet.zrqbmnf.qr> <4CD21679.2070508@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	David Miller <davem@davemloft.net>,
	pascal.mail@plouf.fr.eu.org, netfilter-devel@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63154 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab0KDEPF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Nov 2010 00:15:05 -0400
In-Reply-To: <4CD21679.2070508@zytor.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04.11.2010 03:12, H. Peter Anvin wrote:
> On 11/03/2010 06:52 PM, Jan Engelhardt wrote:
>>
>> I take it you mean a setup where addresses are automatically assigned
>> (DHCPv6, PPP).
>>
> 
> DHCPv6, PPP, RA, anything.  Keep in mind that "expect prefix changes" is
> a deliberate part of the IPv6 systems design.

Do we have a way to identify the prefix(es) in question for the ruleset?
IOW, do the userspace daemons replace the existing prefix or adds a new
one and removes the old one?

The kernel itself seems to make sure the autoconfigured local address
is always the first one on the interface. If userspace does the same
this should be pretty easy.
