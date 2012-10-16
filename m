From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: TEE broken in 3.6
Date: Tue, 16 Oct 2012 22:00:18 +0200
Message-ID: <1350417618.3954.1494.camel@edumazet-glaptop>
References: <20121016211319.3f07a7e3@goldlack.enda.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Torsten Luettgert <ml-netfilter@enda.eu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59204 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab2JPUAW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Oct 2012 16:00:22 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so3712418eek.19
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Oct 2012 13:00:21 -0700 (PDT)
In-Reply-To: <20121016211319.3f07a7e3@goldlack.enda.eu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2012-10-16 at 21:13 +0200, Torsten Luettgert wrote:
> Hi,
> 
> today, I found that the TEE target doesn't work any longer in 3.6 and
> following kernels. The problem is that it tries to ARP-lookup the
> original destination address of the forwarded packet, not the address
> of the gateway.
> 
> I git bisected and found that this commit broke it:
> 
> commit f8126f1d5136be1ca1a3536d43ad7a710b5620f8
> Author: David S. Miller <davem@davemloft.net>
> Date:   Fri Jul 13 05:03:45 2012 -0700
> 
>     ipv4: Adjust semantics of rt->rt_gateway.
>     
>     In order to allow prefixed routes, we have to adjust how rt_gateway
>     is set and interpreted.
>     
>     The new interpretation is:
>     
>     1) rt_gateway == 0, destination is on-link, nexthop is iph->daddr
>     
>     2) rt_gateway != 0, destination requires a nexthop gateway
>     
>     Abstract the fetching of the proper nexthop value using a new
>     inline helper, rt_nexthop(), as suggested by Joe Perches.
>     
>     Signed-off-by: David S. Miller <davem@davemloft.net>
>     Tested-by: Vijay Subramanian <subramanian.vijay@gmail.com>
> 
> which seems plausible. I'm not versed enough in netfilter/routing code
> to fix it myself. Could any of you wizards help?

Hmm...

Could you try latest tree, with the following patch ?

diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index ee2e5bc..bd93e51 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -70,6 +70,7 @@ tee_tg_route4(struct sk_buff *skb, const struct xt_tee_tginfo *info)
 	fl4.daddr = info->gw.ip;
 	fl4.flowi4_tos = RT_TOS(iph->tos);
 	fl4.flowi4_scope = RT_SCOPE_UNIVERSE;
+	fl4.flowi4_flags = FLOWI_FLAG_KNOWN_NH;
 	rt = ip_route_output_key(net, &fl4);
 	if (IS_ERR(rt))
 		return false;




