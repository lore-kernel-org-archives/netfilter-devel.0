From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] tests: validate generated netlink instructions
Date: Wed, 12 Aug 2015 19:46:24 +0200
Message-ID: <20150812174624.GA31166@breakpoint.cc>
References: <1437096699-8832-1-git-send-email-fw@strlen.de>
 <20150720125004.GA7402@salvia>
 <20150720151046.GD11985@breakpoint.cc>
 <20150720170538.GA22735@salvia>
 <20150720183536.GE11985@breakpoint.cc>
 <20150812173453.GA30926@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56347 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769AbbHLRq0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Aug 2015 13:46:26 -0400
Content-Disposition: inline
In-Reply-To: <20150812173453.GA30926@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I found a problem in your change to validate the netlink instructions
> from the python infrastructure that we have for nft.
> 
> The set elements are not always displayed in the same order depending
> on the hash seed, so we get bogus warnings in that case.

Did that change recently?
I run the tests quite extensively at the moment and I did not see
failures in the set parts yet.

> I think the fix for the test infrastructure will require something a
> bit more complicated that a simple string comparison as we'll need to
> interpret the set element part.
> 
> Probably it would be good to wrap the netlink instruction generation
> code under some option until this is resolved, instead of having it
> enabled by default.
> 
> Let me know if you come up with any better idea. Thanks!

I'm currently in the process of finalizing a first draft of vlan
matching, i think i have patches ready next week.

This will also make "nft add rule bridge filter input ip version 4"
work since it adds support for sub-byte sized header elements.

I plan to work on the test suite again after I get v1 out (add BE support
so we can also check nft on s390 etc).

I haven't thought about it yet, first plan was to record separate traces
for LE and BE architectures, think thats better than trying to normalize
the endianess in the output (might also mask errors...).

I'll try to figure out a way to cure the set part.

One way would be accomondate the test parser to recognize the set data
and sort those into some common order (doesn't matter as long as both ondisk
and observed output are in the same sort order).

I don't mind if you add a quick patch that disables the payload
comparision for now, we can reenable it later by default once BE + set
works correctly.
