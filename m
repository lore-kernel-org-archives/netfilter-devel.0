From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] expression: fix output of verdict maps
Date: Thu, 16 Jan 2014 16:57:53 +0000
Message-ID: <20140116165753.GA4958@macbook.localnet>
References: <1389616756-8326-1-git-send-email-pablo@netfilter.org>
 <20140116165337.GA5205@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57592 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbaAPQ54 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:57:56 -0500
Content-Disposition: inline
In-Reply-To: <20140116165337.GA5205@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 16, 2014 at 05:53:37PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Jan 13, 2014 at 01:39:16PM +0100, Pablo Neira Ayuso wrote:
> > % nft list table filter
> > table ip filter {
> > 	...
> > 	chain output {
> > 		...
> > 		ip saddr map { 1.1.1.1 => accept}
> > 	}
> > }
> > 
> > It displays 'map' instead of 'vmap'. Fix it by checking the mapping
> > type in map_expr_print().
> 
> Spinning over the list of pending stuff in my notepad before the
> release.
> 
> I think it's not so bad if we keep the 'vmap' for verdict maps. This
> can just become a synonym of 'map' if we ever find the way to make it
> work without ambiguity complains from the parser.

Yes, absolutely. We should just add your patch to fix the output for now.
