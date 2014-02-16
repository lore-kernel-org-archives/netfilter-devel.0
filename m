From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH nft userspace] nft: connlabel matching support
Date: Sun, 16 Feb 2014 17:59:57 +0100
Message-ID: <20140216165957.GA2408@breakpoint.cc>
References: <1392504432-20918-1-git-send-email-fw@strlen.de>
 <20140216085319.GA26751@macbook.localnet>
 <20140216110152.GD28751@breakpoint.cc>
 <20140216111252.GA29491@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53316 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530AbaBPQ76 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 11:59:58 -0500
Content-Disposition: inline
In-Reply-To: <20140216111252.GA29491@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> Ok I misunderstood your initial problem statement. So basically what it
> should currently do:
> 
> ct labels foo => test whether that bit is set
> ct labels == foo => test whether foo and only foo is set
> 
> Ok I can see the problem :)
> 
> The implicit op only selects FLAGCMP for EXPR_LIST (see
> expr_evaluate_relational()). That should probably be changed to take the
> base type into account. This also seems wrong for the ct state expression,
> we currently use equality if only one state is specified but use a flag
> comparison if multiple flags are specified.

I hacked something up to also select FLAGCMP for bitmask type.

$ nft --debug=netlink add rule filter output ct labels foo
ip filter output 0 0
 [ ct load labels => reg 1 ]
 [ bitwise reg 1 = (reg=1 & 0x00000001 0x00000000 0x00000000 0x00000000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
 [ cmp neq reg 1 0x00000001 0x00000000 0x00000000 0x00000000 ]

looks better.  Still not exactly the same though.
The cmp neq will cause it to match when the label is not set.

I then tried again with vanilla master branch:
tcp flags syn counter packets 0 bytes 0
tcp flags fin,syn counter packets 184 bytes 24880

So, same problem there: EXPR_LIST == cmp neq.  Is that intentional?
It seems wrong to me, e.g.  "tcp flags fin,syn" will match virtually all
tcp packets.

Maybe netlink_gen_flagcmp() should generate NFT_CMP_GT i.e.:
 [ bitwise reg 1 = (reg=1 & 0x00000012 ) ^ 0x00000000 ]
 [ cmp gt reg 1 0x00000000 ]

At least that would be what I would have expected :-}

Am I wrong?
As a side note, experimenting a bit with tcp flags:

add rule filter output tcp flags & (syn|ack) == (syn|ack)

works fine with current master branch.  But list shows

"tcp flags & 18 == 18", i.e. no symbol translation.

Shouldn't it restore the symbolic names?
I think this is the very same problem that I had with my connlabel
dabbling, so it would be nice if it could be solved in generic way.

Thanks,
Florian
