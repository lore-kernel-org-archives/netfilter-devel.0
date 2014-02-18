From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft RFC PATCH 6/6] src: add events reporting
Date: Tue, 18 Feb 2014 10:12:59 +0000
Message-ID: <20140218101259.GC12496@macbook.localnet>
References: <20140217231654.19943.18736.stgit@nfdev.cica.es>
 <20140217231837.19943.77406.stgit@nfdev.cica.es>
 <20140218011007.GA4456@localhost>
 <20140218020354.GG12893@macbook.localnet>
 <20140218092811.GA3880@localhost>
 <20140218093311.GA11507@macbook.localnet>
 <20140218094320.GA4009@localhost>
 <20140218095209.GA12005@macbook.localnet>
 <20140218095829.GA4173@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58378 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbaBRKNE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:13:04 -0500
Content-Disposition: inline
In-Reply-To: <20140218095829.GA4173@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 18, 2014 at 10:58:29AM +0100, Pablo Neira Ayuso wrote:
> On Tue, Feb 18, 2014 at 09:52:10AM +0000, Patrick McHardy wrote:
> > 
> > Sure, just wanted to be clear about which types of errors may cause
> > a fatal error.
> 
> Talking about errors when building the higher level expression tree
> from the netlink message, I think nft should output some low-level
> expression if it fails to interpret it in a human readable way / nft
> syntax way.

Not sure how exactly to do that. It will never really fail unless the
rule has real errors like using data that hasn't been loaded before.
It will always result in *some* expression, so how would be determine
that?

> We already discussed that third party applications may decide to skip
> nft as use the netlink interface to build sophisticated filters, in
> that case, I think those tools should not break the output of nft if
> it fails to understand what it gets from the kernel.

I'm actually not sure nft really could fail if the expression returned
from the kernel makes any sense at all. Worst case should be that it
translates it to literate expressions used by the kernel (IOW,
payload @raw-expression & val ^ val2 >= ... instead of some simplified
form).
