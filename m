From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] possible unaligned packet header caused by
 ip_route_me_harder()->pskb_expand_head()
Date: Mon, 21 Nov 2011 18:47:11 +0100
Message-ID: <20111121174711.GB4193@1984>
References: <4EB9449D.8020701@tilera.com>
 <1320771494.3444.8.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <4EBA48F3.8040906@tilera.com>
 <1320832102.2315.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <4EBB7E3C.9030402@tilera.com>
 <20111113170233.GA16851@1984>
 <4EC0D254.7060503@tilera.com>
 <1321264000.2272.0.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <4EC0F4E6.50103@tilera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Paul Guo <ggang@tilera.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60570 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab1KURrR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:47:17 -0500
Content-Disposition: inline
In-Reply-To: <4EC0F4E6.50103@tilera.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 14, 2011 at 07:00:54PM +0800, Paul Guo wrote:
> This patch tries to fix the following issue in netfilter:
> ip_route_me_harder()->pskb_expand_head() rellocates new header with
> additional head room which can break the alignment of the original
> packet header.
> 
> In one of my NAT test case, the NIC port for internal hosts is
> configured with vlan and the port for external hosts is with
> general configuration. If we ping an external "unknown" hosts from an
> internal host, an icmp packet will be sent. We find that in
> icmp_send()->...->ip_route_me_harder()->pskb_expand_head(), hh_len=18
> and current headroom (skb_headroom(skb)) of the packet is 16. After
> calling pskb_expand_head() the packet header becomes to be unaligned
> and then our system (arch/tile) panics immediately.
> 
> Here is the patch:
> 
> Signed-off-by: Paul Guo <ggang@tilera.com>

Applied to my nf branch:

http://1984.lsi.us.es/git/?p=net/.git;a=summary

Thanks everyone.
