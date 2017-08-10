From: Florian Westphal <fw@strlen.de>
Subject: Re: RFC: Synopsis syntax change in nft.8
Date: Thu, 10 Aug 2017 23:55:03 +0200
Message-ID: <20170810215503.GA23403@breakpoint.cc>
References: <20170810182932.GJ16375@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48508 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753214AbdHJV5Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2017 17:57:16 -0400
Content-Disposition: inline
In-Reply-To: <20170810182932.GJ16375@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Sutter <phil@nwl.cc> wrote:
> When looking at nft man page for the first time, I remember finding the
> synopsis for individual commands (e.g. 'add table') rather misleading. I
> am biased, but the (BNF style) syntax used in the various iproute2 man
> pages is much more precise, so I would like to copy that for nft.8. The
> actual SYNOPSIS section at the top gets is quite right, BTW (apart from
> some minor flaws in font styles).

I have no objections.

> With no prior knowlege of how this syntax works, we start parsing the
> line from left to right and find out that something like:
> 
> | {foo | bar}
> 
> probably means "either 'foo' or 'bar'", no big deal. Next comes 'table'
> in bold font. What does bold mean? Looking at some examples, table seems
> to be a keyword ('terminal' in BNF-speak). But so are 'add', 'delete',
> 'list' and 'flush', so why are they in normal font?

Probably just because there are different authors...

[..]

 
> normal font: meta info (as above)
> bold font: keywords (as above)
> italics UPPERCASE: non-terminals, followed by a definition
> italics lowercase: non-terminals, not followed by a definition

LGTM.

> I am not overly familiar with docbook, so that might use other font
> styles for the different kinds we need. Also, I like to use the same
> font style when referring to elements in prose, which nicely draws
> readers attention while skimming through the text searching for
> explanations of things. Though I have no idea whether docbook allows for
> that without hacks.

FWIW I am not a docbook fan so I would not mind if we switch to
another markup system.

