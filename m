From: Jan Engelhardt <jengelh@inai.de>
Subject: ipt_REJECT and ip6t_REJECT discrepancies
Date: Wed, 11 Jul 2012 03:59:50 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207110355390.15087@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "David S. Miller" <davem@davemloft.net>,
	yasuyuki.kozakai@toshiba.co.jp,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:55239 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab2GKB7w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jul 2012 21:59:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


while looking into making xt_TARPIT ready for inclusion into mainline, I
was at the same time looking at REJECT to see if any new constructs to
packet crafting and sending have been introduced lately. There I notice
a big difference between the ipv4 and ipv6 paths:

The
        memset(&fl6, 0, sizeof(fl6)); 
        fl6.flowi6_proto = IPPROTO_TCP;
        fl6.saddr = oip6h->daddr;   
        fl6.daddr = oip6h->saddr;   
        fl6.fl6_sport = otcph.dest; 
        fl6.fl6_dport = otcph.source;
        security_skb_classify_flow(oldskb, flowi6_to_flowi(&fl6));
        dst = ip6_route_output(net, NULL, &fl6);
	[...]

segment is completely absent in ipv4, and there is not really a comment
about it why IPv6 would need it -- other than to please the LSM with
flow information, and to see that output routing yields non-NULL.

The xfrm lookup is also absent from ipt_REJECT.

Furthermore, ip6t_REJECT has this squiggly allocation logic:

        hh_len = (dst->dev->hard_header_len + 15)&~15;
        nskb = alloc_skb(hh_len + 15 + dst->header_len + sizeof(struct ipv6hdr)
                         + sizeof(struct tcphdr) + dst->trailer_len,
                         GFP_ATOMIC);

while ipt_REJECT keeps it simple:

        nskb = alloc_skb(sizeof(struct iphdr) + sizeof(struct tcphdr) +        
                         LL_MAX_HEADER, GFP_ATOMIC);

What could be the reason? Is the v6 code mostly superfluous now?
