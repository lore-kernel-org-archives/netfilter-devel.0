From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: rules matching ipv6 prefix addrs
Date: Wed, 3 Nov 2010 23:52:26 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011032339220.29167@obet.zrqbmnf.qr>
References: <4CD12B8B.9090506@plouf.fr.eu.org> <20101103.051925.193703726.davem@davemloft.net> <alpine.LNX.2.01.1011031331170.19124@obet.zrqbmnf.qr> <20101103.145503.104044664.davem@davemloft.net> <5ca75042-e809-4439-856a-e3da43cb6c23@email.android.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Miller <davem@davemloft.net>, pascal.mail@plouf.fr.eu.org,
	netfilter-devel@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55986 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825Ab0KCWw1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Nov 2010 18:52:27 -0400
In-Reply-To: <5ca75042-e809-4439-856a-e3da43cb6c23@email.android.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-11-03 23:36, H. Peter Anvin wrote:

>The prefix is set by the ISP and can change at any time.

I take it you mean a setup where addresses are automatically assigned 
(DHCPv6, PPP).

Still I don't see the problem - any security-conscious person would use 
a drop-by-default ruleset. So a change of prefix address would, if 
anything, cause packets to get dropped in FORWARD. (What do we have the 
"ip6table_filter.forward" module option for? Right. And why is it set to 
ACCEPT by default? *headshakethere*)

>In IPv4 this is generally masked by NAT, but in IPv6 it affects every 
>host.

Different scenario. Because packets from Internet are 
only destined for your home gateway address, they would get locally 
delivered in the normal case, and any forwarding is an opt-in 
process on the admin's behalf.

If you used a FORWARD-DROP policy in IPv6, forwarding also becomes the 
same opt-in process. So it's not like NAT would be any magic.
