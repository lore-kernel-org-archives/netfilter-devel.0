From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nftables 6/6] src: add trace support to nft monitor mode
Date: Tue, 24 Nov 2015 12:14:26 +0100
Message-ID: <20151124111426.GJ1740@breakpoint.cc>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-7-git-send-email-fw@strlen.de>
 <20151124102553.GE2310@macbook.localdomain>
 <20151124104834.GF1740@breakpoint.cc>
 <20151124105816.GL2310@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58618 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754497AbbKXLO1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 06:14:27 -0500
Content-Disposition: inline
In-Reply-To: <20151124105816.GL2310@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> > Yes, right now virtually all of the printing is in libnftnl
> > (called from nftables via nftnl_trace_fprintf() ).
> 
> The downside is that we're stuck to fprintf. I'm working on moving nft to
> printing to buffers for pretty printing, intending set contents, sorting
> flow tables in different dimensions etc. If we have external printing we'll
> be missing some flexibilty in handling it, also regarding logging to other
> outputs than stdout.

The _fprint variant is a convenience wrapper for nftnl_trace_snprintf.
Would that work for you?

