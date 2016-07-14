From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 2/3] meta: add short-hand mnemonic for probalistic
 matching
Date: Thu, 14 Jul 2016 12:52:18 +0200
Message-ID: <20160714105218.GA24700@breakpoint.cc>
References: <1467704135-9154-1-git-send-email-fw@strlen.de>
 <1467704135-9154-3-git-send-email-fw@strlen.de>
 <20160714104108.GA2250@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44823 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059AbcGNKwY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jul 2016 06:52:24 -0400
Content-Disposition: inline
In-Reply-To: <20160714104108.GA2250@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Jul 05, 2016 at 09:35:34AM +0200, Florian Westphal wrote:
> > Allow users to use a simpler way to specify probalistic matching, e. g.:
> > 
> > meta probability 0.5		(match approx. every 2nd packet)
> > meta probability 0.001		(match approx. once every 1000 packets)
> > 
> > nft list will still show
> > meta random <= 2147483647
> > meta random <= 4294967
> 
> I don't like this asymmetry.

Its changed in patch #3 when adding the shorthand reverse translation.

> What is the usecase for 'meta random' out of this probability case that
> maps to what xt_statistics offers?

Nothing, but the meta random might be interesting to e.g. set random
(ct)mark for load balancing purposes.
