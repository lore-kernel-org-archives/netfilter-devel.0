From: Florian Westphal <fw@strlen.de>
Subject: Re: nftables rules not matching after upgrading from 0.7 to 0.8
Date: Wed, 25 Oct 2017 19:57:25 +0200
Message-ID: <20171025175725.GJ19457@breakpoint.cc>
References: <1508949114.1154.14.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54772 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932124AbdJYR5k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2017 13:57:40 -0400
Content-Disposition: inline
In-Reply-To: <1508949114.1154.14.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Anders K. Pedersen | Cohaesio <akp@cohaesio.com> wrote:
> After upgrading to nftables 0.8 (from 0.7) on one of my systems, I've
> experiences several cases where rules that used to work fine with 0.7
> sometimes doesn't match anymore with 0.8 (it's not consistent -
> sometimes the rules do match with 0.8).
> 
> The rule chains end with a log statement before rejecting or dropping
> the packets, and I can see in the log that everything is as expected
> and the rules should match. After downgrading to nftables 0.7
> everything works again.

Are those errors restricted to a particular table family, chain or protocol?

At least for ip family all packets will have pkt->tprot_set true,
so I don't see how meta would break there.

>  ip filter input 
> -  [ payload load 1b @ network header + 9 => reg 1 ]
> +  [ meta load l4proto => reg 1 ]
> 
> and
> 
>  ip6 filter input 
> -  [ payload load 1b @ network header + 6 => reg 1 ]
> +  [ meta load l4proto => reg 1 ]
> 
> for many of the rules. I believe this is intentional and correct by
> itself, so I guess the problem is in the kernel (the system is
> currently running 4.13.8), where "meta l4proto" sometimes isn't what it
> should be.

Weird.  We changed the implicit l4 dependencies to meta l4proto because
in ipv6 case this will skip extension headers.

IIRC ipv4 was only changed to keep it more simple.
(also nft_set_pktinfo_ipv4 sets
         pkt->tprot_set = true;
         pkt->tprot = iph->protocol;

so I fail to see why it should not be identical in all cases).

