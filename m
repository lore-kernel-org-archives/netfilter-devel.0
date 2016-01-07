From: Florian Westphal <fw@strlen.de>
Subject: [nft] syntax for retrieving ct byte/packet counters
Date: Thu, 7 Jan 2016 14:43:51 +0100
Message-ID: <20160107134351.GD23789@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45144 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223AbcAGNnx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Jan 2016 08:43:53 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.80)
	(envelope-from <fw@strlen.de>)
	id 1aHAr1-0001sY-Tb
	for netfilter-devel@vger.kernel.org; Thu, 07 Jan 2016 14:43:52 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi.

I've finished the kernel patch to fetch byte/packet conntrack counters.

As discussed earlier, I added two modes:
- fetch original or reply
- fetch sum of original+reply direction
  (i.e. nft_ct adds original+reply before storing result into register).

How should that look like on the userspace side?

I see two solutions to handle this.  Option one is to add a new
pseudo-direction, e.g. "both":
nft ... ct packets both gt 42
nft ... ct packets original gt 42

Second option -- which I'd prefer -- is to allow omitting the direction.
This seems possible w.o. adding parser problems by switching direction
and key, so we'd have:

nft ... ct packets gt 42
nft ... ct reply packets gt 42
nft ... ct original packets gt 42

Because parser would just add

ct_key_counters	: BYTES | PACKETS;
ct_expr:	CT ct_key_counters | CT STRING ct_key_counters

which doesn't introduce ambiguity (original and reply aren't scanner
tokens, unlike ct_keys)

If we follow this route, i'd also swap the direction and key argument
for the existing saddr/daddr/etc keys, i.e. instead of

... 'ct saddr original 1.2.3.4' we'd have
... ct original saddr 1.2.3.4 ...

This would make packets/bytes work *both* like ct_keys with and without
direction:

ct mark gt 42   ---> fetch mark
ct original mark gt 42	-> parser error, mark can only be used w/o dir
ct saddr 1.2.3.4 -> parser error, saddr needs direction
ct original saddr 1.2.3.4 -> fetch ct saddr in original dir
ct packets gt 42 -> fetch sum of packet counter for original and reply
ct original packets gt 42 -> fetch packet counter for original

What do others think?

Swapping key and direction breaks backwards compatibility but
this was added only recently so I think it shouldn't be a problem.
