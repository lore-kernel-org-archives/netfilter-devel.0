From: Phil Sutter <phil@nwl.cc>
Subject: Re: Problem with iptables-translate and tcp flags match
Date: Mon, 28 Nov 2016 13:12:19 +0100
Message-ID: <20161128121219.GB6158@orbyte.nwl.cc>
References: <20161125215017.GK6158@orbyte.nwl.cc>
 <20161128113537.GB1691@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:36074 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754300AbcK1MMV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 07:12:21 -0500
Content-Disposition: inline
In-Reply-To: <20161128113537.GB1691@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 28, 2016 at 12:35:37PM +0100, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Fri, Nov 25, 2016 at 10:50:17PM +0100, Phil Sutter wrote:
> > Hi,
> > 
> > I have a problem which exposes bugs in both iptables-translate and nft
> > and am a bit at a loss with it. But first things first:
> > 
> > | $ iptables-translate -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
> > | nft add rule ip filter INPUT tcp flags & fin|syn == fin|syn counter drop
> > 
> > This only appears to be fine at first glance. When adding the nftables
> > rule, the outcome is this:
> > 
> > | tcp flags & (fin | syn) | fin == fin | syn counter packets 0 bytes 0
> > 
> > Of course, this is obviously wrong. Looking at the output of
> > iptables-translate again, it becomes clear that nftables can only
> > interpret this the wrong way, categorically because binary AND takes
> > precedence over binary OR - so iptables-translate is broken in that it
> > should add parentheses like so:
> > 
> > | nft add rule ip filter INPUT tcp flags & (fin|syn) == fin|syn counter drop
> > 
> > And indeed this leads to expected results in nftables ruleset. On the
> > other hand what nftables interprets the wrong statement into looks a bit
> > fishy as well, but that's another topic - my issue with nftables is
> > exposed when I apply my quick hack to resolve this, which is to just
> > output the missing parentheses print_tcp_xlate(): iptables-translate
> > then outputs the following:
> > 
> > | nft add rule ip filter INPUT tcp flags & (fin|syn) == (fin|syn) counter drop
> > 
> > But nftables in return rejects it:
> > 
> > | <cmdline>:1:45-45: Error: syntax error, unexpected '('
> > | add rule ip filter INPUT tcp flags & (syn|fin) == (syn|fin) counter
> > |                                                   ^
> > 
> > The error message is emitted by the parser (which I am still at war
> > with) and in my opinion it should allow the parentheses on the right
> > side of that relational expression.
> > 
> > So here's a number of question marks for you:
> > * Am I on the right track with adding parentheses to iptables-translate
> >   output at all?
> > * If so, where would I adjust parser_bison.y to allow for them? Maybe
> >   rhs_expr should be extended to allow for it, but it's so generic I'm
> >   afraid of side-effects. Or is the better way to add another case to
> >   relational_expr which explicitly mentions the parentheses around
> >   rhs_expr?
> 
> There used to be parens there indeed, but this got removed when
> rhs_expr was introduced. If you look at old nftables releases you
> should find it there (well, not exactly in rhs_expr since that was
> added recently). So my first suggestion is to restore this in the way
> this was before.

Cool, thanks for the pointer! I'll have a look.

Cheers, Phil
