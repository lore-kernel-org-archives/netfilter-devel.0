From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH 4/4 v3] nft: complete reject support
Date: Mon, 22 Sep 2014 10:20:58 +0200
Message-ID: <20140922082058.GK4971@acer.localdomain>
References: <1411327957-19379-1-git-send-email-alvaroneay@gmail.com>
 <1411327957-19379-4-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35727 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaIVIVD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:21:03 -0400
Content-Disposition: inline
In-Reply-To: <1411327957-19379-4-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 21, 2014 at 09:32:37PM +0200, Alvaro Neira Ayuso wrote:
> This patch allows to use the reject action in rules. Example:
> 
>   nft add rule filter input udp dport 22 reject
> 
> In this rule, we assume that the reason is network unreachable. Also
> we can specify the reason with the option "with" and the reason. Example:
> 
>   nft add rule filter input tcp dport 22 reject with host-unreach
> 
> In the bridge tables and inet tables, we can use this action too. Example:
> 
>   nft add rule inet filter input reject with icmp-host-unreach
> 
> In this rule above, this generates a meta nfproto dependency to match
> ipv4 traffic because we use a icmpv4 reason to reject.
> 
> If the reason is not specified, we infer it from the context.

There are a couple of things I don't like very much about this concept.

First of all, the types have redundant information (icmp-*, icmpv6-*).
This might not look to bad if you only consider the reject statement,
but the redundancy becomes very obvious if you consider a set declaration
which explicitly specifies the data type and still has to use the icmp
prefix for every value.

Its also not consistent with the remaining keywords, we don't use
tcp-syn, tcp-fin etc.

I also don't like having a reject specific family, without taking extra
care this prevents protocol conflict detection and determination of
the protocol for following expressions.

I'd rather have this very explicit:

reject with icmp host-unreachable
reject with icmpv6 host-unreachable
reject with icmp

So the protocol would be an explizit parameter without strcmp hacks and
the type keywords would not encode the protocol. I'd also not be
against just using the exact same syntax as for matches:

reject with icmp type host-unreach (note the extra "type").

> Insufficient context for using reject
>   * nft add rule inet filter input reject
>   * nft add rule bridge filter input reject

Well, we do have the inet reject expression and I consider it important
that we actually support it, we want to help make easier rulesets.

It does actually work today without a specific type as in your example,
so why wouldn't this work anymore?

I actually think we should add full support for this by adding an
inet-specific ICMP type table which is the intersection of the ICMP
and ICMPv6 types for inet and map those to the corresponding real
types:

nft inet filter input reject with host-unreachable
