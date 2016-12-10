From: Phil Sutter <phil@nwl.cc>
Subject: RFC: nft.8 review
Date: Sat, 10 Dec 2016 11:27:16 +0100
Message-ID: <20161210102715.GA2955@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:54645 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751981AbcLJK1S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 10 Dec 2016 05:27:18 -0500
Received: from mail.nwl.cc (orbyte.nwl.cc [127.0.0.1])
        by mail.nwl.cc (Postfix) with ESMTP id 2146361BFB
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Dec 2016 11:27:16 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I skimmed through nft man page and noted down problems I discovered.
While doing so, I got the idea to restructure the whole document for
better organization and comprehensibility but wanted to hear your
thoughts first before creating a ticket in netfilter BZ:


* Use BNF in synopses

This is rudimentally used in the SYNOPSIS section already, but just
lists _cmd_ without explanation - although the fun is only about to
start at this point. :)

What I really don't like is the syntax used in e.g. CHAINS section: it
is not only imprecise (nothing says you have to use 'priority <prio>'
but may not use 'table <table>', but also plain wrong when it comes to
the mandatory braces around the chain_block.


* Organize entity descriptions BNF-style

In my opinion the order of (sub-)sections is a bit chaotic at times.
E.g. RULES section synopsis tries to explain how a rule is made up from
statements, but these are not explained before five sections later (not
counting the bogus BLA section ;).

The idea here is to go from most generic to most specific, like things
are defined in yacc - just not as explicit, since if I want to know the
relation between concat_rhs_expr and shift_rhs_expr, I can just as well
read the code itself.


* What about sub-pages?

Looking at some expressions' descriptions, it seems like these might
grow exponentially with the documentation improving. So maybe it makes
sense to follow iptables' advice and have 'nft-extensions.8'? I would
have called it 'nft-statements.8' or 'nft-expressions.8' but the two are
too much intertwined to keep them separate.

OK, maybe this can wait until nft.8 really has become awfully long.


Comments, flame, donations highly appreciated, of course!

Cheers, Phil
