From: Andreas Herz <andi@geekosphere.org>
Subject: ICMPv6 Type 1 Code 5 and 6 missing in iptables REJECT target and
 icmpv6 match
Date: Wed, 19 Aug 2015 16:51:36 +0200
Message-ID: <20150819145136.GN21654@kvmbude>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.geekosphere.org ([78.47.150.211]:56137 "EHLO
	mail.geekosphere.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbbHSOvj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Aug 2015 10:51:39 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

as i read the RFC 7084 i found the following suggestion:

> L-14:   The IPv6 CE router MUST send an ICMPv6 Destination Unreachable
>         message, code 5 (Source address failed ingress/egress policy)
>         for packets forwarded to it that use an address from a prefix
>         that has been invalidated.

And in RFC 4443 they are defined as:

> 5 - Source address failed ingress/egress policy
> 6 - Reject route to destination

Is there a reason for that?

If i look into the "extensions/libip6t_icmp6.c" i just see the codes 0,1,2,3,4
for type 1. And in "include/linux/netfilter_ipv6/ip6t_REJECT.h" it's
"IP6T_ICMP6_ECHOREPLY" which doesnt' sound like the one in the RFC.

Or is it just missing, so i might add it?

Thanks

-- 
Andreas Herz
