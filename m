From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: rules matching ipv6 prefix addrs
Date: Wed, 03 Nov 2010 22:12:09 -0400
Message-ID: <4CD21679.2070508@zytor.com>
References: <4CD12B8B.9090506@plouf.fr.eu.org> <20101103.051925.193703726.davem@davemloft.net> <alpine.LNX.2.01.1011031331170.19124@obet.zrqbmnf.qr> <20101103.145503.104044664.davem@davemloft.net> <5ca75042-e809-4439-856a-e3da43cb6c23@email.android.com> <alpine.LNX.2.01.1011032339220.29167@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, pascal.mail@plouf.fr.eu.org,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:41974 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774Ab0KDCNF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Nov 2010 22:13:05 -0400
In-Reply-To: <alpine.LNX.2.01.1011032339220.29167@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/03/2010 06:52 PM, Jan Engelhardt wrote:
>
> I take it you mean a setup where addresses are automatically assigned
> (DHCPv6, PPP).
>

DHCPv6, PPP, RA, anything.  Keep in mind that "expect prefix changes" is 
a deliberate part of the IPv6 systems design.

> Still I don't see the problem - any security-conscious person would use
> a drop-by-default ruleset. So a change of prefix address would, if
> anything, cause packets to get dropped in FORWARD. (What do we have the
> "ip6table_filter.forward" module option for? Right. And why is it set to
> ACCEPT by default? *headshakethere*)
 >
>> In IPv4 this is generally masked by NAT, but in IPv6 it affects every
>> host.
>
> Different scenario. Because packets from Internet are
> only destined for your home gateway address, they would get locally
> delivered in the normal case, and any forwarding is an opt-in
> process on the admin's behalf.
 >
> If you used a FORWARD-DROP policy in IPv6, forwarding also becomes the
> same opt-in process. So it's not like NAT would be any magic.
> On Wednesday 2010-11-03 23:36, H. Peter Anvin wrote:

Sorry this is nonsense.  There is a huge difference -- with IPv6, the 
local prefix affect the addresses *on your internal network*, whereas 
with IPv4/NAT, they do not.  In theory, IPv4 with dynamically assigned 
publically routable blocks would have the same problem, but in practice 
those simply do not exist.

Consider for example the case where I get from my ISP the netblock 
2001:0db8:ac10::/48.  I subnet this internally with subnet numbers 
prefixed by /52 security domains, i.e 2001:0db8:ac10:0000::/52, 
2001:0db8:ac10:1000::/52 and so forth.  Accordingly, my ip6tables would 
contain rules as to what kind of traffic can flow between these prefixes.

Now, the upstream (ISP-assigned) prefix changes to 2001:6b2f:1705::/48. 
  RA will handle reassigning addresses to actual downstream hosts, but 
things that explicitly encode IPv6 addresses need to be changed, and 
that includes ip6tables, in this case these rules now need to refer to 
2001:6b2f:1705:0000::/52, 2001:62bf:1705:1000::/52 and so on.

> Different scenario. Because packets from Internet are
> only destined for your home gateway address, they would get locally
> delivered in the normal case, and any forwarding is an opt-in
> process on the admin's behalf.
>
> If you used a FORWARD-DROP policy in IPv6, forwarding also becomes the
> same opt-in process. So it's not like NAT would be any magic.

You're assuming (a) that I'm talking about a home gateway here (which 
may be, but is far from certain -- the dynamic prefixes are a design 
feature of the entire IPv6 Internet, and any entity that is not large 
enough to have direct access to BGP6 is required to handle arbitrary 
prefix changes), and (b) that I'm only concerned about entry/egress 
control, but this also affects internal control.

	-hpa
