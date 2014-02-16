From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH nft userspace] nft: connlabel matching support
Date: Sun, 16 Feb 2014 18:51:32 +0100
Message-ID: <20140216175132.GB2408@breakpoint.cc>
References: <1392504432-20918-1-git-send-email-fw@strlen.de>
 <20140216085319.GA26751@macbook.localnet>
 <20140216110152.GD28751@breakpoint.cc>
 <20140216111252.GA29491@macbook.localnet>
 <20140216165957.GA2408@breakpoint.cc>
 <20140216172339.GA18357@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53478 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752718AbaBPRvf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 12:51:35 -0500
Content-Disposition: inline
In-Reply-To: <20140216172339.GA18357@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> > So, same problem there: EXPR_LIST == cmp neq.  Is that intentional?
> > It seems wrong to me, e.g.  "tcp flags fin,syn" will match virtually all
> > tcp packets.
> > 
> > Maybe netlink_gen_flagcmp() should generate NFT_CMP_GT i.e.:
> >  [ bitwise reg 1 = (reg=1 & 0x00000012 ) ^ 0x00000000 ]
> >  [ cmp gt reg 1 0x00000000 ]
> > 
> > At least that would be what I would have expected :-}
> > 
> > Am I wrong?
> 
> It should actually generate a NEQ 0. Seems this was broken in commit
> aae836a7 (src: use libnftables).
> 
> Try the attached patch please.

Thanks, 'tcp flags syn,fin' now behaves as expected.

> > As a side note, experimenting a bit with tcp flags:
> > 
> > add rule filter output tcp flags & (syn|ack) == (syn|ack)
> > 
> > works fine with current master branch.  But list shows
> > 
> > "tcp flags & 18 == 18", i.e. no symbol translation.
> > 
> > Shouldn't it restore the symbolic names?
> > I think this is the very same problem that I had with my connlabel
> > dabbling, so it would be nice if it could be solved in generic way.
> 
> Most likely. Please see if the attached patch solves this.

No:
add rule filter output tcp flags & (syn|ack) == (syn|ack)
list table filter
tcp flags & 18 == 18

The expression works.
