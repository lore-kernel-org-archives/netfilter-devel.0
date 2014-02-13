From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2 nft] scanner: fix parsing of tc handle
Date: Thu, 13 Feb 2014 13:21:06 +0000
Message-ID: <20140213132106.GB4707@macbook.localnet>
References: <1392291672-7885-1-git-send-email-pablo@netfilter.org>
 <1392291672-7885-2-git-send-email-pablo@netfilter.org>
 <20140213115112.GA30397@macbook.localnet>
 <20140213130102.GB4223@macbook.localnet>
 <52FCC3C1.9070702@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39569 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbaBMNVK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Feb 2014 08:21:10 -0500
Content-Disposition: inline
In-Reply-To: <52FCC3C1.9070702@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 13, 2014 at 02:08:17PM +0100, Mart Frauenlob wrote:
> On 13.02.2014 14:01, Patrick McHardy wrote:
> ...
> 
> >Generally it seems like using a ':' in maps might not be the best idea
> >after all, its used for too many other things already. This might be
> >the reason why I initially used =>, not sure anymore.
> >
> >Is there a reasonable alternative to ':' with a single character?
> 
> x = y or x=y sounds and looks very reasonable and fitting the case
> to me, would it break something else?

I've thought about this myself, it should prevent these problems, though
I actually don't like it very much. Just my taste though, I still hope
we can come up with something in the lexer.
