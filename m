From: Florian Westphal <fw@strlen.de>
Subject: [RFC nft] ct expr: make directional keys work
Date: Thu, 17 Dec 2015 01:55:33 +0100
Message-ID: <20151217005533.GA24044@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34903 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755445AbbLQA57 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Dec 2015 19:57:59 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.80)
	(envelope-from <fw@strlen.de>)
	id 1a9MtJ-0006c0-PN
	for netfilter-devel@vger.kernel.org; Thu, 17 Dec 2015 01:57:57 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

some ct expressions don't work at the moment since we never set the
'direction' attribute, but kernel mandates it.

The current approach i've been working splits ct keywords into
two groups, one mandates a 'direction' argument (saddr, protocol),
others do not (mark for example).

Would this syntax be acceptable?

ct saddr original 192.168.0.1

If not, I'd like suggestions on how this should look like instead.

Since the saddr (and a few other) arguments have unknown size
(depends on the l3 tracker tuple sizes), its currently filled in
later depending on NH base (i.e. in nft upstream).

This means that

ct proto-dst original ssh

will NOT work, but

ct protocol original tcp ct proto-dst original ssh

would.  Is that ok?  I don't see how I could auto-add the dependency in
such case.

Moreover, while this is currently implemented as a dependency (type set to
inet_service if PROTO_BASE_TRANSPORT_HDR present) the kernel does just
fetch a 16 bit quantity from the tuple so there is no real dependency
-- its just raw data.

So we could actually allow things like

ct proto-dst original 22

and it would match anything that has a 22 in the dst.tuple.all field...
but -- does that make sense?

Finally, I'm working on support for packets and byte counters.

Fetching original or reply directions would 'just work' after
directional keys are supported, i.e.:

ct packets original > 100

But I'm not sure how we should handle the case where someone wants to test
'X bytes/packets in total'.

ct packets > 100:
could be confusing, also not sure how difficult it is
to allow ct keywords that have an optional direction

ct packets both > 100: also looks wrong to me

ct packets original + ct packets reply > 100:
Looks like the most nft-esque solution to me, but would need new EXPR_ADD.

Thoughts?

Thanks,
Florian
