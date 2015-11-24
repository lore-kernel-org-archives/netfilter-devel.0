From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nftables 6/6] src: add trace support to nft monitor mode
Date: Tue, 24 Nov 2015 11:41:54 +0000
Message-ID: <20151124114154.GQ2310@macbook.localdomain>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-7-git-send-email-fw@strlen.de>
 <20151124102553.GE2310@macbook.localdomain>
 <20151124104834.GF1740@breakpoint.cc>
 <20151124105816.GL2310@macbook.localdomain>
 <20151124111426.GJ1740@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:45130 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751730AbbKXLl6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 06:41:58 -0500
Content-Disposition: inline
In-Reply-To: <20151124111426.GJ1740@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.11, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > > Yes, right now virtually all of the printing is in libnftnl
> > > (called from nftables via nftnl_trace_fprintf() ).
> > 
> > The downside is that we're stuck to fprintf. I'm working on moving nft to
> > printing to buffers for pretty printing, intending set contents, sorting
> > flow tables in different dimensions etc. If we have external printing we'll
> > be missing some flexibilty in handling it, also regarding logging to other
> > outputs than stdout.
> 
> The _fprint variant is a convenience wrapper for nftnl_trace_snprintf.
> Would that work for you?

Probably, but with downsides. The nft internal buffer printing will
encapsulate every printed element so we can reorder them based on an
abstract meaning, f.i. for pretty printing, where we want to keep
related things together and reindent other parts.

We can also do filters, sorting on individual parts both numerically
and lexically, structured output etc etc, but all that requires to
have the invidual parts of the output available seperately.

So yeah it would work, and at least the sorting part doesn't make sense
for tracing anyways, but it would be a special case with some limitations.
