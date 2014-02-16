From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH nft userspace] nft: connlabel matching support
Date: Sun, 16 Feb 2014 17:23:39 +0000
Message-ID: <20140216172339.GA18357@macbook.localnet>
References: <1392504432-20918-1-git-send-email-fw@strlen.de>
 <20140216085319.GA26751@macbook.localnet>
 <20140216110152.GD28751@breakpoint.cc>
 <20140216111252.GA29491@macbook.localnet>
 <20140216165957.GA2408@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41347 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbaBPRXp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 12:23:45 -0500
Content-Disposition: inline
In-Reply-To: <20140216165957.GA2408@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 16, 2014 at 05:59:57PM +0100, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > Ok I misunderstood your initial problem statement. So basically what it
> > should currently do:
> > 
> > ct labels foo => test whether that bit is set
> > ct labels == foo => test whether foo and only foo is set
> > 
> > Ok I can see the problem :)
> > 
> > The implicit op only selects FLAGCMP for EXPR_LIST (see
> > expr_evaluate_relational()). That should probably be changed to take the
> > base type into account. This also seems wrong for the ct state expression,
> > we currently use equality if only one state is specified but use a flag
> > comparison if multiple flags are specified.
> 
> I hacked something up to also select FLAGCMP for bitmask type.
> 
> $ nft --debug=netlink add rule filter output ct labels foo
> ip filter output 0 0
>  [ ct load labels => reg 1 ]
>  [ bitwise reg 1 = (reg=1 & 0x00000001 0x00000000 0x00000000 0x00000000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
>  [ cmp neq reg 1 0x00000001 0x00000000 0x00000000 0x00000000 ]
> 
> looks better.  Still not exactly the same though.
> The cmp neq will cause it to match when the label is not set.
> 
> I then tried again with vanilla master branch:
> tcp flags syn counter packets 0 bytes 0
> tcp flags fin,syn counter packets 184 bytes 24880
> 
> So, same problem there: EXPR_LIST == cmp neq.  Is that intentional?
> It seems wrong to me, e.g.  "tcp flags fin,syn" will match virtually all
> tcp packets.
> 
> Maybe netlink_gen_flagcmp() should generate NFT_CMP_GT i.e.:
>  [ bitwise reg 1 = (reg=1 & 0x00000012 ) ^ 0x00000000 ]
>  [ cmp gt reg 1 0x00000000 ]
> 
> At least that would be what I would have expected :-}
> 
> Am I wrong?

It should actually generate a NEQ 0. Seems this was broken in commit
aae836a7 (src: use libnftables).

Try the attached patch please.

> As a side note, experimenting a bit with tcp flags:
> 
> add rule filter output tcp flags & (syn|ack) == (syn|ack)
> 
> works fine with current master branch.  But list shows
> 
> "tcp flags & 18 == 18", i.e. no symbol translation.
> 
> Shouldn't it restore the symbolic names?
> I think this is the very same problem that I had with my connlabel
> dabbling, so it would be nice if it could be solved in generic way.

Most likely. Please see if the attached patch solves this.

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 332383a..3e9a078 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -285,7 +285,6 @@ static void netlink_gen_flagcmp(struct netlink_linearize_ctx *ctx,
 	netlink_gen_raw_data(zero, expr->right->byteorder, len, &nld);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_SREG, sreg);
 	nft_rule_expr_set_u32(nle, NFT_EXPR_CMP_OP, NFT_CMP_NEQ);
-	netlink_gen_data(expr->right, &nld);
 	nft_rule_expr_set(nle, NFT_EXPR_CMP_DATA, nld.value, nld.len);
 	nft_rule_add_expr(ctx->nlr, nle);
 
