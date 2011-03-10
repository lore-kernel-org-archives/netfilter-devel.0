From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 2/2] netfilter: xt_addrtype: ipv6 support.
Date: Thu, 10 Mar 2011 23:22:04 +0100
Message-ID: <20110310222204.GZ8821@Chamillionaire.breakpoint.cc>
References: <1299619045-4027-1-git-send-email-fw@strlen.de>
 <1299619045-4027-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:48509 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980Ab1CJWWG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:22:06 -0500
Received: id: fw by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1PxoFA-0005pn-Kd
	for netfilter-devel@vger.kernel.org; Thu, 10 Mar 2011 23:22:04 +0100
Content-Disposition: inline
In-Reply-To: <1299619045-4027-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> diff --git a/net/netfilter/xt_addrtype.c b/net/netfilter/xt_addrtype.c
> index e89c0b8..2220b85 100644
> --- a/net/netfilter/xt_addrtype.c
> +++ b/net/netfilter/xt_addrtype.c
[..]
> +	if ((XT_ADDRTYPE_LOCAL | XT_ADDRTYPE_ANYCAST |
> +	     XT_ADDRTYPE_UNREACHABLE) & mask) {
> +		struct rt6_info *rt;
> +		u32 type;
> +		int ifindex = dev ? dev->ifindex : 0;
> +
> +		rt = rt6_lookup(net, addr, NULL, ifindex, !!dev);
> +

This needs a Kconfig
	 depends on (IPV6 || IPV6=n)

to avoid linker errors for the ipv6=m and xt_addrtype=y case.

Patrick, I'll refrain from sending v3 for now in case any other changes
might be needed.

Please let me know if you want me to send a V3 with the Kconfig change
only.

Thanks,
Florian
