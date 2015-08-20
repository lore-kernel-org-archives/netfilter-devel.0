From: Andreas Herz <andi@geekosphere.org>
Subject: Re: ICMPv6 Type 1 Code 5 and 6 missing in iptables REJECT target and
 icmpv6 match
Date: Thu, 20 Aug 2015 11:06:42 +0200
Message-ID: <20150820090642.GR21654@kvmbude>
References: <20150819145136.GN21654@kvmbude>
 <alpine.LSU.2.20.1508201012310.28043@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.geekosphere.org ([78.47.150.211]:38571 "EHLO
	mail.geekosphere.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbbHTJGp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 05:06:45 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1508201012310.28043@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20/08/15 at 10:13, Jan Engelhardt wrote:
> 
> On Wednesday 2015-08-19 16:51, Andreas Herz wrote:
> >And in RFC 4443 they are defined as:
> >
> >> 5 - Source address failed ingress/egress policy
> >> 6 - Reject route to destination
> >
> >Is there a reason for that?
> >
> >If i look into the "extensions/libip6t_icmp6.c" i just see the codes 0,1,2,3,4
> >for type 1. And in "include/linux/netfilter_ipv6/ip6t_REJECT.h" it's
> >"IP6T_ICMP6_ECHOREPLY" which doesnt' sound like the one in the RFC.
> >
> >Or is it just missing, so i might add it?
> 
> It would appear fine to just add it.

I just tested around and icmpv6 is already working but that's caused by
rather optimistic parsing:

> if (!xtables_strtoui(slash+1, NULL, &number, 0, UINT8_MAX))

So --icmpv6-type 1/255 is also possible. Is this intended to make those
types and codes work although they don't match the names defined in
"static const struct icmpv6_names icmpv6_codes"?

Since it doesn't harm i guess keeping it non restrictive might be good
(since checking every type and code number exactly would result in a
little bit more complex code) or should i also straiten this check in
parse_icmpv6?

If no, the patch will just add the missing icmpv6 parts for the name
based configuration.

-- 
Andreas Herz
