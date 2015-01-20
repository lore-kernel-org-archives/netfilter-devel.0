From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] bridge: forward IPv6 fragmented packets when passing
 netfilter
Date: Tue, 20 Jan 2015 18:28:05 +0100
Message-ID: <20150120172805.GA11456@salvia>
References: <1421628209-5064-1-git-send-email-bernhard.thaler@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35973 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbbATRZN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:25:13 -0500
Content-Disposition: inline
In-Reply-To: <1421628209-5064-1-git-send-email-bernhard.thaler@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 19, 2015 at 01:43:29AM +0100, Bernhard Thaler wrote:
> ip6_fragment() in net/ipv6/ip6_output.c was changed due to a NULL pointer de-
> reference happening when handling packets coming from br_nf_dev_queue_xmit().
> When calling IP6_INC_STATS(), ip6_dst_idev(skb_dst(skb)) did crash the kernel
> like this:
> 
> BUG: unable to handle kernel NULL pointer dereference at 000000000000037a
> IP: [<ffffffff814cba2a>] ip6_fragment+0x99a/0x1290
> PGD 3bc3f067 PUD 3bc12067 PMD 0 
> Oops: 0000 [#1] SMP  
> ...
> 
> So in6_dev_get(skb->dev) is used to set a variable "idev" which is used to call
> IP6_INC_STATS() later on. It is assumed that this also solves other occasions
> where ip6_fragment() will be called that may cause the same crash. However,
> a better fix would be to check for the missing element causing the NULL pointer
> dereference and only setting it when it is missing.

IP6_INC_STATS() handles null idev pointers. I suspect the struct
fake_rtable in struct net_bridge (see net/bridge/br_private.h) needs
to be converted to something like:

        union {
                struct rtable   fake_rtable;
                struct rt6_info fake_rt6_info;
        };

just to allocate enough room for it.

> ip6_fragment() is further changed to use nf_bridge_mtu_reduction(skb) as it is
> done in the IPv4 code.

This specific change looks the same to what we have in IPv4, so no
objections.

Thanks.
