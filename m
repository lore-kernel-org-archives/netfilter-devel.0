From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH RFC 0/2] nftables: fix time parsing
Date: Sat, 11 Apr 2015 18:25:56 +0100
Message-ID: <20150411172556.GC8539@acer.localdomain>
References: <1428760830-6135-1-git-send-email-kaber@trash.net>
 <20150411165250.GA8078@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52066 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbbDKR0A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Apr 2015 13:26:00 -0400
Content-Disposition: inline
In-Reply-To: <20150411165250.GA8078@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11.04, Pablo Neira Ayuso wrote:
> On Sat, Apr 11, 2015 at 03:00:28PM +0100, Patrick McHardy wrote:
> > These patches attempt to fix time parsing to not require quotation marks
> > around the time spec and loosen the checks so times can also be specified
> > in smaller units.
> > 
> > Some testing indicates it works fine, however I'd put them into a branch
> > for 4.1 since I mainly need this fixed for the set timeout support.
> 
> Thanks, this looks fine to me.

Still reworking it slightly for the set related timeouts. Will post
a final version later tonight I think.

> I still think that we need to consider flex start conditions or
> something similar to make the scanner a bit smarter (stateful) to
> avoid complexity on the parser.
> 
> I think that may also help to avoid the side issue related to this
> patch:
> 
> http://patchwork.ozlabs.org/patch/443091/
> 
> Basically, the scanner takes this:
> 
> tcp sport vmap { 25:accept, 28:drop };ok
>                  ^^^^^
> 
> as a tc handle.

The problem with start conditions is that we need the parser to actually
start them. This means the parser will have to know, in advance, what
to expect. TC handles are actually one of the easier cases since they
can only occur on the RHS of a meta stmt, but it gets ugly very quickly.

Overall, I don't think they will provide much help, have already tried
many times.

I'm thinking - basically these cases are not too common, keywords require
seperators anyways. Maybe greedily matching for non-keywords until clear
seperators like ",", whitespace, {, }, ... might help. Not sure if flex
is capable of doing that.

I can look into that at the end of next week.
