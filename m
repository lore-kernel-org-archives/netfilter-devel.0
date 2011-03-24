From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 2/3] netfilter: af_info: add 'strict' parameter to
 limit lookup to .oif
Date: Thu, 24 Mar 2011 16:15:16 -0700 (PDT)
Message-ID: <20110324.161516.42815453.davem@davemloft.net>
References: <1300998597-2018-1-git-send-email-fw@strlen.de>
	<1300998597-2018-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54034
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934344Ab1CXXOh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Mar 2011 19:14:37 -0400
In-Reply-To: <1300998597-2018-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Florian Westphal <fw@strlen.de>
Date: Thu, 24 Mar 2011 21:29:56 +0100

> ipv6 fib lookup can set RT6_LOOKUP_F_IFACE flag to restrict search
> to an interface, but this flag cannot be set via struct flowi.
> 
> Also, it cannot be set via ip6_route_output: this function uses the
> passed sock struct to determine if this flag is required
> (by testing for nonzero sk_bound_dev_if).
> 
> Work around this by passing in an artificial struct sk in case
> 'strict' argument is true.
> 
> This is required to replace the rt6_lookup call in xt_addrtype.c with
> nf_afinfo->route().
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: David S. Miller <davem@davemloft.net>
