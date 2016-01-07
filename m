From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft] syntax for retrieving ct byte/packet counters
Date: Thu, 7 Jan 2016 18:53:21 +0100
Message-ID: <20160107175321.GA1481@salvia>
References: <20160107134351.GD23789@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57555 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbcAGRx0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Jan 2016 12:53:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 623C23153AB
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Jan 2016 18:53:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 525B2DA85D
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Jan 2016 18:53:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 682D1DA807
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Jan 2016 18:53:22 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160107134351.GD23789@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 07, 2016 at 02:43:51PM +0100, Florian Westphal wrote:
> Hi.
> 
> I've finished the kernel patch to fetch byte/packet conntrack counters.
> 
> As discussed earlier, I added two modes:
> - fetch original or reply
> - fetch sum of original+reply direction
>   (i.e. nft_ct adds original+reply before storing result into register).
> 
> How should that look like on the userspace side?
> 
> I see two solutions to handle this.  Option one is to add a new
> pseudo-direction, e.g. "both":
> nft ... ct packets both gt 42
> nft ... ct packets original gt 42
> 
> Second option -- which I'd prefer -- is to allow omitting the direction.
> This seems possible w.o. adding parser problems by switching direction
> and key, so we'd have:
> 
> nft ... ct packets gt 42
> nft ... ct reply packets gt 42
> nft ... ct original packets gt 42
> 
> Because parser would just add
> 
> ct_key_counters	: BYTES | PACKETS;
> ct_expr:	CT ct_key_counters | CT STRING ct_key_counters
> 
> which doesn't introduce ambiguity (original and reply aren't scanner
> tokens, unlike ct_keys)
> 
> If we follow this route, i'd also swap the direction and key argument
> for the existing saddr/daddr/etc keys, i.e. instead of
> 
> ... 'ct saddr original 1.2.3.4' we'd have
> ... ct original saddr 1.2.3.4 ...
> 
> This would make packets/bytes work *both* like ct_keys with and without
> direction:
> 
> ct mark gt 42   ---> fetch mark
> ct original mark gt 42	-> parser error, mark can only be used w/o dir
> ct saddr 1.2.3.4 -> parser error, saddr needs direction
> ct original saddr 1.2.3.4 -> fetch ct saddr in original dir
> ct packets gt 42 -> fetch sum of packet counter for original and reply
> ct original packets gt 42 -> fetch packet counter for original
> 
> What do others think?
> 
> Swapping key and direction breaks backwards compatibility but
> this was added only recently so I think it shouldn't be a problem.

If that is the only problem, we didn't make any release so far, so no
objection from my side.
