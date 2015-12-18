From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/5] ct: add support for directional keys
Date: Fri, 18 Dec 2015 22:07:58 +0100
Message-ID: <1450472883-19743-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40515 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965327AbbLRVMA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2015 16:12:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Here are the patches for directional key support that I have.
They pass our regression test suite, another advantage is that
nft will no longer parse 'ct saddr 1.2.3.4', it notices that
a direction is missing.

The disadvantage is that we also have (not-yet added) keys
'packets' and 'bytes'.  These are trivial to add, since
they need a direction, just like ct (s|d)addr.

But in byte/packet case it would be good to also allow
matching on total bytes combined (original+reply).

And that either needs 'ambiguos' keys, i.e. allow
ct packets original > 42  (tells kernel: I want packet count in original direction)
ct packets > 42  (tells kernel: I want original+reply direction).

or a '+' expression so that we can
ct packets original + ct packets reply and so sum via intermediate expression.

So don't apply this yet, I'll have another stab at attemting to
not change the parser at all but instead attempt to resolve
this during evaluation, as Pablo suggested, i.e.

ct direction original
-> ct direction = original

BUT
ct direction = original ct saddr
-> merge into single a single ct expression, asking for saddr
in original direction.

Patrick, if you have any advice wrt the nft grammar I'd be glad to hear it.
