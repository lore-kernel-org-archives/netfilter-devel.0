From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 1/6] netfilter: nf_tables: extend tracing
 infrastructure
Date: Tue, 24 Nov 2015 10:33:49 +0000
Message-ID: <20151124103348.GG2310@macbook.localdomain>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-2-git-send-email-fw@strlen.de>
 <20151124102245.GD2683@salvia>
 <20151124102841.GD1740@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:44613 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752563AbbKXKdw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:33:52 -0500
Content-Disposition: inline
In-Reply-To: <20151124102841.GD1740@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.11, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > BTW, do we really want to use the default NFNLGRP_NFTABLES group?
> > 
> > multicast group provide a simple way for filtering out what you don't
> > need from kernelspace. And you can still subscribe both groups
> > NFNLGRP_NFTABLES and NFNLGRP_NFTABLES_TRACE.
> > 
> > I'm telling this when thinking of nft-sync. Why should it be receiving
> > this spamming tracing events when it only cares about ruleset updates?
> 
> I can add a new group but nftables will need to subscribe to both
> in trace mode since we need to see new rules...

I agree with Pablo. Under high load this has the potential to decrease
reliability of rule notifications a lot for any interested listener. Since
tracing is a debugging tool I don't think we should do that.

BTW and completely unrelated to the netlink group: I think it would be
nicer to have a "trace" keyword instead of "nftrace set 1" in the nft
frontend.
