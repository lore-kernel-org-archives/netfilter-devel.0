From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nftables PATCH] proto: add icmp and icmpv6 in inet protocols
Date: Mon, 23 Jun 2014 12:55:22 +0100
Message-ID: <20140623115522.GA32759@macbook.localnet>
References: <1403522297-16661-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55700 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaFWLz1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:55:27 -0400
Content-Disposition: inline
In-Reply-To: <1403522297-16661-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 23, 2014 at 01:18:17PM +0200, Alvaro Neira Ayuso wrote:
> If we try to add a rule with icmp or icmpv6 in a inet table like this:
> 
> nft add rule inet filter input icmp type echo-request counter
> or
> nft add rule inet filter input icmpv6 type echo-request counter
> 
> we have this error:
> 
> <cmdline>:1:28-38: Error: conflicting protocols specified: inet-service vs. icmpv6
> add rule inet filter input icmpv6 type echo-request counter accept
>                            ^^^^^^^^^^^
> 
> This patch solve it adding icmp and icmpv6 in the inet protocols that we can use.
> Also, I have added a statement meta for restricting that the rules for icmp is only
> for ipv4 traffic and the rules for icmpv6 is for ipv6 traffic.

These a rather complex changes and I'd like to see the protocol context
parts split and explained in more detail.

I'm also not convinced by the special handling for this case. The same
problem affects f.i. the bridge family. Stated generically, the problem
is finding dependency expressions when one or more element in the chain
is missing. My feeling is that we should walk all possible paths to
the base protocol and, if only a single path exists (for now), use that
for dependencies.
