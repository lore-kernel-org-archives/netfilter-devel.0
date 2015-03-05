From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] netfilter: nf_tables: check for overflow of rule
 dlen field
Date: Thu, 5 Mar 2015 18:42:39 +0100
Message-ID: <20150305174239.GA7411@salvia>
References: <1425413060-6187-1-git-send-email-kaber@trash.net>
 <1425413060-6187-3-git-send-email-kaber@trash.net>
 <20150305163127.GA6878@salvia>
 <20150305163122.GW29092@acer.localdomain>
 <20150305171150.GA7275@salvia>
 <20150305171352.GD29092@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35571 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758320AbbCERi5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2015 12:38:57 -0500
Content-Disposition: inline
In-Reply-To: <20150305171352.GD29092@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 05, 2015 at 05:13:53PM +0000, Patrick McHardy wrote:
> I think this case shouldn't exist at all since it codifies kernel
> internals into the API. Today we might accept 128 expressions, the
> other day just 100, all depending on 32 or 64 bit systems. Its not
> good.
> 
> The problem is I also don't want to increase the maximum rule size
> to more than 4k since this will run into issues with memory
> fragmentation. I think we need to decrease NFT_EXPR_MAXNUM, its
> unreasonable large, and then add a per expression maximum size.

Yes, that's more than anyone would need I guess. We used to have a
couple of crazy tests in iptables with lots of matches in one rule
(maps to one expression each) that were hitting the limit. So my
motivation was to avoid hitting that it from nft_compat. Assuming that
the info area consumes ~32 bytes and 128 expressions, we would exactly
reach the limit. But there are xtables extensions consuming more than
that for the info area, so we may hit the limit before those 128
expressions with this check. I think that's OK, we should consider
realistic scenarios, not too crazy tests.

> For now I'd say apply it as it is, keep the different errno code
> since its a really different case, and we'll fix up the underlying
> problem after a bit more of thought.

Sure, thanks for the explanation.
