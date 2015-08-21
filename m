From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] add missing icmpv6 codes (rfc4443) in REJECT
Date: Fri, 21 Aug 2015 11:01:45 +0200
Message-ID: <20150821090144.GB4160@breakpoint.cc>
References: <1440147540-27296-1-git-send-email-andi@geekosphere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Andreas Herz <andi@geekosphere.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43982 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752617AbbHUJBq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Aug 2015 05:01:46 -0400
Content-Disposition: inline
In-Reply-To: <1440147540-27296-1-git-send-email-andi@geekosphere.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Andreas Herz <andi@geekosphere.org> wrote:
> RFC 4443 added two new codes values for ICMPv6 type 1:
> 
>  5 - Source address failed ingress/egress policy
>  6 - Reject route to destination
> 
> And RFC 7084 states in L-14 that IPv6 Router MUST send ICMPv6 Destination
> Unreachable with code 5 for packets forwarded to it that use an address 
> from a prefix that has been invalidated.
> 
> Signed-off-by: Andreas Herz <andi@geekosphere.org>
> ---
>  include/uapi/linux/netfilter_ipv6/ip6t_REJECT.h | 2 ++
>  net/ipv6/netfilter/ip6t_REJECT.c                | 6 ++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_REJECT.h b/include/uapi/linux/netfilter_ipv6/ip6t_REJECT.h
> index 205ed62..8bd5f4b 100644
> --- a/include/uapi/linux/netfilter_ipv6/ip6t_REJECT.h
> +++ b/include/uapi/linux/netfilter_ipv6/ip6t_REJECT.h
> @@ -9,6 +9,8 @@ enum ip6t_reject_with {
>  	IP6T_ICMP6_NOT_NEIGHBOUR,
>  	IP6T_ICMP6_ADDR_UNREACH,
>  	IP6T_ICMP6_PORT_UNREACH,
> +	IP6T_ICMP6_POLICY_FAIL,
> +	IP6T_ICMP6_REJECT_ROUTE,
>  	IP6T_ICMP6_ECHOREPLY,
>  	IP6T_TCP_RESET
>  };

I'm afraid we'll have to append these at the end, else we break abi --
new kernel would use IP6T_ICMP6_POLICY_FAIL if old userspace asked for
IP6T_ICMP6_ECHOREPLY...

