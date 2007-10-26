From: Amin Azez <azez@ufomechanic.net>
Subject: Re: xt_gateway locks up
Date: Fri, 26 Oct 2007 15:08:55 +0100
Message-ID: <4721F4F7.1060602@ufomechanic.net>
References: <Pine.LNX.4.64.0710220012060.1997@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from server1.secure-linux-server.com ([207.44.172.97]:54351 "EHLO
	server1.secure-linux-server.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbXJZOJA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Oct 2007 10:09:00 -0400
In-Reply-To: <Pine.LNX.4.64.0710220012060.1997@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

* Jan Engelhardt wrote, On 21/10/07 23:14:
> Hi Sam,
> 
> 
> just for the fun of it, I tried:
> 
> 	iptables -t mangle -A PREROUTING -m gateway --nexthop 10.10.96.1
> 
> and it locked up hard (not even sysrq-b was possible).
> I am not sure why that happened - it does work properly in -t filter -A 
> OUTPUT, though. I'll experiment a bit.
> The codebase I am on is at 
> http://dev.computergmbh.de/wsvn/misc_kernel/xt_gateway/

Yeah, my match function was very verbose:

{
        const struct ipt_gateway_info *info = matchinfo;
        const struct iphdr *iph = skb->nh.iph;

        return (  !!(info->flags & IPT_GATEWAY_INV) ^
                ( skb && skb->dst && skb->dst->neighbour &&
...

It assumes that IF skb->dst is set, that it is a neighbour table entry.

Your code is:

	dst = skb->dst;
	if ((neigh = dst->neighbour) == NULL)
		return false;


It doesn't consider that skb->dst may be NULL, which it will in PRE_ROUTING.

Sam
