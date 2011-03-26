From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Problem getting IPv6 port numbers
Date: Sat, 26 Mar 2011 13:19:49 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1103261317340.16380@obet.zrqbmnf.qr>
References: <4D8C7C20.8090500@catseye.org> <alpine.LNX.2.01.1103251427500.28161@obet.zrqbmnf.qr> <4D8D554C.4070907@catseye.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mark Montague <mark@catseye.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51580 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab1CZMTv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Mar 2011 08:19:51 -0400
In-Reply-To: <4D8D554C.4070907@catseye.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2011-03-26 03:54, Mark Montague wrote:
>
>> It seems that for IPv6, fragoff is only filled when you explicitly test
>> for a protocol using -p.
>
> This was the problem.  Many thanks for the answer!
>
> Adding a "-p tcp" to my ip6tables rule causes the above code to report the
> source and destination port numbers properly.
>
> Also of note:  it seems like the transport header can only be retrieved if the
> ip6tables rule explicitly tests for a protocol:  Without a -p test, I took out
> the "if (par->fragoff == 0)" check, with the result that the sport and dport
> were set to random (incorrect) numbers.

Because like fragoff, thoff is only filled in if you actually want to
match something. Calculating fragoff/thoff is somewhat more
computationally intensive, as there may be many headers in a IPv6
packet, whereas there is just one static one in IPv4.

Specifically, if you use (ipv6) -p frag, fragoff and thoff will be
valid, but testing for sport/dport will do garbage too, because they
do not actually point to a TCP header.

Yeah this ought to get better..
