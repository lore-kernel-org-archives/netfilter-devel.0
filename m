From: Yasuyuki KOZAKAI <yasuyuki.kozakai@gmail.com>
Subject: Re: ipt_REJECT and ip6t_REJECT discrepancies
Date: Mon, 16 Jul 2012 13:30:38 +0900
Message-ID: <1FAE9F4A-F9B6-4264-8843-C6A1BA4D1E0B@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org, David Miller <davem@davemloft.net>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63392 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2GPEak convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jul 2012 00:30:40 -0400
Received: by pbbrp8 with SMTP id rp8so9406862pbb.19
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Jul 2012 21:30:39 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, Jan,

I reply with the private mail account (and now I've subscribed netfilter-devel with it).

> The
>         memset(&fl6, 0, sizeof(fl6)); 
>         fl6.flowi6_proto = IPPROTO_TCP;
>         fl6.saddr = oip6h->daddr;   
>         fl6.daddr = oip6h->saddr;   
>         fl6.fl6_sport = otcph.dest; 
>         fl6.fl6_dport = otcph.source;
>         security_skb_classify_flow(oldskb, flowi6_to_flowi(&fl6));
>         dst = ip6_route_output(net, NULL, &fl6);
> 	[...]
> 
> segment is completely absent in ipv4, and there is not really a comment
> about it why IPv6 would need it -- other than to please the LSM with
> flow information, and to see that output routing yields non-NULL.
> 
> The xfrm lookup is also absent from ipt_REJECT.

These correspond to ip_route_me_harder() in ipt_REJECT.
I think they can be replaced by ip6_route_me_harder().

The xfrm lookup for the TCP RST is also done by ip_route_me_harder().

>         hh_len = (dst->dev->hard_header_len + 15)&~15;
>         nskb = alloc_skb(hh_len + 15 + dst->header_len + sizeof(struct ipv6hdr)
>                          + sizeof(struct tcphdr) + dst->trailer_len,
>                          GFP_ATOMIC);

In the case of ipt_REJECT, ip_route_me_harder() expands the head of skb after getting a new dst,
then the size calculation here is simple.

On the other hand, ip6_route_me_harder() does not do it.
I think you can simplify the above code if you add a code to expand skb like ip_route_me_harder(),
then you can remove the magic number '15'.

A questionable part is trailer_len. ip_route_me_harder() don't take it into account.
Does xfrm output path expand skb automatically if there is no room to put a trailer ?

Regards,

-- Yasuyuki KOZAKAI

