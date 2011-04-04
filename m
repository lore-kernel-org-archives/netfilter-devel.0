From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2 2/3] netfilter: af_info: add 'strict' parameter to
 limit lookup to .oif
Date: Mon, 04 Apr 2011 17:01:27 +0200
Message-ID: <4D99DD47.9050106@trash.net>
References: <1300998597-2018-1-git-send-email-fw@strlen.de>	<1300998597-2018-2-git-send-email-fw@strlen.de> <20110324.161516.42815453.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54068 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab1DDPBd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:01:33 -0400
In-Reply-To: <20110324.161516.42815453.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.03.2011 00:15, David Miller wrote:
>> > ipv6 fib lookup can set RT6_LOOKUP_F_IFACE flag to restrict search
>> > to an interface, but this flag cannot be set via struct flowi.
>> > 
>> > Also, it cannot be set via ip6_route_output: this function uses the
>> > passed sock struct to determine if this flag is required
>> > (by testing for nonzero sk_bound_dev_if).
>> > 
>> > Work around this by passing in an artificial struct sk in case
>> > 'strict' argument is true.
>> > 
>> > This is required to replace the rt6_lookup call in xt_addrtype.c with
>> > nf_afinfo->route().
>> > 
>> > Signed-off-by: Florian Westphal <fw@strlen.de>
> Acked-by: David S. Miller <davem@davemloft.net>

Applied, thanks.
