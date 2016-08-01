From: Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH 3/7] evaluate: add support to set IPv6 non-byte
 header fields
Date: Mon, 1 Aug 2016 16:23:59 +0200
Message-ID: <20160801142359.GB29553@breakpoint.cc>
References: <1469580196-2100-1-git-send-email-fw@strlen.de>
 <1469580196-2100-4-git-send-email-fw@strlen.de>
 <20160801102910.GA3206@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45620 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696AbcHAOYd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Aug 2016 10:24:33 -0400
Content-Disposition: inline
In-Reply-To: <20160801102910.GA3206@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Jul 27, 2016 at 02:43:12AM +0200, Florian Westphal wrote:
> > 'ip6 ecn set 1' will generate a zero-sized write operation.
> > Just like when matching on bit-sized header fields we need to
> > round up to a byte-sized quantity and add a mask to retain those
> > bits outside of the header bits that we want to change.
> >
> > Example:
> > 
> > ip6 ecn set ce
> >   [ payload load 1b @ network header + 1 => reg 1 ]
> >   [ bitwise reg 1 = (reg=1 & 0x000000cf ) ^ 0x00000030 ]
> >   [ payload write reg 1 => 1b @ network header + 1 csum_type 0 csum_off 0 ]
> > 
> > 1. Load the full byte containing the ecn bits
> > 2 .Mask out everything *BUT* the ecn bits
> > 3 .Set the CE mark
> > 
> > This patch only works if the protcol doesn't need a checksum fixup.
> > Will address this in a followup patch.
> > 
> > This also doesn't yet include the needed reverse translation.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  src/evaluate.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 77 insertions(+), 4 deletions(-)
> > 
> > diff --git a/src/evaluate.c b/src/evaluate.c
> > index 8116735..e6d4642 100644
> > --- a/src/evaluate.c
> > +++ b/src/evaluate.c
> > @@ -1608,13 +1608,86 @@ static int stmt_evaluate_verdict(struct eval_ctx *ctx, struct stmt *stmt)
> >  
> >  static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
> >  {
> > +	struct expr *binop, *mask, *and, *payload_bytes;
> > +	unsigned int masklen, extra_len = 0;
> > +	unsigned int payload_byte_size;
> > +	uint8_t shift_imm, data[16];
> 
> Instead of hardcoding to our current maximum word size, I think you
> can extract this information from the ctx.

I changed it to data[NFT_REG_SIZE].

> This idiom is already used in expr_evaluate_payload(), so you can
> probably wrap this code in a function, eg. payload_needs_adjustment()
> in a follow up patch and we skip this comment on top of this function.

Okay, can do this.

> > +
> > +	shift_imm = expr_offset_shift(payload, payload->payload.offset, &extra_len);
> > +	if (shift_imm) {
> > +		struct expr *off;
> > +
> > +		off = constant_expr_alloc(&payload->location,
> > +					  expr_basetype(payload),
> > +					  BYTEORDER_HOST_ENDIAN,
> > +					  sizeof(shift_imm), &shift_imm);
> > +
> > +		binop = binop_expr_alloc(&payload->location, OP_LSHIFT,
> > +					 stmt->payload.val, off);
> > +		binop->dtype		= payload->dtype;
> > +		binop->byteorder		= payload->byteorder;
> 
> This indent doesn't look correct.
> 
> I'd suggest you amend this before pushing this out.

Will do, thanks!
