From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: rules matching ipv6 prefix addrs
Date: Thu, 04 Nov 2010 07:36:24 -0400
Message-ID: <051c8c45-58d9-420c-aa86-41cb0c75a05a@email.android.com>
References: <4CD12B8B.9090506@plouf.fr.eu.org> <20101103.051925.193703726.davem@davemloft.net> <alpine.LNX.2.01.1011031331170.19124@obet.zrqbmnf.qr> <20101103.145503.104044664.davem@davemloft.net> <5ca75042-e809-4439-856a-e3da43cb6c23@email.android.com> <alpine.LNX.2.01.1011032339220.29167@obet.zrqbmnf.qr> <4CD21679.2070508@zytor.com> <alpine.LNX.2.01.1011040943200.4050@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: David Miller <davem@davemloft.net>, pascal.mail@plouf.fr.eu.org,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:47344 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab0KDLhc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Nov 2010 07:37:32 -0400
In-Reply-To: <alpine.LNX.2.01.1011040943200.4050@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Guess what... other services like DNS needs to deal with this too, and so far has not; this is part of what needs to happen before nontrivial scale IPv6 deployment happens...

"Jan Engelhardt" <jengelh@medozas.de> wrote:

>
>On Thursday 2010-11-04 03:12, H. Peter Anvin wrote:
>>
>>Consider for example the case where I get from my ISP the netblock
>>2001:0db8:ac10::/48.  I subnet this internally with subnet numbers
>prefixed by
>>/52 security domains, i.e 2001:0db8:ac10:0000::/52,
>2001:0db8:ac10:1000::/52
>>and so forth.  Accordingly, my ip6tables would contain rules as to
>what kind of
>>traffic can flow between these prefixes.
>>
>>Now, the upstream (ISP-assigned) prefix changes to
>2001:6b2f:1705::/48.  RA
>>will handle reassigning addresses to actual downstream hosts, but
>things that
>>explicitly encode IPv6 addresses need to be changed, and that includes
>>ip6tables, in this case these rules now need to refer to
>>2001:6b2f:1705:0000::/52, 2001:62bf:1705:1000::/52 and so on.
>
>Now that helps, thanks :)
>
>You could use
>
> ip6tables -A FORWARD -d 0:0:0:1000::/0:0:0:ffff::
>
>to ignore the changing prefix part.
>
>>You're assuming (a) that I'm talking about a home gateway here (which
>may be,
>>but is far from certain -- the dynamic prefixes are a design feature
>of the
>>entire IPv6 Internet, and any entity that is not large enough to have
>direct
>>access to BGP6 is required to handle arbitrary prefix changes),
>
>I was just assuming this because I would find it highly disturbing if
>my rented-servers-in-a-datacenter suddenly had their prefix changed,
>for then that would also necessitate a change in the DNS zone.
>If you self-host your own DNS zone to which the ISP has no write
>access then goodluck.

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
