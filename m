From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: ICMPv6 Type 1 Code 5 and 6 missing in iptables REJECT target
 and icmpv6 match
Date: Thu, 20 Aug 2015 10:13:34 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1508201012310.28043@nerf40.vanv.qr>
References: <20150819145136.GN21654@kvmbude>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Andreas Herz <andi@geekosphere.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:54503 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbbHTINf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 04:13:35 -0400
In-Reply-To: <20150819145136.GN21654@kvmbude>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2015-08-19 16:51, Andreas Herz wrote:
>And in RFC 4443 they are defined as:
>
>> 5 - Source address failed ingress/egress policy
>> 6 - Reject route to destination
>
>Is there a reason for that?
>
>If i look into the "extensions/libip6t_icmp6.c" i just see the codes 0,1,2,3,4
>for type 1. And in "include/linux/netfilter_ipv6/ip6t_REJECT.h" it's
>"IP6T_ICMP6_ECHOREPLY" which doesnt' sound like the one in the RFC.
>
>Or is it just missing, so i might add it?

It would appear fine to just add it.
