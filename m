From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] netlink_delinearize: restore listing of host
 byteorder set elements
Date: Fri, 5 Jun 2015 13:57:12 +0200
Message-ID: <20150605115711.GA28206@acer.localdomain>
References: <1433355401-21332-1-git-send-email-pablo@netfilter.org>
 <20150604022340.GA13221@acer.localdomain>
 <20150604203031.GA25026@salvia>
 <20150605100830.GB1613@acer.localdomain>
 <20150605113310.GA3317@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59078 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbbFEL5P (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 07:57:15 -0400
Content-Disposition: inline
In-Reply-To: <20150605113310.GA3317@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05.06, Pablo Neira Ayuso wrote:
> On Fri, Jun 05, 2015 at 12:08:30PM +0200, Patrick McHardy wrote:
> > On 04.06, Pablo Neira Ayuso wrote:
> [...]
> > > I made a quick patch to add specific types for set declarations, eg.
> > > 
> > > # nft add set test test { type cpu32; }
> > > 
> > > We would have, let's say: u8, cpu16, cpu32, cpu64, be16, be32, be64,
> > > whose base datatype is the generic integer_type.
> > > 
> > > This would also allow us to define named sets that contain elements to
> > > be use with any kind of (integer_type) selector.
> > > 
> > > As you said, when declaring named sets we need to know the type since
> > > we have no LHS as this is not yet referenced, this would provide the
> > > specific datatype definition.
> > > 
> > > But if we end up having these specific integer types are in place, I
> > > fail to see why we should not use them consistently everywhere, no
> > > matter if this is a literal set, named set or any kind of simple
> > > comparison.
> > > 
> > > Am I missing anything?
> > > 
> > > Please advice. Thanks!
> > 
> > The main reason is that we have integer type specific handling that would
> > then need to check for all possible types. Internally we don't really need
> > those types if we properly qualify an instantiated integer since our
> > datatypes specify both byteorder and size. So my idea was to map those
> > as soon as we have all the required information to keep the code simpler.
> > 
> > Regarding the set declarations - I do not like the idea of having the
> > user deal with byteorder and type widths directly. I'd rather add a
> > cpu_id type for this specific case.
> > 
> > I don't think we have more meta types that use plain integers. This
> > leaves the question of how to deal with packet data. This uXX/beXX
> > types unfortunately also don't solve this completely. The DCCP protocol
> > for instance uses 48 bits for its sequence numbers. Its of course
> > rather unlikely that it makes any sense to use sets for this, but
> > it illustrates the problem.
> > 
> > An alternative idea would be that instead of specifying a data type,
> > we allow to specify an expression type that the set should hold.
> > F.i.
> > 
> > add set filter test { typeof meta cpu; }
> > add set filter test { typeof dccp seqno; }
> > 
> > What do you think about that?
> 
> I like your typeof idea so the user doesn't need to know the specific
> datatype. However, when listing an unreferenced named set back to
> userspace I think we won't have enough context to reconstruct this
> from the keytype, right?

Yeah, we still need some encoding for that. We currently use 6 bits for
the data type, so if we'd take on of those bits to indicate its an
expression not a type, that leaves 5 to encode the expression type
and subtype. That won't be enough for encoding a full expression type,
at least for payload and exthdr.

Long term we should move type encoding to set userdata IMO since it
also removes limitation in the size of concatenations.

> Going back to the original endianess problem in literal sets using
> integer types, eg.
> 
>         cpu { 50331648}
>         meta length { 50331648}
>         cgroup { 50331648}
> 
> The choices I see here at this moment is:
> 
> 1) Keep integer_type_postprocess() in place and rely on the LHS.
>    Basically, something very similar to what I sent in this original
>    patch.
> 
> 2) Add something like host_integer_type so we can encode the
>    endianness into the set keytype, then use it from the evaluation
>    step. Thus, we can kill integer_type_postprocess().
> 
>  --- a/src/evaluate.c
>  +++ b/src/evaluate.c
>  @@ -942,6 +942,10 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, str
>  
>         switch (rel->op) {
>         case OP_LOOKUP:
>  +               if (left->dtype == &integer_type &&
>  +                   left->byteorder == BYTEORDER_HOST_ENDIAN)
>  +                       left->dtype = &host_integer_type;
> 
> I think we can use this type for set declarations too while keytypes
> in both literal and named sets will look the same. I'm still in doubt
> on how to address the integer size without specific types.
> 
> Let me know if you can pull out any better solution from your hat :).

Given that we don't have a clean way to fix set declarations for unqualified
types so far, I think your original patch is fine.
