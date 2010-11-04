From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: rules matching ipv6 prefix addrs
Date: Thu, 04 Nov 2010 14:45:05 -0400
Message-ID: <4CD2FF31.5050404@zytor.com>
References: <4CD12B8B.9090506@plouf.fr.eu.org> <20101103.051925.193703726.davem@davemloft.net> <alpine.LNX.2.01.1011031331170.19124@obet.zrqbmnf.qr> <20101103.145503.104044664.davem@davemloft.net> <5ca75042-e809-4439-856a-e3da43cb6c23@email.android.com> <alpine.LNX.2.01.1011032339220.29167@obet.zrqbmnf.qr> <4CD21679.2070508@zytor.com> <4CD29423.6050009@earthlink.net> <4CD2C633.3070602@zytor.com> <6F5DE7538AFCDA45A114F5E7510424A70225758A@hq-exchange01.bytemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: sclark46@earthlink.net, Jan Engelhardt <jengelh@medozas.de>,
	David Miller <davem@davemloft.net>,
	pascal.mail@plouf.fr.eu.org, netfilter-devel@vger.kernel.org
To: Jeff Haran <jharan@bytemobile.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:54883 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab0KDSqJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Nov 2010 14:46:09 -0400
In-Reply-To: <6F5DE7538AFCDA45A114F5E7510424A70225758A@hq-exchange01.bytemobile.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/04/2010 01:35 PM, Jeff Haran wrote:
>
> Ideally, your ISP wouldn't do this to you. Ideally, they would advertise
> the new prefix as preferred and deprecate the old one. So connections
> using the old prefix would continue to work while new connections should
> start using the new prefix. By the time the old prefix is invalid there
> should be no TCP connections using it since most TCP connections don't
> last as long as the valid lifetime. But since TCP doesn't define a
> maximum connection duration, it's still a possibility that long lived
> connections could be dropped, no matter how hard the ISP tries to
> prevent it. But it does mean that any reasonable IPv6 firewall setup
> should deal with multiple prefixes. And it also means that if you have
> an application that won't well tolerate dropped connections, you should
> probably code it to do a clean close and restart whenever the address at
> your end of the socket transitions from preferred to deprecated state.
>

Ideally, yes, although I don't realistically believe that will happen. 
Now, to deal with multiple prefixes in parallel is even more complex 
than switching prefixes.

There is obviously no such thing as a maximum TCP duration, and therein 
lies a huge problem; the only way to deal with it sanely would have been 
to separate routing from endpoint identity, but the IPv6 architects 
chose to not go that route, partly because they seriously misestimated 
the timescale of the transition.

	-hpa
