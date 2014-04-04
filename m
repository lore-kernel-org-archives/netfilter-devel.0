From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] expr: do not suppress OP_EQ when RHS is bitmask type
Date: Fri, 4 Apr 2014 14:07:39 +0200
Message-ID: <20140404120739.GC27267@macbook.localnet>
References: <1395094118-32580-1-git-send-email-fw@strlen.de>
 <20140404081723.GA3574@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64031 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaDDMHm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:07:42 -0400
Content-Disposition: inline
In-Reply-To: <20140404081723.GA3574@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 04, 2014 at 10:17:23AM +0200, Pablo Neira Ayuso wrote:
> On Mon, Mar 17, 2014 at 11:08:38PM +0100, Florian Westphal wrote:
> > bitmask types default to flagcmp now, thus do not suppress OP_EQ.  Else,
> > 
> > rule filter output tcp flags syn
> > rule filter output tcp flags == syn
> > 
> > are both displayed as 'flags syn'.
> 
> I believe that in other selectors:
> 
>         selector == value
>         selector value
> 
> are equivalent.

No, it really depends on the base type. For bitmasks the equality relation
should be printed explicitly.

> I think it's not just that we have to fix the printing, but make it
> consistent.

What do you propose to change?
