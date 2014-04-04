From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] expr: do not suppress OP_EQ when RHS is bitmask type
Date: Fri, 4 Apr 2014 10:33:28 +0200
Message-ID: <20140404083328.GE6769@breakpoint.cc>
References: <1395094118-32580-1-git-send-email-fw@strlen.de>
 <20140404081723.GA3574@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38108 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751962AbaDDIda (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2014 04:33:30 -0400
Content-Disposition: inline
In-Reply-To: <20140404081723.GA3574@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
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

Yes, thats true.

> I think it's not just that we have to fix the printing, but make it
> consistent.

Not sure, this was changed recently, see
6bad82aba5d304c7a2dd1b19fe57464dca327f4a
(evaluate: use flagcmp for single RHS bitmask expression).
